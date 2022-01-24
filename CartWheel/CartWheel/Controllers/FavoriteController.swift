//
//  FavoriteController.swift
//  CartWheel
//
//  Created by Richmond Aisabor on 8/8/21.
//

import UIKit
import SafariServices
import Firebase
import FirebaseFirestore

private let reuseIdentifier = "FavoriteCell"

class FavoriteController: UITableViewController, UINavigationControllerDelegate {

    var likedCards = [Product]()
    private let cellIdentifier: String = "tableCell"

    
    var radioURL = ""
    
    let buyNowButton: UIButton = {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 100, height: 20))
        
        button.setTitleColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), for: .normal)
        button.setTitleColor(#colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1), for: .disabled)
        button.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 13, weight: .heavy)
        button.heightAnchor.constraint(equalToConstant: 44).isActive = true

        button.clipsToBounds = true

        button.addTarget(self, action: #selector(handleBuyNowButton), for: .touchUpInside)
        return button
    }()
    
    var buyURLs = [String?]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.register(FavoriteCell.self, forCellReuseIdentifier: reuseIdentifier)
        setupUI()
        

        // Uncomment the following line to preserve selection between presentations
        
    }


    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning ncomplete implementation, return the number of sections
        return 1
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if isBeingDismissed {
            HomeController().likedCards = self.likedCards
        }
    }
    
    
    
    override func tableView(_ tableView: UITableView,
               heightForRowAt indexPath: IndexPath) -> CGFloat {
       // Make the first row larger to accommodate a custom cell.
//      if indexPath.row == 0{
//          return 80
//       }

       // Use the default size for all other rows.
       //return UITableView.automaticDimension
        
        return 80
    }
    
    @objc fileprivate func handleBuyNowButton() {
        
        let url = URL(string: radioURL)
        let safariVC = SFSafariViewController(url: url!)
        present(safariVC, animated: true, completion: nil)
    
    }
    

    
}

extension FavoriteController {

    private func setupUI() {
        self.clearsSelectionOnViewWillAppear = false

       // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        //self.navigationItem.rightBarButtonItem = self.editButtonItem
       
       self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .done, target: self, action: nil)
       self.navigationController?.navigationBar.barTintColor = UIColor.black
       self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
       title = "Shopping Cart"
       
       // Register Class
       tableView.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: reuseIdentifier)
        
       tableView.reloadData()
    }
    
    

}

// MARK: - UITableView DataSource
extension FavoriteController {

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.likedCards.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
        
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier)
        var content = cell?.defaultContentConfiguration()
        let product = self.likedCards[indexPath.row]
        
        content?.text = product.name
        content?.secondaryText = product.store
        let url = URL(string: product.imageURL3!)
        let data = try? Data(contentsOf: url!)
        
        let image = UIImage(data: data!)

        content?.image = image
        cell?.contentConfiguration = content
        
        return cell!
    }

}

// MARK: - UITableView Delegate
extension FavoriteController {
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let item = self.likedCards[indexPath.row]
        let MoreAction = UIContextualAction(style: .normal, title: "More") { action, view, complete in
          print("More")
          let productDetailsController = ProductDetailsController()
            productDetailsController.cardViewModel = item.toCardViewModel()
            print(item.price!)
          self.present(productDetailsController, animated: true, completion: nil)
          complete(true)
        }

        // here set your image and background color
        MoreAction.backgroundColor = .gray
        
        let ShareAction = UIContextualAction(style: .normal, title: "Share") { action, view, complete in
          print("Share")
        
          let name = URL(string: item.url!)
          let vc = UIActivityViewController(activityItems: [name!], applicationActivities: nil)
          vc.popoverPresentationController?.sourceView = self.view

          self.present(vc, animated: true, completion: nil)
         
        }

        // here set your image and background color
        ShareAction.backgroundColor = .blue

        let DeleteAction = UIContextualAction(style: .destructive, title: "Delete") { action, view, complete in
          print("Delete")
 
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let item = self.likedCards[indexPath.row]
        Firestore.firestore().collection("swipes").document(uid).updateData([
                item.pid: FieldValue.delete(),
            ]) { err in
                if let err = err {
                    print("Error updating document: \(err)")
                } else {
                    print("Document successfully updated")
                }
            }


        self.likedCards.remove(at: indexPath.row)
                    
        let viewController = UIApplication.shared.windows.first!.rootViewController as! HomeController
            
        viewController.updateLikedCards(tempLikes: self.likedCards)
            
      
        self.tableView.deleteRows(at: [indexPath], with: .automatic)

        complete(true)
        }

        return UISwipeActionsConfiguration(actions: [DeleteAction, ShareAction, MoreAction])
      }
        


    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            print("Deleted")
            guard let uid = Auth.auth().currentUser?.uid else { return }
            let item = self.likedCards[indexPath.row]
            Firestore.firestore().collection("swipes").document(uid).updateData([
                item.pid: FieldValue.delete(),
            ]) { err in
                if let err = err {
                    print("Error updating document: \(err)")
                } else {
                    print("Document successfully updated")
                }
            }


            self.likedCards.remove(at: indexPath.row)
                    
            let viewController = UIApplication.shared.windows.first!.rootViewController as! HomeController
            
            viewController.updateLikedCards(tempLikes: self.likedCards)
            
      
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
    }


    }
        


}


