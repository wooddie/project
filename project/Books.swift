//
//  Books.swift
//  project
//
//  Created by Канапия Базарбаев on 13.04.2024.
//

import Foundation

struct Books: Codable {
    let title: String
    let author: String
    // Дополнительные свойства книги, если есть

    // Инициализатор, если необходимо
     init(title: String, author: String) {
        self.title = title
        self.author = author
    }
}
