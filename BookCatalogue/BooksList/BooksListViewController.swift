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
    
    let viewModel: BooksListViewModelProtocol
    
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
    
    private var observers: [AnyCancellable] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.largeTitleDisplayMode = .never
        navigationController?.navigationBar.tintColor = .black
        navigationItem.title = viewModel.listName
        UILabel.appearance(whenContainedInInstancesOf: [UINavigationBar.self]).adjustsFontSizeToFitWidth = true
        setUpCollectionView()
        setUpRefreshControl()
        viewModel.fetch { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.collectionView.reloadData()
        }
    }
    
    init(viewModel: BooksListViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpRefreshControl() {
        refreshControl.addTarget(self, action: #selector(refreshCollectionView), for: .valueChanged)
        collectionView.refreshControl = refreshControl
    }
    
    @objc func refreshCollectionView() {
        collectionView.reloadData()
        refreshControl.endRefreshing()
    }
    
    private func setUpCollectionView() {
        view.addSubview(collectionView)
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor).isActive = true
        collectionView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        collectionView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        collectionView.backgroundColor = UIColor(red: 0.973, green: 0.957, blue: 0.930, alpha: 1)
        collectionView.register(BookCollectionViewCell.self, forCellWithReuseIdentifier: "BookCell")
        
        let sectionInserts = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        let itemsAtRow: CGFloat = 1
        let minimumInteritemSpacing: CGFloat = 10
        let screenWidth = view.frame.width
        let spacing = minimumInteritemSpacing * (itemsAtRow - 1)
        let availableWidth = screenWidth - sectionInserts.left - sectionInserts.right - spacing
        let itemWidth = availableWidth / itemsAtRow
        
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.minimumInteritemSpacing = minimumInteritemSpacing
        layout.minimumLineSpacing = 10
        layout.itemSize = CGSize(width: itemWidth, height: itemWidth - 100)
        layout.sectionInset = sectionInserts
    }
}

extension BooksListViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.data?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BookCell",
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
