//
//  NetworkDataFetcher.swift
//  VkNewsFeed
//
//  Created by Macbook on 12.01.2021.
//

import Foundation

protocol DataFetchar {
    func getFeed(nextBatchFrom: String?, response: @escaping (FeedResponse?) -> Void)
    func getUser(response: @escaping (UserResponse?) -> Void)
}

struct NetworkDataFetcher: DataFetchar {
    
    private let networking: Networking
    private let authService: AuthService

    init(networking: Networking, authService: AuthService = SceneDelegate.shared().authService) {
        self.networking = networking
        self.authService = authService
    }
    
    func getFeed(nextBatchFrom: String?, response: @escaping (FeedResponse?) -> Void) {
        
        var params = ["filters": "post, photo"]
        params["start_from"] = nextBatchFrom
        
        networking.request(path: API.newsFeed, params: params) { (data, error) in
            if let error = error {
                print("Error received requesting data \(error.localizedDescription)")
                response(nil)
            }
            let decoded = self.decodeJSON(type: FeedResponseWrapped.self, from: data)
            response(decoded?.response)
        }
    }
    
    func getUser(response: @escaping (UserResponse?) -> Void) {
        guard let userId = authService.userId else { return }
        let params = ["user_ids": userId, "fields": "photo_100"]
        
        networking.request(path: API.user, params: params) { (data, error) in
            if let error = error {
                print("Error received requesting data \(error.localizedDescription)")
                response(nil)
            }
            
            let decoded = self.decodeJSON(type: UserResponseWrapped.self, from: data)
            response(decoded?.response.first)
        }
    }
    
    private func decodeJSON<T: Decodable>(type: T.Type, from: Data?) -> T? {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        guard let data = from, let response = try? decoder.decode(type.self, from: data) else { return nil }
        return response
    }
}
