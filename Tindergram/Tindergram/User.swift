//
//  User.swift
//  Tindergram
//
//  Created by thomas on 4/14/15.
//  Copyright (c) 2015 thomas. All rights reserved.
//

import Foundation

struct User {
  let id: String
  let name: String
  fileprivate let pfUser: PFUser
  
  func getPhoto(_ callback: @escaping (UIImage) -> ()) {
    let imageFile = pfUser.object(forKey: "picture") as! PFFile
    
    imageFile.getDataInBackground(block: {
      data, error in
      if let data = data {
        callback(UIImage(data: data)!)
      }
    })
  }
}

func pfUserToUser(_ user: PFUser) -> User {
  return User(id: user.objectId!, name: user.object(forKey: "firstName") as! String, pfUser: user)
}

func currentUser() -> User? {
  if let user = PFUser.current() {
    return pfUserToUser(user)
  }
  return nil
}

func fetchUnviewedUsers(_ callback: @escaping (([User]) -> ())) {
  
  PFQuery(className: "Action")
    .whereKey("byUser", equalTo: PFUser.current()!.objectId!).findObjectsInBackground(block: {
      objects, error in
      
      print(objects!)
      let viewedUsers = map(objects!, {$0.object(forKey: "toUser")!})
      print(viewedUsers)
      
      PFUser.query()!
        .whereKey("objectId", notEqualTo: PFUser.current()!.objectId!)
        .whereKey("objectId", notContainedIn: viewedUsers)
        .findObjectsInBackground(block: {
          objects, error in
          
          if let pfUsers = objects as? [PFUser] {
            let users = map(pfUsers, {pfUserToUser($0)})
            callback(users)
          }
        })
    })
}

func saveSkip(_ user: User) {
  let skip = PFObject(className: "Action")
  skip.setObject(PFUser.current()!.objectId!, forKey: "byUser")
  skip.setObject(user.id, forKey: "toUser")
  skip.setObject("skipped", forKey: "type")
  skip.saveInBackground(block: nil)
}

func saveLike(_ user: User) {
  PFQuery(className: "Action")
    .whereKey("byUser", equalTo: user.id)
    .whereKey("toUser", equalTo: PFUser.current()!.objectId!)
    .whereKey("type", equalTo: "liked")
    .getFirstObjectInBackground(block: {
      object, error in
      
      var matched = false
      
      if object != nil {
        matched = true
        object!.setObject("matched", forKey: "type")
        object!.saveInBackground(block: nil)
      }
      
      let match = PFObject(className: "Action")
      match.setObject(PFUser.current()!.objectId!, forKey: "byUser")
      match.setObject(user.id, forKey: "toUser")
      match.setObject(matched ? "matched" : "liked", forKey: "type")
      match.saveInBackground(block: nil)
    })
}

