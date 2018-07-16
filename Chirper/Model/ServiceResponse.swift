//
//  Service.swift
//  Chirper
//
//  Created by 전정철 on 16/07/2018.
//  Copyright © 2018 MarkiiimarK. All rights reserved.
//

import Foundation

struct ServiceResponse: Codable {
    let recordings: [Recording]
    let page: Int
    let numPages: Int
}
