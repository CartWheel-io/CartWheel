//
//  User.swift
//  Indiewave
//
//  Created by Richmond Aisabor on 6/30/21.
//

import UIKit

struct Product: ProducesCardViewModel {
    
    var name: String?
    var url: String?
    var price: Int?
    var description: String?
    var imageUrl1: String?
    var imageUrl2: String?
    var imageUrl3: String?
   
    init(dictionary: [String: Any]) {
        
        // Initialize our user here
        self.name = dictionary["fullName"] as? String ?? ""
        self.url = dictionary["url"] as? String
        self.price = dictionary["price"] as? Int
        self.description = dictionary["description"] as? String
        
        self.imageUrl1 = dictionary["imageUrl1"] as? String
        self.imageUrl2 = dictionary["imageUrl2"] as? String
        self.imageUrl3 = dictionary["imageUrl3"] as? String
        
    }
    
    func toCardViewModel() -> CardViewModel {
        
        let attributedText = NSMutableAttributedString(string: name ?? "", attributes: [.font: UIFont.systemFont(ofSize: 32, weight: .heavy)])
        
        let priceString = price != nil ? "\(price!)" : "N\\A"
        attributedText.append(NSAttributedString(string: " \(priceString)", attributes: [.font: UIFont.systemFont(ofSize: 24, weight: .regular)]))
        
        let descriptionString = self.description != nil ? self.description! : "Not available"
        
        attributedText.append(NSAttributedString(string: "\n\(descriptionString)", attributes: [.font: UIFont.systemFont(ofSize: 20, weight: .regular)]))
        
        var imageUrls = [String]()
        
        if let url = imageUrl1 { imageUrls.append(url) }
        if let url = imageUrl2 { imageUrls.append(url) }
        if let url = imageUrl3 { imageUrls.append(url) }
        
        return CardViewModel(name: self.name ?? "", imageNames: imageUrls, attributedString: attributedText, textAlignment: .left)
    }
}
