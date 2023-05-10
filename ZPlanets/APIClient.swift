//
//  APIClient.swift
//  ZPlanets
//
//  Created by Zubair Ahmad on 10/05/2023.
//

import Foundation
import Combine

enum APIError: Error {
    case invalidURL
    case networkError(Error)
    case invalidResponse
    case invalidStatusCode(Int)
    case decodingError(Error)
    case invalidData
}

class APIClient {
    private let session: URLSession
    
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    func fetchPlanets() -> AnyPublisher<[Planet], APIError>  {
        guard let url = URL(string: "https://swapi.dev/api/planets/") else {
            return Fail(error: APIError.invalidURL).eraseToAnyPublisher()
        }
        
        return session.dataTaskPublisher(for: url)
            .tryMap{ (data, response) -> [Planet] in
                guard let response = response as? HTTPURLResponse else {
                    throw APIError.invalidResponse
                }
                guard response.statusCode == 200 else {
                    throw APIError.invalidStatusCode(response.statusCode)
                }
                
                do {
                    let result = try JSONDecoder().decode(PlanetResults.self, from: data)
                    return result.results
                } catch {
                    throw APIError.decodingError(error)
                }
            }
            .mapError { error -> APIError in
                return APIError.networkError(error)
            }.eraseToAnyPublisher()
    }
}

