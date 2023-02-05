//
//  CategoryCollectionViewCell.swift
//  BookCatalogue
//
//  Created by Julia on 03.02.2023.
//

import UIKit

class CategoryCollectionViewCell: UICollectionViewCell {
    private var categoryNameLabel: UILabel = {
        let categoryNameLabel = UILabel()
        return categoryNameLabel
    }()
    
    private var categoryInfoStack: UIStackView = {
        let categoryInfoStack = UIStackView()
        return categoryInfoStack
    }()
    
    private var updateFrequencyLabel: UILabel = {
        let updateFrequencyLabel = UILabel()
        return updateFrequencyLabel
    }()
    
    private var newestPublishedDate: UILabel = {
        let newestPublishedDate = UILabel()
        return newestPublishedDate
    }()
    
    private var divider: UIView = {
        let divider = UIView()
        return divider
    }()
    
    var viewModel: CategoryCollectionViewCellModelProtocol?
    
    func setUpContentView() {
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = 4
        addSubviews()
        setUpConstraints()
        setUpCategoryInfoStack()
        makeShadow()
        divider.backgroundColor = UIColor(red: 0.353, green: 0.294, blue: 0.267, alpha: 1)
        categoryNameLabel.text = viewModel?.listName
        categoryNameLabel.font = UIFont.systemFont(ofSize: 27, weight: .heavy)
        categoryNameLabel.lineBreakMode = .byWordWrapping
        categoryNameLabel.numberOfLines = 0
        updateFrequencyLabel.text = "Updated: weekly"
        newestPublishedDate.text = "Last Published: 22.12.2022"
    }
    
    private func addSubviews() {
        contentView.addSubview(categoryNameLabel)
        contentView.addSubview(categoryInfoStack)
        contentView.addSubview(divider)
        categoryInfoStack.addArrangedSubview(updateFrequencyLabel)
        categoryInfoStack.addArrangedSubview(newestPublishedDate)
    }
    
    private func setUpConstraints() {
        categoryNameLabel.translatesAutoresizingMaskIntoConstraints = false
        categoryNameLabel.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        categoryNameLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 10).isActive = true
        categoryNameLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -10).isActive = true
        categoryNameLabel.bottomAnchor.constraint(greaterThanOrEqualTo: divider.topAnchor, constant: -3).isActive = true
        categoryNameLabel.setContentHuggingPriority(UILayoutPriority(rawValue: 249), for: .vertical)
        categoryNameLabel.setContentCompressionResistancePriority(UILayoutPriority(749), for: .vertical)
        
        divider.translatesAutoresizingMaskIntoConstraints = false
        divider.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 5).isActive = true
        divider.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -5).isActive = true
        divider.bottomAnchor.constraint(equalTo: categoryInfoStack.topAnchor, constant: -3).isActive = true
        divider.heightAnchor.constraint(equalToConstant: 1.5).isActive = true
        
        categoryInfoStack.translatesAutoresizingMaskIntoConstraints = false
        categoryInfoStack.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 10).isActive = true
        categoryInfoStack.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -10).isActive = true
        categoryInfoStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10).isActive = true
    }
    
    private func setUpCategoryInfoStack() {
        categoryInfoStack.axis = .vertical
        categoryInfoStack.spacing = 5
        updateFrequencyLabel.font = UIFont.systemFont(ofSize: UIScreen.main.bounds.height < 750 ? 10 : 10, weight: .medium)
        newestPublishedDate.font = UIFont.systemFont(ofSize: UIScreen.main.bounds.height < 750 ? 10 : 10, weight: .medium)
    }
    
    private func makeShadow() {
        self.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.layer.shadowRadius = 3
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.3
    }
}
