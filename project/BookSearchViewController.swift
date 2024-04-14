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
        // Additional setup
    }
    
    func searchBooks(withQuery query: String, completion: @escaping (Result<[Book], Error>) -> Void) {
        // URL для запроса к API
        let urlString = "https://www.googleapis.com/books/v1/volumes?q=\(query)&key=AIzaSyBXBo1rRuAPsAHQ3k3dH2uhEca61LV4I2A"
        guard let url = URL(string: urlString) else {
            completion(.failure(NSError(domain: "Invalid URL", code: 0, userInfo: nil)))
            return
        }
        // Создаем запрос
        var request = URLRequest(url: url)
        request.httpMethod = "GET"

        // Создаем сессию
        let session = URLSession.shared

        // Создаем задачу для выполнения запроса
        let task = session.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            // Проверяем наличие данных в ответе
            guard let data = data else {
                completion(.failure(NSError(domain: "No data in response", code: 0, userInfo: nil)))
                return
            }

            do {
                // Парсим JSON данные в массив объектов Book
                let bookResponse = try JSONDecoder().decode(BookSearchResponse.self, from: data)
                let convertedBooks = bookResponse.items.map { Book(title: $0.title, author: $0.author) }
                completion(.success(convertedBooks))
            } catch {
                completion(.failure(error))
            }
        }

        // Запускаем задачу
        task.resume()
    }
}

extension BookSearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchText = searchBar.text, !searchText.isEmpty else { return }

        // Perform search request using API
        searchBooks(withQuery: searchText) { result in
            switch result {
            case .success(_):
                // Update UI with search results
                DispatchQueue.main.async {
                    // Update table view with search results
                }
            case .failure(let error):
                // Handle error
                print("Search error: \(error)")
            }
        }
    }
}

extension BookSearchViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count// Предполагается, что у вас есть свойство books, содержащее массив книг
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BookCell", for: indexPath)
        
        // Получаем книгу для текущей строки
        let book = searchResults[indexPath.row]
        
        // Настраиваем ячейку с данными о книге
        cell.textLabel?.text = book.title
        cell.detailTextLabel?.text = book.author
        
        return cell
    }
}
