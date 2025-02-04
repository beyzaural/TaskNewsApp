//
//  NewsAPIResponse.swift
//  Task
//
//  Created by beyza ural on 4.02.2025.
//

import Foundation

struct NewsAPIResponse: Decodable {
    
    let status: String
    let totalResults: Int?
    let articles: [Article]?
    
    let code: String?
    let message: String?
    
}
