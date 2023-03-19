//
//  PostLikesCollectionViewCell.swift
//  Instagram-clone
//
//  Created by Tsenguun on 18/3/23.
//

import UIKit
import SnapKit
 
protocol PostLikesCollectionViewCellDelegate: AnyObject {
    func postLikesCollectionViewCellDidTapLikeCount(_ cell: PostLikesCollectionViewCell)
}

class PostLikesCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "PostLikesCollectionViewCell"
    weak var delegate: PostLikesCollectionViewCellDelegate?
    
    private let label: UILabel = {
       let label = UILabel()
        label.numberOfLines = 1
        label.isUserInteractionEnabled = true
        return label
    }()
        
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.clipsToBounds = true
        contentView.backgroundColor = .systemBackground
        contentView.addSubview(label)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTapLabel))
        
        label.addGestureRecognizer(tap)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func didTapLabel() {
        delegate?.postLikesCollectionViewCellDidTapLikeCount(self)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        label.snp.makeConstraints { make in
            make.width.height.equalToSuperview()
            make.leading.equalToSuperview().offset(20)
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        label.text = nil
    }
    
    func configure(with viewModel: PostLikesCollectionViewCellViewModel) {
        let users = viewModel.likers
        label.text = "\(users.count) Likes"
    }
}
