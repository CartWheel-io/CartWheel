//
//  BottomNavigationStackView.swift
//  Indiewave
//
//  Created by Richmond Aisabor on 6/30/21.
//

import UIKit

class BottomNavigationStackView: UIStackView {
    
    let profileButton = UIButton(type: .system)
    let favoriteButton = UIButton(type: .system)
    let swipeButton = UIButton(type: .system)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        distribution = .equalCentering
        heightAnchor.constraint(equalToConstant: 80).isActive = true
        
        profileButton.setImage(#imageLiteral(resourceName: "top_left_profile").withRenderingMode(.alwaysOriginal), for: .normal)
        favoriteButton.setImage(#imageLiteral(resourceName: "top_left_profile").withRenderingMode(.alwaysOriginal), for: .normal)
        swipeButton.setImage(#imageLiteral(resourceName: "top_right_messages").withRenderingMode(.alwaysOriginal), for: .normal)
        
        [swipeButton, UIView(), profileButton, UIView(), swipeButton].forEach { (view)  in

            addArrangedSubview(view)
        }
        
        isLayoutMarginsRelativeArrangement = true
        layoutMargins = .init(top: 0, left: 16, bottom: 0, right: 16)
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


