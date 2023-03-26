//
//  FollowNotificationTableViewCell.swift
//  Instagram-clone
//
//  Created by Tsenguun on 25/3/23.
//

import UIKit
import SnapKit

class FollowNotificationTableViewCell: UITableViewCell {

    static let identifier = "FollowNotificationTableViewCell"
    
    private let profilPictureImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let label: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 18)
        label.textAlignment = .left
        
        return label
    }()
    
    private let followButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 4
        button.layer.masksToBounds = true
        
        return button
    }()
    
    
    // MARK: - Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.clipsToBounds = true
        contentView.addSubview(profilPictureImageView)
        contentView.addSubview(label)
        contentView.addSubview(followButton)
        followButton.addTarget(self, action: #selector(didTapFollowButton), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func didTapFollowButton() {
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let imageSize: CGFloat = contentView.height / 1.5
        
        profilPictureImageView.snp.makeConstraints { make in
            make.width.height.equalTo(imageSize)
            make.leading.equalTo(contentView.snp.leading).offset(10)
            make.centerY.equalToSuperview()
        }
        profilPictureImageView.layer.cornerRadius = imageSize / 2
        
        let labelSize = label.sizeThatFits(CGSize(
            width: contentView.width - profilPictureImageView.width - followButton.width - 46
            , height: contentView.height))
        
        label.snp.makeConstraints { make in
            make.leading.equalTo(profilPictureImageView.snp.trailing).offset(10)
            //            make.centerY.equalTo(profilPictureImageView.snp.centerY)
            make.width.equalTo(labelSize.width)
            make.height.equalTo(contentView.height)
        }
        
        followButton.sizeToFit()
        followButton.snp.makeConstraints { make in
            make.centerY.equalTo(contentView.snp.centerY)
            make.leading.equalTo(contentView.width - followButton.width - 24)
            make.width.equalTo(followButton.width+16)
            make.height.equalTo(followButton.height)
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        label.text = nil
        profilPictureImageView.image = nil
        followButton.setTitle(nil, for: .normal)
        followButton.backgroundColor = nil
    }
    
    public func configure(with viewModel: FollowNotificationCellViewModel) {
        label.text = viewModel.username + " started following you"
        profilPictureImageView.sd_setImage(with: viewModel.profilePictureURL)
        
        followButton.setTitle(viewModel.isCurrentUserFollowing ? "Unfollow" : "Follow", for: .normal)
        followButton.backgroundColor = viewModel.isCurrentUserFollowing ? .systemBackground : .systemBlue
        followButton.setTitleColor(viewModel.isCurrentUserFollowing ? .label : .white, for: .normal)
        
        if viewModel.isCurrentUserFollowing {
            followButton.layer.borderWidth = 1
            followButton.layer.borderColor = UIColor.secondaryLabel.cgColor
        }
    }
}
