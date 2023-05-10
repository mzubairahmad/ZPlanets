//
//  PlanetMO.swift
//  ZPlanets
//
//  Created by Zubair Ahmad on 10/05/2023.
//

import Foundation
import CoreData

extension PlanetEntity {
    
    func toPlanet() -> Planet {
        return Planet(name: name ?? "" , population: population ?? "", terrain: terrain ?? "", climate: climate ?? "")
    }
}
