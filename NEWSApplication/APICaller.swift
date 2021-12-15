//
//  APICaller.swift
//  NEWSApplication
//
//  Created by PRO on 11/17/21.
//

import Foundation

final class APICaller {
    static let shared = APICaller()
    
    struct Constants {
       static let topHeadlinesURL = URL(string: "https://gnews.io/api/v4/top-headlines?token=e3fa86dafa51b478c55a53d7d9682052&lang=en")
       // https://gnews.io/api/v4/top-headlines?token=e3fa86dafa51b478c55a53d7d9682052&lang=en
        static let searchUrlstring = "https://gnews.io/api/v4/search?q=example&token=e3fa86dafa51b478c55a53d7d9682052&lang=en"
    }
    
    private init() {}
    
    public func getTopStories(completion: @escaping (Result<[Article], Error>) ->Void) {
        guard let url = Constants.topHeadlinesURL else  {
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                completion(.failure(error))
            }
            
            else if let data = data {
                do{
                    let result = try JSONDecoder().decode(APIResponse.self, from: data)
                    
                    print("Articles: \(result.articles.count)")
                    completion(.success(result.articles))
                    
                  
                }
                
                catch {
                    completion(.failure(error))
                }
            }
        }
       
        task.resume()
    }
    
    public func search(with query: String, completion: @escaping (Result<[Article], Error>) ->Void) {
        guard !query.trimmingCharacters(in: .whitespaces).isEmpty else{
            return
        }
        let urlstring = Constants.searchUrlstring + query
        guard let url = URL(string: urlstring) else  {
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                completion(.failure(error))
            }
            
            else if let data = data {
                do{
                    let result = try JSONDecoder().decode(APIResponse.self, from: data)
                    
                    print("Articles: \(result.articles.count)")
                    completion(.success(result.articles))
                    
                  
                }
                
                catch {
                    completion(.failure(error))
                }
            }
        }
       
        task.resume()
    }
    
}


//create models

struct APIResponse: Codable{
    let articles: [Article]
}

struct Article: Codable {
    let source: Source
    let title: String
    let description: String?
    let url: String?
    let urlToImage: String?
    let publishedAt: String
    
}

struct Source: Codable{
    let name: String
}
