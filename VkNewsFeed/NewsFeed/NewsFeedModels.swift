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
                case getUser
                case revealPostIds(postId: Int)
                case getNextBatch
            }
        }
        struct Response {
            enum ResponseType {
                case presentNewsFeed(feed: FeedResponse, revealedPostIds: [Int])
                case presentUserInfo(user: UserResponse?)
                case presentFooterLoader
            }
        }
        struct ViewModel {
            enum ViewModelData {
                case displayNewsFeed(feedViewModel: FeedViewModel)
                case displayUser(userViewModel: UserViewModel)
                case displayFooterLoader
            }
        }
    }
}

struct UserViewModel: TitleViewViewModel {
    var photoUrlString: String?
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
        var photoAttachments: [FeedCellPhotoAttachementViewModelProtocol]
        var sizes: FeedCellSizesProtocol
    }
    
    struct FeedCellPhotoAttachement: FeedCellPhotoAttachementViewModelProtocol {
        var photoUrlString: String?
        var width: Int
        var height: Int
    }
    
    let cells: [Cell]
    let footerTitle: String?
}
