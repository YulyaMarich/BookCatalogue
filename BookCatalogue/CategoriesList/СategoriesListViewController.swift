//
//  СategoriesListViewController.swift
//  BookCatalogue
//
//  Created by Julia on 02.02.2023.
//

import UIKit

class СategoriesListViewController: UICollectionViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
       setUpNavigationController()
       setUpCollectionView()
    }
    
    private func setUpNavigationController() {
        navigationItem.title = "The New York Times"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    private func setUpCollectionView() {
        collectionView.backgroundColor = UIColor(red: 0.973, green: 0.957, blue: 0.930, alpha: 1)
        collectionView.register(CategoryCollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
        
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        let itemsAtRow: CGFloat = 2
        let sectionInserts = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        let minimumLineSpacing: CGFloat = 10
        let minimumInteritemSpacing: CGFloat = 10
        let screenWidth = collectionView.frame.width
        let spacing = minimumInteritemSpacing * (itemsAtRow - 1)
        let availableWidth = screenWidth - sectionInserts.left - sectionInserts.right - spacing
        let itemWidth = availableWidth / itemsAtRow
        
        layout.itemSize = CGSize(width: CGFloat(itemWidth), height: CGFloat(itemWidth + 10))
        layout.sectionInset = sectionInserts
        layout.minimumLineSpacing = minimumLineSpacing
        layout.minimumInteritemSpacing = minimumInteritemSpacing
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 53
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! CategoryCollectionViewCell
        cell.setUpContentView()
        
        return cell
    }
}
