//
//  ViewController.swift
//  Indiewave
//
//  Created by Richmond Aisabor on 6/28/21.
//

import UIKit
import FirebaseFirestore

class ViewController: UIViewController {
    let db = Firestore.firestore()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
      
        db.collection("test").addDocument(data: ["age":24, "name":"Mike", "race": "white"])
       
        
    }
    

}

