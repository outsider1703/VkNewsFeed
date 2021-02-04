//
//  GallaryCollectionViewCell.swift
//  VkNewsFeed
//
//  Created by Macbook on 01.02.2021.
//

import Foundation
import UIKit

class GallaryCollectionViewCell: UICollectionViewCell {
    static let reuseId = "GallaryCollectionViewCell"
    
    let myImageView: WebImageView = {
        let imageView = WebImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = #colorLiteral(red: 0.8901960784, green: 0.8980392157, blue: 0.9098039216, alpha: 1)
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(myImageView)
        
        myImageView.fillSuperview()
    }
    
    override func prepareForReuse() {
        myImageView.image = nil
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        myImageView.layer.masksToBounds = true
        myImageView.layer.cornerRadius = 10
        self.layer.shadowRadius = 3
        layer.shadowOpacity = 0.4
        layer.shadowOffset = CGSize(width: 2.5, height: 4)
    }
    
    func set(imageURL: String?) {
        myImageView.set(imageURL: imageURL)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
