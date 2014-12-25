//
//  SocialCell.swift
//  Verb
//
//  Created by Jonathan Porta on 11/10/14.
//  Copyright (c) 2014 Jonathan Porta. All rights reserved.
//

import Foundation
import UIKit

class SocialCell: UITableViewCell {

  var connectionFriendModel: ConnectionFriendModel!

  @IBOutlet var profileImageView: UIImageView!
  @IBOutlet var foregroundLabel: UILabel!
  @IBOutlet var foregroundStatusLabel: FontableLabel!
  @IBOutlet var iconUIView: UIView!
  @IBOutlet var activityIndicator: UIActivityIndicatorView!

  override func awakeFromNib() {
    super.awakeFromNib()
  }

  func setModel(model: ConnectionFriendModel) {
    // TODO: Needs to figure out best way to inject fonts, instead of treating them as global.
    var font = UIFont(name: "icomoon-standard", size: 24.0)!
    connectionFriendModel = model
    foregroundLabel.text = connectionFriendModel.firstName
    foregroundStatusLabel.setFont(font)

    //if model.isHidden {

      foregroundStatusLabel.setText(connectionFriendModel.relationship)
      //foregroundStatusLabel.setTextColor(connectionFriendModel.friendshipStatusColor())
    //}
  }
}
