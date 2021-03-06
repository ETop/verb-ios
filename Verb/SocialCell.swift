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

  @IBOutlet var foregroundLabel: UILabel!
  @IBOutlet var foregroundStatusLabel: FontableLabel!
  @IBOutlet var iconUIView: UIView!

  let statusIcons = [
    "friends": "\u{e670}",
    "not friends": "\u{e852}",
    "friendship requested": "\u{e677}",
    "friendship received": "\u{e852}"
  ]

  override func awakeFromNib() {
    super.awakeFromNib()
  }

  func setModel(model: ConnectionFriendModel) {
    // TODO: Needs to figure out best way to inject fonts, instead of treating them as global.
    var font = UIFont(name: "icomoon-standard", size: 24.0)!
    foregroundStatusLabel.setFont(font)
    foregroundLabel.text = model.firstName

    var icon = statusIcons[model.relationship]!
    foregroundStatusLabel.setText(icon)
  }
}
