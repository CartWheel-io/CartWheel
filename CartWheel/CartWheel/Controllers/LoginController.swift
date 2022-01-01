//
//  User.swift
//  CartWheel
//
//  Created by Richmond Aisabor on 7/1/21.
//


import UIKit
import JGProgressHUD
import FirebaseAuth
import AuthenticationServices

protocol LoginControllerDelegate {
    func didFinishLoggingIn()
}

class LoginController: UIViewController {
    

    var registrationDelegate: RegistrationControllerDelegate?
    var loginDelegate: LoginControllerDelegate?
    
    let fireImageView = UIImageView(image: #imageLiteral(resourceName: "login_icon-"))
    
    
    let emailTextField: UITextField = {
        let textField = CustomTextField(padding: 22, height: 44)
        textField.placeholder = "Enter email"
        textField.keyboardType = .emailAddress
        textField.addTarget(self, action: #selector(handleTextField), for: .editingChanged)
        return textField
    }()
    
    let passwordTextField: UITextField = {
        let textField = CustomTextField(padding: 22, height: 44)
        textField.placeholder = "Enter password"
        textField.isSecureTextEntry = true
        textField.addTarget(self, action: #selector(handleTextField), for: .editingChanged)
        return textField
    }()
    
    let loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Login", for: .normal)
        button.setTitleColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), for: .normal)
        button.setTitleColor(#colorLiteral(red: 0.3459398746, green: 0.340980351, blue: 0.3452142477, alpha: 1), for: .disabled)
        button.backgroundColor = #colorLiteral(red: 0.6714041233, green: 0.6664924026, blue: 0.6706650853, alpha: 1)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .heavy)
        button.isEnabled = false
        button.heightAnchor.constraint(equalToConstant: 44).isActive = true
        button.layer.cornerRadius = 22
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(handleLoginButton), for: .touchUpInside)
        
        return button
    }()
    
    fileprivate let backToRegisterButton: UIButton = {
        let button = UIButton()
        button.setTitle("Register", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.addTarget(self, action: #selector(handleBackButton), for: .touchUpInside)
        return button
    }()
    
    fileprivate let setupAppleSignInButton: UIButton = {
     
        let customAppleLoginBtn = UIButton()
            customAppleLoginBtn.layer.borderWidth = 2.0
            customAppleLoginBtn.backgroundColor = UIColor.white
            customAppleLoginBtn.layer.borderColor = UIColor.black.cgColor
            customAppleLoginBtn.setTitle("Sign in with Apple", for: .normal)
            customAppleLoginBtn.setTitleColor(UIColor.black, for: .normal)
            customAppleLoginBtn.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
            customAppleLoginBtn.setImage(UIImageView(image: #imageLiteral(resourceName: "apple_icon")).image, for: .normal)
            customAppleLoginBtn.imageEdgeInsets = UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 12)
            customAppleLoginBtn.addTarget(self, action: #selector(actionHandleAppleSignin), for: .touchUpInside)
      
        return customAppleLoginBtn
        
    }()
    
    fileprivate let loginViewModel = LoginViewModel()
    fileprivate let loginHUD = JGProgressHUD(style: .dark)
    
    
    fileprivate func setupTapGesture() {
        
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap)))
    }
    
    @objc fileprivate func handleTap() {
        
        self.view.endEditing(true)
    }
    
    @objc fileprivate func handleTextField(textField: UITextField) {
        
        if textField == emailTextField {
            
            loginViewModel.email = textField.text
        } else {
            loginViewModel.password = textField.text
        }
    }
    
    @objc fileprivate func handleLoginButton() {
        
        loginViewModel.performLogin { (error) in
        //loginHUD.dismiss()
            if let error = error {
                self.showHUDWithError(error: error)
                return
            }
            
            self.dismiss(animated: true, completion: {
                self.loginDelegate?.didFinishLoggingIn()
            })
        }
    }
    
    
    
    fileprivate func showHUDWithError(error: Error) {
        
        loginHUD.dismiss(animated: true)
        let hud = JGProgressHUD(style: .dark)
        hud.textLabel.text = "Failed login"
        hud.detailTextLabel.text = error.localizedDescription
        hud.show(in: self.view)
        hud.dismiss(afterDelay: 4)
    }

    
    @objc fileprivate func handleBackButton() {
        
        let registerController = RegistrationController()
        registerController.registerDelegate = registrationDelegate
        navigationController?.pushViewController(registerController, animated: true)
    }
    
    lazy var verticalStackView: UIStackView = {
        
        let stacView = UIStackView(arrangedSubviews: [
            emailTextField,
            passwordTextField,
            loginButton,
            setupAppleSignInButton
       
            ])
        stacView.axis = .vertical
        stacView.spacing = 24
        return stacView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
    
          setupGradientLayer()
          setupLayout()
          setupTapGesture()
          setupBindables()
        
       
    }

    
    fileprivate func setupBindables() {
        loginViewModel.isFormValid.bind { [unowned self] (isFormValid) in
            
            guard let ifFormValid = isFormValid else { return }
            self.loginButton.isEnabled = ifFormValid
            self.loginButton.backgroundColor = ifFormValid ? #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1) : .lightGray
        }
        
        loginViewModel.isLogedIn.bind { [unowned self] (isRegistering) in
            
            if isRegistering == true {
                self.loginHUD.textLabel.text = "Logging in..."
                self.loginHUD.show(in: self.view)
            } else {
                self.loginHUD.dismiss()
            }
        }
    }
    
    let gradientLayer = CAGradientLayer()
    
    fileprivate func setupGradientLayer() {
        
        let topColor    = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        let bottomColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        
        gradientLayer.colors = [topColor.cgColor, bottomColor.cgColor]
        gradientLayer.locations = [0, 1]
        
        view.layer.addSublayer(gradientLayer)
        
        gradientLayer.frame = view.bounds
    }
    
    
    
    @objc func actionHandleAppleSignin()
    {
                
         let appleIDProvider = ASAuthorizationAppleIDProvider()
         
         let request = appleIDProvider.createRequest()
         request.requestedScopes = [.fullName, .email]
         
         let authorizationController = ASAuthorizationController(authorizationRequests: [request])
         authorizationController.delegate = self
         authorizationController.presentationContextProvider = self
         authorizationController.performRequests()
    }
    

    fileprivate func setupLayout() {
        
        navigationController?.isNavigationBarHidden = true
        view.addSubview(fireImageView)
        fireImageView.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing:
        view.trailingAnchor, padding: .init(top: 150, left: 50, bottom: 0, right: -50))
    

        view.addSubview(verticalStackView)
        verticalStackView.anchor(top: nil, leading: view.leadingAnchor, bottom: nil, trailing:
        view.trailingAnchor, padding: .init(top: 0, left: 50, bottom: 0, right: -50))
        
        verticalStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        view.addSubview(backToRegisterButton)
        backToRegisterButton.anchor(top: nil, leading: view.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.trailingAnchor)
    }
}
extension LoginController : ASAuthorizationControllerDelegate {
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: Error){
        print("failed!")
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization)
    {
        switch authorization.credential {
            
        case let credentials as ASAuthorizationAppleIDCredential:
            let firstName = credentials.fullName?.givenName
            let lastName = credentials.fullName?.familyName
            let email = credentials.email
            break
            
        default:
            break
        }
    }
 
}

extension LoginController : ASAuthorizationControllerPresentationContextProviding
{
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor
    {
        return view.window!
    }
}
