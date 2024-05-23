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
        searchBar.delegate = self
    }
    
    func searchBooks(withQuery query: String, completion: @escaping (Result<[Book], Error>) -> Void) {
        let formattedQuery = query.replacingOccurrences(of: " ", with: "%20")
        let urlString = "https://openlibrary.org/search.json?q=\(formattedQuery)&fields=key,title,author_name,editions"
        print("Search URL:", urlString)
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
    
    func saveBook(_ book: BookLocal) {
        var books = UserDefaults.standard.array(forKey: "Books") as? [[String: String]] ?? []
        books.append(["author": book.author, "title": book.title])
        UserDefaults.standard.set(books, forKey: "Books")
    }
}

extension BookSearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchText = searchBar.text, !searchText.isEmpty else { return }

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

extension BookSearchViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BookCell", for: indexPath)
        
        let book = searchResults[indexPath.row]
        
        cell.textLabel?.text = book.title
        cell.detailTextLabel?.text = book.author_name?.first
        
        // Добавить кнопку сохранения
        let saveButton = UIButton(type: .contactAdd)
        saveButton.tag = indexPath.row
        saveButton.addTarget(self, action: #selector(saveButtonTapped(_:)), for: .touchUpInside)
        cell.accessoryView = saveButton
        
        return cell
    }
    
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
