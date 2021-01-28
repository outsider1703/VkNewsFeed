//
//  NewsFeedPresenter.swift
//  VkNewsFeed
//
//  Created by Macbook on 13.01.2021.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol NewsFeedPresentationLogic {
    func presentData(response: NewsFeed.Model.Response.ResponseType)
}

class NewsFeedPresenter: NewsFeedPresentationLogic {
    weak var viewController: NewsFeedDisplayLogic?
    var cellLayoutCalculater: FeedCellLayourCalculatorProtocol = NewsFeedCellLayoutCalculator()
    
    let dateFormatter: DateFormatter = {
        let dt = DateFormatter()
        dt.locale = Locale(identifier: "ru_RU")
        dt.dateFormat = "d.MM 'в' HH:mm"
        return dt
    }()
    
    func presentData(response: NewsFeed.Model.Response.ResponseType) {
        switch response {
        case .presentNewsFeed(let feed, let revealedPostIds):
            let cells = feed.items.map { feedItem in
                cellViewModel(from: feedItem,
                              profiles: feed.profiles,
                              groups: feed.groups,
                              revealedPostIds: revealedPostIds)
            }
            let feedViewModel = FeedViewModel.init(cells: cells)
            viewController?.displayData(viewModel: .displayNewsFeed(feedViewModel: feedViewModel))
        }
    }
    
    private func cellViewModel(from feedItem: FeedItem, profiles: [Profile], groups: [Group], revealedPostIds: [Int]) -> FeedViewModel.Cell {
        let profile = self.profile(for: feedItem.sourceId, profiles: profiles, groups: groups)
        
        let photoAttachement = self.photoAttachement(feedItem: feedItem)
        
        let date = Date(timeIntervalSince1970: feedItem.date)
        let dateTitle = dateFormatter.string(from: date)
        
        let isFullSized = revealedPostIds.contains(feedItem.postId)
        
        let sizes = cellLayoutCalculater.sizes(postText: feedItem.text, photoAttachement: photoAttachement, isFullSizePost: isFullSized)
        
        return FeedViewModel.Cell.init(postId: feedItem.postId,
                                       iconImageUrl: profile.photo,
                                       name: profile.name,
                                       date: dateTitle,
                                       post: feedItem.text,
                                       like: String(feedItem.likes?.count ?? 0),
                                       comment: String(feedItem.comments?.count ?? 0),
                                       share: String(feedItem.reposts?.count ?? 0),
                                       views: String(feedItem.views?.count ?? 0),
                                       photoAttachement: photoAttachement,
                                       sizes: sizes)
    }
    
    private func profile(for sourseId: Int, profiles: [Profile], groups: [Group]) -> ProfileRepresentable {
        
        let profileOrGroups: [ProfileRepresentable] = sourseId >= 0 ? profiles : groups
        let normalSourseId = sourseId >= 0 ? sourseId : -sourseId
        let profileRepresentable = profileOrGroups.first { (myprofileRepresentable) -> Bool in
            myprofileRepresentable.id == normalSourseId
        }
        return profileRepresentable!
    }
    
    private func photoAttachement(feedItem: FeedItem) -> FeedViewModel.FeedCellPhotoAttachement? {
        guard let photos = feedItem.attachments?.compactMap({ attachment in
            attachment.photo
        }), let firstPhoto = photos.first else { return nil }
        return FeedViewModel.FeedCellPhotoAttachement(photoUrlString: firstPhoto.srcBIG,
                                                      width: firstPhoto.width,
                                                      height: firstPhoto.height)
    }
    
}
