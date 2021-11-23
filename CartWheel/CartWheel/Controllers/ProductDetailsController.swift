//
//  ProductDetailsController.swift
//  CartWheel
//
//  Created by Richmond Aisabor on 6/30/21.
//

import UIKit
import SafariServices

class ProductDetailsController: UIViewController, UIScrollViewDelegate {
    
    var radioURL: String = ""
    
    var cardViewModel: CardViewModel! {
        didSet {
            infoLabel.attributedText = cardViewModel.attributedString
            radioURL = cardViewModel.url
            infoLabel.adjustsFontSizeToFitWidth = true
            swipingPhotosController.cardViewModel = cardViewModel
        }
    }
    
    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.alwaysBounceVertical = true
        scrollView.contentInsetAdjustmentBehavior = .never
        scrollView.delegate = self

        return scrollView
    }()
    
    let swipingPhotosController = SwipePhotosController()
    
    
    let infoLabel: UILabel = {
        let label = UILabel()
        label.text = "User name 30\nDoctor\nSome bio text below"
        label.numberOfLines = 0
        return label
    }()
    
    let dismissButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "arrow").withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(handleDismissButton), for: .touchUpInside)
        return button
    }()
    
    let buyNowButton: UIButton = {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 100, height: 20))
        button.setTitle("Buy Now", for: .normal)
        button.setTitleColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), for: .normal)
        button.setTitleColor(#colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1), for: .disabled)
        button.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 13, weight: .heavy)
        button.heightAnchor.constraint(equalToConstant: 44).isActive = true

        button.clipsToBounds = true

        button.addTarget(self, action: #selector(handleBuyNowButton), for: .touchUpInside)
        return button
    }()
    
    
    fileprivate func createButton(image: UIImage, selector: Selector) -> UIButton {
        let button = UIButton(type: .system)
        button.setImage(image, for: .normal)
        button.imageView?.contentMode = .scaleAspectFill
        button.addTarget(self, action: selector, for: .touchUpInside)
        return button
    }
    

    
    @objc fileprivate func handleBuyNowButton() {
        
        let url = URL(string: radioURL)
        let safariVC = SFSafariViewController(url: url!)
        present(safariVC, animated: true, completion: nil)
    
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setupLayout()
        setupVisualBlurEffectView()
    }
    
    
    
    fileprivate func setupVisualBlurEffectView() {
        
        let blurEddect = UIBlurEffect(style: .regular)
        let visualEffectView = UIVisualEffectView(effect: blurEddect)
        
        view.addSubview(visualEffectView)
        visualEffectView.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: view.safeAreaLayoutGuide.topAnchor, trailing: view.trailingAnchor)
    }
    
    fileprivate func setupLayout() {
        
        view.addSubview(scrollView)
        scrollView.fillSuperview()
        
        let swipingView = swipingPhotosController.view!
        scrollView.addSubview(swipingView)
        
        scrollView.addSubview(infoLabel)
        
        
        infoLabel.anchor(top: swipingView.bottomAnchor, leading: scrollView.leadingAnchor, bottom: nil, trailing: scrollView.trailingAnchor, padding: .init(top: 16, left: 16, bottom: -16, right: -16), size: .init(width: UIScreen.screenWidth*0.75, height: UIScreen.screenHeight*0.15))
    
        
        scrollView.addSubview(dismissButton)
        dismissButton.anchor(top: swipingView.bottomAnchor, leading: nil, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: -25, left: 0, bottom: 0, right: -25), size: .init(width: 50, height: 50))

        scrollView.addSubview(buyNowButton)
        
        buyNowButton.frame.origin = CGPoint(x:self.view.frame.size.width/3, y: self.view.frame.size.height - buyNowButton.frame.size.height - 145)
        

        
    }
    
    fileprivate let extraSwipeHeight: CGFloat = 80
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        let swipingView = swipingPhotosController.view!
        swipingView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.width + extraSwipeHeight)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let changeY = -scrollView.contentOffset.y
        var width = view.frame.width + changeY * 2
        width = min(view.frame.width, width)
        
        let imageView = swipingPhotosController.view!
        imageView.frame = CGRect(x: min(0, -changeY), y: min(0, -changeY), width: width, height: width + extraSwipeHeight)
    }
    
    @objc fileprivate func handleDismissButton() {
        
        self.dismiss(animated: true, completion: nil)
    }
}
