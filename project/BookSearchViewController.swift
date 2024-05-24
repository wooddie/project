//
//  SearchViewController.swift
//  project
//
//  Created by Канапия Базарбаев on 07.04.2024.
//

import UIKit

class BookSearchViewController: UIViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    // Массив для хранения результатов поиска книг
    var searchResults: [Book] = []
    
    // Метод, вызываемый после загрузки ViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        // Установка делегатов для таблицы и поисковой строки
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
    }
    
    // Метод для поиска книг по запросу
    func searchBooks(withQuery query: String, completion: @escaping (Result<[Book], Error>) -> Void) {
        // Форматирование запроса для использования в URL
        let formattedQuery = query.replacingOccurrences(of: " ", with: "%20")
        let urlString = "https://openlibrary.org/search.json?q=\(formattedQuery)&fields=key,title,author_name,editions"
        print("Search URL:", urlString)
        
        // Проверка корректности URL
        guard let url = URL(string: urlString) else {
            completion(.failure(NSError(domain: "Invalid URL", code: 0, userInfo: nil)))
            return
        }
        
        // Запрос данных из API
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "No data in response", code: 0, userInfo: nil)))
                return
            }
            
            // Декодирование JSON ответа
            do {
                let bookResponse = try JSONDecoder().decode(BookSearchResponse.self, from: data)
                print("Received \(bookResponse.docs.count) books:")
                for book in bookResponse.docs {
                    if let authorName = book.author_name {
                        if !authorName.isEmpty {
                            print("Title: \(book.title), Authors: \(authorName.joined(separator: ", "))")
                        } else {
                            print("Title: \(book.title), Authors: Unknown")
                        }
                    } else {
                        print("Title: \(book.title), Authors: Unknown")
                    }
                }
                completion(.success(bookResponse.docs))
            } catch {
                completion(.failure(error))
            }
        }
        
        task.resume() // Запуск задачи
    }
    
    // Метод для сохранения книги в UserDefaults
    func saveBook(_ book: BookLocal) {
        var books = UserDefaults.standard.array(forKey: "Books") as? [[String: String]] ?? []
        books.append(["author": book.author, "title": book.title])
        UserDefaults.standard.set(books, forKey: "Books")
    }
}

// Расширение для обработки событий UISearchBar
extension BookSearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchText = searchBar.text, !searchText.isEmpty else { return }

        // Вызов метода поиска книг с указанным запросом
        searchBooks(withQuery: searchText) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let books):
                DispatchQueue.main.async {
                    self.searchResults = books
                    print("Search results count: \(self.searchResults.count)")
                    self.tableView.reloadData()
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
                print("Search error: \(error)")
            }
        }
    }
}

// Расширение для обработки событий UITableView
extension BookSearchViewController: UITableViewDataSource, UITableViewDelegate {
    // Метод для указания количества строк в секции таблицы
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }

    // Метод для создания ячейки таблицы
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BookCell", for: indexPath)
        
        let book = searchResults[indexPath.row]
        
        cell.textLabel?.text = book.title
        cell.detailTextLabel?.text = book.author_name?.first
        
        // Добавление кнопки для сохранения книги
        let saveButton = UIButton(type: .contactAdd)
        saveButton.tag = indexPath.row
        saveButton.addTarget(self, action: #selector(saveButtonTapped(_:)), for: .touchUpInside)
        cell.accessoryView = saveButton
        
        return cell
    }
    
    // Метод, вызываемый при нажатии кнопки сохранения
    @objc func saveButtonTapped(_ sender: UIButton) {
        let book = searchResults[sender.tag]
        if let author = book.author_name?.first {
            let bookLocal = BookLocal(title: book.title, author: author)
            saveBook(bookLocal)
            let alert = UIAlertController(title: "Success", message: "Book saved successfully!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
        }
    }
}
