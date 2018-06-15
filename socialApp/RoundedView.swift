//
//  RoundedView.swift
//  socialApp
//
//  Created by Ahmad Ghadiri on 2/24/18.
//  Copyright © 2018 AhmadGhadiri. All rights reserved.
//

import UIKit

class RoundedView: UIView {
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.cornerRadius = 20
        self.clipsToBounds = true
    }
}
