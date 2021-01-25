//
//  NewsFeedCell.swift
//  VkNewsFeed
//
//  Created by Macbook on 15.01.2021.
//

import Foundation
import UIKit

protocol FeedCellViewModelProtocol {
    var iconImageUrl: String { get }
    var name: String { get }
    var date: String { get }
    var post: String? { get }
    var like: String? { get }
    var comment: String? { get }
    var share: String? { get }
    var views: String? { get }
    var photoAttachement: FeedCellPhotoAttachementViewModelProtocol? { get }
    var sizes: FeedCellSizesProtocol { get }
}

protocol FeedCellSizesProtocol {
    var postLabelFrame: CGRect { get }
    var attachementFrame: CGRect { get }
    var bottonViewFrame: CGRect { get }
    var totalHeight: CGFloat { get }
}

protocol FeedCellPhotoAttachementViewModelProtocol {
    var photoUrlString: String? { get }
    var width: Int { get }
    var height: Int { get }
}

class NewsFeedCell: UITableViewCell {
    static let reuseId = "NewsFeedCell"
    
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var iconImage: WebImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var postLabel: UILabel!
    @IBOutlet weak var postImageView: WebImageView!
    @IBOutlet weak var likeLabel: UILabel!
    @IBOutlet weak var commentLabel: UILabel!
    @IBOutlet weak var sharesLabel: UILabel!
    @IBOutlet weak var viewsLabel: UILabel!

    override func prepareForReuse() {
        iconImage.set(imageURL: nil)
        postImageView.set(imageURL: nil)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        iconImage.layer.cornerRadius = iconImage.frame.width / 2
        iconImage.clipsToBounds = true

        cardView.layer.cornerRadius = 10
        cardView.clipsToBounds = true
        
        backgroundColor = .clear
        selectionStyle = .none
    }
    
    func set(viewModel: FeedCellViewModelProtocol) {
        iconImage.set(imageURL: viewModel.iconImageUrl)
        nameLabel.text = viewModel.name
        dateLabel.text = viewModel.date
        postLabel.text = viewModel.post
        likeLabel.text = viewModel.like
        commentLabel.text = viewModel.comment
        sharesLabel.text = viewModel.share
        viewsLabel.text = viewModel.views
        
        postLabel.frame = viewModel.sizes.postLabelFrame
        postImageView.frame = viewModel.sizes.attachementFrame
        bottomView.frame = viewModel.sizes.bottonViewFrame
        
        if let photoAttachement = viewModel.photoAttachement {
            postImageView.set(imageURL: photoAttachement.photoUrlString)
            postImageView.isHidden = false
        } else {
            postImageView.isHidden = true
        }
    }
}
