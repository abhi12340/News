//
//  CountriesNewsViewModel.swift
//  News
//
//  Created by Abhishek Kumar on 25/02/22.
//

import Foundation

class CountriesNewsViewModel {
    
    private let networkService: NetworkProtocol
    private let paginationOffset = 20
    
    var isPaginating = false
    var dataSource = Variable<[Any]>([])
    var error = Variable<String>("error while fetching")
    
    init(networkService: NetworkProtocol) {
        self.networkService = networkService
    }
}

extension CountriesNewsViewModel {
    
    
    func resetPaginationFlagAndDatasource() {
        isPaginating = false
        dataSource.value = []
        networkService.cancel()
    }
    
    func getTopHeadLines(for countryCode: String, with pagination: Bool = false) {
        if pagination {
            isPaginating = true
        }
        let currentPageOffset = (dataSource.value.count / paginationOffset) + 1
        networkService.request(routerRequest: HeadlineRequest.getHeadline(code: countryCode,
                                                                          pageNo: currentPageOffset,
                                                                          key: NetworkConstants.countryKey),
                               type: NewsResponse.self) { [weak self] result in
            switch result {
            case .success(let response):
                self?.dataSource.value.append(contentsOf: response.articles ?? [])
            case .failure(let error):
                self?.dataSource.value.append(contentsOf: [])
                self?.error.value = error.localizedDescription
            }
            if pagination {
                self?.isPaginating = false
            }
        }
    }
    
    func getSource(for countryCode: String, with pagination: Bool) {
        if pagination {
            isPaginating = true
        }
        let currentPageOffset = (dataSource.value.count / paginationOffset) + 1
        networkService.request(routerRequest: SourceRequest.getNewsSource(code: countryCode,
                                                                          pageNo: currentPageOffset),
                               type: NewsResponse.self) { [weak self] result in
            switch result {
            case .success(let response):
                self?.dataSource.value.append(contentsOf: response.sources ?? [])
            case .failure(let error):
                self?.dataSource.value.append(contentsOf: [])
                self?.error.value = error.localizedDescription
            }
            if pagination {
                self?.isPaginating = false
            }
        }
    }
}
