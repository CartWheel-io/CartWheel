//
//  DetailViewController.swift
//  CartWheel
//
//  Created by Richmond Aisabor on 1/17/22.
//

import Foundation
import UIKit

class DetailViewController: UIViewController {

    @IBOutlet var imageView: UIImageView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var store: UILabel!

    var product: Product?

    override func viewDidLoad() {
        super.viewDidLoad()
        if let product = product {
            navigationItem.title = product.name
            imageView.image = UIImage(named: product.imageURL3!)
            nameLabel.text = product.name
            store.text = "Store: " + product.store!
        }
    }
}
