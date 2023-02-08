//
//  BooksList.swift
//  BookCatalogue
//
//  Created by Julia on 02.02.2023.
//

import UIKit
import Combine
import SafariServices

class BooksListViewController: UIViewController {
    
    private struct Constants {
        static let cellIdentifier = "BookCell"
        static let horizontalInsets: CGFloat = 15
        static let itemsAtRow: CGFloat = 1
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
    
    private var observers: [AnyCancellable] = []
    private let viewModel: BooksListViewModelProtocol
    
    init(viewModel: BooksListViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addSubviews()
        setUpNavigationController()
        setUpActivityIndicator()
        setUpRefreshControl()
        viewModel.fetch { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.loadingInducator.stopAnimating()
            strongSelf.setUpCollectionView()
            strongSelf.collectionView.reloadData()
        }
        
        observeErrorToast()
    }
    
    private func addSubviews() {
        view.addSubview(collectionView)
        view.addSubview(loadingInducator)
    }
    
    private func setUpNavigationController() {
        navigationItem.largeTitleDisplayMode = .never
        navigationController?.navigationBar.tintColor = .black
        navigationItem.title = viewModel.listName
        UILabel.appearance(whenContainedInInstancesOf: [UINavigationBar.self]).adjustsFontSizeToFitWidth = true
        
        view.backgroundColor = .backgroundColor
    }
    
    private func observeErrorToast() {
        viewModel.errorPublisher.sink { error in
            guard let error = error else { return }
            self.showToast(with: error)
        }.store(in: &self.observers)
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
        
        collectionView.backgroundColor = .clear
        collectionView.register(BookCollectionViewCell.self, forCellWithReuseIdentifier: Constants.cellIdentifier)
        
        let sectionInserts = UIEdgeInsets(top: 0, left: Constants.horizontalInsets, bottom: 0, right: Constants.horizontalInsets)
        let screenWidth = view.frame.width
        let spacing = Constants.minimumInteritemSpacing * (Constants.itemsAtRow - 1)
        let availableWidth = screenWidth - sectionInserts.left - sectionInserts.right - spacing
        let itemWidth = availableWidth / Constants.itemsAtRow
        
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.minimumInteritemSpacing = Constants.minimumInteritemSpacing
        layout.minimumLineSpacing = 10
        layout.itemSize = CGSize(width: itemWidth, height: itemWidth - 100)
        layout.sectionInset = sectionInserts
    }
    
    @objc func refreshCollectionView() {
        viewModel.fetch { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.collectionView.reloadData()
            strongSelf.refreshControl.endRefreshing()
        }
    }
}

extension BooksListViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.data?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.cellIdentifier,
                                                      for: indexPath) as! BookCollectionViewCell
        let book = viewModel.data?[indexPath.item]
        cell.viewModel = BookCollectionViewCellModel(data: book, indexPath: indexPath)
        
        cell.pressBuyBookButton.sink { url in
            let safariVC = SFSafariViewController(url: url)
            self.present(safariVC, animated: true)
        }.store(in: &observers)
        
        cell.configure()
        
        return cell
    }
}
