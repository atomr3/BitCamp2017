//
//  LoginViewController.swift
//  Tindergram
//
//  Created by thomas on 4/11/15.
//  Copyright (c) 2015 thomas. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
  }
  
  @IBAction func loginButtonPressed(_ sender: UIButton) {
    PFFacebookUtils.logIn(withPermissions: ["public_profile", "user_about_me", "user_birthday"], block: {
      user, error in
      
      if user == nil {
        print("Ruh-roh, the user cancelled the Facebook login.")
        return
      } else if user!.isNew {
        print("User just signed up and logged in for the first time.")
        
        FBRequestConnection.start(withGraphPath: "/me?fields=picture,first_name,birthday,gender", completionHandler: {
          connection, result, error in
          
          var r = result as! NSDictionary
          
          user!["firstName"] = r["first_name"]
          user!["gender"] = r["gender"]
          
          var dateFormatter = DateFormatter()
          dateFormatter.dateFormat = "MM/dd/yyyy"
          user!["birthDay"] = dateFormatter.date(from: r["birthday"] as! String)
          
          let pictureURL = ((r["picture"] as! NSDictionary)["data"] as! NSDictionary) ["url"] as! String
          let url = URL(string: pictureURL)
          let request = URLRequest(url: url!)
          
          NSURLConnection.sendAsynchronousRequest(request, queue: OperationQueue.main, completionHandler: {
            response, data, error in
            
            let imageFile = PFFile(name: "avatar.jpg", data: data!!)
            user!["picture"] = imageFile
            user!.saveInBackground(block: nil)
          })
        })
      } else {
        print("User logged in through Facebook.")
      }
      
      let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CardsNavController") 
      self.present(vc, animated: true, completion: nil)
    })
  }
  
}
