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

/*
 class SettingsController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var settingDelegate: SettingsControllerDelegate?
    
    lazy var image1Button = createButton(selector: #selector(handleSelectPhoto))
    lazy var image2Button = createButton(selector: #selector(handleSelectPhoto))
    lazy var image3Button = createButton(selector: #selector(handleSelectPhoto))
    
    @objc func handleSelectPhoto(button: UIButton) {
        
        let imagePickerController = CustomerImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.imageButton = button
        present(imagePickerController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        let selectedImage = info[.originalImage] as? UIImage
        let imageButton = (picker as? CustomerImagePickerController)?.imageButton
        imageButton?.setImage(selectedImage?.withRenderingMode(.alwaysOriginal), for: .normal)
        
        let fileName = UUID().uuidString
        let reference = Storage.storage().reference(withPath: "/images/\(fileName)")
        guard let uploadDate = selectedImage?.jpegData(compressionQuality: 0.75) else { return }
        
        let hud = JGProgressHUD(style: .dark)
        hud.textLabel.text = "Uploading image..."
        hud.show(in: view)
        reference.putData(uploadDate, metadata: nil) { (nil, error) in
            
            if let error = error {
                
                hud.dismiss()
                print("Failed to upload to Storage: \(error)")
                return
            }
            
            reference.downloadURL(completion: { (url, error) in
                
                hud.dismiss()
                
                if let error = error {
                    
                    print("Failed to retrieve download url: \(error)")
                    return
                }
                
                if imageButton == self.image1Button {
                    
                    self.user?.image = url?.absoluteString
                }
                    
            })
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    func createButton(selector: Selector) -> UIButton {
        
        let button = UIButton(type: .system)
        button.setTitle("Select Photo", for: .normal)
        button.backgroundColor = .white
        button.layer.cornerRadius = 8
        button.clipsToBounds = true
        button.imageView?.contentMode = .scaleAspectFill
        button.addTarget(self, action: selector, for: .touchUpInside)
        return button
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationItems()
        setupTapGesture()
        tableView.backgroundColor = UIColor(white: 0.95, alpha: 1)
        tableView.tableFooterView = UIView()
        tableView.keyboardDismissMode = .none
        
        fetchCurrentUser()
    }
    
    var user: User?
    
    fileprivate func fetchCurrentUser() {
        
        Firestore.firestore().fetchCurrentUser { (user, error) in
            if let error = error {
                print("Failed to fetch user:", error)
                return
            }
            self.user = user
            
            self.tableView.reloadData()
        }
    }
    lazy var headerView: UIView = {
        
        let headerView = UIView()
        headerView.addSubview(image1Button)
        let padding: CGFloat = 16
        image1Button.anchor(top: headerView.topAnchor, leading: headerView.leadingAnchor, bottom: headerView.bottomAnchor, trailing: nil, padding: .init(top: padding, left: padding, bottom: -padding, right: 0))
        image1Button.widthAnchor.constraint(equalTo: headerView.widthAnchor, multiplier: 0.45).isActive = true
        
        let stackView = UIStackView(arrangedSubviews: [image2Button, image3Button])
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = padding
        
        headerView.addSubview(stackView)
        stackView.anchor(top: headerView.topAnchor, leading: image1Button.trailingAnchor, bottom: headerView.bottomAnchor, trailing: headerView.trailingAnchor, padding: .init(top: padding, left: padding, bottom: -padding, right: -padding))
        return headerView
    }()
    
    class HeaderLabel: UILabel {
        
        override func drawText(in rect: CGRect) {
            super.drawText(in: rect.insetBy(dx: 16, dy: 0))
        }
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    
        if section == 0 {
            
            return headerView
            
        } else {
            
            let headerLabel = HeaderLabel()
            switch section {
            case 1:
                headerLabel.text = "Name"
                break
            case 2:
                headerLabel.text = "Gender"
                break
            case 3:
                headerLabel.text = "Age"
                break
            case 4:
                headerLabel.text = "Bio"
                break
            default:
                break
            }
            headerLabel.font = UIFont.boldSystemFont(ofSize: 14)
            return headerLabel
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        if section == 0 {
            
            return 300
            
        } else {
            
            return 40
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 6
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return section == 0 ? 0 : 1
    }
    
    static let defaultAge = 18
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
    let cell = SettingsCell(style: .default, reuseIdentifier: nil)
      switch indexPath.section {
         case 1:
              cell.textField.placeholder = "Enter Name"
              cell.textField.text = user?.name
              cell.textField.addTarget(self, action: #selector(handleNameChange), for: .editingChanged)
              break
          case 2:
              cell.textField.placeholder = "Enter Gender"
              cell.textField.text = user?.gender
              cell.textField.addTarget(self, action: #selector(handleGenderChange), for: .editingChanged)
            break
        case 3:
            cell.textField.placeholder = "Enter Age"
            if let age = user?.age {
                cell.textField.text = String(age)
            }
            cell.textField.addTarget(self, action: #selector(handleAgeChange), for: .editingChanged)
            break
       default:
            cell.textField.placeholder = "Enter Bio"
            break
        }
        return cell
    }
    
   
  @objc fileprivate func handleNameChange(textField: UITextField) {
        textField.isSecureTextEntry = true
        self.user?.name = textField.text
    }
    
    @objc fileprivate func handleGenderChange(textField: UITextField) {
        textField.isSecureTextEntry = true
        self.user?.gender = textField.text
    }
    
    @objc fileprivate func handleAgeChange(textField: UITextField) {
        textField.keyboardType = .default
        self.user?.age = Int(textField.text ?? "")
    }
    
    fileprivate func setupNavigationItems() {
        
        navigationItem.title = "Settings"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancelButton))
        navigationItem.rightBarButtonItems = [UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(handleSaveButton)), UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(handleLogoutButton))]
    }
    
    fileprivate func setupTapGesture() {
        
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap)))
    }
    
    @objc fileprivate func handleTap() {
        
        self.view.endEditing(true)
    }
    @objc fileprivate func handleCancelButton() {
        
        dismiss(animated: true, completion: nil)
    }
    
    @objc fileprivate func handleSaveButton() {
        
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        let documentData: [String : Any] = [
            "uid": uid,
            "fullName": user?.name ?? "",
            "imageUrl1": user?.image ?? "",
            "gender": user?.gender ?? "",
            "age": user?.age ?? -1
            //"minSeekingAge": user?.minSeekingAge ?? -1,
            //"maxSeekingAge": user?.maxSeekingAge ?? -1
            ]
        
        let hud = JGProgressHUD(style: .dark)
        hud.textLabel.text = "Saving settings"
        hud.show(in: view)
        
        Firestore.firestore().collection("users").document(uid).setData(documentData) { (error) in
            
            hud.dismiss()
            
            if let error = error {
                print("Failed to save user setting: \(error)")
                return
            }
            
            self.dismiss(animated: true, completion: {
                print("Dismissal complete")
                self.settingDelegate?.didSaveSettings()
            })
        }
    }
    
    @objc fileprivate func handleLogoutButton() {
           
           try? Auth.auth().signOut()
           dismiss(animated: true)
       }
    
}
 */


//
//  ViewController.swift
//  SettingsTemplate
//
//  Created by Stephen Dowless on 2/10/19.
//  Copyright © 2019 Stephan Dowless. All rights reserved.
//


private let reuseIdentifier = "SettingsCell"


class SettingsController: UIViewController {
  
    
    // MARK: - Properties
    
    var tableView: UITableView!
    var userInfoHeader: UserInfoHeader!
    static let defaultAge = 18
    var settingDelegate: SettingsControllerDelegate?
    var user: User?
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
        userInfoHeader.usernameLabel.text = self.user?.name
        print(user?.name as Any)
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
             
           
             // fetched our user here
             guard let dictionary = snapshot?.data() else { return }
             self.user = User(dictionary: dictionary)
             self.userInfoHeader.usernameLabel.text = self.user?.name
             //print(self.user?.image as Any)
            
            let url: NSURL = NSURL(string : (self.user?.image)!)!
            //Now use image to create into NSData format
            let imageData: NSData = NSData.init(contentsOf: url as URL)!
            
            self.userInfoHeader.profileImageView.image = UIImage(data: imageData as Data)
             
             
        
             
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

    
