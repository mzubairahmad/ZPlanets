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
    private let apiClient: APIClient
    private let dataManager: CoreDataManager
    private var cancellables = Set<AnyCancellable>()
    
    @Published var planets: [Planet] = []
    @Published var isOffline: Bool = false
    
    init(apiClient: APIClient = APIClient(), dataManager: CoreDataManager = CoreDataManager.shared) {
        self.apiClient = apiClient
        self.dataManager = dataManager
    }
    
    func fetchPlanets() {
        if Reachability().isConnectedToNetwork(){
            return apiClient.fetchPlanets()
                .receive(on: DispatchQueue.main)
                .sink (
                    receiveCompletion: { [weak self] completion in
                        switch completion {
                        case .failure(let error):
                            print("error: \(error)")
                            self?.isOffline = true
                        case .finished:
                            print("Finished")
                        }
                    }, receiveValue: { [weak self] response in
                        self?.isOffline = false
                        self?.savePlanets(response)
                        self?.planets = response
                        
                    }
                ).store(in: &cancellables)
        }else{
            self.isOffline = true
            let cdPlanets = self.dataManager.fetchPlanets()
            self.planets = cdPlanets.map { $0.toPlanet() }
        }
        
        
    }
    
    private func savePlanets(_ planets: [Planet]) {
        dataManager.deleteAllPlanets()
        dataManager.savePlanets(planets)
    }
}
