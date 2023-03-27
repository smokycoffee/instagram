//
//  LikeNotificationTableViewCell.swift
//  Instagram-clone
//
//  Created by Tsenguun on 25/3/23.
//

import UIKit

protocol LikeNotificationTableViewCellDelegate: AnyObject {
    func likeNotificationTableViewCell(_cell: LikeNotificationTableViewCell, didTapPost viewModel: LikeNotificationCellViewModel)
}

class LikeNotificationTableViewCell: UITableViewCell {

    static let identifier = "LikeNotificationTableViewCell"
    
    private var viewModel: LikeNotificationCellViewModel?
    weak var delegate: LikeNotificationTableViewCellDelegate?
    
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
        selectionStyle = .none
        contentView.clipsToBounds = true
        contentView.addSubview(profilPictureImageView)
        contentView.addSubview(label)
        contentView.addSubview(postImageView)
        
        postImageView.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTapPost))
        postImageView.addGestureRecognizer(tap)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func didTapPost() {
        guard let vm = viewModel else {
            return
        }
        delegate?.likeNotificationTableViewCell(_cell: self, didTapPost: vm)
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
            make.leading.equalTo(contentView.width - postSize - 10 )
            make.top.equalTo(contentView.top - 3).offset(3)
        }
        
        let labelSize = label.sizeThatFits(CGSize(width: contentView.width - profilPictureImageView.right - 25 - postSize, height: contentView.height))
        label.snp.makeConstraints { make in
            make.leading.equalTo(profilPictureImageView.snp.trailing).offset(10)
            //            make.centerY.equalTo(profilPictureImageView.snp.centerY)
            make.width.equalTo(labelSize.width)
            make.height.equalTo(contentView.height)
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        label.text = nil
        profilPictureImageView.image = nil
        postImageView.image = nil
    }
    
    public func configure(with viewModel: LikeNotificationCellViewModel) {
        self.viewModel = viewModel
        profilPictureImageView.sd_setImage(with: viewModel.profilePictureURL)
        postImageView.sd_setImage(with: viewModel.postURL)
        label.text = viewModel.username + " liked your post"
        
    }
}
