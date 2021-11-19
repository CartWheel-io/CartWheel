//
//  LoginViewModel.swift
//  CartWheel
//
//  Created by Richmond Aisabor
//
import Firebase

class LoginViewModel {
    
    var isLogedIn = Bindable<Bool>()
    var isFormValid = Bindable<Bool>()
    
    var email: String? {
        didSet {
            checkFromValidity()
        }
    }
    
    var password: String? {
        didSet {
            checkFromValidity()
        }
    }
    
    
    fileprivate func checkFromValidity() {
        let isValid = email?.isEmpty == false && password?.isEmpty == false
        isFormValid.value = isValid
    }
    
    func performLogin(completion: @escaping (Error?) -> ()) {
        
        guard let email = email, let password = password else { return }
        isLogedIn.value = true
        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
            completion(error)
        }
        
  
       
    }
}

