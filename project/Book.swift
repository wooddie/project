//
//  Book.swift
//  project
//
//  Created by Канапия Базарбаев on 13.04.2024.
//

import Foundation

struct BookSearchResponse: Codable {
    let numFound: Int
    let docs: [Book]
}

struct Book: Codable {
    let key: String
    let title: String
    let author_name: [String]?
    let editions: Editions?
}

struct Editions: Codable {
    let numFound: Int
    let docs: [Edition]
}

struct Edition: Codable {
    let key: String
    let title: String
}
