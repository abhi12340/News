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
    var articleDataSource = Variable<[Article]>([Article(source: nil, author: "Abhishek", title: "Your trusted source for breaking news, analysis, exclusive interviews, headlines, and videos at ABCNews.com", articleDescription: nil, url: nil, urlToImage: nil, publishedAt: nil, content: nil),
                                          Article(source: nil, author: "Abhishek", title: "Your trusted source for breaking news, analysis, exclusive interviews, headlines, and videos at ABCNews.com", articleDescription: nil, url: nil, urlToImage: nil, publishedAt: nil, content: nil),Article(source: nil, author: "Abhishek", title: "Your trusted source for breaking news, analysis, exclusive interviews, headlines, and videos at ABCNews.com", articleDescription: nil, url: nil, urlToImage: nil, publishedAt: nil, content: nil),Article(source: nil, author: "Abhishek", title: "Your trusted source for breaking news, analysis, exclusive interviews, headlines, and videos at ABCNews.com", articleDescription: nil, url: nil, urlToImage: nil, publishedAt: nil, content: nil)])
    var error = Variable<String>("error while fetching")
    
    var sourceDataSource = Variable<[Source]>([])
    
    init(networkService: NetworkProtocol) {
        self.networkService = networkService
    }
}

extension CountriesNewsViewModel {
    
    
    func resetPaginationFlag() {
        isPaginating = false
    }
    
    func getTopHeadLines(for countryCode: String, with pagination: Bool = false) {
        if pagination {
            isPaginating = true
        }
        let currentPageOffset = (articleDataSource.value.count / paginationOffset) + 1
        networkService.request(routerRequest: HeadlineRequest.getHeadline(code: countryCode,
                                                                          pageNo: currentPageOffset),
                               type: NewsResponse.self) { [weak self] result in
            switch result {
            case .success(let response):
                self?.articleDataSource.value.append(contentsOf: response.articles ?? [])
            case .failure(let error):
                self?.articleDataSource.value.append(contentsOf: [])
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
        let currentPageOffset = (sourceDataSource.value.count / paginationOffset) + 1
        networkService.request(routerRequest: SourceRequest.getNewsSource(code: countryCode,
                                                                          pageNo: currentPageOffset),
                               type: NewsResponse.self) { [weak self] result in
            switch result {
            case .success(let response):
                self?.sourceDataSource.value.append(contentsOf: response.source ?? [])
            case .failure(let error):
                self?.sourceDataSource.value.append(contentsOf: [])
                self?.error.value = error.localizedDescription
            }
            if pagination {
                self?.isPaginating = false
            }
        }
    }
}
