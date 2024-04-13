//
//  AllDataViewController.swift
//  project
//
//  Created by Канапия Базарбаев on 06.04.2024.
//

import UIKit

class AllDataViewController: UIViewController, UITableViewDelegate {

    @IBOutlet weak var allDataTableView: UITableView!
    
    var authors: [String] = []
    var bookTitles: [String] = []
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        allDataTableView.dataSource = self
        allDataTableView.delegate = self // Установка делегата
        loadAllData()
        allDataTableView.reloadData()
    }
    
    func loadAllData() {
        if let booksData = UserDefaults.standard.array(forKey: "Books") as? [[String: String]], !booksData.isEmpty {
            // Преобразуем данные книг в объекты Book
            let books = booksData.map { Book(author: $0["author"]!, title: $0["title"]!) }
            // Получаем списки авторов и названий книг из объектов Book
            authors = books.map { $0.author }
            bookTitles = books.map { $0.title }
        } else {
            authors = []
            bookTitles = []
        }
        
        // Отладочный вывод
        print("Loaded authors: \(authors)")
        print("Loaded book titles: \(bookTitles)")
    }
}

extension AllDataViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return authors.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DataCell", for: indexPath)
        cell.textLabel?.text = "Author: \(authors[indexPath.row]), Book Title: \(bookTitles[indexPath.row])"
        return cell
    }
}
