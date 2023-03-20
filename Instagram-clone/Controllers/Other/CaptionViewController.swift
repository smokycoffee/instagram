//
//  CaptionViewController.swift
//  Instagram-clone
//
//  Created by Tsenguun on 13/3/23.
//

import UIKit
import SnapKit

class CaptionViewController: UIViewController, UITextViewDelegate {
    
    private let image: UIImage
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFit
        
        return imageView
    }()
    
    private let textView: UITextView = {
        let textView = UITextView()
        textView.text = "Add caption..."
        textView.backgroundColor = .secondarySystemBackground
        textView.font = .systemFont(ofSize: 22)
        textView.textContainerInset = UIEdgeInsets(top: 3, left: 3, bottom: 3, right: 3)
        return textView
    }()
    
    init(image: UIImage) {
        self.image = image
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(imageView)
        imageView.image = image
        view.addSubview(textView)
        textView.delegate = self
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Upload", style: .done, target: self, action: #selector(didTapUpload))
    }
    
    @objc func didTapUpload() {
        textView.resignFirstResponder()
        var caption = textView.text ?? ""
        if caption == "Add Caption..." {
            caption = ""
        }
        
        // upload and upload to database
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let size: CGFloat = view.width / 4
        
        imageView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaInsets.top + 10)
            make.width.height.equalTo(size)
//            make.centerY.equalTo(view.width / 2)
            make.trailing.leading.equalToSuperview()
        }
        
        textView.snp.makeConstraints { make in
            make.width.equalTo(view.width-40)
            make.height.equalTo(100)
            make.top.equalTo(imageView.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(10)
        }
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "Add caption..." {
            textView.text = nil
        }
    }

}
