//
//  Persistence.swift
//  ZPlanets
//
//  Created by Zubair Ahmad on 10/05/2023.
//

import Foundation
import CoreData

class CoreDataManager {
    static let shared = CoreDataManager()
    
    // persistentContainer will initaated once accessed
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "ZPlanets")
        container.loadPersistentStores(completionHandler: { _, error in
            if let error = error {
                fatalError("Failed to load Core Data stack: \(error)")
            }
        })
        return container
    }()
    
    // CoreData Context
    var mainContext: NSManagedObjectContext {
        persistentContainer.viewContext
    }
    
    // common save method
    func saveContext() {
        let context = mainContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    // fetching Planets data from CoreData
    func fetchPlanets() -> [PlanetEntity] {
        let fetchRequest: NSFetchRequest<PlanetEntity> = PlanetEntity.fetchRequest()
        do {
            let results = try mainContext.fetch(fetchRequest)
            return results
        } catch {
            print("Error fetching planets: \(error.localizedDescription)")
            return []
        }
    }
    
    // Saving into CoreData
    func savePlanets(_ planets: [Planet]) {
        mainContext.perform { [weak self] in
            do {
                let request = NSFetchRequest<NSFetchRequestResult>(entityName: "PlanetEntity")
                let deleteRequest = NSBatchDeleteRequest(fetchRequest: request)
                try self?.mainContext.execute(deleteRequest)
                
                // iterating in planet array and saving
                for planet in planets {
                    let planetEntity = PlanetEntity(context: self?.mainContext ?? NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType))
                    planetEntity.name = planet.name
                    planetEntity.climate = planet.climate
                    planetEntity.population = planet.population
                    planetEntity.terrain = planet.terrain
                }
                
                try self?.mainContext.save()
            } catch {
                print("Failed saving planets: \(error.localizedDescription)")
            }
        }
    }
    
    // delete data of planets
    func deleteAllPlanets() {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = PlanetEntity.fetchRequest()
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try self.persistentContainer.persistentStoreCoordinator.execute(deleteRequest, with: self.persistentContainer.viewContext)
            try self.persistentContainer.viewContext.save()
        } catch {
        }
    }
}
