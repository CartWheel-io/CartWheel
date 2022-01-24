//
//  CardView.swift
//  CartWheel
//
//  Created by Richmond Aisabor on 6/30/21.
//

import UIKit
import SDWebImage

protocol CardViewDelegate {
    
    func didTapMoreInfo(cardViewModel: CardViewModel)
    func didRemoveCard(cardView: CardView)
}

class CardView: UIView {
    
    var nextCardView: CardView?
    
    var cardViewDelegate: CardViewDelegate?
    
    var cardViewModel: CardViewModel! {
        
        didSet {
            
            swipingPhotosController.cardViewModel = self.cardViewModel
            
            informationLabel.attributedText = cardViewModel.attributedName
            informationLabel.font = informationLabel.font.withSize(18)
            informationLabel.textAlignment = cardViewModel.textAlignment
            
        }
    }
    
    fileprivate let swipingPhotosController = SwipePhotosController(isCardViewMode: true)
    fileprivate let informationLabel = UILabel()
    let gradientLayer = CAGradientLayer()
    
    var xCenter: CGFloat = 0.0
    var yCenter: CGFloat = 0.0
    var originalPoint = CGPoint.zero
    
    let theresoldMargin = (UIScreen.main.bounds.size.width/2) * 0.75
    let stength : CGFloat = 5
    let range : CGFloat = 0.90
    
    var containerView : UIView!
    
    var LikeImageView : UIImageView = {
            let imageView = UIImageView()
            imageView.alpha = 0
            return imageView
        }()
    
    var DislikeImageView : UIImageView = {
            let imageView = UIImageView()
            imageView.alpha = 0
            return imageView
        }()
        
        
        var overlayImageView : UIImageView = {
            let imageView = UIImageView()
            imageView.alpha = 0
            return imageView
        }()
    
    
    // Configuration
    fileprivate let treshold: CGFloat = 120
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupLayout()
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan(gesture:)))
        addGestureRecognizer(panGesture)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(gesture:)))
        addGestureRecognizer(tapGesture)
    }
    
    fileprivate let moreInfoButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "info_icon").withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(handelMoreInfoButton), for: .touchUpInside)
        return button
    }()
    
    @objc fileprivate func handelMoreInfoButton() {
        
        // Use delegate
        cardViewDelegate?.didTapMoreInfo(cardViewModel: self.cardViewModel)
    }
    
    fileprivate func setupLayout() {
        
        layer.cornerRadius = 10
        clipsToBounds = true
        
        let swipingPhotosView = swipingPhotosController.view!
        addSubview(swipingPhotosView)
        swipingPhotosView.fillSuperview()
        
        // Add gradian layer
        setupGradianLayer()
        
        containerView = UIView(frame: bounds)
        containerView.backgroundColor = .clear
               
        LikeImageView = UIImageView(frame: CGRect(x: (frame.size.width + 25), y: 50, width: 120, height: 120))
        
        DislikeImageView = UIImageView(frame: CGRect(x: (frame.size.width + 270), y: 50, width: 120, height: 120))
        containerView.addSubview(DislikeImageView)
               
        
        addSubview(informationLabel)
        informationLabel.textColor = .white
        informationLabel.numberOfLines = 0
        
        informationLabel.anchor(top: nil, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, padding: .init(top: 0, left: 5, bottom: -40, right: 0))
        
        addSubview(moreInfoButton)
        moreInfoButton.anchor(top: nil, leading: nil, bottom: bottomAnchor, trailing: trailingAnchor, padding: .init(top: 0, left: 0, bottom: -5, right: -16), size: .init(width: 44, height: 44))
    }
    
    fileprivate func setupGradianLayer() {
        
        gradientLayer.colors = [UIColor.clear.cgColor, UIColor.black.cgColor]
        gradientLayer.locations = [0.5, 1.1]
        
        layer.addSublayer(gradientLayer)
    }
    
    override func layoutSubviews() {
        
        gradientLayer.frame = self.frame
        
    }
    
    fileprivate let barDeselectedColor = UIColor(white: 0, alpha: 0.1)
    
    @objc fileprivate func handleTap(gesture: UITapGestureRecognizer) {
        
        
        let tapLocation = gesture.location(in: nil)
        let shouldAdvanceNextPhoto = tapLocation.x > frame.width / 2 ? true : false
        
        if shouldAdvanceNextPhoto {
            
            cardViewModel.advaceToNextPhoto()
        } else {
            
            cardViewModel.goToPreviousPhoto()
        }
    }

    @objc fileprivate func handlePan(gesture: UIPanGestureRecognizer) {
        
        
        switch gesture.state {
        case .began:
            superview?.subviews.forEach({ (subview) in
                subview.layer.removeAllAnimations()
            })
            addSubview(containerView)
        case .changed:
            handleChanged(gesture)
        case .ended:
            handleEnded(gesture)
        default:
            ()
        }
    }
    
    fileprivate func handleChanged(_ gesture: UIPanGestureRecognizer) {
        
        
        xCenter = gesture.translation(in: self).x
        yCenter = gesture.translation(in: self).y
        
        // Rotation
        let translation = gesture.translation(in: nil)
        let degrees: CGFloat = translation.x / 20
        let angle = degrees * .pi / 180
       
        
        let rotationalTransformation = CGAffineTransform(rotationAngle: angle)
        self.transform = rotationalTransformation.translatedBy(x: translation.x, y: translation.y)
        updateOverlay(xCenter)
    }
    
    fileprivate func handleEnded(_ gesture: UIPanGestureRecognizer) {
        self.containerView.removeFromSuperview()
        let translationDirection: CGFloat = gesture.translation(in: nil).x > 0 ? 1 : -1
        let shouldDismissCard = gesture.translation(in: nil).x > treshold || gesture.translation(in: nil).x < -treshold
        
        if shouldDismissCard {
            guard let homeController = self.cardViewDelegate as? HomeController else { return }
            if translationDirection == 1 {
                homeController.handleLikeButton()
            } else {
                homeController.handleDislikeButton()
                
               
            }
        } else{
            UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.1, options: .curveEaseOut, animations: {
                self.transform = .identity
            })
        }
    }
    
        /*
         * Updating overlay methods
         */
        fileprivate func updateOverlay(_ distance: CGFloat) {
            
            if(distance > 0){
                containerView.addSubview(LikeImageView)
                DislikeImageView.removeFromSuperview()
                LikeImageView.image = makeImage(name: "star")!.image
                LikeImageView.alpha = min(abs(distance) / 100, 0.8)
            }else {
                containerView.addSubview(DislikeImageView)
                LikeImageView.removeFromSuperview()
                DislikeImageView.image = makeImage(name: "trash")!.image
                DislikeImageView.alpha = min(abs(distance) / 100, 0.8)
            }
            
            //overlayImageView.image = makeImage(name:  distance > 0 ? "overlay_like" : "overlay_skip")
            
            
            
            //overlayImageView.image = makeImage(name:  distance > 0 ? "overlay_like" : "overlay_skip")
            
            //overlayImageView.alpha = min(abs(distance) / 100, 0.8)
            //delegate?.currentCardStatus(card: self, distance: distance)
        }
    
    /*
     * Acessing image from bundle
     */
    
    fileprivate func makeImage(name: String) -> UIImageView? {
        let image: UIImageView?
        
        
        if(name == "star") {
            image = UIImageView(image: #imageLiteral(resourceName: "star_icon"))
            print("star")
        }else {
            image = UIImageView(image: #imageLiteral(resourceName: "trash_icon"))
            print("trash")
        }
           
        return image
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
