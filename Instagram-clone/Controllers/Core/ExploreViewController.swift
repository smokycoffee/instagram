//
//  ExploreViewController.swift
//  Instagram-clone
//
//  Created by Tsenguun on 13/3/23.
//

import UIKit

class ExploreViewController: UIViewController, UISearchResultsUpdating {
    
    private let searchVC = UISearchController(searchResultsController: SearchResultsViewController())

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Explore"
        view.backgroundColor = .systemBackground
        (searchVC.searchResultsController as? SearchResultsViewController)?.delegate = self
        searchVC.searchBar.placeholder = "Search for user..."
        searchVC.searchResultsUpdater = self
        navigationItem.searchController = searchVC
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let vc = searchController.searchResultsController as? SearchResultsViewController,
              let query = searchController.searchBar.text,
              !query.trimmingCharacters(in: .whitespaces).isEmpty else {
            return
        }
        
        DatabaseManager.shared.findUsers(with: query) { results in
            DispatchQueue.main.async {
                vc.update(with: results)
            }
        }
    }
}

extension ExploreViewController: SearchResultsViewControllerDelegate {
    func searchResultsViewController(_ vc: SearchResultsViewController, didSelectResultWith user: User) {
        let vc = ProfileViewController(user: user)
        navigationController?.pushViewController(vc, animated: true)

    }
}
