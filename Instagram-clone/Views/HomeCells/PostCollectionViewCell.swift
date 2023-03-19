//
//  PostCollectionViewCell.swift
//  Instagram-clone
//
//  Created by Tsenguun on 18/3/23.
//

import UIKit
import SDWebImage
import SnapKit

protocol PostCollectionViewCellDelegate: AnyObject {
    func postCollectionViewCellDidTapLike(_ cell: PostCollectionViewCell)
}

class PostCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "PostCollectionViewCell"
    
    weak var delegate: PostCollectionViewCellDelegate?
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        
        return imageView
    }()
    
    private let heartImageView: UIImageView = {
        let image = UIImage(systemName: "suit.heart.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 40))
        let imageView = UIImageView(image: image)
        imageView.tintColor = .red
        imageView.isHidden = true
        imageView.alpha = 0
        return imageView
    }()
    
    // MARK: - INIT
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.clipsToBounds = true
        contentView.backgroundColor = .secondarySystemBackground
        contentView.addSubview(imageView)
        contentView.addSubview(heartImageView)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTapLike))
        tap.numberOfTapsRequired = 2
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(tap)
    }
    
    @objc func didTapLike() {
        
        heartImageView.isHidden = false
        UIView.animate(withDuration: 0.4) {
            self.heartImageView.alpha = 1
        } completion: { done in
            if done {
                UIView.animate(withDuration: 0.4) {
                    self.heartImageView.alpha = 0
                } completion: { done in
                    if done {
                        self.heartImageView.isHidden = true
                    }
                }
            }
        }
        
        delegate?.postCollectionViewCellDidTapLike(self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imageView.snp.makeConstraints { make in
            make.width.height.equalToSuperview()
//            make.width.height.equalTo(contentView.bounds)
        }
        
        let size: CGFloat = contentView.width / 5
        heartImageView.snp.makeConstraints { make in
            make.width.height.equalTo(size)
            make.centerY.equalTo(contentView.height/2)
            make.centerX.equalTo(contentView.width/2)
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
    }
    
    func configure(with viewModel: PostCollectionViewCellViewModel) {
        imageView.sd_setImage(with: viewModel.postUrl, completed: nil)
    }
}
