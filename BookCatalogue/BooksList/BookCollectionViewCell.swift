//
//  а.swift
//  BookCatalogue
//
//  Created by Julia on 06.02.2023.
//

import UIKit
import Combine

class BookCollectionViewCell: UICollectionViewCell {
    var viewModel: BookCollectionViewCellModelProtocol?
    
    private lazy var viewBackground: UIView = {
        let viewBackground = UIView()
        return viewBackground
    }()
    
    private lazy var bookImageView: UIImageView = {
        let bookImageView = UIImageView()
        return bookImageView
    }()
    
    private lazy var buyBookButton: UIButton = {
        let buyBookButton = UIButton()
        return buyBookButton
    }()
    
    private lazy var bookTitleLabel: UILabel = {
        let bookTitleLabel = UILabel()
        return bookTitleLabel
    }()
    
    private lazy var authorLabel: UILabel = {
        let authorLabel = UILabel()
        return authorLabel
    }()
    
    private lazy var publisherLabel: UILabel = {
        let publisherLabel = UILabel()
        return publisherLabel
    }()
    
    private lazy var bookDescriptionLabel: UILabel = {
        let bookDescriptionLabel = UILabel()
        return bookDescriptionLabel
    }()
    
    private lazy var rankBackgroundView: UIView = {
        let rankBackgroundView = UIView()
        return rankBackgroundView
    }()
    
    private lazy var rankLabel: UILabel = {
        let rankLabel = UILabel()
        return rankLabel
    }()
    
    private lazy var authorAndPublisherStack: UIStackView = {
        let authorAndPublisherStack = UIStackView()
        return authorAndPublisherStack
    }()
    
    private lazy var divider: UIView = {
        let divider = UIView()
        return divider
    }()
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView()
        return activityIndicator
    }()
    
    let pressBuyBookButton = PassthroughSubject<URL, Never>()
    
    func configure() {
        setUpImageView()
        addSubviews()
        setUpConstraints()
        setUpAuthorAndPublisherStack()
        makeShadow(to: contentView)
        setUpContentView()
        setUpBookTitleLabel()
        setUpBookDescriptionLabel()
        setUpBuyBookButton()
        setUpRankView()
    }
    
    private func setUpContentView() {
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = 4
        
        divider.backgroundColor = UIColor(red: 0.353, green: 0.294, blue: 0.267, alpha: 1)
    }
    
    private func setUpRankView() {
        rankLabel.text = "\(viewModel?.rank ?? 0)"
        rankLabel.font = UIFont.systemFont(ofSize: 20, weight: .black)
        rankLabel.adjustsFontSizeToFitWidth = true
        rankLabel.textAlignment = .center
        rankBackgroundView.backgroundColor = .white
        makeShadow(to: rankBackgroundView)
    }
    
    private func setUpBuyBookButton() {
        buyBookButton.backgroundColor = UIColor(red: 0.353, green: 0.294, blue: 0.267, alpha: 1)
        buyBookButton.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .black)
        buyBookButton.setTitle("BUY".localized(), for: .normal)
        buyBookButton.layer.cornerRadius = 4
        buyBookButton.showsMenuAsPrimaryAction = true
        
        buyBookButton.menu = UIMenu(children: createUIAtion())
    }
    
    private func createUIAtion() -> [UIAction] {
        var actions: [UIAction] = []
        
        if let links = viewModel?.buyLinks {
            for bookLink in links {
                let action = UIAction(title: bookLink.name) { _ in
                    self.openShop(on: bookLink.url)
                }
                actions.append(action)
            }
        }
        return actions
    }
    
    private func openShop(on link: String?) {
        guard let stringURl = link, let url = URL(string: stringURl) else { return }
        pressBuyBookButton.send(url)
    }
    
    private func setUpBookTitleLabel() {
        bookTitleLabel.text = viewModel?.title
        bookTitleLabel.font = UIFont.systemFont(ofSize: 20, weight: .black)
        bookTitleLabel.numberOfLines = 0
    }
    
    private func setUpBookDescriptionLabel() {
        bookDescriptionLabel.text = viewModel?.description
        bookDescriptionLabel.numberOfLines = 0
        bookDescriptionLabel.font = UIFont.systemFont(ofSize: 13)
    }
    
    private func setUpImageView() {
        self.tag = viewModel?.indexPath.item ?? 0
        bookImageView.isHidden = true
        activityIndicator.startAnimating()
        if let imageURL = viewModel?.bookImage {
            if let image = viewModel?.cacheManager.getImageFromCache(for: imageURL) {
                    self.bookImageView.image = image
                    self.bookImageView.isHidden = false
                    self.activityIndicator.stopAnimating()
            } else {
                DispatchQueue.global().async {
                    guard let url = URL(string: imageURL) else { return }
                    guard let data = try? Data(contentsOf: url) else { return }
                    DispatchQueue.main.async {
                        if self.tag == self.viewModel?.indexPath.item {
                            self.viewModel?.cacheManager.saveDataToCache(data: data, for: imageURL)
                            self.bookImageView.image = UIImage(data: data)
                            self.activityIndicator.stopAnimating()
                            self.bookImageView.isHidden = false
                        }
                    }
                }
            }
        }
    }
    
    private func addSubviews() {
        contentView.addSubview(viewBackground)
        viewBackground.addSubview(buyBookButton)
        viewBackground.addSubview(bookImageView)
        viewBackground.addSubview(bookTitleLabel)
        viewBackground.addSubview(bookDescriptionLabel)
        viewBackground.addSubview(rankBackgroundView)
        viewBackground.addSubview(activityIndicator)
        rankBackgroundView.addSubview(rankLabel)
        viewBackground.addSubview(authorAndPublisherStack)
        authorAndPublisherStack.addArrangedSubview(authorLabel)
        authorAndPublisherStack.addArrangedSubview(publisherLabel)
        viewBackground.addSubview(divider)
    }
    
    private func setUpConstraints() {
        let cellHeight = contentView.frame.height
        let topPadding: CGFloat = 10
        let bottomPadding: CGFloat = -10
        let middleSpacing: CGFloat = 10
        let availableHeight = cellHeight - topPadding - bottomPadding - middleSpacing
        let buyBookButtomHeight = availableHeight * 0.14
        
        viewBackground.translatesAutoresizingMaskIntoConstraints = false
        viewBackground.topAnchor.constraint(equalTo: contentView.topAnchor, constant: topPadding).isActive = true
        viewBackground.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 10).isActive = true
        viewBackground.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: bottomPadding).isActive = true
        viewBackground.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -10).isActive = true
        
        bookImageView.translatesAutoresizingMaskIntoConstraints = false
        bookImageView.topAnchor.constraint(equalTo: viewBackground.topAnchor).isActive = true
        bookImageView.leftAnchor.constraint(equalTo: viewBackground.leftAnchor).isActive = true
        bookImageView.widthAnchor.constraint(equalToConstant: contentView.frame.width / 2 - 45).isActive = true
        
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.centerXAnchor.constraint(equalTo: bookImageView.centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: bookImageView.centerYAnchor).isActive = true

        buyBookButton.translatesAutoresizingMaskIntoConstraints = false
        buyBookButton.topAnchor.constraint(equalTo: bookImageView.bottomAnchor, constant: middleSpacing).isActive = true
        buyBookButton.leftAnchor.constraint(equalTo: bookImageView.leftAnchor).isActive = true
        buyBookButton.heightAnchor.constraint(equalToConstant: buyBookButtomHeight).isActive = true
        buyBookButton.widthAnchor.constraint(equalToConstant: contentView.frame.width / 2 - 45).isActive = true
        buyBookButton.bottomAnchor.constraint(equalTo: viewBackground.bottomAnchor).isActive = true
        
        rankBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        rankBackgroundView.topAnchor.constraint(equalTo: bookImageView.topAnchor, constant: -15).isActive = true
        rankBackgroundView.leftAnchor.constraint(equalTo: bookImageView.leftAnchor, constant: -15).isActive = true
        rankBackgroundView.widthAnchor.constraint(equalToConstant: 35).isActive = true
        rankBackgroundView.heightAnchor.constraint(equalToConstant: 35).isActive = true
        
        rankLabel.translatesAutoresizingMaskIntoConstraints = false
        rankLabel.centerXAnchor.constraint(equalTo: rankBackgroundView.centerXAnchor).isActive = true
        rankLabel.centerYAnchor.constraint(equalTo: rankBackgroundView.centerYAnchor).isActive = true
        rankLabel.widthAnchor.constraint(equalToConstant: 40).isActive = true
        rankLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        bookTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        bookTitleLabel.topAnchor.constraint(equalTo: viewBackground.topAnchor).isActive = true
        bookTitleLabel.leftAnchor.constraint(equalTo: bookImageView.rightAnchor, constant: 10).isActive = true
        bookTitleLabel.rightAnchor.constraint(equalTo: viewBackground.rightAnchor).isActive = true
        
        divider.translatesAutoresizingMaskIntoConstraints = false
        divider.topAnchor.constraint(equalTo: bookTitleLabel.bottomAnchor, constant: 2).isActive = true
        divider.leftAnchor.constraint(equalTo: bookImageView.rightAnchor, constant: 10).isActive = true
        divider.rightAnchor.constraint(equalTo: viewBackground.rightAnchor).isActive = true
        divider.heightAnchor.constraint(equalToConstant: 2).isActive = true
        
        authorAndPublisherStack.translatesAutoresizingMaskIntoConstraints = false
        authorAndPublisherStack.topAnchor.constraint(equalTo: divider.bottomAnchor, constant: 2).isActive = true
        authorAndPublisherStack.leftAnchor.constraint(equalTo: bookImageView.rightAnchor, constant: 10).isActive = true
        authorAndPublisherStack.rightAnchor.constraint(lessThanOrEqualTo: viewBackground.rightAnchor, constant: -10).isActive = true
        
        bookDescriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        bookDescriptionLabel.topAnchor.constraint(equalTo: authorAndPublisherStack.bottomAnchor, constant: 10).isActive = true
        bookDescriptionLabel.leftAnchor.constraint(equalTo: bookImageView.rightAnchor, constant: 10).isActive = true
        bookDescriptionLabel.rightAnchor.constraint(equalTo: viewBackground.rightAnchor).isActive = true
        bookDescriptionLabel.bottomAnchor.constraint(lessThanOrEqualTo: viewBackground.bottomAnchor).isActive = true
    }
    
    func setUpAuthorAndPublisherStack() {
        authorAndPublisherStack.axis = .vertical
        authorAndPublisherStack.spacing = 0
        authorLabel.text = viewModel?.author
        publisherLabel.text = viewModel?.publisher
        
        authorLabel.font = UIFont.systemFont(ofSize: 10, weight: .bold)
        publisherLabel.font = UIFont.systemFont(ofSize: 10, weight: .bold)
        
        authorLabel.textColor = .darkGray
        publisherLabel.textColor = .darkGray
        
        authorLabel.numberOfLines = 0
        publisherLabel.numberOfLines = 0
    }
    
    private func makeShadow(to someView: UIView) {
        someView.layer.shadowOffset = CGSize(width: 0, height: 0)
        someView.layer.shadowRadius = 3
        someView.layer.shadowColor = UIColor.black.cgColor
        someView.layer.shadowOpacity = 0.3
    }
}
