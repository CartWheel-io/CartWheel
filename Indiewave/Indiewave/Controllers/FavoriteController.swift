//
//  FavoriteController.swift
//  Indiewave
//
//  Created by Richmond Aisabor on 8/1/21.
//

import UIKit
import SwiftUI
import Firebase


class FavoriteController: UIViewController, UIScrollViewDelegate, UINavigationControllerDelegate {
    
    var likedCards = [Product]()
    var nameCard = [String]()
    var priceCard = [String]()
    

    let emailTextField: UITextField = {
        let textField = CustomTextField(padding: 22, height: 44)
        textField.placeholder = "Enter email"
        textField.keyboardType = .emailAddress
        return textField
    }()
    
    let passwordTextField: UITextField = {
        let textField = CustomTextField(padding: 22, height: 44)
        textField.placeholder = "Enter password"
        
        textField.isSecureTextEntry = true
        return textField
    }()
    
    lazy var verticalStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            emailTextField,
            passwordTextField,
            ])
        stackView.axis = .vertical
        stackView.spacing = 8
        return stackView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        setupLayout()
    }

    
    fileprivate func setupLayout() {
        
        //self.navigationController!.navigationBar.topItem!.title = "Favorites"
        //navigationController?.navigationBar.prefersLargeTitles = true
    
        view.backgroundColor = .black
        
        
        view.addSubview(verticalStackView)
        
        verticalStackView.anchor(top: nil, leading: view.leadingAnchor, bottom: nil, trailing:
        view.trailingAnchor, padding: .init(top: 0, left: 50, bottom: 0, right: -50))
        verticalStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
     
    }
    
    
    fileprivate func setupLikedCards() {
       
           likedCards.forEach { (card) in
            nameCard.append(card.name!)
            priceCard.append(card.price!)
           }
       }

   
    
}


