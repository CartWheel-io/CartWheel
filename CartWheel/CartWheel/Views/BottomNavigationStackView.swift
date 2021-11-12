//
//  BottomNavigationStackView.swift
//  Cartwheel
//
//  Created by Richmond Aisabor on 6/30/21.
//

import UIKit

class BottomNavigationStackView: UIStackView {
    
    
    static func createButton(image: UIImage) -> UIButton {
           let button = UIButton(type: .system)
           button.setImage(image.withRenderingMode(.alwaysOriginal), for: .normal)
           button.imageView?.contentMode = .scaleToFill
           return button
    }
    
    let profileButton = createButton(image: #imageLiteral(resourceName: "profile"))
    let favoriteButton = createButton(image: #imageLiteral(resourceName: "favorite"))
    let homeButton = createButton(image: #imageLiteral(resourceName: "home"))
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        distribution = .equalCentering
        heightAnchor.constraint(equalToConstant: 80).isActive = true
        
        
        
        [profileButton, homeButton, favoriteButton].forEach { (button)  in

            addArrangedSubview(button)
        }
        
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


