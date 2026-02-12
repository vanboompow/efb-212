//
//  MockWeatherService.swift
//  efb-212Tests
//
//  Mock weather service for testing components that depend on WeatherServiceProtocol.
//

import Foundation
@testable import efb_212

final class MockWeatherService: WeatherServiceProtocol, @unchecked Sendable {
    var mockWeather: [String: WeatherCache] = [:]
    var shouldFail: Bool = false

    func fetchMETAR(for stationID: String) async throws -> WeatherCache {
        if shouldFail {
            throw EFBError.weatherFetchFailed(underlying: NSError(domain: "test", code: -1))
        }
        guard let weather = mockWeather[stationID] else {
            throw EFBError.weatherFetchFailed(underlying: NSError(domain: "test", code: -1))
        }
        return weather
    }

    func fetchTAF(for stationID: String) async throws -> String {
        if shouldFail {
            throw EFBError.weatherFetchFailed(underlying: NSError(domain: "test", code: -1))
        }
        return "TAF \(stationID) mock data"
    }

    func fetchWeatherForStations(_ stationIDs: [String]) async throws -> [WeatherCache] {
        if shouldFail {
            throw EFBError.weatherFetchFailed(underlying: NSError(domain: "test", code: -1))
        }
        return stationIDs.compactMap { mockWeather[$0] }
    }

    func cachedWeather(for stationID: String) -> WeatherCache? {
        mockWeather[stationID]
    }
}
