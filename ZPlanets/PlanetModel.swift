//
//  Planet.swift
//  ZPlanets
//
//  Created by Zubair Ahmad on 10/05/2023.
//

import Foundation

struct Planet: Codable, Identifiable {
    let id = UUID()
    let name: String
    let population: String
    let terrain: String
    let climate: String
    
    enum CodingKeys: String, CodingKey {
        case name
        case population
        case terrain
        case climate
    }
}

struct PlanetResults: Codable {
    // array of planets
    let results: [Planet]
}
