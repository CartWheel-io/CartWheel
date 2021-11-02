//
//  SettingsController.swift
//  Indiewave
//
//  Created by Richmond Aisabor on 7/8/21.
//

import UIKit
import Firebase
import JGProgressHUD
import SDWebImage
import SafariServices

protocol SettingsControllerDelegate {
    func didSaveSettings()
}

class CustomerImagePickerController: UIImagePickerController {
    
    var imageButton: UIButton?
    
}


private let reuseIdentifier = "SettingsCell"


class SettingsController: UIViewController {
  
    
    // MARK: - Properties
    
    var tableView: UITableView!
    var userInfoHeader: UserInfoHeader!
    static let defaultAge = 18
    var settingDelegate: SettingsControllerDelegate?
    var window: UIWindow?
    
    // MARK: - Init
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        

    }

    // MARK: - Helper Functions
    
    func configureTableView() {
        tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 60
        
        tableView.register(SettingsCell.self, forCellReuseIdentifier: reuseIdentifier)
        view.addSubview(tableView)
        tableView.frame = view.frame
        
        let frame = CGRect(x: 0, y: 88, width: view.frame.width, height: 100)
        userInfoHeader = UserInfoHeader(frame: frame)
        tableView.tableHeaderView = userInfoHeader
        tableView.tableFooterView = UIView()

    }

    
    func configureUI() {
        configureTableView()
        
        //navigationController?.navigationBar.prefersLargeTitles = true
        //navigationController?.navigationBar.barStyle = .black
        navigationController?.navigationBar.barTintColor = UIColor.black
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navigationItem.title = "Settings"

    }

}

extension SettingsController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return SettingsSection.allCases.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        guard let section = SettingsSection(rawValue: section) else { return 0 }
        
        
        switch section {
        case .Social: return SocialOptions.allCases.count
        case .Communications: return CommunicationOptions.allCases.count
        default: return 0
        }
        
    }
    
    
    func fetchCurrentUser() {
             
             guard let uid = Auth.auth().currentUser?.uid else { return }
             Firestore.firestore().collection("users").document(uid).getDocument { (snapshot, error) in
                 
                 let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
                 // fetched our user here
                 guard let dictionary = snapshot?.data() else { return }
                 let user = User(dictionary: dictionary)
                 let url: URL = URL(string : (user.image)!)!
                 
                 changeRequest?.displayName = user.name
                 changeRequest?.photoURL = url
                 //print(self.user?.image as Any)
                
                 // let url: NSURL = NSURL(string : (self.user?.image)!)!
                //Now use image to create into NSData format
                //let imageData: NSData = NSData.init(contentsOf: url as URL)!
                
                //Auth.auth().currentUser?.photoURL = UIImage(data: imageData as Data)
                 
                changeRequest?.commitChanges { error in
                    if error != nil {
                          // An error happened.
                        } else {
                          // Profile updated.
                        }
                      }
                 
            
                 
             }
     
         
        }
 

    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = UIColor.black
        
        print("Section is \(section)")
        
        let title = UILabel()
        title.font = UIFont.boldSystemFont(ofSize: 16)
        title.textColor = .white
        title.text = SettingsSection(rawValue: section)?.description
        view.addSubview(title)
        title.translatesAutoresizingMaskIntoConstraints = false
        title.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        title.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16).isActive = true
        
        
        return view
    }
    


    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! SettingsCell
        guard let section = SettingsSection(rawValue: indexPath.section) else { return UITableViewCell() }
        
        
        switch section {
        case .Social:
            let social = SocialOptions(rawValue: indexPath.row)
            cell.sectionType = social
        case .Communications:
            let communications = CommunicationOptions(rawValue: indexPath.row)
            cell.sectionType = communications
            
            //return CommunicationsOptions.allCases.count
        }
        
        return cell
    }
    
    internal func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let social = SocialOptions(rawValue: indexPath.row)
        let section = SettingsSection(rawValue: indexPath.section)
        let communications = CommunicationOptions(rawValue: indexPath.row)
        
    switch section {
        case .Social:
            switch social {
                case .logOut:
                //print("Log Out")
                    handleLogoutButton()
            case .donate:
                //print("Donate")
                    handleDonationButton()
                default:
                    print("none")
            }
            
        case .Communications:
            switch communications {
            case .notifications:
                handleNotificationsButton()
            case .email:
                handleEmailButton()
            case .reportCrashes:
                handleReportCrashesButton()
                
            default:
                print("none")
            }
        case .none:
           print("none")
    }
        
    }
    
   
    
    func handleLogoutButton() {
           
           try? Auth.auth().signOut()
           let controller = HomeController()
        
           self.view.window?.makeKeyAndVisible()
      
           self.view.window?.rootViewController = controller
           self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
       
        /*
           if Auth.auth().currentUser == nil {
            
            let controller = HomeController()
            
            window?.makeKeyAndVisible()
          
            window?.rootViewController = controller
            
            //let topViewController = UIApplication.shared.keyWindow?.rootViewController
            
            //window?.rootViewController.present(controller, animated: true, completion: nil)
     
        
        }
      */
           
    }
    
     func handleDonationButton() {
        
        let url = URL(string: "https://www.patreon.com/richaisabor")
        let safariVC = SFSafariViewController(url: url!)
        present(safariVC, animated: true, completion: nil)
        
        print("Donates")
    }
    
    func handleNotificationsButton() {
        
        let alert = UIAlertController(title: "Ooops!", message: "The Notifications Button May Need Service", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
        NSLog("The \"OK\" alert occured.")
        }))
        
        self.present(alert, animated: true, completion: nil)
        
        print("notification")
        
    }
    
    func handleEmailButton() {
        let alert = UIAlertController(title: "Ooops!", message: "The Email Button May Need Service", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
        NSLog("The \"OK\" alert occured.")
        }))
        
        self.present(alert, animated: true, completion: nil)
        
        print("email")
    }
    
    func handleReportCrashesButton() {
        let alert = UIAlertController(title: "Ooops!", message: "The Report Crashes Button May Need Service", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
        NSLog("The \"OK\" alert occured.")
        }))
        
        self.present(alert, animated: true, completion: nil)
        
        print("report Crashes")
    }
}
