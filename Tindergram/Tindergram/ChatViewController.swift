//
//  ChatViewController.swift
//  Tindergram
//
//  Created by thomas on 4/22/15.
//  Copyright (c) 2015 thomas. All rights reserved.
//

import Foundation

class ChatViewController: JSQMessagesViewController {
  
  var messages: [JSQMessage] = []
  var matchID: String?
  var messageListener: MessageListener?
  
  let outgoingBubble = JSQMessagesBubbleImageFactory().outgoingMessagesBubbleImage(with: UIColor.jsq_messageBubbleLightGray())
  let incomingBubble = JSQMessagesBubbleImageFactory().incomingMessagesBubbleImage(with: UIColor.jsq_messageBubbleBlue())
  
  override func viewWillAppear(_ animated: Bool) {
    if let id = matchID {
      messageListener = MessageListener(matchID: id, startDate: Date(), callback: {
        message in
        
        self.messages.append(JSQMessage(senderId: message.senderID, senderDisplayName: message.senderID, date: message.date, text: message.message))
      })
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    senderDisplayName = currentUser()!.id
    senderId = currentUser()!.id
    
    collectionView.collectionViewLayout.incomingAvatarViewSize = CGSize.zero
    collectionView.collectionViewLayout.outgoingAvatarViewSize = CGSize.zero
    inputToolbar.contentView.leftBarButtonItem = nil
    
    if let id = matchID {
      fetchMessages(id, {
        messages in
        
        for m in messages {
          self.messages.append(JSQMessage(senderId: m.senderID, senderDisplayName: m.senderID, date: m.date, text: m.message))
        }
        self.finishReceivingMessage()
      })
    }
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    messageListener?.stop()
  }
  
  override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageDataForItemAt indexPath: IndexPath!) -> JSQMessageData! {
    let data = self.messages[indexPath.row]
    return data
  }
  
  override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return messages.count
  }
  
  override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageBubbleImageDataForItemAt indexPath: IndexPath!) -> JSQMessageBubbleImageDataSource! {
    
    let data = messages[indexPath.row]
    if data.senderId == PFUser.current()!.objectId! {
      return outgoingBubble
    } else {
      return incomingBubble
    }
  }
  
  override func didPressSend(_ button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!, date: Date!) {
    
    let m = JSQMessage(senderId: senderId, senderDisplayName: senderDisplayName, date: date, text: text)
    messages.append(m!)
    
    if let id = matchID {
      saveMessage(id, Message(message: text, senderID: senderId, date: date))
    }
    
    finishSendingMessage()
  }
  
}
