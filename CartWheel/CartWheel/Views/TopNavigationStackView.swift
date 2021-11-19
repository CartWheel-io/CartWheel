//
//  TopNavigationStackView.swift
//  CartWheel
//
//  Created by Richmond Aisabor on 6/30/21.
//

import UIKit

class TopNavigationStackView: UIStackView {
    
    let settingsButton = UIButton(type: .system)
    let messageButton = UIButton(type: .system)
    let fireImageView = UIImageView(image: #imageLiteral(resourceName: "app_icon-"))
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        distribution = .equalCentering
        heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        fireImageView.contentMode = .scaleAspectFit
        settingsButton.setImage(#imageLiteral(resourceName: "profile").withRenderingMode(.alwaysOriginal), for: .normal)
        messageButton.setImage(#imageLiteral(resourceName: "profile").withRenderingMode(.alwaysOriginal), for: .normal)
        
        [UIView(), fireImageView, UIView()].forEach { (view)  in

            addArrangedSubview(view)
        }
        
        isLayoutMarginsRelativeArrangement = true
        layoutMargins = .init(top: 0, left: 16, bottom: 0, right: 16)
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
