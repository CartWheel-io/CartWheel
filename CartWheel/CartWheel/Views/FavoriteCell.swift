//
//  FavoriteCell.swift
//  Cartwheel
//
//  Created by Richmond Aisabor on 6/30/21.
//

import UIKit
import SafariServices

class FavoriteCell: UITableViewCell {
    
    // MARK: - Properties
 
    static let cellID = "FavoriteCell"
    let radioURL = ""
    let buyNowButton: UIButton = {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 100, height: 20))
        button.setTitle("Buy Now", for: .normal)
        button.setTitleColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), for: .normal)
        button.setTitleColor(#colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1), for: .disabled)
        button.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 13, weight: .heavy)
        button.heightAnchor.constraint(equalToConstant: 44).isActive = true
       // button.layer.cornerRadius = 18
        button.clipsToBounds = true

        button.addTarget(self, action: #selector(handleBuyNowButton), for: .touchUpInside)
        return button
    }()

    
    // MARK: - Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(buyNowButton)
      
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Selectors
    
    @objc fileprivate func handleBuyNowButton() {
        
        /*let url = URL(string: radioURL)
        let safariVC = SFSafariViewController(url: url!)
        
        if let vc = self.next(ofType: UIViewController.self) {
            vc.present(safariVC, animated: true, completion: nil)
        }
    */
        print("buy")
    
    }
    
}
/*
extension UIResponder {
    func next<T:UIResponder>(ofType: T.Type) -> T? {
        let r = self.next
        if let r = r as? T ?? r?.next(ofType: T.self) {
            return r
        } else {
            return nil
        }
    }
}

*/
