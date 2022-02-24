//
//  HeadLineViewModel.swift
//  News
//
//  Created by Abhishek Kumar on 24/02/22.
//

import Foundation

class HeadLineViewModel {
    
    private let networkService: NetworkProtocol
    private let paginationOffset = 20
    
    var isPaginating = false
    var datasource = Variable<[Article]>([Article(source: nil, author: "Abhishek", title: "Your trusted source for breaking news, analysis, exclusive interviews, headlines, and videos at ABCNews.com", articleDescription: nil, url: nil, urlToImage: nil, publishedAt: nil, content: nil),
                                          Article(source: nil, author: "Abhishek", title: "Your trusted source for breaking news, analysis, exclusive interviews, headlines, and videos at ABCNews.com", articleDescription: nil, url: nil, urlToImage: nil, publishedAt: nil, content: nil),Article(source: nil, author: "Abhishek", title: "Your trusted source for breaking news, analysis, exclusive interviews, headlines, and videos at ABCNews.com", articleDescription: nil, url: nil, urlToImage: nil, publishedAt: nil, content: nil),Article(source: nil, author: "Abhishek", title: "Your trusted source for breaking news, analysis, exclusive interviews, headlines, and videos at ABCNews.com", articleDescription: nil, url: nil, urlToImage: nil, publishedAt: nil, content: nil)])
    var error = Variable<String>("error while fetching")
    
    init(networkService: NetworkProtocol) {
        self.networkService = networkService
    }
}

extension HeadLineViewModel {
    
    func getTopHeadLines(with pagination: Bool = false) {
        if pagination {
            isPaginating = true
        }
        let currentPageOffset = (datasource.value.count / paginationOffset) + 1
        networkService.request(routerRequest: HeadlineRequest.getHeadline(code: "en",
                                                                          pageNo: currentPageOffset),
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
}
