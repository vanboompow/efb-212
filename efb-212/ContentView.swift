//
//  ContentView.swift
//  efb-212
//
//  Root view — TabView with 5 main app tabs.
//  Map tab shows the full moving map with instrument strip and layer controls.
//  Aircraft tab shows pilot and aircraft profile management.
//  Settings tab shows app settings and chart management.
//  Flights and Logbook tabs are placeholders until Wave 3.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var appState: AppState
    @State private var selectedTab: AppTab = .map

    // Map dependencies — created once for the map tab
    @State private var mapService = MapService()
    @State private var mapViewModel: MapViewModel?

    var body: some View {
        TabView(selection: $selectedTab) {
            Tab(AppTab.map.title, systemImage: AppTab.map.systemImage, value: .map) {
                mapTab
            }

            Tab(AppTab.flights.title, systemImage: AppTab.flights.systemImage, value: .flights) {
                NavigationStack {
                    Text("Flights")
                        .font(.largeTitle)
                        .foregroundStyle(.secondary)
                        .navigationTitle("Flights")
                }
            }

            Tab(AppTab.logbook.title, systemImage: AppTab.logbook.systemImage, value: .logbook) {
                NavigationStack {
                    Text("Logbook")
                        .font(.largeTitle)
                        .foregroundStyle(.secondary)
                        .navigationTitle("Logbook")
                }
            }

            Tab(AppTab.aircraft.title, systemImage: AppTab.aircraft.systemImage, value: .aircraft) {
                aircraftTab
            }

            Tab(AppTab.settings.title, systemImage: AppTab.settings.systemImage, value: .settings) {
                NavigationStack {
                    SettingsView()
                }
            }
        }
        .onAppear {
            if mapViewModel == nil {
                mapViewModel = MapViewModel(
                    databaseManager: appState.databaseManager,
                    mapService: mapService
                )
            }
        }
        .sheet(isPresented: $appState.isPresentingAirportInfo) {
            if let airportID = appState.selectedAirportID,
               let airport = mapViewModel?.selectedAirport, airport.icao == airportID {
                AirportInfoSheet(airport: airport, weather: nil)
            }
        }
    }

    // MARK: - Map Tab

    @ViewBuilder
    private var mapTab: some View {
        ZStack(alignment: .bottom) {
            // Map fills the entire space
            MapView(mapService: mapService)
                .ignoresSafeArea(edges: .top)

            // Floating layer controls (top-right)
            VStack {
                HStack {
                    Spacer()
                    LayerControlsView(mapService: mapService)
                        .padding(.trailing, 16)
                        .padding(.top, 60)
                }
                Spacer()
            }

            // Instrument strip at bottom
            InstrumentStripView()
                .padding(.horizontal, 16)
                .padding(.bottom, 8)
        }
    }

    // MARK: - Aircraft Tab

    @ViewBuilder
    private var aircraftTab: some View {
        NavigationStack {
            List {
                NavigationLink("Aircraft Profiles") {
                    AircraftProfileView()
                }
                NavigationLink("Pilot Profile") {
                    PilotProfileView()
                }
            }
            .navigationTitle("Aircraft & Pilot")
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(
            AppState(
                locationManager: PlaceholderLocationManager(),
                databaseManager: PlaceholderDatabaseManager(),
                weatherService: PlaceholderWeatherService()
            )
        )
}
