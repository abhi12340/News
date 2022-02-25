//
//  NewsDetailVC.swift
//  News
//
//  Created by Abhishek Kumar on 25/02/22.
//

import UIKit
import SafariServices

class NewsDetailsVC: UIViewController {
    
    private let article: Article
    
    private lazy var newsTitle: UILabel = {
        $0.textColor = .black
        $0.font = UIFont.boldSystemFont(ofSize: 14)
        $0.textAlignment = .justified
        $0.lineBreakMode = .byWordWrapping
        $0.numberOfLines = 0
        return $0
    }(UILabel())
    
    private lazy var newsImage: LazyImageView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 3
        $0.heightAnchor.constraint(equalToConstant: view.frame.height / 3).isActive = true
        return $0
    }(LazyImageView())
    
    lazy var articleDesc: UILabel = {
        $0.textColor = .darkGray
        $0.textAlignment = .justified
        $0.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        $0.lineBreakMode = .byWordWrapping
        $0.numberOfLines = 0
        return $0
    }(UILabel())
    
    lazy var content: UILabel = {
        $0.textColor = .lightGray
        $0.textAlignment = .justified
        $0.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        $0.lineBreakMode = .byWordWrapping
        $0.numberOfLines = 2
        return $0
    }(UILabel())
    
    lazy var author: UILabel = {
        $0.textColor = .black
        $0.textAlignment = .justified
        $0.font = UIFont.systemFont(ofSize: 12, weight: .bold)
        $0.lineBreakMode = .byWordWrapping
        $0.setContentHuggingPriority(.defaultLow, for: .horizontal)
        $0.numberOfLines = 1
        return $0
    }(UILabel())
    
    lazy var link: UILabel = {
        $0.textColor = .link
        $0.text = "link"
        $0.font = UIFont.systemFont(ofSize: 12, weight: .bold)
        $0.isUserInteractionEnabled = true
        return $0
    }(UILabel())
    
    init(article: Article) {
        self.article = article
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init failed for the NewsDetailsVC")
    }
    
    override func viewDidLoad() {
        title = "NewsDetails"
        super.viewDidLoad()
        view.backgroundColor = .white
        setupView()
        configure()
    }
}

extension NewsDetailsVC {
    
    private func setupView() {
        let scrollView = UIScrollView()
        view.addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50),
                                     scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
                                     scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                                     scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor)])
        
        let stackview = UIStackView(arrangedSubviews: [newsTitle, newsImage, articleDesc, link ,author, content])
        stackview.translatesAutoresizingMaskIntoConstraints = false
        stackview.axis = .vertical
        stackview.distribution = .fill
        stackview.spacing = 8
        stackview.alignment = .leading
        view.addSubview(stackview)
        NSLayoutConstraint.activate([stackview.topAnchor.constraint(equalTo: scrollView.topAnchor),
                                     stackview.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16),
                                     stackview.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16)])
        link.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapGesture(_:))))
    }
    
    private func configure() {
        let attributedString = NSMutableAttributedString(string: "Author:- ",
                                                         attributes: [.font: UIFont.boldSystemFont(ofSize: 13),     .foregroundColor: UIColor.black])
        let secondString = NSAttributedString(string: article.author ?? "",
                                              attributes: [.font: UIFont.systemFont(ofSize: 12),
                                                           .foregroundColor: UIColor.gray])
        attributedString.append(secondString)
        author.attributedText = attributedString
        if let url = article.urlToImage  {
            newsImage.loadImage(fromURL: URL(string: url)!, placeHolderImage: "")
        }
        let contentAttributedString = NSMutableAttributedString(string: "Content:- ",
                                                                attributes: [.font: UIFont.boldSystemFont(ofSize: 14),     .foregroundColor: UIColor.black])
        let secondryString = NSAttributedString(string: article.content ?? "",
                                                attributes: [.font: UIFont.systemFont(ofSize: 12),
                                                             .foregroundColor: UIColor.gray])
        contentAttributedString.append(secondryString)
        content.attributedText = contentAttributedString
        articleDesc.text = article.articleDescription
        newsTitle.text = article.title
        link.text = article.url ?? ""
    }
    
    @objc func tapGesture(_ sender: UITapGestureRecognizer) {
        if let link = article.url, let url = URL(string: link) {
            let vc = SFSafariViewController(url: url)
            present(vc, animated: true, completion: nil)
        }
    }
}
