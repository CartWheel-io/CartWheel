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
    
        

        // Uncomment the following line to preserve selection between presentations
         self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
         //self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        
        self.navigationController?.navigationBar.barTintColor = UIColor.black
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        title = "Favorites"
        
        // Register Class
        tableView.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: reuseIdentifier)
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

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.likedCards.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let item = self.likedCards[indexPath.row]
        
            let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)
            let button : UIButton = UIButton(type: UIButton.ButtonType.custom) as UIButton
            radioURL = item.url!
            button.frame = CGRect(x: 120, y: 62, width: 175, height: 15)
            button.setTitleColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), for: .normal)
            button.setTitleColor(#colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1), for: .disabled)
            button.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 11, weight: .heavy)
            button.heightAnchor.constraint(equalToConstant: 44).isActive = true
            button.addTarget(self, action: #selector(handleBuyNowButton), for: .touchUpInside)
            button.setTitle("Buy Now", for: .normal)

            //Remove all subviews so the button isn't added twice when reusing the cell.
            for view: UIView in cell.contentView.subviews {
                view.removeFromSuperview()
            }
            cell.contentView.addSubview(button)
        
            cell.textLabel?.numberOfLines = 2
            cell.textLabel?.lineBreakMode = .byWordWrapping
            cell.textLabel?.adjustsFontSizeToFitWidth = true
            // Configure Table View Cell
            cell.textLabel?.text = item.name
            let url = URL(string: item.imageURL1!)
            let data = try? Data(contentsOf: url!)
            cell.imageView!.image = UIImage(data: data!)
        
        return cell
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
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
