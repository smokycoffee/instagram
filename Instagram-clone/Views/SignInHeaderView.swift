//
//  SignInHeaderView.swift
//  Instagram-clone
//
//  Created by Tsenguun on 14/3/23.
//

import UIKit
import SnapKit

class SignInHeaderView: UIView {

    private var gradientlayer: CALayer?
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "text_logo")
        imageView.contentMode = .scaleAspectFit
        
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        clipsToBounds = true
        createGradient()
        addSubview(imageView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func createGradient() {
        let gradientlayer = CAGradientLayer()
        gradientlayer.colors = [UIColor.systemBlue.cgColor, UIColor.systemPink.cgColor]
        
        layer.addSublayer(gradientlayer)
        self.gradientlayer = gradientlayer
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientlayer?.frame = layer.bounds
//        imageView.frame = CGRect(x: width/4, y: 20, width: width/2, height: height-40)
        imageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.centerX.equalTo(width/2)
            make.width.equalTo(width/2)
            make.height.equalTo(height-40)
        }
    }

}
