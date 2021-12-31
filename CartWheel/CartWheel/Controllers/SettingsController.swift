//
//  SettingsController.swift
//  CartWheel
//
//  Created by Richmond Aisabor on 7/8/21.
//

import UIKit
import Firebase
import JGProgressHUD
import SDWebImage
import SafariServices
import QuickTableViewController

protocol SettingsControllerDelegate {
    func didSaveSettings()
}

class CustomerImagePickerController: UIImagePickerController {
    
    var imageButton: UIButton?
    
}


private let reuseIdentifier = "SettingsCell"


final class SettingsController: QuickTableViewController {
  
    
    // MARK: - Properties
    
    // Profile Image View
    let profileImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.translatesAutoresizingMaskIntoConstraints = false
        var image: UIImage?
        var url: URL?
        url = Auth.auth().currentUser?.photoURL
        print(url as Any)
        if let imageData: NSData = NSData(contentsOf:  url!) {
            image = UIImage(data: imageData as Data)
            
        }
         
        iv.image = image?.circleMasked
        
        return iv
    }()
    //
    
    static let defaultAge = 18
    var settingDelegate: SettingsControllerDelegate?
    var window: UIWindow?

    
    // MARK: - Init
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    
        tableContents = [
             Section(title: "Profile", rows: [
                NavigationRow(text: (Auth.auth().currentUser?.displayName)!,  detailText: .subtitle((Auth.auth().currentUser?.email)!), icon: .image(profileImageView.image!))
             ], footer: ""),

            
            Section(title: "Donation", rows: [
                NavigationRow(text: "Patreon", detailText: .none, action: { [weak self] in self?.handleDonatePatreon($0) }),
                NavigationRow(text: "PayPal", detailText: .none, action: { [weak self] in self?.handleDonatePayPal($0) }),
            ], footer: ""),

            Section(title: "", rows: [
                NavigationRow(text: "Share CartWheel", detailText: .none, action: { [weak self] in self?.shareButton($0) }),
            ], footer: ""),
            
            Section(title: "", rows: [
                TapActionRow(text: "Logout", action: { [weak self] in self?.handleLogoutButton($0)})
            ]),
           ]

    }

    // MARK: - Helper Functions

    
    func configureUI() {

        
        navigationController?.navigationBar.barTintColor = UIColor.black
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navigationItem.title = "Settings"

    }
    
    func handleLogoutButton(_ sender: Row) {
           
           try? Auth.auth().signOut()
           let controller = HomeController()
        
           self.view.window?.makeKeyAndVisible()
      
           self.view.window?.rootViewController = controller
           self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
           
    }
    

    func handleDonatePatreon(_ sender: Row) {
       
       let url = URL(string: "https://www.patreon.com/richaisabor")
       let safariVC = SFSafariViewController(url: url!)
       present(safariVC, animated: true, completion: nil)
       
       print("Patreon Donates")
   }
    
    func handleDonatePayPal(_ sender: Row) {
       
       let url = URL(string: "https://paypal.me/richaisabor")
       let safariVC = SFSafariViewController(url: url!)
       present(safariVC, animated: true, completion: nil)
       
       print("PayPal Donates")
   }
    
    func shareButton(_ sender: Row) {

        let name = URL(string: "https://www.google.com")
        let vc = UIActivityViewController(activityItems: [name!], applicationActivities: nil)
        vc.popoverPresentationController?.sourceView = self.view

        self.present(vc, animated: true, completion: nil)
    }



}

extension UIImage {
    
    var isPortrait:  Bool    { return size.height > size.width }
    var isLandscape: Bool    { return size.width > size.height }
    var breadth:     CGFloat { return min(size.width, size.height) }
    var breadthSize: CGSize  { return CGSize(width: breadth, height: breadth) }
    var breadthRect: CGRect  { return CGRect(origin: .zero, size: breadthSize) }
    
    var circleMasked: UIImage? {
        UIGraphicsBeginImageContextWithOptions(breadthSize, false, scale)
        defer { UIGraphicsEndImageContext() }
        guard let cgImage = cgImage?.cropping(to: CGRect(origin: CGPoint(x: isLandscape ? floor((size.width - size.height) / 2) : 0, y: isPortrait  ? floor((size.height - size.width) / 2) : 0), size: breadthSize)) else { return nil }
        UIBezierPath(ovalIn: breadthRect).addClip()
        UIImage(cgImage: cgImage, scale: 1, orientation: imageOrientation).draw(in: breadthRect)
        
        
        return UIGraphicsGetImageFromCurrentImageContext()
    }
}


