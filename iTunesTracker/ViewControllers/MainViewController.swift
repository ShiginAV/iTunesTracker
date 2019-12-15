//
//  ViewController.swift
//  iTunesTracker
//
//  Created by Alexander on 02/10/2019.
//  Copyright © 2019 Alexander Shigin. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    
    var tableView = UITableView()
    var trackList = [Track]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar()
        configureTableView()
    }
    
    fileprivate func setupNavigationBar() {
        navigationItem.title = "iTunes Tracker"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.delegate = self
        
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
    }

    func configureTableView() {
        view.addSubview(tableView)
        setTableViewDelegates()
        tableView.register(TrackCell.self, forCellReuseIdentifier: "TrackCell")
        tableView.rowHeight = 116
        setupConstraints()
    }

    func setTableViewDelegates() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func setupConstraints() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    
    private func makeContextMenu() -> UIMenu {
        let share = UIAction(title: "Share", image: UIImage(systemName: "square.and.arrow.up")) { _ in
            print("Share")
        }
        
        let delete = UIAction(title: "Delete", image: UIImage(systemName: "trash"), attributes: .destructive) { _ in
            print("Delete")
        }
        
        let moreMenu = UIMenu(title: "", options: .displayInline, children: [
            UIAction(title: "More...", image: UIImage(systemName: "ellipsis.circle")) { _ in
                print("More")
            }
        ])
        
        return UIMenu(title: "", image: nil, identifier: nil, options: [], children: [share, delete, moreMenu])
    }
    
    private func makePhotoPreview() -> UITargetedPreview? {
        //TODO: get index for selected cell
        guard let indexPath = tableView.indexPathForSelectedRow else { return nil }
        guard let cell = tableView.cellForRow(at: indexPath) as? TrackCell else { return nil }
        let imagePreview = UITargetedPreview(view: cell.albumImageView)
        return imagePreview
    }
}

//MARK: - UITableViewDelegate+DataSource
extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return trackList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TrackCell", for: indexPath) as! TrackCell
        let track = trackList[indexPath.row]
        cell.setup(track)
        
        //setup image
        NetworkManager.shared.fetchImage(url: track.albumImage) { image in
            DispatchQueue.main.async {
                cell.albumImageView.image = image
            }
        }
        return cell
    }
    
    //Context Menu
    func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        
        let configuration = UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { _ in
            return self.makeContextMenu()
        }
        
        return configuration
    }
    
    func tableView(_ tableView: UITableView, previewForHighlightingContextMenuWithConfiguration configuration: UIContextMenuConfiguration) -> UITargetedPreview? {
        
        return makePhotoPreview()
    }
}

extension MainViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchBar.text, text != "" else { return }
        
        NetworkManager.shared.fetchSearchResult(searchText: text) { trackList in
            guard let trackList = trackList else { return }
            self.trackList = trackList.results
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
}
