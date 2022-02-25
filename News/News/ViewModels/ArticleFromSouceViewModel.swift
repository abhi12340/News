//
//  ArticleFromSouceViewModel.swift
//  News
//
//  Created by Abhishek Kumar on 25/02/22.
//

import Foundation

class ArticleFromSouceViewModel {
    
    private let networkService: NetworkProtocol
    private let paginationOffset = 20
    
    var isPaginating = false
    var datasource = Variable<[Article]>([])
    var error = Variable<String>("error while fetching")
    
    init(networkService: NetworkProtocol) {
        self.networkService = networkService
    }
}

extension ArticleFromSouceViewModel {
    
    func getTopHeadLines(with sourceCode: String, pagination: Bool = false) {
        if pagination {
            isPaginating = true
        }
        let currentPageOffset = (datasource.value.count / paginationOffset) + 1
        networkService.request(routerRequest: HeadlineRequest.getHeadline(code: sourceCode,
                                                                          pageNo: currentPageOffset,
                                                                          key: NetworkConstants.sourceKey),
                               type: NewsResponse.self) { [weak self] result in
            switch result {
            case .success(let response):
                self?.datasource.value.append(contentsOf: response.articles ?? [])
            case .failure(let error):
                self?.datasource.value.append(contentsOf: [])
                self?.error.value = error.localizedDescription
            }
            if pagination {
                self?.isPaginating = false
            }
        }
    }
    
    func resetPaginationFlagAndDatasource() {
        isPaginating = false
        datasource.value = []
        networkService.cancel()
    }
}
