//
//  HomeController.swift
//  Indiewave
//
//  Created by Richmond Aisabor on 6/30/21.
//

import UIKit
import Firebase
import FirebaseFirestore
import JGProgressHUD

class HomeController: UIViewController, SettingsControllerDelegate,CardViewDelegate, LoginControllerDelegate {
    
    func didSaveSettings() {
        fetchCurrentProduct()
    }
    
    let cardsDeckView   = UIView()
    let bottomControls = BottomNavigationStackView()
       
    var cardViewModels = [CardViewModel]()
    var likedCards = [Product]()
    
    
    
    override func viewDidLoad() {
          super.viewDidLoad()
          
          
          bottomControls.profileButton.addTarget(self, action: #selector(handleProfileButton), for: .touchUpInside)
          bottomControls.favoriteButton.addTarget(self, action: #selector(handleFavoriteButton), for: .touchUpInside)
          bottomControls.homeButton.addTarget(self, action: #selector(handleHomeButton), for: .touchUpInside)
        setupLayout()
        fetchCurrentUser()
      }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        
        if Auth.auth().currentUser == nil {
            
            let registrationController = RegistrationController()
            registrationController.loginControllerDelegate = self
            let navigationController = UINavigationController(rootViewController: registrationController)
            present(navigationController, animated: true, completion: nil)
        }
    }
    
    func didFinishLoggingIn() {
           
           fetchCurrentProduct()
    }
    
    
    fileprivate var user: User?
    
    fileprivate func fetchCurrentUser() {
        
        Firestore.firestore().fetchCurrentUser { (user, error) in
            
            if let error = error {
                print("Error, \(error)")
                return
            }
            
        
            self.user = user
            
            self.fetchSwipes()
        }
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

    var swipes = [String: Int]()
    
    fileprivate func fetchSwipes() {
           
        guard let uid = Auth.auth().currentUser?.uid else { return }
        Firestore.firestore().collection("swipes").document(uid).getDocument { (snapshot, error) in
            if let error = error {
                   print("Failed to fetch swipes info for currently logged in user: ",error)
                   return
               }
               
               guard let data = snapshot?.data() as? [String: Int] else { return }
               self.swipes = data
               self.fetchProductsFromFirebase()
           }
       }
    
    
    fileprivate func fetchProductsFromFirebase() {
            
            //let minAge = user?.minSeekingAge ?? SettingsController.defaultMinSeekingAge
            //let maxAge = user?.maxSeekingAge ?? SettingsController.defaultMaxSeekingAge
            
            let hud = JGProgressHUD(style: .dark)
            hud.textLabel.text = "Fetching Products"
            hud.show(in: view)
            
            //let query = Firestore.firestore().collection("users").whereField("age", isGreaterThan: minAge - 1).whereField("age", isLessThan: maxAge + 1)
            let query = Firestore.firestore().collection("products")
            
            topCardView = nil
            
            query.getDocuments { (snapshot, error) in
                
                hud.dismiss()
                
                if let error = error {
                    print("Error: \(error)")
                    return
                }
                
                var prevoiusCardView: CardView?
                
                snapshot?.documents.forEach({ (documentSnapshot) in
                    
                    let productDictionary = documentSnapshot.data()
                    let product = Product(dictionary: productDictionary)
                    
                    //let isNotCurrentUser = user.uid != Auth.auth().currentUser?.uid
                    //let hasSwipedBefore = self.swipes[user.uid!] == nil
                    let hasSwipedBefore = true
                    //isNotCurrentUser &&
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
    
    
    @objc fileprivate func handleHomeButton() {
           
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
        
           let tempProd = topCardView?.cardViewModel.toProduct()
           
           let documentData = [cardPID: didLike]
           
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
                   Firestore.firestore().collection("swipes").document(uid).setData(documentData) { (err) in
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
           
           saveSwipeToFirestore(didLike: 0)
           performSwipeAnimation(translation: -700, angle: -10)
           
       }
    
    func didTapMoreInfo(cardViewModel: CardViewModel) {
        let userDetailsController = UserDetailsController()
        userDetailsController.cardViewModel = cardViewModel
        present(userDetailsController, animated: true, completion: nil)
    }
    
    @objc fileprivate func handleFavoriteButton() {
        let favoriteController = FavoriteController()
        favoriteController.likedCards = self.likedCards
        present(favoriteController, animated: true, completion: nil)
        
       }
    
    
    func didRemoveCard(cardView: CardView) {
        self.topCardView?.removeFromSuperview()
        self.topCardView = self.topCardView?.nextCardView
    }
    
    
    //MARK: - Setup File Private Methods
        fileprivate func setupLayout() {
            
            view.backgroundColor = .black
            
            let overallStackView = UIStackView(arrangedSubviews: [cardsDeckView, bottomControls])
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
