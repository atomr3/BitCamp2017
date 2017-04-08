//
//  SwipeView.swift
//  Tindergram
//
//  Created by thomas on 3/31/15.
//  Copyright (c) 2015 thomas. All rights reserved.
//

import Foundation
import UIKit

protocol SwipeViewDelegate: class {
  func swipedLeft()
  func swipedRight()
}

class SwipeView: UIView {
  
  enum Direction {
    case none
    case right
    case left
  }
  
  weak var delegate: SwipeViewDelegate?
  
  let overlay: UIImageView = UIImageView()
  var direction: Direction?
  
  var innerView: UIView? {
    didSet {
      if let v = innerView {
        insertSubview(v, belowSubview: overlay)
        v.frame = CGRect(x: 0, y: 0, width: frame.width, height: frame.height)
      }
    }
  }
  
  fileprivate var originalPoint: CGPoint?
  
  required init(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    initialize()
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    initialize()
  }
  
  fileprivate func initialize() {
    backgroundColor = UIColor.clear
    
    addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(SwipeView.dragged(_:))))
    
    overlay.frame = CGRect(x: 0, y: 0, width: frame.width, height: frame.height)
    addSubview(overlay)
  }
  
  func dragged(_ gestureRecognizer: UIPanGestureRecognizer) {
    let distance = gestureRecognizer.translation(in: self)
    
    switch gestureRecognizer.state {
    
    case .began:
      originalPoint = center
    
    case .changed:
      let rotationPercentage = min(distance.x/(self.superview!.frame.width/2), 1)
      let rotationAngle = (CGFloat(2*M_PI/16)*rotationPercentage)
      
      transform = CGAffineTransform(rotationAngle: rotationAngle)
      center = CGPoint(x: originalPoint!.x + distance.x, y: originalPoint!.y + distance.y)
      updateOverlay(distance.x)
    
    case .ended:
      if abs(distance.x) < frame.width/4 {
        resetViewPositionAndTransformations()
      } else {
        swipeDirection(distance.x > 0 ? .right : .left) // ternary operator - if true, first condition, otherwise second
      }
    
    default:
      print("Default triggered for GestureRecognizer")
      break
    }
  }
  
  func swipeDirection(_ s: Direction) {
    if s == .none {
      return
    }
    var parentWidth = superview!.frame.size.width
    if s == .left {
      parentWidth *= -1
    }
    
    UIView.animate(withDuration: 0.2, animations: {
      self.center.x = self.frame.origin.x + parentWidth
      }, completion: {
        success in
        if let d = self.delegate {
          s == .right ? d.swipedRight() : d.swipedLeft() // protocol functions
        }
    })
  }
  
  fileprivate func updateOverlay(_ distance: CGFloat) {
    var newDirection: Direction
    newDirection = distance < 0 ? .left : .right
    
    if newDirection != direction {
      direction = newDirection
      overlay.image = direction == .right ? UIImage(named: "yeah-stamp") : UIImage(named: "nah-stamp")
    }
    overlay.alpha = abs(distance) / (superview!.frame.width / 2)
  }
  
  fileprivate func resetViewPositionAndTransformations() {
    UIView.animate(withDuration: 0.2, animations: { () -> Void in
      self.center = self.originalPoint!
      self.transform = CGAffineTransform(rotationAngle: 0)
      
      self.overlay.alpha = 0
    })
  }
  
}
