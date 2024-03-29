//
//  PaginatingListView.swift
//  News
//
//  Created by Abhishek Kumar on 24/02/22.
//

import UIKit

protocol PaginatingDelegate: AnyObject {
    func fetchMore()
    func dataAtSelectedRow(data: GenericProtocol)
    func setTabBarHidden(state: Bool)
}

class PaginatingListView: UIView {
    
    private var dataList: [GenericProtocol] = []
    
    weak var delegate: PaginatingDelegate?
    
    private lazy var tableView: UITableView = {
        $0.dataSource = self
        $0.delegate = self
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.register(NewsFeatureCell.self, forCellReuseIdentifier: NewsFeatureCell.reuseIdentifier)
        $0.register(UITableViewCell.self, forCellReuseIdentifier: "cellId")
        return $0
    }(UITableView())
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupTableView()
    }
    
    private func setupTableView() {
        self.addSubview(tableView)
        NSLayoutConstraint.activate([tableView.topAnchor.constraint(equalTo: self.topAnchor),
                                     tableView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
                                     tableView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
                                     tableView.trailingAnchor.constraint(equalTo: self.trailingAnchor)])
    }
    
    required init?(coder: NSCoder) {
        fatalError("Failed to initialize the PaginatingList")
    }
}

extension PaginatingListView: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let data = dataList as? [Article] {
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: NewsFeatureCell.reuseIdentifier,
                                                           for: indexPath) as? NewsFeatureCell  else {
                fatalError("cell failed to deque the cell")
            }
            cell.configure(with: data[indexPath.row])
            return cell
        } else if let data = dataList as? [Source] {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath)
            cell.textLabel?.text = data[indexPath.row].name
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.dataAtSelectedRow(data: dataList[indexPath.row])
    }
    
    func update(list: [GenericProtocol]) {
        self.dataList = list
        if tableView.tableFooterView != nil {
            tableView.tableFooterView = nil
        }
        tableView.reloadData()
    }
}

extension PaginatingListView: UIScrollViewDelegate {
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        delegate?.setTabBarHidden(state: true)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let postion = scrollView.contentOffset.y
        if postion > (tableView.contentSize.height - 100 - scrollView.frame.size.height) {
            if tableView.tableFooterView == nil {
                tableView.tableFooterView = createSpinnerFooter()
            }
            delegate?.fetchMore()
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        delegate?.setTabBarHidden(state: false)
    }
    
    private func createSpinnerFooter() -> UIView {
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: frame.width, height: 100))
        let spinner = UIActivityIndicatorView()
        spinner.center = footerView.center
        footerView.addSubview(spinner)
        spinner.startAnimating()
        return footerView
    }
}
