//
//  ViewController.swift
//  RSSReaderArcher
//
//  Created by Artem Karpovych on 11/2/19.
//  Copyright © 2019 Artem Karpovych. All rights reserved.
//

import UIKit

protocol MainVCDelegate: class {
    func openNewsPressed(news: NewsPosts)
    func openImageScreen(image: UIImage)
}

protocol MainVCCellDelegate: class {
    func imageButtonPressed(image: UIImage)
}

class MainVC: UIViewController, StoryboardLoadable {
    
    var dataSource = [NewsPosts]()
    var delegate: MainVCDelegate?
    var reachability: Reachability?
    var searchText: String = String()
    @IBOutlet weak var tableView: UITableView!
    
    static func makeViewController(delegate: MainVCDelegate) -> MainVC {
        let vc = loadFromStoryboard()
        vc.delegate = delegate
        vc.reachability = Reachability()
        return vc
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        navigationItem.leftBarButtonItem = nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(NewsCell.self)
        self.setupSearchBar()

        NewsRepository().start() { [weak self] news in
            if news.isEmpty {
                self?.showEmptyNewsAlert()
            }
            
            self?.dataSource = news
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.checkReachability), name: .reachabilityChanged, object: nil)
        self.checkReachability()
        try? self.reachability?.startNotifier()
    }
    
    func setupSearchBar() {
        let search = UISearchController(searchResultsController: nil)
        search.searchResultsUpdater = self
        search.obscuresBackgroundDuringPresentation = true
        search.searchBar.placeholder = "Type here to search"
        self.navigationItem.searchController = search
        definesPresentationContext = true
    }
    
    @objc func checkReachability() {
        if reachability?.connection.description == "No Connection" {
            self.showOfflineAlert()
        }
    }
}

extension MainVC: MainVCCellDelegate {
    func imageButtonPressed(image: UIImage) {
        self.delegate?.openImageScreen(image: image)
    }
}

extension MainVC: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        self.searchText = searchController.searchBar.text!
        tableView.reloadData()
    }
}

extension MainVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let dummy = UITableViewCell()
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: NewsCell.className) as? NewsCell else { return dummy }
        cell.fillWith(model: dataSource[indexPath.row], searchText: self.searchText)
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.delegate?.openNewsPressed(news: dataSource[indexPath.row])
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
}
