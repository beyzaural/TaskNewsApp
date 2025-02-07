//
//  NewsAPI.swift
//  Task
//
//  Created by beyza ural on 6.02.2025.
//

import Foundation

struct NewsAPI {
    static let apiKey = "aac5843bfa614e4f8c8d4a1bbfc4e2f4"
    static let baseURL = "https://newsapi.org/v2/everything"
    
    static func fetchNews(page: Int, pageSize: Int, completion: @escaping (Result<[Article], Error>) -> Void) {
        let query = "Tesla"
        guard let url = URL(string: "\(baseURL)?q=\(query)&page=\(page)&pageSize=\(pageSize)&apiKey=\(apiKey)") else {
            completion(.failure(URLError(.badURL)))
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            //URL oluşturulamazsa,
            guard let data = data else {
                completion(.failure(URLError(.badServerResponse)))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .iso8601
                // JSON data, NewsAPIResponse yapısına decode edildi.
                let response = try decoder.decode(NewsAPIResponse.self, from: data)
                completion(.success(response.articles ?? []))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}
