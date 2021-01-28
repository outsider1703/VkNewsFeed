//
//  NewsFeedModels.swift
//  VkNewsFeed
//
//  Created by Macbook on 13.01.2021.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

enum NewsFeed {
    
    enum Model {
        struct Request {
            enum RequestType {
                case getNewsFeed
                case revealPostIds(postId: Int)
            }
        }
        struct Response {
            enum ResponseType {
                case presentNewsFeed(feed: FeedResponse, revealedPostIds: [Int])
            }
        }
        struct ViewModel {
            enum ViewModelData {
                case displayNewsFeed(feedViewModel: FeedViewModel)
            }
        }
    }
}

struct FeedViewModel {
    struct Cell: FeedCellViewModelProtocol {
        var postId: Int
        
        var iconImageUrl: String
        var name: String
        var date: String
        var post: String?
        var like: String?
        var comment: String?
        var share: String?
        var views: String?
        var photoAttachement: FeedCellPhotoAttachementViewModelProtocol?
        var sizes: FeedCellSizesProtocol
    }
    
    struct FeedCellPhotoAttachement: FeedCellPhotoAttachementViewModelProtocol {
        var photoUrlString: String?
        var width: Int
        var height: Int
    }
    
    let cells: [Cell]
}
