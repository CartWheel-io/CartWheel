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
      
        db.collection("test1").addDocument(data: ["name":"Y2K Grateful Dead Blackbird Rock Music Tee", "url":"https://pfrvintage.com/collections/all-products/products/y2k-grateful-dead-blackbird-rock-music-tee", "price": 25, "imageUrl1":"https://cdn.shopify.com/s/files/1/0261/3523/2591/products/image_c82c74b7-96f1-45a8-a790-df24550e8d91_1024x1024@2x.jpg?v=1624736160", "description": "Good Condition (spot by graphic, signs of wear throughout) Size XXL Liquid Blue Brand Pit to Pit - 25 Top to Bottom - 28 "])
        
        db.collection("test1").addDocument(data: ["name":"Corday Solid Perfume Birds Swing in Cage \"Fame\"", "url":"https://www.rubylane.com/item/168800-21P39/Corday-Solid-Perfume-Birds-Swing-Cage?search=1&t=85fdc8b7", "price": 65, "imageUrl1":"https://cdn0.rubylane.com/_pod/item/168800/21P39/Corday-Solid-Perfume-Birds-Swing-Cage-full-1A-2048%3a10.10-58298128-c1ccd6.png", "description": "Solid Perfume by Corday. The scent is \"Fame\" and there is still perfume in the small trinket box. The birds swing inside the cage. It has the original label. Called Love Birds. From 1960's-70's."])
       
       
        
    }
    

}

