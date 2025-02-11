//
//  Article.swift
//  Task
//
//  Created by beyza ural on 4.02.2025.
//

import Foundation
fileprivate let relativeDateFormatter = RelativeDateTimeFormatter()

struct Article {
    

    var id: String { url } // Used `url` as the unique identifier because order date show article multiple times
    
    //title property is constant once the Article is created because of let
    let source: Source
    let title: String
    let url: String
    let publishedAt: Date
    
    let author: String?
    let description: String?
    let urlToImage: String?
    
    
    enum CodingKeys: String, CodingKey {
        case source
        case title
        case url
        case publishedAt
        case author
        case description
        case urlToImage
    }
    //var properties can change after initialization
    //author's name or an empty string
    var authorText: String {
            author ?? ""
        }
        
        var descriptionText: String {
            description ?? ""
        }
        
        var captionText: String {
            "\(source.name) ‧ \(relativeDateFormatter.localizedString(for: publishedAt, relativeTo: Date()))"
        }
        
        var articleURL: URL {
            URL(string: url)!
        }
        
        var imageURL: URL? {
            guard let urlToImage = urlToImage else {
                return nil
            }
            return URL(string: urlToImage)
        }
        
    }

extension Article: Codable {}
extension Article: Equatable {}
extension Article: Identifiable {}

extension Article {
    
    static var previewData: [Article] {
        let previewDataURL = Bundle.main.url(forResource: "news", withExtension: "json")!
        let data = try! Data(contentsOf: previewDataURL)
        
        let jsonDecoder = JSONDecoder()
        jsonDecoder.dateDecodingStrategy = .iso8601
        
        // can decode JSON data into Swift objects(remember codable)
        let apiResponse = try! jsonDecoder.decode(NewsAPIResponse.self, from: data)
        return apiResponse.articles ?? []
    }
    
}

struct Source {
    let name: String
}

extension Source: Codable {}
extension Source: Equatable {}
