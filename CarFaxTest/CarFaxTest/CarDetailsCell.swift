//
//  CarDetailsCell.swift
//  CarFaxTest
//
//  Created by Kalpesh Thakare on 2020-08-28.
//  Copyright © 2020 Kalpesh Thakare. All rights reserved.
//

import UIKit

class CarDetailsCell: UICollectionViewCell {

    //MARK: IBOUTLETS

    @IBOutlet weak var imgView_CarImage: UIImageView!

    @IBOutlet weak var lbl_CarInformation: UILabel!

    @IBOutlet weak var lbl_CarPrice: UILabel!
    @IBOutlet weak var lbl_CarMilageKm: UILabel!
    @IBOutlet weak var lbl_DelarAddress: UILabel!

    @IBOutlet weak var btn_delarPhoneNumber: UIButton!

    @IBOutlet weak var view_CellBackground: UIView!
    override func awakeFromNib() {

        lbl_CarInformation.makeCornerRadius()
        lbl_CarPrice.makeCornerRadius()
        lbl_CarMilageKm.makeCornerRadius()
        lbl_DelarAddress.makeCornerRadius()

        view_CellBackground.layer.cornerRadius = 20
        view_CellBackground.layer.masksToBounds = true
    }
}

extension UILabel {

    func makeCornerRadius() {
        self.layer.cornerRadius = self.frame.size.height/2.0
        self.layer.masksToBounds = true
    }
}

