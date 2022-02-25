//
//  ArticleFromSourceVC.swift
//  News
//
//  Created by Abhishek Kumar on 25/02/22.
//

import UIKit

class ArticleFromSourceVC: UIViewController {
    
    private let sourecCode: String
    private var sourceName: String?
    private let viewmodel: ArticleFromSouceViewModel
    private let disposeBag = DisposeBag()
    
    private lazy var paginatingView: PaginatingListView = {
        $0.frame = view.frame
        $0.delegate = self
        return $0
    }(PaginatingListView())
    
    init(sourceCode: String, sourceName: String?) {
        self.sourecCode = sourceCode
        self.sourceName = sourceName
        self.viewmodel = ArticleFromSouceViewModel(networkService: NetworkClient.shared)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = sourceName
        setupBinding()
    }
    
    override func viewDidLayoutSubviews() {
        view.addSubview(paginatingView)
        super.viewDidLayoutSubviews()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        viewmodel.getTopHeadLines(with: sourecCode)
        super.viewDidAppear(animated)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        viewmodel.resetPaginationFlagAndDatasource()
        super.viewDidDisappear(animated)
    }

}

extension ArticleFromSourceVC {
    
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

extension ArticleFromSourceVC: PaginatingDelegate {
    func fetchMore() {
        if viewmodel.isPaginating {
            return
        }
        viewmodel.getTopHeadLines(with: sourecCode, pagination: true)
    }
    
    func dataAtSelectedRow(data: GenericProtocol) {
        if let article = data as? Article {
            let vc = NewsDetailsVC(article: article)
            present(vc, animated: true, completion: nil)
        }
    }
}
