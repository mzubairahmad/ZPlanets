//
//  ContentView.swift
//  ZPlanets
//
//  Created by Zubair Ahmad on 10/05/2023.
//

import SwiftUI
//import CoreData

import SwiftUI

struct ContentView: View {
    @StateObject var viewModel = PlanetViewModel()
    
    var body: some View {
        NavigationView {
            // using PlanetsListView to show the list of planets
            PlanetListView(viewModel: viewModel)
                .navigationBarTitle("Planets")
        }
    }
}
