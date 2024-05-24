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
    
    // Делегат для уведомления о добавлении книги
    var delegate: BookAddedDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // Метод, вызываемый при нажатии на кнопку "Добавить"
    @IBAction func BtnTapped(_ sender: Any) {
        // Проверка, что поля ввода не пусты
        guard let author = AuthorTxt.text, !author.isEmpty,
              let bookTitle = BookTitleTxt.text, !bookTitle.isEmpty else {
            return
        }
        // Создание объекта книги
        let book = BookLocal(title: bookTitle, author: author)
        // Сохранение книги
        saveBook(book)
        // Переход на следующий экран
        navigateToNextScreen()
    }
    
    // Метод для сохранения книги в UserDefaults
    func saveBook(_ booklocal: BookLocal) {
        // Загрузка существующего списка книг из UserDefaults
        var books = UserDefaults.standard.array(forKey: "Books") as? [[String: String]] ?? []
        // Добавление новой книги в список
        books.append(["author": booklocal.author, "title": booklocal.title])
        // Сохранение обновленного списка в UserDefaults
        UserDefaults.standard.set(books, forKey: "Books")
        // Уведомление делегата о добавлении книги
        delegate?.didAddBook(booklocal)
    }
    
    // Метод для перехода на следующий экран
    func navigateToNextScreen() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        // Получение экземпляра DataDetailsViewController из storyboard
        if let dataDetailsViewController = storyboard.instantiateViewController(withIdentifier: "DataDetailsViewController") as? DataDetailsViewController {
            // Установка делегата
            dataDetailsViewController.delegate = self
            // Переход на экран DataDetailsViewController
            navigationController?.pushViewController(dataDetailsViewController, animated: true)
        }
    }
    
    // Метод делегата для обработки добавления книги
    func didAddBook(_ booklocal: BookLocal) {
        // Обновление данных в AllDataViewController
        let allDataViewController = navigationController?.viewControllers.first(where: { $0 is AllDataViewController }) as? AllDataViewController
        allDataViewController?.loadAllData()
        allDataViewController?.allDataTableView.reloadData()
    }
}
