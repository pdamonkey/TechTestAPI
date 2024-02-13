//
//  Schedule.swift
//  API
//
//  Created by Matthew Gallagher on 12/02/2024.
//

import Foundation

public struct Schedule: Decodable {
    public let data: Data

    public struct Data: Decodable {
        public let slots: [Slot]
    }
}
