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
    
    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        navigationItem.title = "Top Stories"
        super.viewDidLoad()
        setupBinding()
    }
    
    override func viewDidLayoutSubviews() {
        view.addSubview(paginatingView)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        viewmodel.getTopHeadLines()
        super.viewDidAppear(animated)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        viewmodel.resetPaginationFlagAndDatasource()
        super.viewDidDisappear(animated)
    }
}

extension TopHeadLinesController {
    
    func setupBinding() {
        
        viewmodel.datasource.subscribe { [weak self] articles in
            DispatchQueue.main.async {
                self?.paginatingView.update(list: articles)
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

extension TopHeadLinesController: PaginatingDelegate {
    func fetchMore() {
        if viewmodel.isPaginating {
            return
        }
        viewmodel.getTopHeadLines(with: true)
    }
    
    func dataAtSelectedRow(data: GenericProtocol) {
        if let article = data as? Article {
            let vc = NewsDetailsVC(article: article)
            present(vc, animated: true, completion: nil)
        }
    }
}
