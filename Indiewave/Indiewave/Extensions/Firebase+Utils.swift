//
//  Firebase+Utils.swift
//  Indiewave
//
//  Created by Richmond Aisabor on 6/30/21.
//

import Firebase

extension Firestore {
    
    func fetchCurrentProduct(completion: @escaping (Product?, Error?) -> ()) {
        
        //guard let uid = Auth.auth().currentUser?.uid else { return }
        Firestore.firestore().collection("products").document("05K3R8SddCSCgKsBcQe").getDocument { (snapshot, error) in
            
            if let error = error {
                completion(nil, error)
                return
            }
            
            // fetched our user here
            guard let dictionary = snapshot?.data() else { return }
            let product = Product(dictionary: dictionary)
            completion(product, nil)
        }
    }
    
    
    func fetchCurrentUser(completion: @escaping (User?, Error?) -> ()) {
        
        //guard let uid = Auth.auth().currentUser?.uid else { return }
        Firestore.firestore().collection("test").document("6VG6H509P6gGfnZNtF7M").getDocument { (snapshot, error) in
            
            if let error = error {
                completion(nil, error)
                return
            }
            
            // fetched our user here
            guard let dictionary = snapshot?.data() else { return }
            let user = User(dictionary: dictionary)
            completion(user, nil)
        }
    }
}

