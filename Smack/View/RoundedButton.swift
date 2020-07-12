//
//  RoundedButton.swift
//  Smack
//
//  Created by NGUYENLONGTIEN on 5/7/20.
//  Copyright © 2020 NGUYENLONGTIEN. All rights reserved.
//

import UIKit
@IBDesignable
class RoundedButton: UIButton {

    @IBInspectable var conerRadius:CGFloat = 3.0 {
        didSet{
            self.layer.cornerRadius = conerRadius
        }
    }
    override func awakeFromNib() {
        self.setupView()
    }
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        self.setupView()
    }
    func setupView(){
        self.layer.cornerRadius = conerRadius
    }

}
