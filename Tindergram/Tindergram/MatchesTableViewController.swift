//
//  MatchesTableViewController.swift
//  Tindergram
//
//  Created by thomas on 4/21/15.
//  Copyright (c) 2015 thomas. All rights reserved.
//

import UIKit

class MatchesTableViewController: UITableViewController {
  
  var matches: [Match] = []
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    navigationItem.titleView = UIImageView(image: UIImage(named: "chat-header"))
    let leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "nav-back-button"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(MatchesTableViewController.goToPreviousVC(_:)))
    navigationItem.setLeftBarButton(leftBarButtonItem, animated: true)
    
    fetchMatches({
      matches in
      self.matches = matches
      self.tableView.reloadData()
    })
  }
  
  func goToPreviousVC(_ button: UIBarButtonItem) {
    pageController.goToPreviousVC()
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
  }
  
  // MARK: - Table view data source
  
  override func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return matches.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell", for: indexPath) as! UserCell
    
    let user = matches[indexPath.row].user
    cell.nameLabel.text = user.name
    user.getPhoto({
      image in
      cell.avatarImageView.image = image
    })
    return cell
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
    let vc = ChatViewController()
    let match = matches[indexPath.row]
    vc.matchID = match.id
    vc.title = match.user.name
    
    navigationController?.pushViewController(vc, animated: true)
    
    tableView.deselectRow(at: indexPath, animated: true)
  }
  
}
