//
//  DataDetailsViewController.swift
//  project
//
//  Created by Канапия Базарбаев on 30.03.2024.
//

import UIKit

protocol DataDetailsDelegate: AnyObject {
    func updateData(author: String, bookTitle: String)
}

class DataDetailsViewController: UIViewController {

    @IBOutlet weak var AuthorLabel: UILabel!
    @IBOutlet weak var BookTitleLabel: UILabel!
    
    weak var delegate: DataDetailsDelegate?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadAndDisplayData()
    }
    
    func loadAndDisplayData() {
        // Load data from UserDefaults
        if let author = UserDefaults.standard.string(forKey: "Author"),
           let bookTitle = UserDefaults.standard.string(forKey: "BookTitle") {
            // Display data in labels
            AuthorLabel.text = "Author: \(author)"
            BookTitleLabel.text = "Book Title: \(bookTitle)"
        }
    }
}
