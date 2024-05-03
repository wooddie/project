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
        let book = BookLocal(title: bookTitle, author: author) // Заменено на author
        saveBook(book)
        navigateToNextScreen()
    }
    
    func saveBook(_ booklocal: BookLocal) { // Изменен тип аргумента
        var books = UserDefaults.standard.array(forKey: "Books") as? [[String: String]] ?? []
        books.append(["author": booklocal.author, "title": booklocal.title]) // Заменено на book.authors
        UserDefaults.standard.set(books, forKey: "Books")
        delegate?.didAddBook(booklocal)
    }
    
    func navigateToNextScreen() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let dataDetailsViewController = storyboard.instantiateViewController(withIdentifier: "DataDetailsViewController") as? DataDetailsViewController {
            dataDetailsViewController.delegate = self
            navigationController?.pushViewController(dataDetailsViewController, animated: true)
        }
    }
    
    func didAddBook(_ booklocal: BookLocal) {
        let allDataViewController = navigationController?.viewControllers.first(where: { $0 is AllDataViewController }) as? AllDataViewController
        allDataViewController?.loadAllData()
        allDataViewController?.allDataTableView.reloadData()
    }
}
