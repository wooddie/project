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
        // Do any additional setup after loading the view.
    }
    
    @IBAction func BtnTapped(_ sender: Any) {
        guard let author = AuthorTxt.text, !author.isEmpty,
              let bookTitle = BookTitleTxt.text, !bookTitle.isEmpty else {
            // Ensure both fields are filled
            return
        }
        // Save data to UserDefaults
        UserDefaults.standard.set(author, forKey: "Author")
        UserDefaults.standard.set(bookTitle, forKey: "BookTitle")
        // Navigate to the next screen
        navigateToNextScreen()
    }
    
    func loadSavedData() {
        // Load data from UserDefaults
        if let author = UserDefaults.standard.string(forKey: "Author"),
           let bookTitle = UserDefaults.standard.string(forKey: "BookTitle") {
            // Set text fields with saved data
            AuthorTxt.text = author
            BookTitleTxt.text = bookTitle
        }
    }
    
    func navigateToNextScreen() {
        // Navigate to the next screen
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let dataDetailsViewController = storyboard.instantiateViewController(withIdentifier: "DataDetailsViewController") as? DataDetailsViewController {
            navigationController?.pushViewController(dataDetailsViewController, animated: true)
        }
    }
}

