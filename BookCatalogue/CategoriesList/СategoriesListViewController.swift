//
//  СategoriesListViewController.swift
//  BookCatalogue
//
//  Created by Julia on 02.02.2023.
//

import UIKit
import Alamofire

class СategoriesListViewController: UIViewController {
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero,
                                              collectionViewLayout: layout)
        return collectionView
    }()
    
    private var viewModel: CategoriesListViewModelProtocol
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavigationController()
        viewModel.fetch { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.setUpCollectionView()
        }
    }
    
    init(viewModel: CategoriesListViewModelProtocol = CategoriesListViewModel()) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpNavigationController() {
        navigationItem.title = "The New York Times"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
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
        collectionView.register(CategoryCollectionViewCell.self, forCellWithReuseIdentifier: "CategoryCell")
        
        let sectionInserts = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        let itemsAtRow: CGFloat = 2
        let minimumInteritemSpacing: CGFloat = 10
        let screenWidth = view.frame.width
        let spacing = minimumInteritemSpacing * (itemsAtRow - 1)
        let availableWidth = screenWidth - sectionInserts.left - sectionInserts.right - spacing
        let itemWidth = availableWidth / itemsAtRow
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        
        layout.minimumInteritemSpacing = minimumInteritemSpacing
        layout.minimumLineSpacing = 10
        layout.itemSize = CGSize(width: itemWidth, height: itemWidth + 10)
        layout.sectionInset = sectionInserts
    }
}

extension СategoriesListViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.data?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryCell",
                                                      for: indexPath) as! CategoryCollectionViewCell
        let category = viewModel.data?[indexPath.item]
        cell.viewModel = CategoryCollectionViewCellModel(data: category)
        cell.configure()
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let category = viewModel.data?[indexPath.item] else { return }
        let viewModel1 = BooksListViewModel(listNameEncoded: category.listNameEncoded, listName: category.listName)
        print(viewModel.data?[indexPath.item].listNameEncoded ?? "No info")
        let booksListVC = BooksListViewController(viewModel: viewModel1)
        navigationController?.pushViewController(booksListVC, animated: true)
    }
}
