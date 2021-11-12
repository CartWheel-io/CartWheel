//
//  CardViewModel.swift
//  Cartwheel
//
//  Created by Richmond Aisabor on 6/30/21.
//

import UIKit

protocol ProducesCardViewModel {
    
    func toCardViewModel() -> CardViewModel
}


class CardViewModel {
    
    let pid: String
    let url: String
    let imageURLs: [String]
    let attributedString: NSAttributedString
    let attributedName: NSAttributedString
    let attributedPrice: NSAttributedString
    let attributedDescription: NSAttributedString
    let attributedSize: NSAttributedString
    let textAlignment: NSTextAlignment

    
    init(pid: String, url: String, imageNames: [String], attributedString: NSAttributedString, attributedName: NSAttributedString, attributedPrice: NSAttributedString, attributedDescription: NSAttributedString, attributedSize:NSAttributedString,  textAlignment: NSTextAlignment) {
        
        self.pid              = pid
        self.url              = url
        self.imageURLs        = imageNames
        self.attributedString = attributedString
        self.attributedName = attributedName
        self.textAlignment    = textAlignment
        self.attributedPrice = attributedPrice
        self.attributedDescription = attributedDescription
        self.attributedSize = attributedSize
        
    }
    
    fileprivate var imageIndex = 0 {
        
        didSet {
            
            let imageUrl = imageURLs[imageIndex]
            imageIndexObserver?(imageIndex, imageUrl)
        }
    }
    
    // Reactive programming
    var imageIndexObserver: ((Int, String?) -> ())?
    
    func advaceToNextPhoto() {
        
        imageIndex = min(imageIndex + 1, imageURLs.count - 1)
    }
    
    func goToPreviousPhoto() {
        
        imageIndex = max(0, imageIndex - 1)
    }
    
    func toProduct() -> Product? {
        
        let name = self.attributedName.string
        let pid = self.pid
        let url = self.url
        let price = self.attributedPrice.string
        let description = self.attributedDescription.string
        let size = self.attributedSize.string
        let imageURL1 = self.imageURLs[0]
        let imageURL2 = self.imageURLs[1]
        let imageURL3 = self.imageURLs[2]
    
        let diction = ["name": name,
                        "pid": pid,
                         "url": url,
                         "price": price,
                         "size": size,
                         "description": description,
                         "imageURL1": imageURL1,
                         "imageURL2": imageURL2,
                         "imageURL3": imageURL3]
 
        return Product(dictionary: diction)

    }
    
}
