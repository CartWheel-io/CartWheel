//
//  User.swift
//  Indiewave
//
//  Created by Richmond Aisabor on 6/30/21.
//

import UIKit

struct Product: ProducesCardViewModel {
    
    var name: String?
    var pid: String?
    var url: String?
    var price: String?
    var size: String?
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

        
        self.imageURL1 = dictionary["imageURL1"] as? String
        self.imageURL2 = dictionary["imageURL2"] as? String
        self.imageURL3 = dictionary["imageURL3"] as? String
        
    }
    
    func toCardViewModel() -> CardViewModel {
        
       
        let priceString = self.price
        let urlString = self.url!
        let pidString = UUID().uuidString
        
        let descriptionString = self.description != nil ? self.description! : "Not available"
        
        
        let attributedName = NSMutableAttributedString(string: name ?? "", attributes: [.font: UIFont.systemFont(ofSize: 23, weight: .heavy)])
        
        let attributedPrice = NSMutableAttributedString(string: price ?? "", attributes: [.font: UIFont.systemFont(ofSize: 23, weight: .heavy)])
        
        let attributedDescription = NSMutableAttributedString(string: description ?? "", attributes: [.font: UIFont.systemFont(ofSize: 23, weight: .heavy)])
        
        let attributedSize = NSMutableAttributedString(string: size ?? "", attributes: [.font: UIFont.systemFont(ofSize: 23, weight: .heavy)])
        
        let attributedText = NSMutableAttributedString(string: name ?? "", attributes: [.font: UIFont.systemFont(ofSize: 32, weight: .heavy)])
        
        
        attributedText.append(NSAttributedString(string: "\n$\(priceString!)", attributes: [.font: UIFont.systemFont(ofSize: 24, weight: .regular)]))
        
        attributedText.append(NSAttributedString(string: "\n\n\(descriptionString)", attributes: [.font: UIFont.systemFont(ofSize: 20, weight: .regular)]))
        
        var imageURLs = [String]()
        
        if let url = imageURL1 { imageURLs.append(url) }
        if let url = imageURL2 { imageURLs.append(url) }
        if let url = imageURL3 { imageURLs.append(url) }
        
        return CardViewModel(pid: pidString , url: urlString, imageNames: imageURLs, attributedString: attributedText, attributedName: attributedName, attributedPrice: attributedPrice, attributedDescription: attributedDescription, attributedSize: attributedSize, textAlignment: .left)
    }
}
