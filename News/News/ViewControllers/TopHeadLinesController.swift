//
//  TopHeadLinesController.swift
//  News
//
//  Created by Abhishek Kumar on 24/02/22.
//

import UIKit

class TopHeadLinesController: UIViewController {
    
    //MARK: - Dependency Injection.
    private let viewmodel = HeadLineViewModel(networkService: NetworkClient.shared)
    
    private lazy var paginatingView: PaginatingListView = {
        $0.frame = view.frame
        $0.delegate = self
        return $0
    }(PaginatingListView())
    
    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        navigationItem.title = "Headlines"
        setupBinding()
        super.viewDidLoad()
    }
    
    override func viewDidLayoutSubviews() {
        view.addSubview(paginatingView)
    }
}

extension TopHeadLinesController {
    
    func setupBinding() {
        viewmodel.getTopHeadLines()
        viewmodel.datasource.subscribe { [weak self] articles in
            DispatchQueue.main.async {
                self?.paginatingView.update(list: articles)
            }
        }.disposed(by: disposeBag)
    }
}

extension TopHeadLinesController: PaginatingDelegate {
    func fetchMore() {
        if viewmodel.isPaginating {
            return
        }
        viewmodel.getTopHeadLines(with: true)
    }
    
    func dataAtSelectedRow(data: Any) {
        if let article = data as? Article {
            print(article)
        }
    }
}
