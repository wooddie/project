//
//  DataDetailsViewController.swift
//  project
//
//  Created by Канапия Базарбаев on 30.03.2024.
//

import UIKit

// Протокол делегата для уведомления о добавлении книги
protocol BookAddedDelegate: AnyObject {
    func didAddBook(_ booklocal: BookLocal)
}

class DataDetailsViewController: UIViewController {

    @IBOutlet weak var AuthorLabel: UILabel!
    @IBOutlet weak var BookTitleLabel: UILabel!
    
    // Делегат для уведомления о добавлении книги
    weak var delegate: BookAddedDelegate?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadAndDisplayData()
    }
    
    // Метод для загрузки и отображения данных книги
    func loadAndDisplayData() {
        // Получение сохраненных данных книг из UserDefaults
        if let booksData = UserDefaults.standard.array(forKey: "Books") as? [[String: String]], !booksData.isEmpty {
            // Преобразование данных в массив объектов BookLocal
            let books = booksData.map { BookLocal(title: $0["title"]!, author: $0["author"]!) }
            // Получение последней добавленной книги
            let latestBook = books.last!
            // Отображение автора и названия книги
            AuthorLabel.text = "Author: \(latestBook.author)"
            BookTitleLabel.text = "Book Title: \(latestBook.title)"
        } else {
            // Если данных нет, отображение сообщения "No Data Available"
            AuthorLabel.text = "No Data Available"
            BookTitleLabel.text = ""
        }
    }
}
