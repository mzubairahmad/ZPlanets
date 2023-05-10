//
//  ContentView.swift
//  ZPlanets
//
//  Created by Zubair Ahmad on 10/05/2023.
//

import SwiftUI

struct PlanetListView: View {
    // PlanetViewModel observeable Object
    @ObservedObject var viewModel: PlanetViewModel
    
    var body: some View {
        // List of planets
        List(viewModel.planets) { planet in
            // cell of list
            VStack(alignment: .leading) {
                Text(planet.name)
                    .font(.headline)
                Text("Terrain: \(planet.terrain)")
            }
        }
        .onAppear {
            // start fetching data
            viewModel.fetchPlanets()
        }
        .overlay(offlineOverlay)
    }
    
    // this will show only if we are in Offline mode
    // Currently it is showing in centre of the screen
    private var offlineOverlay: some View {
        Group {
            if viewModel.isOffline {
                VStack {
                    Text("Offline mode")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding(.vertical, 4)
                        .padding(.horizontal, 8)
                        .background(Color.red)
                        .cornerRadius(8)
                        .padding()
                }
            }
        }
    }
}
