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
        view.backgroundColor = .systemBackground
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
        
        // generate post id
        guard let newPostID = createNewPostID() else {
            return
        }
        // upload post
        StorageManager.shared.uploadPost(data: image.pngData(), id: newPostID) { newPostDownload in
            guard let url = newPostDownload else {
                print("error: failed to upload")
                return
            }
            // New POst
            
            let newPost = Post(id: newPostID, caption: caption, postedDate: String.date(from: Date()) ?? "", postURLString: url.absoluteString, likers: [])
            
            // update database
            DatabaseManager.shared.createPost(newPost: newPost) { [weak self] finished in
                guard finished else {
                    return
                }
                DispatchQueue.main.async {
                    self?.tabBarController?.tabBar.isHidden = false
                    self?.tabBarController?.selectedIndex = 0
                    self?.navigationController?.popToRootViewController(animated: false)
                }
            }
        }
    }
    
    private func createNewPostID() -> String? {
        let date = Date()
        let timeStamp = date.timeIntervalSince1970
        
        let randomNumber = Int.random(in: 0...1000)
        guard let username = UserDefaults.standard.string(forKey: "username") else {
            return nil
        }
        
        return "\(username)_\(randomNumber)_\(timeStamp)"
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
            make.top.equalTo(imageView.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(10)
        }
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "Add caption..." {
            textView.text = nil
        }
    }

}
