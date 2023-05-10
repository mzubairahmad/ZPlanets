//
//  ContentView.swift
//  ZPlanets
//
//  Created by Zubair Ahmad on 10/05/2023.
//

import SwiftUI

struct PlanetListView: View {
    @ObservedObject var viewModel: PlanetViewModel
    
    var body: some View {
        List(viewModel.planets, id: \.name) { planet in
            VStack(alignment: .leading) {
                Text(planet.name)
                    .font(.headline)
                Text("Terrain: \(planet.terrain)")
            }
        }
        .onAppear {
            viewModel.fetchPlanets()
        }
        .overlay(offlineOverlay)
    }
    
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
