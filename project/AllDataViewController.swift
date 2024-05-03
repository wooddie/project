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
        allDataTableView.delegate = self
        loadAllData()
        allDataTableView.reloadData()
    }
    
    func loadAllData() {
        if let booksData = UserDefaults.standard.array(forKey: "Books") as? [[String: String]], !booksData.isEmpty {
            let books = booksData.map { BookLocal(title: $0["title"]!, author: $0["author"]!) }
            authors = books.map { $0.author }
            bookTitles = books.map { $0.title }
        } else {
            authors = []
            bookTitles = []
        }
        print("Loaded author: \(authors)")
        print("Loaded book titles: \(bookTitles)")
    }
    
    func removeBook(at index: Int) {
        var books = UserDefaults.standard.array(forKey: "Books") as? [[String: String]] ?? []
        books.remove(at: index)
        UserDefaults.standard.set(books, forKey: "Books")
    }
}

extension AllDataViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return authors.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DataCell", for: indexPath)
        cell.textLabel?.text = "\(authors[indexPath.row]) - \(bookTitles[indexPath.row])"
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            removeBook(at: indexPath.row)
            loadAllData()
            allDataTableView.reloadData()
        }
    }
}
