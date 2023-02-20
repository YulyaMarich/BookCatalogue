//
//  СategoriesListViewController.swift
//  BookCatalogue
//
//  Created by Julia on 02.02.2023.
//

import UIKit
import Combine
import Alamofire

class СategoriesListViewController: UIViewController {
    
    private struct Constants {
        static let cellIdentifier = "CategoryCell"
        static let titleFontSize: CGFloat = 36
        static let horizontalInsets: CGFloat = 15
        static let itemsAtRow: CGFloat = 2
        static let minimumInteritemSpacing: CGFloat = 10
    }
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero,
                                              collectionViewLayout: layout)
        return collectionView
    }()
    
    private lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        return refreshControl
    }()
    
    private lazy var loadingInducator: UIActivityIndicatorView = {
        let loadingInducator = UIActivityIndicatorView()
        return loadingInducator
    }()
    
    private var viewModel: CategoriesListViewModelProtocol
    private var observers: [AnyCancellable] = []
    
    init(viewModel: CategoriesListViewModelProtocol = CategoriesListViewModel()) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .backgroundColor
        addSubviews()
        setUpNavigationController()
        setUpActivityIndicator()
        setUpRefreshControl()
        viewModel.fetch()
        
        observeData()
        observeErrorToast()
    }
    
    private func addSubviews() {
        view.addSubview(collectionView)
        view.addSubview(loadingInducator)
    }
    
    private func setUpNavigationController() {
        navigationItem.title = "The New York Times"
        navigationController?.navigationBar.largeTitleTextAttributes = [.font: UIFont.systemFont(ofSize: Constants.titleFontSize, weight: .black)]
        UILabel.appearance(whenContainedInInstancesOf: [UINavigationBar.self]).adjustsFontSizeToFitWidth = true
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
    }
    
    private func setUpActivityIndicator() {
        loadingInducator.translatesAutoresizingMaskIntoConstraints = false
        loadingInducator.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        loadingInducator.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor).isActive = true
        
        loadingInducator.startAnimating()
        loadingInducator.hidesWhenStopped = true
    }
    
    private func setUpRefreshControl() {
        refreshControl.addTarget(self, action: #selector(refreshCollectionView), for: .valueChanged)
        collectionView.refreshControl = refreshControl
    }
    
    private func setUpCollectionView() {
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor).isActive = true
        collectionView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -10).isActive = true
        collectionView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        collectionView.backgroundColor = .backgroundColor
        collectionView.register(CategoryCollectionViewCell.self, forCellWithReuseIdentifier: Constants.cellIdentifier)
        
        let sectionInsets = UIEdgeInsets(top: 0, left: Constants.horizontalInsets, bottom: 0, right: Constants.horizontalInsets)
        let screenWidth = view.frame.width
        let spacing = Constants.minimumInteritemSpacing * (Constants.itemsAtRow - 1)
        let availableWidth = screenWidth - sectionInsets.left - sectionInsets.right - spacing
        let itemWidth = availableWidth / Constants.itemsAtRow
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        
        layout.minimumInteritemSpacing = Constants.minimumInteritemSpacing
        layout.minimumLineSpacing = 10
        layout.itemSize = CGSize(width: itemWidth, height: itemWidth + 10)
        layout.sectionInset = sectionInsets
    }
    
    private func observeData() {
        viewModel.dataPublisher.sink { _ in
            self.loadingInducator.stopAnimating()
            self.setUpCollectionView()
            self.collectionView.reloadData()
        }.store(in: &observers)
    }
    
    private func observeErrorToast() {
        viewModel.errorPublisher.sink { error in
            guard let error = error else { return }
            self.showToast(with: error)
        }
        .store(in: &self.observers)
    }
    
    @objc private func refreshCollectionView() {
        viewModel.fetch()
        viewModel.dataPublisher.sink { _ in
            self.collectionView.reloadData()
            self.refreshControl.endRefreshing()
        }.store(in: &observers)
    }
}

extension СategoriesListViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.dataPublisher.value?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.cellIdentifier,
                                                      for: indexPath) as! CategoryCollectionViewCell
        let category = viewModel.dataPublisher.value?[indexPath.item]
        cell.viewModel = CategoryCollectionViewCellModel(data: category)
        cell.configure()
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let category = viewModel.dataPublisher.value?[indexPath.item] else { return }
        let booksListViewModel = BooksListViewModel(listNameEncoded: category.listNameEncoded, listName: category.listName)
        let booksListVC = BooksListViewController(viewModel: booksListViewModel)
        navigationController?.pushViewController(booksListVC, animated: true)
    }
}
