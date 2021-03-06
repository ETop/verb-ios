//
//  MessageModel.swift
//  Verb
//
//  Created by Jonathan Porta on 8/27/14.
//  Copyright (c) 2014 Jonathan Porta. All rights reserved.
//

import Foundation

class MessageModel: Actionable {
  var id: Int
  var type: String
  var verb: String
  var acknowledgedAt: Int
  var acknowlegedAtInWords: String
  var createdAt: Int
  var createdAtInWords: String
  var sender: UserModel
  var recipient: UserModel
  var activity: ActivityModel?

  init(actionable: JSON, activity: ActivityModel? = nil) {
    self.id = actionable["id"].intValue
    self.verb = actionable["verb"].stringValue
    self.type = actionable["type"].stringValue
    self.acknowledgedAt = actionable["acknowledged_at"].intValue
    self.acknowlegedAtInWords = actionable["acknowleged_at_in_words"].stringValue
    self.createdAt = actionable["created_at"].intValue
    self.createdAtInWords = actionable["created_at_in_words"].stringValue
    self.sender = UserModel(user: actionable["sender"])
    self.recipient = UserModel(user: actionable["recipient"])

    if activity != nil {
      self.activity = activity
    }
  }

  // Implement Actionable
  func isAcknowledged() -> Bool {
    if acknowledgedAt > 0 { // TODO: Fix T.A.R.D.I.S. edgecase where no actionables can be ack'd at the unix epoch.
      return true
    }
    return false
  }

  func canAcknowledge() -> Bool {
    if isAcknowledged() { // We can't ack an already ack'd actionable.
      return false
    }
    return true
  }

  func acknowledge() {
    MessageFactory.Acknowledge(self)
  }

  func canReciprocate() -> Bool {
    return true
  }

  func reciprocate() {
    MessageFactory.Reciprocate(self)
  }

  // Implement Swipeable
  func isSwipeable() -> Bool {
    return true
  }

  func promptMessage() -> String {
    return "\(verb) back!"
  }

  func workingMessage() -> String {
    return "about to \(verb)!"
  }
}
