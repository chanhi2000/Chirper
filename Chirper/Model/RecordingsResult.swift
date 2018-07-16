//
//  RecordingResult.swift
//  Chirper
//
//  Created by 전정철 on 16/07/2018.
//  Copyright © 2018 MarkiiimarK. All rights reserved.
//

import Foundation

struct RecordingsResult {
    let recordings: [Recording]?
    let error: Error?
    let currentPage: Int
    let pageCount: Int
    
    var hasMorePages: Bool {
        return currentPage < pageCount
    }
    
    var nextPage: Int {
        return hasMorePages ? currentPage + 1 : currentPage
    }
    
}
