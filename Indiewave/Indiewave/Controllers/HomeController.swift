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

class HomeController: UIViewController, CardViewDelegate {
    
    
    let cardsDeckView   = UIView()
    let bottomControls = BottomNavigationStackView()
       
    var cardViewModels = [CardViewModel]()
    
    override func viewDidLoad() {
          super.viewDidLoad()
          
          
          bottomControls.profileButton.addTarget(self, action: #selector(handleProfileButton), for: .touchUpInside)
          bottomControls.favoriteButton.addTarget(self, action: #selector(handleLikeButton), for: .touchUpInside)
          bottomControls.homeButton.addTarget(self, action: #selector(handleHomeButton), for: .touchUpInside)
        setupLayout()
        //fetchCurrentUser()
      }
    var swipes = [String: Int]()
    
    fileprivate func fetchSwipes() {
           
          // guard let uid = Auth.auth().currentUser?.uid else { return }
           Firestore.firestore().collection("test1").document("HLt9Uzji33OxILAsnh6F").getDocument { (snapshot, error) in
               if let error = error {
                   print("Failed to fetch sipes info for currently logged in user: ",error)
                   return
               }
               
               guard let data = snapshot?.data() as? [String: Int] else { return }
               self.swipes = data
               //self.fetchUsersFromFirebase()
           }
       }
    
    
    @objc fileprivate func handleHomeButton() {
           
           cardsDeckView.subviews.forEach({$0.removeFromSuperview()})
           //fetchUsersFromFirebase()
       }
    
    @objc fileprivate func handleProfileButton() {
           
           //let settingsController = SettingsController()
          // settingsController.settingDelegate = self
          // let navigationController = UINavigationController(rootViewController: settingsController)
         // present(navigationController, animated: true, completion: nil)
           
       }
    
    var topCardView: CardView?
    
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
    
    
    //var topCardView: CardView?
       
       @objc func handleLikeButton() {
           
           //saveSwipeToFirestore(didLike: 1)
           performSwipeAnimation(translation: 700, angle: 15)

       }
       
       @objc func handleDislikeButton() {
           
           //saveSwipeToFirestore(didLike: 0)
           performSwipeAnimation(translation: -700, angle: -10)
           
       }
    
    func didTapMoreInfo(cardViewModel: CardViewModel) {
        //let userDetailsController = UserDetailsController()
        //userDetailsController.cardViewModel = cardViewModel
        //present(userDetailsController, animated: true, completion: nil)
    }
    
    func didRemoveCard(cardView: CardView) {
        self.topCardView?.removeFromSuperview()
        self.topCardView = self.topCardView?.nextCardView
    }
    
    
    fileprivate func setupFirestoreUserCards() {
       
           cardViewModels.forEach { (cardViewModel) in
               
               let cardView = CardView(frame: .zero)
               cardView.cardViewModel = cardViewModel
               cardsDeckView.addSubview(cardView)
               cardView.fillSuperview()
           }
       }
    
    //MARK: - Setup File Private Methods
        fileprivate func setupLayout() {
            
            view.backgroundColor = .white
            
            let overallStackView = UIStackView(arrangedSubviews: [cardsDeckView, bottomControls])
            overallStackView.axis = .vertical
            view.addSubview(overallStackView)
            
            overallStackView.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.trailingAnchor)
            
            overallStackView.isLayoutMarginsRelativeArrangement = true
            overallStackView.layoutMargins = .init(top: 0, left: 12, bottom: 0, right: 12)
            
            overallStackView.bringSubviewToFront(cardsDeckView)
        }
    
}
