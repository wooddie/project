//
//  AllDataViewController.swift
//  project
//
//  Created by Канапия Базарбаев on 06.04.2024.
//

import UIKit

class AllDataViewController: UIViewController {

    @IBOutlet weak var allDataTableView: UITableView!
    
    var authors: [String] = []
    var bookTitles: [String] = []
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadAllData()
        allDataTableView.dataSource = self
        allDataTableView.reloadData()
    }
    
    func loadAllData() {
        if let savedAuthors = UserDefaults.standard.array(forKey: "Authors") as? [String] {
            authors = savedAuthors
        }
        if let savedBookTitles = UserDefaults.standard.array(forKey: "BookTitles") as? [String] {
            bookTitles = savedBookTitles
        }
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
