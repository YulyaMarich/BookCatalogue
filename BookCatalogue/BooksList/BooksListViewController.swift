//
//  BooksList.swift
//  BookCatalogue
//
//  Created by Julia on 02.02.2023.
//

import UIKit

class BooksListViewController: UICollectionViewController {
    
    let viewModel: BooksListViewModelProtocol
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.largeTitleDisplayMode = .never    }
    
    init(viewModel: BooksListViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
