//
//  ZPlanetsTests.swift
//  ZPlanetsTests
//
//  Created by Zubair Ahmad on 10/05/2023.
//

import XCTest
@testable import ZPlanets

final class ZPlanetsTests: XCTestCase {

    var viewModel: PlanetViewModel!
        
        override func setUp() {
            super.setUp()
            viewModel = PlanetViewModel(apiClient: APIClient(session: URLSession.shared), dataManager: CoreDataManager.shared)
        }
        
        override func tearDown() {
            super.tearDown()
            viewModel = nil
        }
    
    func testFetchPlanetsSuccess() {
            // given
        let mockPlanets = [Planet(name: "Tatooine", population: "200000", terrain: "desert", climate: "arid"), Planet(name: "Alderaan", population: "2000000000", terrain: "grasslands, mountains", climate: "temperate")]
            let mockData = try! JSONEncoder().encode(mockPlanets)
            let url = URL(string: "https://swapi.dev/api/planets/")!
            let urlResponse = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)!
            let session = URLSessionMock(data: mockData, response: urlResponse, error: nil)
            let apiClient = APIClient(session: session)
            viewModel = PlanetViewModel(apiClient: apiClient, dataManager: CoreDataManager.shared)
            let expectation = self.expectation(description: "fetchPlanets should succeed")
            
            // when
            viewModel.fetchPlanets()
            
            // then
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                XCTAssertEqual(self.viewModel.planets.count, 2)
                XCTAssertEqual(self.viewModel.planets[0].name, "Tatooine")
                XCTAssertEqual(self.viewModel.planets[0].terrain, "desert")
                XCTAssertFalse(self.viewModel.isOffline)
                expectation.fulfill()
            }
            
            waitForExpectations(timeout: 1.0, handler: nil)
        }
    
    
    func testFetchPlanetsFailure() {
             //given
            let session = URLSessionMock(data: nil, response: nil, error: APIError.invalidURL)
            let apiClient = APIClient(session: session)
            viewModel = PlanetViewModel(apiClient: apiClient, dataManager: CoreDataManager.shared)
            let expectation = self.expectation(description: "fetchPlanets should fail")

            // when
            viewModel.fetchPlanets()

            // then
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                XCTAssertTrue(self.viewModel.planets.isEmpty)
                XCTAssertTrue(self.viewModel.isOffline)
                expectation.fulfill()
            }

            waitForExpectations(timeout: 1.0, handler: nil)
        }
    
    func testFetchPlanetsOffline() {
            // given
            let session = URLSessionMock(data: nil, response: nil, error: nil)
            let apiClient = APIClient(session: session)
            viewModel = PlanetViewModel(apiClient: apiClient, dataManager: CoreDataManager.shared)
            let expectation = self.expectation(description: "fetchPlanets should be offline")

            // when
            viewModel.fetchPlanets()

            // then
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                XCTAssertTrue(self.viewModel.planets.isEmpty)
                XCTAssertTrue(self.viewModel.isOffline)
                expectation.fulfill()
            }

            waitForExpectations(timeout: 1.0, handler: nil)
        }
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}


class URLSessionMock: URLSession {
    
    var data: Data?
    var response: URLResponse?
    var error: Error?
    
    init(data: Data?, response: URLResponse?, error: Error?) {
        self.data = data
        self.response = response
        self.error = error
    }
    
    override func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        return URLSessionDataTaskMock {
            completionHandler(self.data, self.response, self.error)
        }
    }
}

class URLSessionDataTaskMock: URLSessionDataTask {
    
    private let completion: () -> Void
    
    init(completion: @escaping () -> Void) {
        self.completion = completion
    }
    
    override func resume() {
        completion()
    }
}
