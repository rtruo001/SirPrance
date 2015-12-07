//
//  Ground.swift
//  Sir Prance
//
//  Created by Randy Truong on 10/8/15.
//  Copyright © 2015 Vent Origins. All rights reserved.
//

import UIKit

class Ground {
    // MARK: Private Variables
    
    // MARK: UIViews
    private var gameGroundImageView: UIImageView!
    private var gameGroundImageViewRight: UIImageView!
    private var groundBackgroundColor: UIImageView!

    private let screenSize: CGRect = UIScreen.mainScreen().bounds
    private let velocityOfGroundX: CGFloat!
    
    // MARK: Functions
    init() {
        // Speed of ground
        velocityOfGroundX = CGFloat(screenSize.width * 0.008)
        
        // Creates a UIImage which is gameground.png
        let groundImage = UIImage(named: "gameground")
        
        // Sets the arguments for the frame
        var posX = CGFloat(0.0)
        var posY = screenSize.height * 0.50
        var groundWidth = screenSize.width + CGFloat(10)
        var groundHeight = 0.10 * screenSize.height
        
        // Creates the image at the bottom of the screen
        gameGroundImageView = UIImageView(frame: CGRectMake(posX, posY, groundWidth, groundHeight))
        gameGroundImageView.image = groundImage
        gameGroundImageView.contentMode = .ScaleToFill
        gameGroundImageView.clipsToBounds = true
        
        posX = screenSize.width
        
        // Creates the second groundImage in order for the scroll of the ground to look infinite
        gameGroundImageViewRight = UIImageView(frame: CGRectMake(posX, posY, groundWidth, groundHeight))
        gameGroundImageViewRight.image = groundImage
        gameGroundImageViewRight.contentMode = .ScaleToFill
        gameGroundImageViewRight.clipsToBounds = true
        
        // Resetting the variables into arguments for the non-animating ground
        posX = CGFloat(0.0)
        posY = posY + groundHeight
        groundWidth = screenSize.width + CGFloat(10)
        groundHeight = screenSize.height - posY
        
        // Creates the rest of the ground below the animating ground
        groundBackgroundColor = UIImageView(frame: CGRectMake(posX, posY, groundWidth, groundHeight))
        groundBackgroundColor.image = UIImage(named: "brown")
        groundBackgroundColor.contentMode = .ScaleToFill
        groundBackgroundColor.clipsToBounds = true
    }
    
    func update() {
        // Ground that goes left out of the screen
        var currGroundFrame: CGRect = gameGroundImageView.frame
        // Ground that goes left into the screen
        var currGroundRightFrame: CGRect = gameGroundImageViewRight.frame
        
        // When the ground is about to move pass the edge, set it's position exactly at the edge, this prevents white space
        if ((currGroundFrame.origin.x - velocityOfGroundX) <= -screenSize.width) {
            currGroundFrame.origin.x = 0
            currGroundRightFrame.origin.x = screenSize.width
        }
        // Moves the ground accordingly to the velocity
        else {
            currGroundFrame.origin.x -= velocityOfGroundX
            currGroundRightFrame.origin.x -= velocityOfGroundX
        }
        
        //Sets the grounds frame to the new frames
        gameGroundImageView.frame = currGroundFrame
        gameGroundImageViewRight.frame = currGroundRightFrame
    }
    
    // MARK: Accessors
    
    func getGroundView() -> UIImageView! {
        return gameGroundImageView!
    }
    
    func getGroundRightView() -> UIImageView! {
        return gameGroundImageViewRight!
    }
    
    func getGroundBackgroundView() -> UIImageView! {
        return groundBackgroundColor!
    }
}
