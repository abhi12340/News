//
//  CountriesNews.swift
//  News
//
//  Created by Abhishek Kumar on 24/02/22.
//

import UIKit

class CountriesNews: UIViewController {
    
    //MARK: - Dependency Injection.
    private let viewmodel = CountriesNewsViewModel(networkService: NetworkClient.shared)
    private let disposeBag = DisposeBag()
    
    let country = ["us", "in", "jp"]
    
    var selectedCountryIndex = 0
    
    lazy var pickerView: UIPickerView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.dataSource = self
        $0.delegate = self
        return $0
    }(UIPickerView())
    
    lazy var paginatingView: PaginatingListView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.delegate = self
        return $0
    }(PaginatingListView())
    
    lazy var segment: UISegmentedControl = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.selectedSegmentIndex = 0
        return $0
    }(UISegmentedControl(items: ["Country", "Source"]))

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Countries News"
        viewmodel.getTopHeadLines(for: country[selectedCountryIndex])
        setupbinding()
    }
    
    override func viewDidLayoutSubviews() {
        setupView()
    }
}

extension CountriesNews: UIPickerViewDelegate, UIPickerViewDataSource {
    
    private func setupView() {
        view.addSubview(pickerView)
        view.addSubview(segment)
        view.addSubview(paginatingView)
        NSLayoutConstraint.activate([pickerView.heightAnchor.constraint(equalToConstant: 180),
                                     pickerView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
                                     pickerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                                     pickerView.trailingAnchor.constraint(equalTo: view.trailingAnchor)])
        segment.addTarget(self, action: #selector(changeSegment(_:)), for: .valueChanged)
        NSLayoutConstraint.activate([segment.heightAnchor.constraint(equalToConstant: 50),
                                     segment.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
                                     segment.widthAnchor.constraint(equalTo: view.widthAnchor)])
        NSLayoutConstraint.activate([paginatingView.topAnchor.constraint(equalTo: segment.bottomAnchor),
                                     paginatingView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
                                     paginatingView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
                                     paginatingView.bottomAnchor.constraint(equalTo: pickerView.topAnchor)])
    }
    
    @objc private func changeSegment(_ sender: UISegmentedControl) {
        viewmodel.resetPaginationFlagAndDatasource()
        switchForChangeSegment()
    }
    
    private func setupbinding() {
        viewmodel.dataSource.subscribe { [weak self] result in
            DispatchQueue.main.async {
                self?.paginatingView.update(list: result)
            }
        }.disposed(by: disposeBag)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return country.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return country[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedCountryIndex = row
        viewmodel.resetPaginationFlagAndDatasource()
        switchForChangeSegment()
    }
}

extension CountriesNews: PaginatingDelegate {
    
    func fetchMore() {
        if viewmodel.isPaginating {
            return
        }
        switchForChangeSegment(with: true)
    }
    
    private func switchForChangeSegment(with pagination: Bool = false) {
        
        switch segment.selectedSegmentIndex {
            case 0:
                viewmodel.getTopHeadLines(for: country[selectedCountryIndex],
                                             with: pagination)
            case 1:
                viewmodel.getSource(for: country[selectedCountryIndex],
                                       with: pagination)
            default:
                break
        }
    }
    
    func dataAtSelectedRow(data: Any) {
        
    }
}
