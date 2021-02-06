//
//  NewsFeedWorker.swift
//  VkNewsFeed
//
//  Created by Macbook on 13.01.2021.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

class NewsFeedWorker {
    
    var authService: AuthService
    var networking: Networking
    var fetcher: DataFetchar
    var newFromInProcess: String?
    
    private var revealedPostId = [Int]()
    private var feedResponse: FeedResponse?
    
    init() {
        self.authService = SceneDelegate.shared().authService
        self.networking = NetworkService(authService: authService)
        self.fetcher = NetworkDataFetcher(networking: networking)
    }
    
    func getUser(completion: @escaping (UserResponse?) -> Void) {
        fetcher.getUser { userResponse in
            completion(userResponse)
        }
    }
    
    func getFeed(completion: @escaping ([Int], FeedResponse) -> Void) {
        fetcher.getFeed(nextBatchFrom: nil) { [weak self] feed in
            self?.feedResponse = feed
            guard let feedResponse = self?.feedResponse else { return }
            completion(self!.revealedPostId, feedResponse)
        }
    }
    
    func revealPostIds(forPostId postId: Int, completion: @escaping ([Int], FeedResponse) -> Void) {
        revealedPostId.append(postId)
        guard let feedResponse = self.feedResponse else { return }
        completion(revealedPostId, feedResponse)
    }
    
    func getNextBatch(completion: @escaping ([Int], FeedResponse) -> Void) {
        newFromInProcess = feedResponse?.nextFrom
        fetcher.getFeed(nextBatchFrom: newFromInProcess) { [ weak self] (feed) in
            guard let feed = feed else { return }
            guard self?.feedResponse?.nextFrom != feed.nextFrom else { return }
            
            if self?.feedResponse == nil {
                self?.feedResponse = feed
            } else {
                self?.feedResponse?.items.append(contentsOf: feed.items)
                
                var profiles = feed.profiles
                if let oldProfiles = self?.feedResponse?.profiles {
                    let oldProfilesFiltered = oldProfiles.filter({ (oldProfile) -> Bool in
                        !feed.profiles.contains(where: { $0.id == oldProfile.id })
                    })
                    profiles.append(contentsOf: oldProfilesFiltered)
                }
                self?.feedResponse?.profiles = profiles
                
                var groups = feed.groups
                if let oldGroups = self?.feedResponse?.groups {
                    let oldGroupsFiltered = oldGroups.filter({ (oldGroup) -> Bool in
                        !feed.groups.contains(where: { $0.id == oldGroup.id })
                    })
                    groups.append(contentsOf: oldGroupsFiltered)
                }
                self?.feedResponse?.groups = groups
                self?.feedResponse?.nextFrom = feed.nextFrom
            }
            
            guard let feedResponse = self?.feedResponse else { return }
            completion(self!.revealedPostId, feedResponse)
        }
    }
//    func getNextBatch(comletion: @escaping ([Int], FeedResponse) -> Void) {
//        newFromInProcess = feedResponse?.nextFrom
//        fetcher.getFeed(nextBatchFrom: newFromInProcess) { [weak self] feed in
//            guard let feed = feed else { return }
//            guard self?.feedResponse?.nextFrom != feed.nextFrom else { return }
//
//            if self?.feedResponse == nil {
//                self?.feedResponse = feed
//            } else {
//                self?.feedResponse?.items.append(contentsOf: feed.items)
//
//                var profiles = feed.profiles
//                if let oldProfile = self?.feedResponse?.profiles {
//                    let oldProfilesFiltered = oldProfile.filter { (oldProfile) -> Bool in
//                        !feed.profiles.contains(where: { $0.id == oldProfile.id })
//                    }
//                    profiles.append(contentsOf: oldProfilesFiltered)
//                }
//                self?.feedResponse?.profiles = feed.profiles
//
//                var groups = feed.groups
//                if let oldGroups = self?.feedResponse?.groups {
//                    let oldGroupsFeltered = oldGroups.filter { (oldGroup) -> Bool in
//                        !feed.groups.contains(where: { $0.id == oldGroup.id })
//                    }
//                    groups.append(contentsOf: oldGroupsFeltered)
//                }
//                self?.feedResponse?.groups = feed.groups
//
//                self?.feedResponse?.nextFrom = feed.nextFrom
//            }
//            guard let feedResponse = self?.feedResponse else { return }
//            comletion(self!.revealedPostId, feedResponse)
//        }
//    }
    
}
