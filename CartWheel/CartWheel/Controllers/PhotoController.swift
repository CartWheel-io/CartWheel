//
//  PhotoController.swift
//  CartWheel
//
//  Created by Richmond Aisabor on 6/30/21.
//

import UIKit

class PhotoController: UIViewController {

    let imageView = UIImageView(image: #imageLiteral(resourceName: "photo_placeholder"))
    
    init(imageUrl: String) {
        
        if let url = URL(string: imageUrl) {
            imageView.sd_setImage(with: url)
        }
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(imageView)
        imageView.fillSuperview()
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
    }
}
