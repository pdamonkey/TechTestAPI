//
//  API.swift
//  API
//
//  Created by Matthew Gallagher on 12/02/2024.
//

import Foundation
import OSLog

public struct API {
    private static let baseAPI = "https://swiftleeds.co.uk/api"
    
    public static let log = Logger(subsystem: Bundle.main.bundleIdentifier!, category: "api")
    
    public static func retrieveSchedule() async throws -> [Slot] {
        let item: Schedule

        if ProcessInfo.isMockingData || ProcessInfo.isRunningUnitTest {
            log.info("Using mocked file for Schedule")
            item = try loadJSON(filename: "schedule")
        } else {
            log.info("Retrieving Schedule")
            item = try await retrieveItem(for: "\(Self.baseAPI)/v1/schedule?event=2D951908-1679-4D02-944B-54579698888B")
        }
        
        return item.data.slots
    }
    
    private static func retrieveItem<Item: Decodable>(for url: String) async throws -> Item {
        guard let url = URL(string: url) else {
            log.error("Invalid URL")
            throw NetworkError.invalidURL
        }

        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            guard let response = response as? HTTPURLResponse else { throw NetworkError.invalidResponse }
            guard response.statusCode != 304 else { throw NetworkError.notModified }
            guard 200...299 ~= response.statusCode else { throw NetworkError.invalidStatus }

            let item: Item = try decode(from: data)
            return item
        } catch {
            log.error("Could not retrieve data")
            throw NetworkError.couldNotRetrieveData
        }
    }

    private static func decode<Item: Decodable>(from data: Data) throws -> Item {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601

        do {
            return try decoder.decode(Item.self, from: data)
        } catch {
            log.error("Could not decode the item: \(error.localizedDescription)")
            throw NetworkError.decoding(error)
        }
    }
    
    private static func loadJSON<Item: Decodable>(filename: String) throws -> Item {
        guard let url = Bundle.module.url(forResource: filename, withExtension: "json") else { throw NetworkError.invalidURL }

        do {
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            return try decoder.decode(Item.self, from: data)
        } catch let error as DecodingError {
            log.error("Network decoding error: \(error.localizedDescription)")
            throw NetworkError.decoding(error)
        } catch {
            log.error("Network error: could not retrieve data")
            throw NetworkError.couldNotRetrieveData
        }
    }

    // MARK: - Network Error
    public enum NetworkError: Error {
        case couldNotRetrieveData
        case invalidURL
        case invalidResponse
        case invalidStatus
        case decoding(Error)
        case notModified
    }
}

// MARK: - ProcessInfo helpers
extension ProcessInfo {
    static var isMockingData: Bool {
        ProcessInfo.processInfo.arguments.contains("MockData")
    }

    static var isRunningUnitTest: Bool {
        ProcessInfo.processInfo.environment["XCTestConfigurationFilePath"] != nil
    }
}
