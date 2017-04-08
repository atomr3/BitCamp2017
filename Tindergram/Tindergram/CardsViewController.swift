//
//  CardsViewController.swift
//  Tindergram
//
//  Created by thomas on 3/31/15.
//  Copyright (c) 2015 thomas. All rights reserved.
//

import UIKit
// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}


class CardsViewController: UIViewController {
  
  struct Card {
    let cardView: CardView
    let swipeView: SwipeView
    let user: User
  }
  
  let frontCardTopMargin: CGFloat = 0
  let backCardTopMargin: CGFloat = 10
  
  @IBOutlet weak var cardStackView: UIView!
  
  @IBOutlet weak var nahButton: UIButton!
  @IBOutlet weak var yeahButton: UIButton!
  
  var backCard: Card?
  var frontCard: Card?
  
  var users: [User]?
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    navigationItem.titleView = UIImageView(image: UIImage(named: "nav-header"))
    let leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "profile-button"), style: .plain, target: self, action: #selector(CardsViewController.goToProfile(_:)))
    navigationItem.setLeftBarButton(leftBarButtonItem, animated: true)
    let rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "chat-header"), style: .plain, target: self, action: #selector(CardsViewController.goToMatches(_:)))
    navigationItem.setRightBarButton(rightBarButtonItem, animated: true)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    cardStackView.backgroundColor = UIColor.clear
    nahButton.setImage(UIImage(named: "nah-button-pressed"), for: .highlighted)
    yeahButton.setImage(UIImage(named: "yeah-button-pressed"), for: .highlighted)
    
    fetchUnviewedUsers({
      returnUsers in
      self.users = returnUsers
      
      if let card = self.popCard() {
        self.frontCard = card
        self.cardStackView.addSubview(self.frontCard!.swipeView)
      }
      
      if let card = self.popCard() {
        self.backCard = card
        self.backCard!.swipeView.frame = self.createCardFrame(self.backCardTopMargin)
        self.cardStackView.insertSubview(self.backCard!.swipeView, belowSubview: self.frontCard!.swipeView)
      }
    })
  }
  
  @IBAction func nahButtonPressed(_ sender: UIButton) {
    if let card = frontCard {
      card.swipeView.swipeDirection(.left)
    }
  }
  
  @IBAction func yeahButtonPressed(_ sender: UIButton) {
    if let card = frontCard {
      card.swipeView.swipeDirection(.right)
    }
  }
  
  func goToProfile(_ button: UIBarButtonItem) {
      pageController.goToPreviousVC()
  }
  
  func goToMatches(_ button: UIBarButtonItem) {
    pageController.goToNextVC()
  }

  fileprivate func createCardFrame(_ topMargin: CGFloat) -> CGRect {
    return CGRect(x: 0, y: topMargin, width: cardStackView.frame.width, height: cardStackView.frame.height)
  }
  
  fileprivate func createCard(_ user: User) -> Card {
    let cardView = CardView()
    
    cardView.name = user.name
    user.getPhoto({
      image in
      cardView.image = image
    })
    
    let swipeView = SwipeView(frame: createCardFrame(frontCardTopMargin))
    swipeView.delegate = self
    swipeView.innerView = cardView
    return Card(cardView: cardView, swipeView: swipeView, user: user)
  }
  
  fileprivate func popCard() -> Card? {
    if users != nil && users?.count > 0 {
      return createCard(users!.removeLast())
    }
    return nil
  }
  
  fileprivate func switchCards() {
    if let card = backCard {
      frontCard = card
      UIView.animate(withDuration: 0.2, animations: {
        self.frontCard!.swipeView.frame = self.createCardFrame(self.frontCardTopMargin)
      })
    }
    
    if let card = self.popCard() {
      backCard = card
      backCard!.swipeView.frame = createCardFrame(backCardTopMargin)
      cardStackView.insertSubview(backCard!.swipeView, belowSubview: frontCard!.swipeView)
    }
  }
  
}


// MARK: SwipeViewDelegate
extension CardsViewController: SwipeViewDelegate {
  
  func swipedLeft() {
    print("left")
    if let frontCard = frontCard {
      frontCard.swipeView.removeFromSuperview()
      saveSkip(frontCard.user)
      switchCards()
    }
  }
  
  func swipedRight() {
    print("right")
    if let frontCard = frontCard {
      frontCard.swipeView.removeFromSuperview()
      saveLike(frontCard.user)
      switchCards()
    }
  }
  
}
