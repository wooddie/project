//
//  BookLocal.swift
//  project
//
//  Created by Канапия Базарбаев on 14.04.2024.
//

import Foundation

struct BookLocal {
    let title: String
    let author: String

    // Изменен инициализатор, чтобы соответствовать новым необязательным полям
    init(title: String, author: String) {
        self.title = title
        self.author = author
    }
}
