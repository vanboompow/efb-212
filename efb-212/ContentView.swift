//
//  ContentView.swift
//  efb-212
//
//  Root view — TabView with 5 main app tabs.
//  AppTab enum is defined in Core/Types.swift.
//

import SwiftUI

struct ContentView: View {
    @State private var selectedTab: AppTab = .map

    var body: some View {
        TabView(selection: $selectedTab) {
            Tab(AppTab.map.title, systemImage: AppTab.map.systemImage, value: .map) {
                NavigationStack {
                    Text("Map View")
                        .font(.largeTitle)
                        .navigationTitle("Map")
                }
            }

            Tab(AppTab.flights.title, systemImage: AppTab.flights.systemImage, value: .flights) {
                NavigationStack {
                    Text("Flights")
                        .font(.largeTitle)
                        .navigationTitle("Flights")
                }
            }

            Tab(AppTab.logbook.title, systemImage: AppTab.logbook.systemImage, value: .logbook) {
                NavigationStack {
                    Text("Logbook")
                        .font(.largeTitle)
                        .navigationTitle("Logbook")
                }
            }

            Tab(AppTab.aircraft.title, systemImage: AppTab.aircraft.systemImage, value: .aircraft) {
                NavigationStack {
                    Text("Aircraft & Pilot")
                        .font(.largeTitle)
                        .navigationTitle("Aircraft")
                }
            }

            Tab(AppTab.settings.title, systemImage: AppTab.settings.systemImage, value: .settings) {
                NavigationStack {
                    Text("Settings")
                        .font(.largeTitle)
                        .navigationTitle("Settings")
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
