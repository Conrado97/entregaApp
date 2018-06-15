//
//  CircleImage.swift
//  socialApp
//
//  Created by Ahmad Ghadiri on 2/24/18.
//  Copyright © 2018 AhmadGhadiri. All rights reserved.
//

import UIKit

class CircleImage: UIImageView {

    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.cornerRadius = self.frame.width/2
        self.clipsToBounds = true
    }
}
