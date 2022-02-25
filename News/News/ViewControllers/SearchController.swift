//
//  SearchController.swift
//  News
//
//  Created by Abhishek Kumar on 24/02/22.
//

import UIKit
import SafariServices

class SearchController: UIViewController {
    
    private let viewmodel = SearchViewModel(networkService: NetworkClient.shared)
    private let searchBarVc = UISearchController(searchResultsController: nil)
    private var searchKey = ""
    
    private lazy var paginatingView: PaginatingListView = {
        $0.frame = view.frame
        $0.delegate = self
        return $0
    }(PaginatingListView())
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        navigationItem.title = "Search"
        super.viewDidLoad()
        viewmodel.getTopHeadLines(for: "")
        setupSearchBar()
        setupBinding()
    }
    
    override func viewDidLayoutSubviews() {
        view.addSubview(paginatingView)
        super.viewDidLayoutSubviews()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        viewmodel.resetPaginationFlagAndDatasource()
        super.viewDidDisappear(animated)
    }
    
    private func setupSearchBar() {
        navigationItem.searchController = searchBarVc
        searchBarVc.searchBar.delegate = self
    }
}

extension SearchController {
    
    func setupBinding() {
        
        viewmodel.datasource.subscribe { [weak self] articles in
            DispatchQueue.main.async {
                self?.paginatingView.update(list: articles)
                self?.searchBarVc.dismiss(animated: false, completion: nil)
            }
        }.disposed(by: disposeBag)
        
        viewmodel.error.subscribe { [weak self] errorMessage in
            DispatchQueue.main.async {
                self?.view.showToast(message: errorMessage,
                                     yPosition: self?.view.center.y ?? CGFloat(100), duration: 3)
            }
        }.disposed(by: disposeBag)
    }
}

extension SearchController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let text = searchBar.text, !text.isEmpty {
            searchKey = text
            viewmodel.resetPaginationFlagAndDatasource()
            viewmodel.getTopHeadLines(for: text)
        }
    }
}

extension SearchController: PaginatingDelegate {
    
    func fetchMore() {
        
        if searchKey.isEmpty {
            return
        }
        
        if viewmodel.isPaginating {
            return
        }
        
        viewmodel.getTopHeadLines(for: searchKey, pagination: true)
    }
    
    func dataAtSelectedRow(data: GenericProtocol) {
        if let article = data as? Article {
            let vc = NewsDetailsVC(article: article)
            present(vc, animated: true, completion: nil)
        }
    }
}
