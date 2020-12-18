//
//  StarWars.swift
//  StarWars
//
//  Created by Christian Shirichena on 12/18/20.
//

import Foundation

struct StarWars: Decodable{
    let name: String
    let frontImageURL: URL
    
    enum CodingKeys: String, CodingKey  {
        case name
        case results
    }
    
    enum ResultsCodingKeys: String, CodingKey {
        case front = "front_default"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let resultsContainer = try container.nestedContainer(keyedBy: ResultsCodingKeys.self, forKey: .results)
        self.name = try container.decode(String.self, forKey: .name)
        self.frontImageURL = try resultsContainer.decode(URL.self, forKey: .front)
        
    }
}
