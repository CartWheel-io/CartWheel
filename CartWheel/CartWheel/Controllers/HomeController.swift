//
//  HomeController.swift
//  CartWheel
//
//  Created by Richmond Aisabor on 6/30/21.
//

import UIKit
import Firebase
import FirebaseFirestore
import JGProgressHUD

class HomeController: UIViewController, SettingsControllerDelegate, CardViewDelegate, LoginControllerDelegate {
    
    func didSaveSettings() {
        fetchCurrentProduct()
    }
    
    let cardsDeckView   = UIView()
    let bottomControls = BottomNavigationStackView()
    let topStackView    = TopNavigationStackView()
       
    var cardViewModels = [CardViewModel]()
    public var likedCards = [Product]()
    

    override func viewDidLoad() {
          super.viewDidLoad()
          bottomControls.profileButton.addTarget(self, action: #selector(handleProfileButton), for: .touchUpInside)
          bottomControls.favoriteButton.addTarget(self, action: #selector(handleFavoriteButton), for: .touchUpInside)
          bottomControls.homeButton.addTarget(self, action: #selector(handleHomeButton), for: .touchUpInside)
          setupLayout()
      }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        
        if Auth.auth().currentUser == nil {
            
            let loginController = LoginController()
            loginController.isModalInPresentation = true
            loginController.loginDelegate = self
            let navigationController = UINavigationController(rootViewController: loginController)
            present(navigationController, animated: false, completion: nil)
        }
        
    }
    
    func didFinishLoggingIn() {
           
        cardsDeckView.subviews.forEach({$0.removeFromSuperview()})
        fetchCurrentUser()
        fetchProductsFromFirebase()
        fetchSwipes()
    }
    
    
    fileprivate var product: Product?
    
    fileprivate func fetchCurrentProduct() {
            
            cardsDeckView.subviews.forEach({$0.removeFromSuperview()})
            Firestore.firestore().fetchCurrentProduct { (product, error) in
                
                if let error = error {
                    print("Error, \(error)")
                    return
                }
                
                self.product = product
            
            }
}

    var swipes = [String: Any]()
    
    fileprivate func fetchSwipes() {
    
        guard let uid = Auth.auth().currentUser?.uid else { return }
    
        Firestore.firestore().collection("swipes").document(uid).getDocument { (snapshot, error) in
            
                if let error = error {
                    print("Error getting documents: \(error)")
                } else {
                    self.likedCards.removeAll()
                    guard let dictionary = snapshot?.data() else { return }
                    for swipe in dictionary {
                        self.likedCards.append(Product(dictionary: swipe.value as! [String : Any]))
                    }
                    
                }
    
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
                 
                changeRequest?.commitChanges { error in
                    if error != nil {
                          // An error happened.
                            print("error")
                        } else {
                          // Profile updated.
                            print("updated")
                            
                        }
                }
                 
        }
     
}
    
    fileprivate func fetchProductsFromFirebase() {
            

            let hud = JGProgressHUD(style: .dark)
            hud.textLabel.text = "Fetching Products"
            hud.show(in: view)
            
            let query = Firestore.firestore().collection("products")
 
            topCardView = nil
            
        query.getDocuments { (snapshot, error) in
                
                hud.dismiss()
                
                if let error = error {
                    print("Error: \(error)")
                    return
                }
                
                var prevoiusCardView: CardView?
            
                
                    snapshot?.documents.shuffled().forEach({ (documentSnapshot) in
                    
                    let productDictionary = documentSnapshot.data()
                    let product = Product(dictionary: productDictionary)
                    
                  
                    let hasSwipedBefore = true
             
                    if  hasSwipedBefore {
                        
                        let cardView = self.setupCardFromProduct(product: product)
                        
                        prevoiusCardView?.nextCardView = cardView
                        prevoiusCardView = cardView
                        
                        if self.topCardView == nil {
                            
                            self.topCardView = cardView
                        }
                    }
                })
            }
        
    }
    
    
    @objc func handleHomeButton() {
           
           cardsDeckView.subviews.forEach({$0.removeFromSuperview()})
           fetchProductsFromFirebase()
       }
    
    @objc fileprivate func handleProfileButton() {
                 let settingsController = SettingsController()
                 settingsController.settingDelegate = self
                 let navigationController = UINavigationController(rootViewController: settingsController)
                 present(navigationController, animated: true, completion: nil)
    
    }

    
    var topCardView: CardView?
    
    fileprivate func saveSwipeToFirestore(didLike: Int) {
           guard let uid = Auth.auth().currentUser?.uid else { return }
           
           guard let cardPID = topCardView?.cardViewModel.pid else { return }
        
           let tempDict = topCardView?.cardViewModel.toProduct()?.toDictionary()
        
           let tempProd = topCardView?.cardViewModel.toProduct()
        
           let documentData = [cardPID: tempDict!]
        
           Firestore.firestore().collection("swipes").document(uid).getDocument { (snapshot, err) in
               if let err = err {
                   print("Failed to fetch swipe document:", err)
                   return
               }
               
               if snapshot?.exists == true {
                Firestore.firestore().collection("swipes").document(uid).updateData(documentData) { (err) in
                       if let err = err {
                           print("Failed to save swipe data:", err)
                           return
                       }
                       
                       if didLike == 1 {
                        self.addtoFavorites(cardPID: cardPID, tempProd:tempProd!)
                       }
                   }
               } else {
                Firestore.firestore().collection("swipes").document(uid).setData(documentData ) { (err) in
                       if let err = err {
                           print("Failed to save swipe data:", err)
                           return
                       }
                       
                       if didLike == 1 {
                        self.addtoFavorites(cardPID: cardPID, tempProd: tempProd!)
                       }
                   }
               }
           }
       }
    
    fileprivate func addtoFavorites(cardPID: String, tempProd: Product) {
        
          guard let uid = Auth.auth().currentUser?.uid else { return }
      
            Firestore.firestore().collection("swipes").document(uid).getDocument { (snapshot, err) in
              if let err = err {
                  print("Failed to fetch document for user:", err)
                  return
              }
              
              guard let data = snapshot?.data() else { return }
              print(data)
              self.likedCards.append(tempProd)
              
            
          }
    }
    
    fileprivate func performSwipeAnimation(translation: CGFloat, angle: CGFloat) {
            
            let duration = 0.5
            let translationAnimation = CABasicAnimation(keyPath: "position.x")
            translationAnimation.toValue = translation
            translationAnimation.duration = duration
            translationAnimation.fillMode = .forwards
            translationAnimation.timingFunction = CAMediaTimingFunction(name: .easeOut)
            translationAnimation.isRemovedOnCompletion = false
            
            let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
            rotationAnimation.toValue = angle * CGFloat.pi / 180
            rotationAnimation.duration = duration
            
            let coardView = topCardView
            topCardView = coardView?.nextCardView
            
            CATransaction.setCompletionBlock {
                coardView?.removeFromSuperview()
            }
            
            coardView?.layer.add(translationAnimation, forKey: "translation")
            coardView?.layer.add(rotationAnimation, forKey: "rotation")
            
            CATransaction.commit()
        }
        
        fileprivate func setupCardFromProduct(product: Product) -> CardView {
            
            let cardView = CardView(frame: .zero)
            cardView.cardViewModel = product.toCardViewModel()
            cardView.cardViewDelegate = self
            cardsDeckView.addSubview(cardView)
            cardsDeckView.sendSubviewToBack(cardView)
            cardView.fillSuperview()
            
            return cardView
        }
    
    
       
       @objc func handleLikeButton() {
           saveSwipeToFirestore(didLike: 1)
           performSwipeAnimation(translation: 700, angle: 15)

       }
       
       @objc func handleDislikeButton() {
           
           performSwipeAnimation(translation: -700, angle: -10)
           
       }
    
    func didTapMoreInfo(cardViewModel: CardViewModel) {
        let productDetailsController = ProductDetailsController()
        productDetailsController.cardViewModel = cardViewModel
        present(productDetailsController, animated: true, completion: nil)
    }
    
    @objc fileprivate func handleFavoriteButton() {
        let favoriteController = FavoriteController()
        print("liked Cards count: ", self.likedCards.count)
        favoriteController.likedCards = self.likedCards
        let navigationController = UINavigationController(rootViewController: favoriteController)
         
        
        present(navigationController, animated: true, completion: nil)
        
        
       }
    
    func updateLikedCards(tempLikes: [Product]) {
        self.likedCards = tempLikes
    }

    
    
    func didRemoveCard(cardView: CardView) {
        self.topCardView?.removeFromSuperview()
        self.topCardView = self.topCardView?.nextCardView
    }
    
    
    //MARK: - Setup File Private Methods
        fileprivate func setupLayout() {
            
            view.backgroundColor = .black
            
            let overallStackView = UIStackView(arrangedSubviews: [topStackView, cardsDeckView, bottomControls])
            overallStackView.axis = .vertical
            view.addSubview(overallStackView)
            
            overallStackView.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.trailingAnchor)
            
            overallStackView.isLayoutMarginsRelativeArrangement = true
            overallStackView.layoutMargins = .init(top: 0, left: 12, bottom: 0, right: 12)
            
            overallStackView.bringSubviewToFront(cardsDeckView)
        }
    
    
    fileprivate func setupFirestoreProductCards() {
       
           cardViewModels.forEach { (cardViewModel) in
               
               let cardView = CardView(frame: .zero)
               cardView.cardViewModel = cardViewModel
               cardsDeckView.addSubview(cardView)
               cardView.fillSuperview()
           }
       }
    
    
}
