//
//  CardView.swift
//  Tindergram
//
//  Created by thomas on 3/31/15.
//  Copyright (c) 2015 thomas. All rights reserved.
//

import Foundation
import UIKit

class CardView: UIView {
  
  fileprivate let imageView: UIImageView = UIImageView()
  fileprivate let nameLabel: UILabel = UILabel()
  
  var name: String? {
    didSet {
      if let name = name {
        nameLabel.text = name
      }
    }
  }
  
  var image: UIImage? {
    didSet {
      if let image = image {
        imageView.image = image
      }
    }
  }
  
  required init(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    initialize()
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    initialize()
  }
  
  fileprivate func initialize() {
    imageView.setTranslatesAutoresizingMaskIntoConstraints(false)
    imageView.backgroundColor = UIColor.clear
    addSubview(imageView)
    
    nameLabel.setTranslatesAutoresizingMaskIntoConstraints(false)
    addSubview(nameLabel)
    
    backgroundColor = UIColor.white
    layer.borderWidth = 0.5
    layer.borderColor = UIColor.lightGray.cgColor // converts UIColor to correct type
    layer.cornerRadius = 5
    layer.masksToBounds = true // things cannot exceed the cardview's bounds
    
    setConstraints()
  }
  
  fileprivate func setConstraints() {
    // imageView Constraints
    addConstraint(NSLayoutConstraint(item: imageView, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1.0, constant: 0))
    addConstraint(NSLayoutConstraint(item: imageView, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1.0, constant: 0))
    addConstraint(NSLayoutConstraint(item: imageView, attribute: .width, relatedBy: .equal, toItem: self, attribute: .width, multiplier: 1.0, constant: 0))
    addConstraint(NSLayoutConstraint(item: imageView, attribute: .height, relatedBy: .equal, toItem: self, attribute: .height, multiplier: 1.0, constant: 0))
    
    // nameLabel Constraints
    addConstraint(NSLayoutConstraint(item: nameLabel, attribute: .top, relatedBy: .equal, toItem: imageView, attribute: .top, multiplier: 1.0, constant: 0))
    addConstraint(NSLayoutConstraint(item: nameLabel, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1.0, constant: 10))
    addConstraint(NSLayoutConstraint(item: nameLabel, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1.0, constant: -10))
    addConstraint(NSLayoutConstraint(item: nameLabel, attribute: .bottom, relatedBy: .equal, toItem: imageView, attribute: .bottom, multiplier: 1.0, constant: 0))
  }
  
}
