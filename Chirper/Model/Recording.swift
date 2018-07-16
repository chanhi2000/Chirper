//
//  Recording.swift
//  Chirper
//
//  Created by 전정철 on 16/07/2018.
//  Copyright © 2018 MarkiiimarK. All rights reserved.
//

import Foundation

struct Recording: Codable {
    let genus: String
    let species: String
    let friendlyName: String
    let country: String
    let fileURL: URL
    let date: String
    
    enum CodingKeys: String, CodingKey {
        case genus = "gen"
        case species = "sp"
        case friendlyName = "en"
        case country = "cnt"
        case date
        case fileURL = "file"
    }
}
