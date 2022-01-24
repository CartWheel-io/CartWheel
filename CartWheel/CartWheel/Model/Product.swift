//
//  User.swift
//  CartWheel
//
//  Created by Richmond Aisabor on 6/30/21.
//

import UIKit
import FirebaseFirestore
import Firebase

struct Product: ProducesCardViewModel {
    
    var name: String?
    var pid: String?
    var url: String?
    var price: String?
    var size: String?
    var store: String?
    var description: String?
    var imageURL1: String?
    var imageURL2: String?
    var imageURL3: String?
    
   
    init(dictionary: [String: Any]) {
        
        // Initialize our user here
        self.name = dictionary["name"] as? String ?? ""
        self.pid = dictionary["pid"] as? String
        self.url = dictionary["url"] as? String
        self.price = dictionary["price"] as? String
        self.description = dictionary["description"] as? String
        self.size = dictionary["size"] as? String
        self.store = dictionary["store"] as? String

        
        self.imageURL1 = dictionary["imageURL1"] as? String
        self.imageURL2 = dictionary["imageURL2"] as? String
        self.imageURL3 = dictionary["imageURL3"] as? String
        
    }
    
    init(snapshot: QueryDocumentSnapshot) {
        
            self.name = snapshot.data()["name"] as? String
            self.pid = snapshot.data()["pid"] as? String
            self.url = snapshot.data()["url"] as? String
            self.price = snapshot.data()["price"] as? String
            self.description = snapshot.data()["description"] as? String
            self.size = snapshot.data()["size"] as? String
            self.store = snapshot.data()["store"] as? String
            self.imageURL1 = snapshot.data()["imageURL1"] as? String
            self.imageURL2 = snapshot.data()["imageURL2"] as? String
            self.imageURL3 = snapshot.data()["imageURL3"] as? String
        }
    
    func toDictionary() -> [String: Any] {
        
        let tempDict = ["name": name,
                        "pid": pid,
                         "url": url,
                         "price": price,
                         "size": size,
                         "description": description,
                         "store": store,
                         "imageURL1": imageURL1,
                         "imageURL2": imageURL2,
                         "imageURL3": imageURL3] as [String : Any]
        
        return tempDict
 
    }
    
    func toCardViewModel() -> CardViewModel {
        
       
        let priceString = self.price!
        let urlString = self.url!
        let pidString = UUID().uuidString
        
        let descriptionString = self.description != nil ? self.description! : "Not available"
        let sizeString = self.size
        
        
        let attributedName = NSMutableAttributedString(string: name ?? "", attributes: [.font: UIFont.systemFont(ofSize: 23, weight: .heavy)])
        
        
        let attributedPrice = NSMutableAttributedString(string: priceString , attributes: [.font: UIFont.systemFont(ofSize: 23, weight: .heavy)])
        
        let attributedDescription = NSMutableAttributedString(string: description ?? "", attributes: [.font: UIFont.systemFont(ofSize: 23, weight: .heavy)])
        
        let attributedSize = NSMutableAttributedString(string: size ?? "", attributes: [.font: UIFont.systemFont(ofSize: 23, weight: .heavy)])
        
        let attributedStore = NSMutableAttributedString(string: store ?? "", attributes: [.font: UIFont.systemFont(ofSize: 23, weight: .heavy)])
        
        let attributedText = NSMutableAttributedString(string: name ?? "", attributes: [.font: UIFont.systemFont(ofSize: 43, weight: .regular)])
        
        
        attributedText.append(NSAttributedString(string: "\n\n$\(priceString)", attributes: [.font: UIFont.systemFont(ofSize: 30, weight: .heavy)]))
        
        attributedText.append(NSAttributedString(string: "\n\(sizeString!)", attributes: [.font: UIFont.systemFont(ofSize: 30, weight: .regular)]))
        
        attributedText.append(NSAttributedString(string: "\n\n\(descriptionString)", attributes: [.font: UIFont.systemFont(ofSize: 22, weight: .regular)]))
        
        var imageURLs = [String]()
        
        if let url = imageURL1 { imageURLs.append(url) }
        if let url = imageURL2 { imageURLs.append(url) }
        if let url = imageURL3 { imageURLs.append(url) }
        
        return CardViewModel(pid: pidString , url: urlString, imageNames: imageURLs, attributedString: attributedText, attributedName: attributedName, attributedPrice: attributedPrice, attributedDescription: attributedDescription, attributedSize: attributedSize, attributedStore: attributedStore, textAlignment: .left)
    }
}
