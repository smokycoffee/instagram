//
//  IGTextField.swift
//  Instagram-clone
//
//  Created by Tsenguun on 14/3/23.
//

import UIKit

class IGTextField: UITextField {

    override init(frame: CGRect) {
        super.init(frame: frame)
        leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 50))
        leftViewMode = .always
        layer.cornerRadius = 10
        layer.borderWidth = 1
        layer.borderColor = UIColor.secondaryLabel.cgColor
        backgroundColor = .secondarySystemBackground
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
