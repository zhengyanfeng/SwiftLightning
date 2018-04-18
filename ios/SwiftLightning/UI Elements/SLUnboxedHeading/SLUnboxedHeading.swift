//
//  SLUnboxedHeading.swift
//  SwiftLightning
//
//  Created by Howard Lee on 2018-04-17.
//  Copyright © 2018 BiscottiGelato. All rights reserved.
//

import UIKit

@IBDesignable class SLUnboxedHeading: NibView {

  @IBOutlet weak var title: UILabel!
  @IBOutlet weak var logoHeightConstraint: NSLayoutConstraint!
  @IBOutlet weak var logoAspectRatioConstraint: NSLayoutConstraint!
  
  
  override var intrinsicContentSize: CGSize {
    let logoHeight = logoHeightConstraint.constant
    let logoWidth = logoHeight / logoAspectRatioConstraint.multiplier
    
    let width = logoWidth + title.intrinsicContentSize.width + 15.0
    let height = max(logoHeight, title.intrinsicContentSize.height)
    
    return CGSize(width: width, height: height)
  }
}