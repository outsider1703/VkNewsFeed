//
//  NewsFeedCellLayoutCalculator.swift
//  VkNewsFeed
//
//  Created by Macbook on 19.01.2021.
//

import Foundation
import UIKit

protocol FeedCellLayourCalculatorProtocol {
    func sizes(postText: String?, photoAttachement: FeedCellPhotoAttachementViewModelProtocol?) -> FeedCellSizesProtocol
}

struct Sizes: FeedCellSizesProtocol {
    var postLabelFrame: CGRect
    var attachementFrame: CGRect
    var bottonViewFrame: CGRect
    var totalHeight: CGFloat
}

struct Constants {
    static let cardInSets = UIEdgeInsets(top: 0, left: 8, bottom: 12, right: 8)
    static let topViewHeight: CGFloat = 40
    static let postLabelInsets = UIEdgeInsets(top: 8 + Constants.topViewHeight + 4, left: 8, bottom: 8, right: 8)
    static let postLabelFont = UIFont.systemFont(ofSize: 15)
    static let bottomViewHeight: CGFloat = 40
}

final class NewsFeedCellLayoutCalculator: FeedCellLayourCalculatorProtocol {
    
    private let screenWidth: CGFloat
    
    init(screenWidth: CGFloat = min(UIScreen.main.bounds.width, UIScreen.main.bounds.height)) {
        self.screenWidth = screenWidth
    }
    
    func sizes(postText: String?, photoAttachement: FeedCellPhotoAttachementViewModelProtocol?) -> FeedCellSizesProtocol {
        
        let cardViewWidth = screenWidth - Constants.cardInSets.left - Constants.cardInSets.right
        
        //MARK: Работа с postLabelFrame
        
        var postLabelFrame = CGRect(origin: CGPoint(x: Constants.postLabelInsets.left, y: Constants.postLabelInsets.top),
                                    size: CGSize.zero)
        
        if let text = postText, !text.isEmpty {
            let widht = cardViewWidth - Constants.postLabelInsets.left - Constants.postLabelInsets.right
            let height = text.height(width: widht, font: Constants.postLabelFont)
            
            postLabelFrame.size = CGSize(width: widht, height: height)
        }
        
        //MARK: Работа с attachementFrame
        
        let attachmentTop = postLabelFrame.size == CGSize.zero ? Constants.postLabelInsets.top : postLabelFrame.maxY + Constants.postLabelInsets.bottom
        
        var attachmentFrame = CGRect(origin: CGPoint(x: 0, y: attachmentTop),
                                      size: CGSize.zero)
        
        if let attachment = photoAttachement {
            let photoHeight: Float = Float(attachment.height)
            let photoWidth: Float = Float(attachment.width)
            let ratio = CGFloat(photoHeight / photoWidth)
            
            attachmentFrame.size = CGSize(width: cardViewWidth, height: cardViewWidth * ratio)
        }
        
        //MARK: Работа с bottonViewFrame

        let bottomViewTop = max(postLabelFrame.maxY, attachmentFrame.maxY)
        
        let bottomViewFrame = CGRect(origin: CGPoint(x: 0, y: bottomViewTop),
                                     size: CGSize(width: cardViewWidth, height: Constants.bottomViewHeight))
        
        //MARK: Работа с bottonViewFrame

        let totalHeight = bottomViewFrame.maxY + Constants.cardInSets.bottom
        
        return  Sizes(postLabelFrame: postLabelFrame,
                      attachementFrame: attachmentFrame,
                      bottonViewFrame: bottomViewFrame,
                      totalHeight: totalHeight)
    }
    
}
