//
//  CategoryCollectionViewCell.swift
//  BookCatalogue
//
//  Created by Julia on 03.02.2023.
//

import UIKit

class CategoryCollectionViewCell: UICollectionViewCell {

    
    private struct Constants {
        static let elementPadding: CGFloat = 10
        static let dividerPadding: CGFloat = 5
    }
    
    private lazy var categoryNameLabel: UILabel = {
        let categoryNameLabel = UILabel()
        return categoryNameLabel
    }()
    
    private lazy var categoryInfoStack: UIStackView = {
        let categoryInfoStack = UIStackView()
        return categoryInfoStack
    }()
    
    private lazy var updateFrequencyLabel: UILabel = {
        let updateFrequencyLabel = UILabel()
        return updateFrequencyLabel
    }()
    
    private lazy var newestPublishedDate: UILabel = {
        let newestPublishedDate = UILabel()
        return newestPublishedDate
    }()
    
    private lazy var divider: UIView = {
        let divider = UIView()
        return divider
    }()
    
    var viewModel: CategoryCollectionViewCellModelProtocol?
    
    func configure() {
        setUpContentView()
        addSubviews()
        setUpConstraints()
        setUpCategoryNameLabel()
        setUpCategoryInfoStack()
    }
    
    private func setUpContentView() {
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = 4
        contentView.makeShadowWith()
        
        divider.backgroundColor = .lightBrownColor
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
        categoryNameLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: Constants.elementPadding).isActive = true
        categoryNameLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -Constants.elementPadding).isActive = true
        categoryNameLabel.bottomAnchor.constraint(greaterThanOrEqualTo: divider.topAnchor, constant: -3).isActive = true
        categoryNameLabel.setContentHuggingPriority(UILayoutPriority(rawValue: 249), for: .vertical)
        categoryNameLabel.setContentCompressionResistancePriority(UILayoutPriority(749), for: .vertical)
        
        divider.translatesAutoresizingMaskIntoConstraints = false
        divider.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: Constants.dividerPadding).isActive = true
        divider.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -Constants.dividerPadding).isActive = true
        divider.bottomAnchor.constraint(equalTo: categoryInfoStack.topAnchor, constant: -Constants.dividerPadding).isActive = true
        divider.heightAnchor.constraint(equalToConstant: 2).isActive = true
        
        categoryInfoStack.translatesAutoresizingMaskIntoConstraints = false
        categoryInfoStack.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: Constants.elementPadding).isActive = true
        categoryInfoStack.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -Constants.elementPadding).isActive = true
        categoryInfoStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -Constants.elementPadding).isActive = true
    }
    
    private func setUpCategoryNameLabel() {
        categoryNameLabel.text = viewModel?.listName
        categoryNameLabel.font = UIFont.systemFont(ofSize: 25, weight: .black)
        categoryNameLabel.numberOfLines = 4
        categoryNameLabel.adjustsFontSizeToFitWidth = true
    }
    
    private func setUpCategoryInfoStack() {
        categoryInfoStack.axis = .vertical
        categoryInfoStack.spacing = 5
        
        updateFrequencyLabel.attributedText = makeAttributedText(with: "Updated: ", and: viewModel?.updated.lowercased() ?? "No info".localized())
        newestPublishedDate.attributedText = makeAttributedText(with: "Last Published: ", and: viewModel?.newestPublishedDate.replacingOccurrences(of: "-", with: ".") ?? "No info".localized())
    }
    
    private func makeAttributedText(with parameter: String, and result: String) -> NSMutableAttributedString {
        let parameterAttributes: [NSAttributedString.Key: Any] = [.font: UIFont.systemFont(ofSize: UIScreen.main.bounds.height < 750 ? 8 : 9, weight: .medium)]
        let resultAttributes: [NSAttributedString.Key: Any] = [.font: UIFont.systemFont(ofSize: UIScreen.main.bounds.height < 750 ? 9 : 9, weight: .bold)]
        
        let resultAttributeString = NSAttributedString(string: result.localized(),
                                                       attributes: resultAttributes)
        let mutableAttributedString = NSMutableAttributedString(string: parameter.localized(),
                                                                attributes: parameterAttributes)
        mutableAttributedString.append(resultAttributeString)
        
        return mutableAttributedString
    }
}
