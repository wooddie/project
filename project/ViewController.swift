//
//  ViewController.swift
//  project
//
//  Created by Канапия Базарбаев on 30.03.2024.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var AuthorTxt: UITextField!
    @IBOutlet weak var BookTitleTxt: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Load and display saved data when the view loads
        loadSavedData()
    }
    
    @IBAction func BtnTapped(_ sender: Any) {
        guard let author = AuthorTxt.text, !author.isEmpty,
              let bookTitle = BookTitleTxt.text, !bookTitle.isEmpty else {
            return
        }
        UserDefaults.standard.set(author, forKey: "Author")
        UserDefaults.standard.set(bookTitle, forKey: "BookTitle")
        navigateToNextScreen()
    }
    
    func loadSavedData() {
        if let author = UserDefaults.standard.string(forKey: "Author"),
           let bookTitle = UserDefaults.standard.string(forKey: "BookTitle") {
            AuthorTxt.text = author
            BookTitleTxt.text = bookTitle
        }
    }
    
    func navigateToNextScreen() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let dataDetailsViewController = storyboard.instantiateViewController(withIdentifier: "DataDetailsViewController") as? DataDetailsViewController {
            navigationController?.pushViewController(dataDetailsViewController, animated: true)
        }
    }
}

