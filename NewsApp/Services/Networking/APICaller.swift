//
//  APICaller.swift
//  NewsApp
//
//  Created by Boris Bolshakov on 10.12.21.
//

import Foundation

final class APICaller {
    
    static let shared = APICaller()
    
    private init() {}
    
    private struct Constants {
        static let apiKey = "61abbfc82cd54f868bd043915601fbfd"
        static let baseUrl = "https://newsapi.org/v2/"
        
        static let secondsInADay: Double = 3600 * 24
    }
    
    enum Endpoint: String {
        case search = "everything"
        case topNews = "top-headlines"
    }
    
    enum newsCategory: String {
        case main = "general"
        case business
        case health
        case entertainment
        case science
        case sports
        case technology
        
    }

    private enum APIError: Error {
        case noDataReturned
        case invalidURL
        case badResponse
    }
    
    
    private func url(
        for endpoint: Endpoint,
        queryParams: [String: String] = [:]
    ) -> URL? {
        
        var urlString = Constants.baseUrl + endpoint.rawValue
        var queryItems = [URLQueryItem]()
        
        for (name, value) in queryParams {
            queryItems.append(.init(name: name, value: value))
        }
        
        queryItems.append(.init(name: "apiKey", value: Constants.apiKey))
        
        urlString += "?" + queryItems.map({ "\($0.name)=\($0.value ?? "")" }).joined(separator: "&")
        
        print("\(urlString)")
        
        return URL(string: urlString)
    }
    
    
    private func request<T: Codable>(
        url: URL?,
        expecting: T.Type,
        completion: @escaping (Result<T, Error>) -> Void
    ) {
        guard let url = url else {
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else {
                if let error = error {
                    completion(.failure(error))
                } else {
                    completion(.failure(APIError.noDataReturned))
                }
                return
            }
            
            do {
                let result = try JSONDecoder().decode(expecting, from: data)
                completion(.success(result))
            } catch {
                completion(.failure(error))
            }
        }
        
        task.resume()
    }
    
    func news(
        for type: Endpoint,
        newsCategory: newsCategory?,
        completion: @escaping (Result<SearchResponse, Error>) -> Void
    ) {
        
        let param = getParams(for: newsCategory ?? .main)
        
        switch type {
        case .search:
            let today = Date()
            let oneMonthBack = today.addingTimeInterval(-(Constants.secondsInADay * 30))
            request(
                url: url(
                    for: .search,
                       queryParams:
                           [
                            "category" : "general",
                            "country" : "us",
                            "pageSize" : "100",
                            "sortBy": "publishedAt",
                            "from" : DateFormatter.newsDateFormatter.string(from: oneMonthBack),
                            "to": DateFormatter.newsDateFormatter.string(from: today)
                           ]
                      
                       ),
                expecting: SearchResponse.self,
                completion: completion
            )
        case .topNews:
            request(
                url: url(
                    for: .topNews,
                       queryParams: param),
                expecting: SearchResponse.self,
                completion: completion
            )
        }
        print(url)
    }
    
    func getParams(for news: newsCategory) -> [String : String] {
        switch news {
        case .main:
            return [
             "category" : "general",
             "country" : "us",
             "pageSize" : "50",
             "sortBy": "popularity"
            ]
        case .business:
            return [
             "category" : "business",
             "country" : "us",
             "pageSize" : "50"
            ]
        case .health:
            return [
             "category" : "health",
             "country" : "us",
             "pageSize" : "50"
            ]
        case .entertainment:
            return [
             "category" : "entertainment",
             "country" : "us",
             "pageSize" : "50"
            ]
        case .science:
            return [
             "category" : "science",
             "country" : "us",
             "pageSize" : "50"
            ]
        case .sports:
            return [
             "category" : "sports",
             "country" : "us",
             "pageSize" : "50"
            ]
        case .technology:
            return [
             "category" : "technology",
             "country" : "us",
             "pageSize" : "50",
            ]
        }
    }
    
    
    
}
