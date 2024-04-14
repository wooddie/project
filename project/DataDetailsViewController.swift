//
//  DataDetailsViewController.swift
//  project
//
//  Created by Канапия Базарбаев on 30.03.2024.
//

import UIKit

protocol BookAddedDelegate: AnyObject {
    func didAddBook(_ book: Book)
}

class DataDetailsViewController: UIViewController {

    @IBOutlet weak var AuthorLabel: UILabel!
    @IBOutlet weak var BookTitleLabel: UILabel!
    
    weak var delegate: BookAddedDelegate?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadAndDisplayData()
    }
    
    func loadAndDisplayData() {
        if let booksData = UserDefaults.standard.array(forKey: "Books") as? [[String: String]], !booksData.isEmpty {
            // Преобразуем данные книг в объекты Book
            let books = booksData.map { Book(title: $0["title"]!, author: $0["author"]!) }
            // Выводим информацию о последней добавленной книге
            let latestBook = books.last!
            AuthorLabel.text = "Author: \(latestBook.author)"
            BookTitleLabel.text = "Book Title: \(latestBook.title)"
        } else {
            AuthorLabel.text = "No Data Available"
            BookTitleLabel.text = ""
        }
    }
}
