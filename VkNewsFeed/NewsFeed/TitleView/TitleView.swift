//
//  TitleView.swift
//  VkNewsFeed
//
//  Created by Macbook on 03.02.2021.
//

import Foundation
import UIKit

protocol TitleViewViewModel {
    var photoUrlString: String? { get }
}

class TitleView: UIView {
    
    private var myTextField = InsetableTextField()
    
    private let profileImage: WebImageView = {
        let image = WebImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.backgroundColor = .orange
        image.clipsToBounds = true
        return image
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        translatesAutoresizingMaskIntoConstraints = false
        addSubview(profileImage)
        addSubview(myTextField)
        makeConstraints()
    }
    
    func set(userViewModel: TitleViewViewModel) {
        profileImage.set(imageURL: userViewModel.photoUrlString)
    }
    
    private func makeConstraints() {
        profileImage.anchor(top: topAnchor,
                            leading: nil,
                            bottom: nil,
                            trailing: trailingAnchor,
                            padding: UIEdgeInsets(top: 4, left: 777, bottom: 777, right: 4))
        profileImage.heightAnchor.constraint(equalTo: myTextField.heightAnchor, multiplier: 1).isActive = true
        profileImage.widthAnchor.constraint(equalTo: myTextField.heightAnchor, multiplier: 1).isActive = true

        myTextField.anchor(top: topAnchor,
                           leading: leadingAnchor,
                           bottom: bottomAnchor,
                           trailing: profileImage.leadingAnchor,
                           padding: UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 12))
    }
    
    override var intrinsicContentSize: CGSize {
        return UIView.layoutFittingExpandedSize
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        profileImage.layer.masksToBounds = true
        profileImage.layer.cornerRadius = profileImage.frame.width / 2
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
