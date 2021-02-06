//
//  NewsFeedInteractor.swift
//  VkNewsFeed
//
//  Created by Macbook on 13.01.2021.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol NewsFeedBusinessLogic {
    func makeRequest(request: NewsFeed.Model.Request.RequestType)
}

class NewsFeedInteractor: NewsFeedBusinessLogic {
    
    var presenter: NewsFeedPresentationLogic?
    var service: NewsFeedWorker?
        
    func makeRequest(request: NewsFeed.Model.Request.RequestType) {
        if service == nil {
            service = NewsFeedWorker()
        }
        switch request {
        case .getNewsFeed:
            service?.getFeed(completion: { [weak self] (revealedPostId, feed) in
                self?.presenter?.presentData(response: .presentNewsFeed(feed: feed, revealedPostIds: revealedPostId))
            })
        case .getUser:
            service?.getUser(completion: { [weak self] user in
                self?.presenter?.presentData(response: .presentUserInfo(user: user))
            })
        case .revealPostIds(let postId):
            service?.revealPostIds(forPostId: postId, completion: { [weak self] (revealedPostId, feed) in
                self?.presenter?.presentData(response: .presentNewsFeed(feed: feed, revealedPostIds: revealedPostId))
            })
        case .getNextBatch:
            self.presenter?.presentData(response: .presentFooterLoader)
            service?.getNextBatch(completion: { (revealedPostId, feed) in
                self.presenter?.presentData(response: .presentNewsFeed(feed: feed, revealedPostIds: revealedPostId))
            })
        }
    }
}
