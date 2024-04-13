//
//  ViewController.swift
//  project
//
//  Created by Канапия Базарбаев on 30.03.2024.
//

import UIKit

class ViewController: UIViewController, BookAddedDelegate {
    
    @IBOutlet weak var AuthorTxt: UITextField!
    @IBOutlet weak var BookTitleTxt: UITextField!
    
    // Добавляем свойство delegate
    var delegate: BookAddedDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Load and display saved data when the view loads
    }
    
    @IBAction func BtnTapped(_ sender: Any) {
        guard let author = AuthorTxt.text, !author.isEmpty,
              let bookTitle = BookTitleTxt.text, !bookTitle.isEmpty else {
            return
        }
        let book = Book(author: author, title: bookTitle)
        saveBook(book)
        navigateToNextScreen()
    }
    
    func saveBook(_ book: Book) {
        // Получаем текущий список книг из UserDefaults
        var books = UserDefaults.standard.array(forKey: "Books") as? [[String: String]] ?? []
        // Добавляем новую книгу в список
        books.append(["author": book.author, "title": book.title])
        // Сохраняем обновленный список книг в UserDefaults
        UserDefaults.standard.set(books, forKey: "Books")
        
        // Сообщаем делегату о добавлении новой книги
        delegate?.didAddBook(book)
    }
    
    func navigateToNextScreen() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let dataDetailsViewController = storyboard.instantiateViewController(withIdentifier: "DataDetailsViewController") as? DataDetailsViewController {
            dataDetailsViewController.delegate = self
            navigationController?.pushViewController(dataDetailsViewController, animated: true)
        }
    }
    
    func didAddBook(_ book: Book) {
        // Обновляем данные в AllDataViewController
        let allDataViewController = navigationController?.viewControllers.first(where: { $0 is AllDataViewController }) as? AllDataViewController
        allDataViewController?.loadAllData()
        allDataViewController?.allDataTableView.reloadData()
    }
}
