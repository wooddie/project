//
//  DataDetailsViewController.swift
//  project
//
//  Created by Канапия Базарбаев on 30.03.2024.
//

import UIKit

class DataDetailsViewController: UIViewController {

    @IBOutlet weak var AuthorLabel: UILabel!
    @IBOutlet weak var BookTitleLabel: UILabel!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadAndDisplayData()
    }
    
    func loadAndDisplayData() {
        if let author = UserDefaults.standard.string(forKey: "Author"),
           let bookTitle = UserDefaults.standard.string(forKey: "BookTitle") {
            // Display data in labels
            AuthorLabel.text = "Author: \(author)"
            BookTitleLabel.text = "Book Title: \(bookTitle)"
        }
    }
}
