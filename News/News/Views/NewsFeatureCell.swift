//
//  TopHeadlineCell.swift
//  News
//
//  Created by Abhishek Kumar on 24/02/22.
//

import UIKit

class NewsFeatureCell: UITableViewCell {
    
    static var reuseIdentifier: String = "NewsFeatureCell"
    
    private lazy var title: UILabel = {
        $0.font = UIFont.boldSystemFont(ofSize: 14)
        $0.lineBreakMode = .byWordWrapping
        $0.numberOfLines = 0
        $0.textColor = .black
        $0.setContentHuggingPriority(.defaultLow, for: .vertical)
        return $0
    }(UILabel())
    
    private lazy var author: UILabel = {
        $0.font = UIFont.systemFont(ofSize: 12)
        $0.textColor = .gray
        $0.numberOfLines = 2
        $0.lineBreakMode = .byWordWrapping
        return $0
    }(UILabel())
    
    private lazy var stackView: UIStackView = {
        $0.distribution = .fill
        $0.alignment = .leading
        $0.axis = .vertical
        $0.spacing = 5
        return $0
    }(UIStackView(arrangedSubviews: [title, author]))
    
    private lazy var leftImageView: LazyImageView = {
        $0.clipsToBounds = true
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.widthAnchor.constraint(equalToConstant: 100).isActive = true
        $0.heightAnchor.constraint(equalToConstant: 100).isActive = true
        $0.layer.cornerRadius = 2
        return $0
    }(LazyImageView())
    
    private lazy var parentStackView: UIStackView = {
        $0.axis = .horizontal
        $0.alignment = .center
        $0.distribution = .fill
        $0.spacing = 8
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UIStackView(arrangedSubviews: [leftImageView, stackView]))
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupParentStackView()
    }
    
    private func setupParentStackView() {
        contentView.addSubview(parentStackView)
        NSLayoutConstraint.activate([parentStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
                                     parentStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5),
                                     parentStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5),
                                     parentStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5)])
    }
    
    required init?(coder: NSCoder) {
        fatalError("failed to initlize the cell")
    }
    
    func configure(with article: Article) {
        let attributedString = NSMutableAttributedString(string: "Author:- ", attributes: [.font: UIFont.boldSystemFont(ofSize: 13), .foregroundColor: UIColor.black])
        let secondString = NSAttributedString(string: article.author ?? "", attributes: [.font: UIFont.systemFont(ofSize: 12), .foregroundColor: UIColor.gray])
        attributedString.append(secondString)
        author.attributedText = attributedString
        title.text = article.title
        if let imageUrl = article.urlToImage, let url = URL(string: imageUrl) {
            leftImageView.loadImage(fromURL: url, placeHolderImage: "")
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        title.text = nil
        author.text = nil
        leftImageView.image = nil
    }
}
