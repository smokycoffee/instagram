//
//  ViewController.swift
//  Instagram-clone
//
//  Created by Tsenguun on 13/3/23.
//

import UIKit
import SnapKit

class HomeViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
   
    private var collectionView: UICollectionView?
    
    private var viewModels = [[HomeFeedCellType]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        title = "Instagram"
        view.backgroundColor = .systemBackground
        
        configureCollectionView()
        fetchPosts()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        collectionView?.snp.makeConstraints { make in
            make.width.height.equalToSuperview()
        }
    }
    
    private func fetchPosts() {
        // mock data
        let postData: [HomeFeedCellType] = [
            .poster(viewModel: PosterCollectionViewCellViewModel(username: "admin", profilePictureUrl: URL(string: "https://i.pinimg.com/originals/c0/97/8c/c0978c0f0ac5fb1619687ab6bbb40dd7.jpg")!)),
            .post(viewModel: PostCollectionViewCellViewModel(postUrl: URL(string: "https://i.pinimg.com/originals/c0/97/8c/c0978c0f0ac5fb1619687ab6bbb40dd7.jpg")!)),
            .actions(viewModel: PostActionsCollectionViewCellVIewModel(isLiked: true)),
            .likeCount(viewModel: PostLikesCollectionViewCellViewModel(likers: ["david", "ss"])),
            .caption(viewModel: PostCaptionCollectionViewCellViewModel(username: "admin", caption: "Working on the instagram cells. Instagram within instagram #inception :)")),
            .timestamp(viewModel: PostDateTimeCollectionViewCellViewModel(date: Date()))
        ]
        
        viewModels.append(postData)
        collectionView?.reloadData()
    }
    
    // CollectionView
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return viewModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModels[section].count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cellType = viewModels[indexPath.section][indexPath.row]
        
        switch cellType {
            
        case .poster(let viewModel):
            
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PosterCollectionViewCell.identifier, for: indexPath) as? PosterCollectionViewCell else {
                return UICollectionViewCell()
                // or fatalError()
            }
            cell.configure(with: viewModel)
            cell.delegate = self
            return cell
            
        case .post(let viewModel):
            
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PostCollectionViewCell.identifier, for: indexPath) as? PostCollectionViewCell else {
                return UICollectionViewCell()
                // or fatalError()
            }
            cell.configure(with: viewModel)
            cell.delegate = self
            return cell
            
        case .actions(let viewModel):
            
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PostActionsCollectionViewCell.identifier, for: indexPath) as? PostActionsCollectionViewCell else {
                return UICollectionViewCell()
                // or fatalError()
            }
            cell.configure(with: viewModel)
            cell.delegate = self
            return cell
            
        case .likeCount(let viewModel):
            
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PostLikesCollectionViewCell.identifier, for: indexPath) as? PostLikesCollectionViewCell else {
                return UICollectionViewCell()
                // or fatalError()
            }
            cell.configure(with: viewModel)
            cell.delegate = self
            return cell

            
        case .caption(let viewModel):
            
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PostCaptionCollectionViewCell.identifier, for: indexPath) as? PostCaptionCollectionViewCell else {
                return UICollectionViewCell()
                // or fatalError()
            }
            cell.configure(with: viewModel)
            cell.delegate = self
            return cell
            
        case .timestamp(let viewModel):
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PostDateTimeCollectionViewCell.identifier, for: indexPath) as? PostDateTimeCollectionViewCell else {
                return UICollectionViewCell()
                // or fatalError()
            }
            cell.configure(with: viewModel)
            return cell
            
        }
    }

}

extension HomeViewController: PosterCollectionViewCellDelegate {
    func posterCollectionViewCellDidTapMore(_ cell: PosterCollectionViewCell) {
        print("tapped more")
        let sheet = UIAlertController(title: "Post Actions", message: nil, preferredStyle: .actionSheet)
        sheet.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        sheet.addAction(UIAlertAction(title: "Share Post", style: .default))
        sheet.addAction(UIAlertAction(title: "Report Post", style: .destructive))
        
        present(sheet, animated: true)
    }
    
    func posterCollectionViewCellDidTapUsername(_ cell: PosterCollectionViewCell) {
        print("tapped username")
        let vc = ProfileViewController(user: User(username: "admin", email: "admin@gmail.com"))
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension HomeViewController: PostCollectionViewCellDelegate {
    func postCollectionViewCellDidTapLike(_ cell: PostCollectionViewCell) {
        print("liked post")
    }
}

extension HomeViewController: PostActionsCollectionViewCellDelegate {
    func postActionsCollectionViewCellDidTapLike(_ cell: PostActionsCollectionViewCell, isLiked: Bool) {
        print("liked")
        
        // call database to update liked and unlike state
        
    }
    
    func postActionsCollectionViewCellDidTapComments(_ cell: PostActionsCollectionViewCell) {
        let vc = PostViewController()
        vc.title = "Post"
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func postActionsCollectionViewCellDidTapShare(_ cell: PostActionsCollectionViewCell) {
        print("tapped share")
        let vc = UIActivityViewController(activityItems: ["sharing to instagram within instagram O.O"], applicationActivities: [])
        present(vc, animated: true)
    }
}

extension HomeViewController: PostLikesCollectionViewCellDelegate {
    func postLikesCollectionViewCellDidTapLikeCount(_ cell: PostLikesCollectionViewCell) {
        print("tapped like count")
        let vc = ListViewController()
        
        vc.title = "Likes"
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension HomeViewController: PostCaptionCollectionViewCellDelegate {
    func postCaptionCollectionViewCellDidTapCaption(_ cell: PostCaptionCollectionViewCell) {
        print("tapped caption")
    }
}

extension HomeViewController {
    
    func configureCollectionView() {
        // 60 + 40 + 40 + 60 + 40
        let sectionHeight: CGFloat = 240 + view.width
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewCompositionalLayout(sectionProvider: { index, _ in
            
            // cell for poster
            let posterItem = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(60)))
            
            // bigger cell for post
            let postItem = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalWidth(1)))
            
            // cell with actions
            let actionsItem = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(40)))
            
            // like count cell
            let likeCountItem = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(40)))

            // timestamp cell
            let captionItem = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(60)))
            
            let timeStampItem = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(40)))

            
            // Group
            let group = NSCollectionLayoutGroup.vertical(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(sectionHeight)), subitems: [posterItem, postItem, actionsItem, likeCountItem, captionItem, timeStampItem])
            
            // Sections
            let section = NSCollectionLayoutSection(group: group)
            
            section.contentInsets = NSDirectionalEdgeInsets(top: 3, leading: 0, bottom: 10, trailing: 0)
            
            return section
        }))

        
        view.addSubview(collectionView)
        collectionView.backgroundColor = .systemBackground
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.register(PosterCollectionViewCell.self, forCellWithReuseIdentifier: PosterCollectionViewCell.identifier)
        collectionView.register(PostCollectionViewCell.self, forCellWithReuseIdentifier: PostCollectionViewCell.identifier)
        collectionView.register(PostActionsCollectionViewCell.self, forCellWithReuseIdentifier: PostActionsCollectionViewCell.identifier)
        collectionView.register(PostLikesCollectionViewCell.self, forCellWithReuseIdentifier: PostLikesCollectionViewCell.identifier)
        collectionView.register(PostCaptionCollectionViewCell.self, forCellWithReuseIdentifier: PostCaptionCollectionViewCell.identifier)
        collectionView.register(PostDateTimeCollectionViewCell.self, forCellWithReuseIdentifier: PostDateTimeCollectionViewCell.identifier)

        self.collectionView = collectionView
    }
    
}

