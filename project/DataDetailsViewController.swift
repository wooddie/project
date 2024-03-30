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
    
    var author = ""
    var bookTitle = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        AuthorLabel.text = "Author: \(author)"
        BookTitleLabel.text = "Book title: \(bookTitle)"

    }
}
