//
//  CommentNotificationTableViewCell.swift
//  Instagram-clone
//
//  Created by Tsenguun on 25/3/23.
//

import UIKit

class CommentNotificationTableViewCell: UITableViewCell {

    static let identifier = "CommentNotificationTableViewCell"
    
    private let profilPictureImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let postImageView: UIImageView = {
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
    
    
    // MARK: - Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.clipsToBounds = true
        contentView.addSubview(profilPictureImageView)
        contentView.addSubview(label)
        contentView.addSubview(postImageView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
        
        let postSize: CGFloat = contentView.height - 6
        postImageView.snp.makeConstraints { make in
            make.width.height.equalTo(postSize)
//            make.leading.equalTo(contentView.width - postSize - 10 )
            make.top.equalTo(contentView.snp.top).offset(3)
            make.trailing.equalTo(contentView.snp.trailing).offset(-10)
        }
        
        let labelSize = label.sizeThatFits(CGSize(width: contentView.width - profilPictureImageView.width - postSize - 30, height: contentView.height))
        label.snp.makeConstraints { make in
//            make.width.equalTo(labelSize.width)
            make.width.lessThanOrEqualTo(labelSize.width)
            make.leading.equalTo(profilPictureImageView.snp.trailing).offset(10)
            //            make.centerY.equalTo(profilPictureImageView.snp.centerY)
            make.height.equalTo(contentView.height)
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        label.text = nil
        profilPictureImageView.image = nil
        postImageView.image = nil
    }
    
    public func configure(with viewModel: CommentNotificationCellViewModel) {
        profilPictureImageView.sd_setImage(with: viewModel.profilePictureURL)
        postImageView.sd_setImage(with: viewModel.postURL)
        label.text = viewModel.username + " commented on your post"
    }
}
