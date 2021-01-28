//
//  NewsFeedCellLayoutCalculator.swift
//  VkNewsFeed
//
//  Created by Macbook on 19.01.2021.
//

import Foundation
import UIKit

protocol FeedCellLayourCalculatorProtocol {
    func sizes(postText: String?, photoAttachement: FeedCellPhotoAttachementViewModelProtocol?, isFullSizePost: Bool) -> FeedCellSizesProtocol
}

struct Sizes: FeedCellSizesProtocol {
    var postLabelFrame: CGRect
    var moreTextButtomFrame: CGRect
    var attachementFrame: CGRect
    var bottonViewFrame: CGRect
    var totalHeight: CGFloat
}

final class NewsFeedCellLayoutCalculator: FeedCellLayourCalculatorProtocol {
    
    private let screenWidth: CGFloat
    
    init(screenWidth: CGFloat = min(UIScreen.main.bounds.width, UIScreen.main.bounds.height)) {
        self.screenWidth = screenWidth
    }
    
    func sizes(postText: String?, photoAttachement: FeedCellPhotoAttachementViewModelProtocol?, isFullSizePost: Bool) -> FeedCellSizesProtocol {
        
        var showMoreTextButtom = false
        
        let cardViewWidth = screenWidth - Constants.cardInSets.left - Constants.cardInSets.right
        
        //MARK: Работа с postLabelFrame
        
        var postLabelFrame = CGRect(origin: CGPoint(x: Constants.postLabelInsets.left, y: Constants.postLabelInsets.top),
                                    size: CGSize.zero)
        
        if let text = postText, !text.isEmpty {
            let widht = cardViewWidth - Constants.postLabelInsets.left - Constants.postLabelInsets.right
            var height = text.height(width: widht, font: Constants.postLabelFont)
            
            let limitHeight = Constants.postLabelFont.lineHeight * Constants.minifiedPostLimitLines
            
            if !isFullSizePost && height > limitHeight {
                height = Constants.postLabelFont.lineHeight * Constants.minifiedPostLines
                showMoreTextButtom = true
            }
            
            postLabelFrame.size = CGSize(width: widht, height: height)
        }
        
        //MARK: Работа с moreTextButtomFrame

        var moreTextButtomSize = CGSize.zero
        
        if showMoreTextButtom {
            moreTextButtomSize = Constants.moreTextButtomSize
        }
        
        let moreTextButtomOrigin = CGPoint(x: Constants.moreTextButtomInsets.left, y: postLabelFrame.maxY)
        
        let moreTextButtomFrame = CGRect(origin: moreTextButtomOrigin, size: moreTextButtomSize)
        
        //MARK: Работа с attachementFrame
        
        let attachmentTop = postLabelFrame.size == CGSize.zero ? Constants.postLabelInsets.top : moreTextButtomFrame.maxY + Constants.postLabelInsets.bottom
        
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
        
        //MARK: Работа с totalHeight

        let totalHeight = bottomViewFrame.maxY + Constants.cardInSets.bottom
        
        return  Sizes(postLabelFrame: postLabelFrame,
                      moreTextButtomFrame: moreTextButtomFrame,
                      attachementFrame: attachmentFrame,
                      bottonViewFrame: bottomViewFrame,
                      totalHeight: totalHeight)
    }
    
}
