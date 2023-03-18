//
//  PosterCollectionViewCell.swift
//  Instagram-clone
//
//  Created by Tsenguun on 18/3/23.
//

import UIKit
import SDWebImage
import SnapKit

final class PosterCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "PosterCollectionViewCell"
    
    private let imageView: UIImageView = {
       let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.layer.masksToBounds = true
        
        return imageView
    }()
    
    private let usernameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .regular)
        
        return label
    }()
    
    private let moreButton: UIButton = {
        let button = UIButton()
        button.tintColor = .label
        let image = UIImage(systemName: "ellipsis", withConfiguration: UIImage.SymbolConfiguration(pointSize: 20))
        button.setImage(image, for: .normal)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.clipsToBounds = true
        contentView.backgroundColor = .systemBackground
        contentView.addSubview(imageView)
        contentView.addSubview(usernameLabel)
        contentView.addSubview(moreButton)
        moreButton.addTarget(self, action: #selector(didTapMore), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func didTapMore() {
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let imagePadding: CGFloat = 4
        let imageSize: CGFloat = contentView.height - (imagePadding * 2)
        imageView.snp.makeConstraints { make in
            make.leading.top.bottom.equalToSuperview().inset(imagePadding)
            make.width.equalTo(imageSize)
            make.height.equalTo(imageSize)
        }
        imageView.layer.cornerRadius = imageSize/2
        
        usernameLabel.sizeToFit()
        usernameLabel.snp.makeConstraints { make in
            make.leading.equalTo(imageView.snp.trailing).offset(10)
            make.centerY.equalTo(imageView.snp.centerY)
            make.width.equalTo(usernameLabel.width)
            make.height.equalTo(contentView.height)
        }
        
        moreButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(5)
            make.centerY.equalTo(usernameLabel.snp.centerY)
            make.width.height.equalTo(50)
        }
        
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        usernameLabel.text = nil
        imageView.image = nil
    }
    
    func configure(with viewModel: PosterCollectionViewCellViewModel) {
        usernameLabel.text = viewModel.username
        imageView.sd_setImage(with: viewModel.profilePictureUrl, completed: nil)
    }
}
