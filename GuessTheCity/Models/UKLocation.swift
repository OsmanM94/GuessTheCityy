//
//  DataModel.swift
//  GuessTheCity
//
//  Created by asia on 05/10/2024.
//

import Foundation
import CoreLocation

struct UKLocation: Codable, Identifiable {
    let id: Int
    let name: String
    let info: String
    let latitude: Double
    let longitude: Double
    let country: String?
    let countyName: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case info
        case latitude
        case longitude
        case country
        case countyName = "county_name"
    }
    
    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    var hint: String {
        let words = name.split(separator: " ")
        if words.count > 1 {
            return "\(words.first!.first!)...\(words.last!.last!)"
        } else {
            return "\(name.first!)...\(name.last!)"
        }
    }
    
    // Radius for map hint (in kilometers)
    var hintRadius: Double {
        return Double.random(in: 10...50)
    }
}
