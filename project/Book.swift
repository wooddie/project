//
//  Book.swift
//  project
//
//  Created by Канапия Базарбаев on 13.04.2024.
//

import Foundation

struct Book: Codable {
    let title: String
    let author: String
    // Дополнительные свойства книги, если есть

    // Инициализатор, если необходимо
     init(title: String, author: String) {
        self.title = title
        self.author = author
    }
}

struct BookSearchResponse: Codable {
    let items: [Book]
}
