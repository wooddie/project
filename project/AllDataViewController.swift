//
//  AllDataViewController.swift
//  project
//
//  Created by Канапия Базарбаев on 06.04.2024.
//

import UIKit

class AllDataViewController: UIViewController, UITableViewDelegate {

    @IBOutlet weak var allDataTableView: UITableView!
    
    // Массивы для хранения авторов и названий книг
    var authors: [String] = []
    var bookTitles: [String] = []
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Установка dataSource и delegate для таблицы
        allDataTableView.dataSource = self
        allDataTableView.delegate = self
        // Загрузка всех данных
        loadAllData()
        // Обновление таблицы
        allDataTableView.reloadData()
    }
    
    // Метод для загрузки всех данных из UserDefaults
    func loadAllData() {
        // Получение сохраненных данных книг из UserDefaults
        if let booksData = UserDefaults.standard.array(forKey: "Books") as? [[String: String]], !booksData.isEmpty {
            // Преобразование данных в массив объектов BookLocal
            let books = booksData.map { BookLocal(title: $0["title"]!, author: $0["author"]!) }
            // Извлечение авторов и названий книг
            authors = books.map { $0.author }
            bookTitles = books.map { $0.title }
        } else {
            // Если данных нет, массивы остаются пустыми
            authors = []
            bookTitles = []
        }
        print("Loaded author: \(authors)")
        print("Loaded book titles: \(bookTitles)")
    }
    
    // Метод для удаления книги по индексу
    func removeBook(at index: Int) {
        // Получение сохраненных данных книг из UserDefaults
        var books = UserDefaults.standard.array(forKey: "Books") as? [[String: String]] ?? []
        // Удаление книги по индексу
        books.remove(at: index)
        // Удаление книги по индексу
        UserDefaults.standard.set(books, forKey: "Books")
    }
}

// Расширение для реализации методов UITableViewDataSource
extension AllDataViewController: UITableViewDataSource {
    // Метод для указания количества строк в секции таблицы
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return authors.count
    }
    
    // Метод для создания ячейки таблицы
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Получение ячейки из пула ячеек с идентификатором "DataCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: "DataCell", for: indexPath)
        // Установка текста ячейки
        cell.textLabel?.text = "\(authors[indexPath.row]) - \(bookTitles[indexPath.row])"
        return cell
    }
    
    // Метод для обработки удаления строки таблицы
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        // Если стиль редактирования - удаление
        if editingStyle == .delete {
            // Удаление книги по индексу
            removeBook(at: indexPath.row)
            // Загрузка обновленных данных
            loadAllData()
            // Обновление таблицы
            allDataTableView.reloadData()
        }
    }
}
