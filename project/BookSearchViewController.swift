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
    
    var searchResults: [Book] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        // Additional setup
    }
    
    func searchBooks(withQuery query: String, completion: @escaping (Result<[Book], Error>) -> Void) {
        // Заменяем пробелы на %20 в запросе
        let formattedQuery = query.replacingOccurrences(of: " ", with: "%20")
        let urlString = "https://openlibrary.org/search.json?q=\(formattedQuery)&fields=key,title,author_name,editions"
        print("Search URL:", urlString) // Выводим URL-адрес для отладки
        guard let url = URL(string: urlString) else {
            completion(.failure(NSError(domain: "Invalid URL", code: 0, userInfo: nil)))
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "No data in response", code: 0, userInfo: nil)))
                return
            }
            
            do {
                let bookResponse = try JSONDecoder().decode(BookSearchResponse.self, from: data)
                print("Received \(bookResponse.docs.count) books:")
                for book in bookResponse.docs {
                    // Проверяем, не пустой ли массив "author_name"
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
        
        task.resume()
    }
}

extension BookSearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchText = searchBar.text, !searchText.isEmpty else { return }

        // Perform search request using API
        searchBooks(withQuery: searchText) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let books):
                // Update UI with search results
                DispatchQueue.main.async {
                    self.searchResults = books
                    print("Search results count: \(self.searchResults.count)") // Добавьте эту строку
                    self.tableView.reloadData() // Обновляем таблицу с новыми результатами
                }
            case .failure(let error):
                // Handle error
                DispatchQueue.main.async {
                    // Отображаем алерт с сообщением об ошибке
                    let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
                print("Search error: \(error)")
            }
        }
    }
}


extension BookSearchViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BookCell", for: indexPath)
        
        // Получаем книгу для текущей строки
        let book = searchResults[indexPath.row]
        
        // Настраиваем ячейку с данными о книге (название и список авторов)
        cell.textLabel?.text = book.title
        cell.detailTextLabel?.text = book.author_name?.first // Обновляем список авторов
        return cell
    }
}
