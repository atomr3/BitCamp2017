//
//  Message.swift
//  Tindergram
//
//  Created by thomas on 4/28/15.
//  Copyright (c) 2015 thomas. All rights reserved.
//

import Foundation

struct Message {
  let message: String
  let senderID: String
  let date: Date
}

class MessageListener {
  var currentHandle: UInt?
  
  init(matchID: String, startDate: Date, callback: @escaping (Message) -> ()) {
    let handle = ref?.child(byAppendingPath: matchID).queryOrderedByKey().queryStarting(atValue: dateFormatter().string(from: startDate)).observe(.childAdded, with: {
      snapshot in
      
      let message = snapshotToMessage(snapshot!)
      callback(message)
    })
    currentHandle = handle
  }
  
  func stop() {
    if let handle = currentHandle {
      ref?.removeObserver(withHandle: handle)
      currentHandle = nil
    }
  }
}

private let ref = Firebase(url: "\(firebaseAppURL)/messages")
private let dateFormat = "yyyyMMddHHmmss"

private func dateFormatter() -> DateFormatter {
  let dateFormatter = DateFormatter()
  dateFormatter.dateFormat = dateFormat
  return dateFormatter
}

func saveMessage(_ matchID: String, message: Message) {
  ref?.child(byAppendingPath: matchID).updateChildValues([
    dateFormatter().string(from: message.date): [
      "message": message.message,
      "sender": message.senderID
    ]])
}

private func snapshotToMessage(_ snapshot: FDataSnapshot) -> Message {
  let date = dateFormatter().date(from: snapshot.key)
  let sender = snapshot.value["sender"] as? String
  let text = snapshot.value["message"] as? String
  return Message(message: text!, senderID: sender!, date: date!)
}

func fetchMessages(_ matchID: String, callback: @escaping ([Message]) -> ()) {
  ref?.child(byAppendingPath: matchID).queryLimited(toFirst: 25).observeSingleEvent(of: .value, with: {
    snapshot in
    
    var messages: [Message] = []
    let enumerator = snapshot?.children
    
    while let data = enumerator?.nextObject() as? FDataSnapshot {
      messages.append(snapshotToMessage(data))
    }
    
    callback(messages)
  })
}
