//
//  PlanetViewModel.swift
//  ZPlanets
//
//  Created by Zubair Ahmad on 10/05/2023.
//

import Foundation
import Combine
import CoreData

class PlanetViewModel: ObservableObject {
    // Network client
    private let apiClient: APIClient
    // Persistance client
    private let dataManager: CoreDataManager
    // disposeables
    private var cancellables = Set<AnyCancellable>()
    
    // data array
    @Published var planets: [Planet] = []
    
    // isOffline will help to show offline overlay
    @Published var isOffline: Bool = false
    
    init(apiClient: APIClient = APIClient(), dataManager: CoreDataManager = CoreDataManager.shared) {
        self.apiClient = apiClient
        self.dataManager = dataManager
    }
    
    func fetchPlanets() {
        // First we will check If have Internet, get daata from remote server / api
        // else check CoreData and respond
        // If there is no data, nothing happen for now
        // Need to add alerts or Empty view messages
        if Reachability().isConnectedToNetwork(){
            return apiClient.fetchPlanets()
                 // receiving on main thread
                .receive(on: DispatchQueue.main)
                .sink (
                    receiveCompletion: { [weak self] completion in
                        switch completion {
                        case .failure(let error):
                            print("error: \(error)")
                            // just assuming its offline state
                            self?.isOffline = true
                        case .finished:
                            print("")
                        }
                    }, receiveValue: { [weak self] response in
                        self?.isOffline = false
                        // save to coreData
                        self?.savePlanets(response)
                        // update planets array with response
                        self?.planets = response
                        
                    }
                ).store(in: &cancellables)
        }else{
            self.isOffline = true
            // getting stord entity data and map into struct
            let cdPlanets = self.dataManager.fetchPlanets()
            self.planets = cdPlanets.map { $0.toPlanet() }
        }
        
        
    }
    
    private func savePlanets(_ planets: [Planet]) {
        // first remove previous data
        dataManager.deleteAllPlanets()
        // save to DB
        dataManager.savePlanets(planets)
    }
}
