//
//  ViewController.swift
//  Chirper
//
//  Created by 전정철 on 16/07/2018.
//  Copyright © 2018 MarkiiimarK. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

    let emptyView: ResultView = {
        let rv = ResultView(frame:
            CGRect(origin: .zero, size: CGSize(width: deviceWidth, height: deviceHeight-75)))
        rv.message = "No results! \nTry searching for something different."
        return rv
    }()
    
    let loadingView: LoadingView = {
        let lv = LoadingView(frame: CGRect(origin: .zero, size: CGSize(width: deviceWidth, height: 128)))
        return lv
    }()
    
    let errorView: ErrorView = {
        let ev = ErrorView(frame: .zero)
        return ev
    }()
    
    lazy var tableView: BaseTableView = {
        let tv = BaseTableView()
        tv.delegate = self
        tv.dataSource = self
        return tv
    }()
    
    lazy var searchController: UISearchController = {
        let sc = UISearchController(searchResultsController: nil)
        sc.obscuresBackgroundDuringPresentation = false
        sc.searchBar.delegate = self
        sc.searchBar.autocapitalizationType = .none
        sc.searchBar.autocorrectionType = .no
        sc.searchBar.tintColor = .white
        sc.searchBar.barTintColor = .white
        return sc
    }()
    
    let networkingServie = NetworkingService()
    var recordings: [Recording]?
    var error: Error?
    
    var isLoading = false {
        didSet {
            loadingView.isAnimating = isLoading
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Chirper"
        prepareTableView()
        prepareSearchBar()
        loadRecordings()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        searchController.searchBar.becomeFirstResponder()
    }
    

}

@objc extension MainViewController {
    func loadRecordings() {
        isLoading = true
        tableView.tableFooterView = loadingView
        recordings = []
        tableView.reloadData()
        
        let query = searchController.searchBar.text
        networkingServie.fetchRecordings(matching: query, page: 1) { [weak self] (resp) in
            guard let `self` = self else { return }
            
            self.searchController.searchBar.endEditing(true)
            self.isLoading = false
            self.update(response: resp)
        }
    }
}

fileprivate extension MainViewController {
    
    func prepareSearchBar() {
        #if DEBUG
        print("navigationBarHeight: \(UINavigationBar.height)")
        #endif
        
        let textFieldInSearchBar = UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self])
        textFieldInSearchBar.defaultTextAttributes = [
            NSAttributedStringKey.foregroundColor.rawValue: UIColor.white
        ]
        navigationItem.searchController = searchController
        searchController.searchBar.becomeFirstResponder()
    }
    
    func prepareTableView() {
        view.addSubview(tableView)
        tableView.anchor(view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        tableView.register(BirdSoundTableViewCell.self, forCellReuseIdentifier: BirdSoundTableViewCell.identifier)
    }
    
    
    func update(response: RecordingsResult) {
        if let recordings = response.recordings, !recordings.isEmpty {
            tableView.tableFooterView = nil
        } else if let error = response.error {
            errorView.errorMessage = error.localizedDescription
            tableView.tableFooterView = errorView
            tableView.reloadData()
        } else {
            tableView.tableFooterView = emptyView
        }
        
        recordings = response.recordings
        error = response.error
        tableView.reloadData()
    }
}

extension MainViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        #if DEBUG
        print("MainViewController:searchBar,selectedScopeButtonIndexDidChange")
        #endif
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(loadRecordings), object: nil)
        perform(#selector(loadRecordings), with: nil, afterDelay: 0.5)
    }
}

extension MainViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        #if DEBUG
        print("navigationBarHeight")
        #endif
        return 100
    }
}

extension MainViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recordings?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: BirdSoundTableViewCell.identifier, for: indexPath) as? BirdSoundTableViewCell else { return UITableViewCell() }
        
        if let recordings = recordings {
            cell.load(recording: recordings[indexPath.row])
        }
        return cell
    }
}

