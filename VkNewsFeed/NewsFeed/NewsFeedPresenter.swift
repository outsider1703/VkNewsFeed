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
            let footerTitle = String.localizedStringWithFormat(NSLocalizedString("newsfeed cells count", comment: ""), cells.count)
            let feedViewModel = FeedViewModel.init(cells: cells, footerTitle: footerTitle)
            viewController?.displayData(viewModel: .displayNewsFeed(feedViewModel: feedViewModel))
        case .presentUserInfo(let user):
            let userViewModel = UserViewModel.init(photoUrlString: user?.photo100)
            viewController?.displayData(viewModel: NewsFeed.Model.ViewModel.ViewModelData.displayUser(userViewModel: userViewModel))
        case .presentFooterLoader:
            viewController?.displayData(viewModel: .displayFooterLoader)
        }
    }
    
    private func cellViewModel(from feedItem: FeedItem, profiles: [Profile], groups: [Group], revealedPostIds: [Int]) -> FeedViewModel.Cell {
        let profile = self.profile(for: feedItem.sourceId, profiles: profiles, groups: groups)
        
        let photoAttachments = self.photoAttachments(feedItem: feedItem)
        
        let date = Date(timeIntervalSince1970: feedItem.date)
        let dateTitle = dateFormatter.string(from: date)
        
        let isFullSized = revealedPostIds.contains(feedItem.postId)
        
        let sizes = cellLayoutCalculater.sizes(postText: feedItem.text, photoAttachments: photoAttachments, isFullSizePost: isFullSized)
        
        return FeedViewModel.Cell.init(postId: feedItem.postId,
                                       iconImageUrl: profile.photo,
                                       name: profile.name,
                                       date: dateTitle,
                                       post: feedItem.text,
                                       like: formatterCounter(feedItem.likes?.count),
                                       comment: formatterCounter(feedItem.comments?.count),
                                       share: formatterCounter(feedItem.reposts?.count),
                                       views: formatterCounter(feedItem.views?.count),
                                       photoAttachments: photoAttachments,
                                       sizes: sizes)
    }
    
    private func formatterCounter(_ counter: Int?) -> String? {
        guard let counter = counter, counter > 0 else { return nil }
        var stringCounter = String(counter)
        if 4...6 ~= stringCounter.count {
            stringCounter = String(stringCounter.dropLast(3)) + "K"
        } else if stringCounter.count > 6 {
            stringCounter = String(stringCounter.dropLast(6)) + "M"
        }
        return stringCounter
    }
    
    private func profile(for sourseId: Int, profiles: [Profile], groups: [Group]) -> ProfileRepresentable {
        
        let profileOrGroups: [ProfileRepresentable] = sourseId >= 0 ? profiles : groups
        let normalSourseId = sourseId >= 0 ? sourseId : -sourseId
        let profileRepresentable = profileOrGroups.first { (myprofileRepresentable) -> Bool in
            myprofileRepresentable.id == normalSourseId
        }
        return profileRepresentable!
    }
    
    private func photoAttachments(feedItem: FeedItem) -> [FeedViewModel.FeedCellPhotoAttachement] {
        guard let attachments = feedItem.attachments else { return [] }
        
        return attachments.compactMap { (attachment) -> FeedViewModel.FeedCellPhotoAttachement? in
            guard let photo = attachment.photo else { return nil }
            return FeedViewModel.FeedCellPhotoAttachement.init(photoUrlString: photo.srcBIG,
                                                               width: photo.width,
                                                               height: photo.height)
        }
    }
    
}
