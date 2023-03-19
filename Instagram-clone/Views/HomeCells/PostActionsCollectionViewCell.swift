//
//  PostActionsCollectionViewCell.swift
//  Instagram-clone
//
//  Created by Tsenguun on 18/3/23.
//

import UIKit

protocol PostActionsCollectionViewCellDelegate: AnyObject {
    func postActionsCollectionViewCellDidTapLike(_ cell: PostActionsCollectionViewCell, isLiked: Bool)
    func postActionsCollectionViewCellDidTapComments(_ cell: PostActionsCollectionViewCell)
    func postActionsCollectionViewCellDidTapShare(_ cell: PostActionsCollectionViewCell)
}

class PostActionsCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "PostActionsCollectionViewCell"
    
    weak var delegate: PostActionsCollectionViewCellDelegate?
    
    private var isLiked = false
    
    private let likeButton: UIButton = {
        let button = UIButton()
        button.tintColor = .label
        let image = UIImage(systemName: "suit.heart", withConfiguration: UIImage.SymbolConfiguration(pointSize: 40))
        button.setImage(image, for: .normal)
        return button
    }()
    
    private let commentButton: UIButton = {
        let button = UIButton()
        button.tintColor = .label
        let image = UIImage(systemName: "message", withConfiguration: UIImage.SymbolConfiguration(pointSize: 40))
        button.setImage(image, for: .normal)
        return button
    }()
    
    private let shareButton: UIButton = {
        let button = UIButton()
        button.tintColor = .label
        let image = UIImage(systemName: "paperplane", withConfiguration: UIImage.SymbolConfiguration(pointSize: 44))
        button.setImage(image, for: .normal)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.clipsToBounds = true
        contentView.backgroundColor = .systemBackground
        contentView.addSubview(likeButton)
        contentView.addSubview(commentButton)
        contentView.addSubview(shareButton)
        // Actions
        likeButton.addTarget(self, action: #selector(didTapLike), for: .touchUpInside)
        commentButton.addTarget(self, action: #selector(didTapComment), for: .touchUpInside)
        shareButton.addTarget(self, action: #selector(didTapShare), for: .touchUpInside)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func didTapLike() {
        if self.isLiked {
            let image = UIImage(systemName: "suit.heart", withConfiguration: UIImage.SymbolConfiguration(pointSize: 44))
            likeButton.setImage(image, for: .normal)
            likeButton.tintColor = .label
        } else {
            let image = UIImage(systemName: "suit.heart.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 44))
            likeButton.setImage(image, for: .normal)
            likeButton.tintColor = .systemRed
        }
        
        delegate?.postActionsCollectionViewCellDidTapLike(self, isLiked: !isLiked) // inverse, if liked, unlike. if not liked, like
        self.isLiked = !isLiked
    }
    
    @objc func didTapComment() {
        delegate?.postActionsCollectionViewCellDidTapComments(self)
    }
    
    @objc func didTapShare() {
        delegate?.postActionsCollectionViewCellDidTapShare(self)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let size: CGFloat = contentView.height / 1.5
        
        likeButton.snp.makeConstraints { make in
//            make.top.bottom.right.equalToSuperview()
            make.leading.equalToSuperview().offset(20)
            make.height.width.equalTo(size)
            make.centerY.equalTo(contentView.snp.centerY)
        }
        
        commentButton.snp.makeConstraints { make in
//            make.top.bottom.right.equalToSuperview()
            make.leading.equalTo(likeButton.snp.trailing).offset(10)
            make.height.width.equalTo(size)
            make.centerY.equalTo(contentView.snp.centerY)
        }
        shareButton.snp.makeConstraints { make in
            //            make.top.bottom.right.equalToSuperview()
            make.leading.equalTo(commentButton.snp.trailing).offset(10)
            make.height.width.equalTo(size)
            make.centerY.equalTo(contentView.snp.centerY)
        }
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    func configure(with viewModel: PostActionsCollectionViewCellVIewModel) {
        isLiked = viewModel.isLiked
        
        if viewModel.isLiked {
            let image = UIImage(systemName: "suit.heart.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 44))
            likeButton.setImage(image, for: .normal)
            likeButton.tintColor = .systemRed
        }
    }
}
