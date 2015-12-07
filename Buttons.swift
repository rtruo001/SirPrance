//
//  Buttons.swift
//  Sir Prance
//
//  Created by Randy Truong on 10/10/15.
//  Copyright © 2015 Vent Origins. All rights reserved.
//

import UIKit

// CONSTANTS
let COLOROFBUTTONS = UIColor(red: 94/255, green: 78/255, blue: 77/255, alpha: 1.0)
let CORNERRADIUSOFBUTTON = CGFloat(10)

class Buttons {
    // MARK: UIView
    private var ssImageButtonView: UIButton!
    private var bowImageButtonView: UIButton!
    private var staffImageButtonView: UIButton!
    
    //  MARK: Public variables
    private let screenSize: CGRect = UIScreen.mainScreen().bounds
    
    // MARK: Functions
    
    init(groundObj: Ground) {
        // Sets the images
        let view = UIImageView(frame: CGRectMake(0, 0, 10, 10))
        view.image = UIImage(named: "ssbutton")
        let ssButtonImage = UIImage(named: "ssbutton")
        let bowButtonImage = UIImage(named: "bowbutton")
        let staffButtonImage = UIImage(named: "staffbutton")

        let betweenButtonsSpacing = CGFloat(10.0)
        
        // Variables used throughout the init function
        let spaceBetweenButtons = 0.04 * screenSize.width
        
        // Arguments for the frame of each button
        var posX = spaceBetweenButtons
        let posY = (screenSize.height / 2) + (screenSize.height * 0.15)
        let buttonWidth = (screenSize.width * 0.28)
        let buttonHeight = screenSize.height - posY - (2 * betweenButtonsSpacing)

        // Init sword and shield button view
        ssImageButtonView = UIButton(frame: CGRectMake(posX, posY, buttonWidth, buttonHeight))
        ssImageButtonView.setImage(ssButtonImage, forState: .Normal)
        // For setting the image size correctly inside the button
        ssImageButtonView.imageEdgeInsets = UIEdgeInsetsMake(buttonHeight * 0.10, buttonWidth * 0.10, buttonHeight * 0.10, buttonWidth * 0.10)
        ssImageButtonView.imageView?.contentMode = .ScaleAspectFit
        ssImageButtonView.backgroundColor = COLOROFBUTTONS
        ssImageButtonView.layer.cornerRadius = CORNERRADIUSOFBUTTON
        
        // Init bow button view
        posX = 2 * spaceBetweenButtons + buttonWidth
        bowImageButtonView = UIButton(frame: CGRectMake(posX, posY, buttonWidth, buttonHeight))
        bowImageButtonView.setImage(bowButtonImage, forState: .Normal)
        // For setting the image size correctly inside the button
        bowImageButtonView.imageEdgeInsets = UIEdgeInsetsMake(buttonHeight * 0.10, buttonWidth * 0.10, buttonHeight * 0.10, buttonWidth * 0.10)
        bowImageButtonView.imageView?.contentMode = .ScaleAspectFit
        bowImageButtonView.backgroundColor = COLOROFBUTTONS
        bowImageButtonView.layer.cornerRadius = CORNERRADIUSOFBUTTON

        // Init staff button view
        posX = posX + spaceBetweenButtons + buttonWidth
        staffImageButtonView = UIButton(frame: CGRectMake(posX, posY, buttonWidth, buttonHeight))
        staffImageButtonView.setImage(staffButtonImage, forState: .Normal)
        // For setting the image size correctly inside the button
        staffImageButtonView.imageEdgeInsets = UIEdgeInsetsMake(buttonHeight * 0.10, buttonWidth * 0.10, buttonHeight * 0.10, buttonWidth * 0.10)
        staffImageButtonView.imageView?.contentMode = .ScaleAspectFit
        staffImageButtonView.backgroundColor = COLOROFBUTTONS
        staffImageButtonView.layer.cornerRadius = CORNERRADIUSOFBUTTON
    }
    
    // MARK: Accessors
    
    func getSSImageButtonView() -> UIButton! {
        return ssImageButtonView
    }
    
    func getBowImageButtonView() -> UIButton! {
        return bowImageButtonView
    }
    
    func getStaffImageButtonView() -> UIButton! {
        return staffImageButtonView
    }
}
