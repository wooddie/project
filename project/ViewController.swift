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
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "DataDetailsViewController") as! DataDetailsViewController
        vc.author = AuthorTxt.text!
        vc.bookTitle = BookTitleTxt.text!
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}

