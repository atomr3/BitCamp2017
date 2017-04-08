//
//  ProfileViewController.swift
//  Tindergram
//
//  Created by thomas on 4/14/15.
//  Copyright (c) 2015 thomas. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {
  
  @IBOutlet weak var imageView: UIImageView!
  @IBOutlet weak var nameLabel: UILabel!
  
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    navigationItem.titleView = UIImageView(image: UIImage(named: "profile-header"))
    let rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "nav-back-button"), style: .plain, target: self, action: #selector(ProfileViewController.goToCards(_:)))
    navigationItem.setRightBarButton(rightBarButtonItem, animated: true)
    
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    nameLabel.text = currentUser()?.name
    currentUser()?.getPhoto({
      image in
      self.imageView.layer.masksToBounds = true
      self.imageView.contentMode = .scaleAspectFill
      self.imageView.image = image
    })
  }
  
  func goToCards(_ button: UIBarButtonItem) {
    pageController.goToNextVC()
  }
  
}
