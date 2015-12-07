//
//  Nature.swift
//  Sir Prance
//
//  Created by Randy Truong on 10/9/15.
//  Copyright © 2015 Vent Origins. All rights reserved.
//

import UIKit

class Nature {
    
    // MARK: Private Variables
    
    // MARK: UIViews
    private var natureImageView: UIImageView!
    private var natureImageRightView: UIImageView!

    // The image for the nature background
    private var imageList = [UIImage]()
    private var index = 0
    
    // Screen size
    private let screenSize: CGRect = UIScreen.mainScreen().bounds

    // MARK: Functions
    
    init(groundObj: Ground) {
        initNatureImages()
        
        // Creates a UIImage which is gameground.png
        index = Int(arc4random_uniform(UInt32(imageList.count)))

        let natureImage = imageList[index]
        index++
        if (index >= imageList.count) {
            index = 0
        }
        let natureRightImage = imageList[index]
        index++
        
        // Initializes the arguments used for the frames
        var posX = CGFloat(0.0)
        let posY = CGFloat(0.0)
        let groundWidth = screenSize.width
        let groundHeight = 0.60 * screenSize.height
        
        // Creates the image at the bottom of the screen
        natureImageView = UIImageView(frame: CGRectMake(posX, posY, groundWidth, groundHeight))
        natureImageView.image = natureImage
        natureImageView.contentMode = .ScaleToFill
        natureImageView.clipsToBounds = true
        
        // Adjusts the arguments used for the right frame
        posX = screenSize.width
        
        // Creates the second groundImage in order for the scroll of the ground to look infinite
        natureImageRightView = UIImageView(frame: CGRectMake(posX, posY, groundWidth, groundHeight))
        natureImageRightView.image = natureRightImage
        natureImageRightView.contentMode = .ScaleToFill
        natureImageRightView.clipsToBounds = true
    }
    
    func update() {
        let posY = CGFloat(0.0)
        let groundWidth = screenSize.width
        let groundHeight = 0.60 * screenSize.height
        
        // Velocity that the nature is moving by
        let velocityOfNatureX = CGFloat(1.2)
        // The frames to be set to the imageView frames
        var currNatureFrame: CGRect = natureImageView.frame
        var currNatureRightFrame: CGRect = natureImageRightView.frame
        
        // Resets to the first nature image after going through the entire list
        if (index >= imageList.count) {
            index = 0;
        }
        
        // When the left frame is fully out of the view screen, changes the image and moves position of the frame to the right
        if (currNatureFrame.origin.x == -screenSize.width) {
            currNatureFrame.origin.x = screenSize.width
            natureImageView.image = imageList[index]
            index++
        }
        // When the right frame is fully out of the view screen, changes the image and moves position of the frame back to the right
        else if (currNatureRightFrame.origin.x == -screenSize.width) {
            currNatureRightFrame.origin.x = screenSize.width
            natureImageRightView.image = imageList[index]
            index++
        }
        // Moves the image into the edge to prevent white spaces from showing if velocity is passed the edge boundaries
        else if (currNatureFrame.origin.x - velocityOfNatureX <= -screenSize.width) {
            currNatureFrame.origin.x = -screenSize.width
            currNatureRightFrame.origin.x = 0
        }
        // Does same as above, but also resets the frames depending on which one is left or right
        else if (currNatureRightFrame.origin.x - velocityOfNatureX <= -screenSize.width) {
            currNatureFrame.origin.x = 0
            currNatureRightFrame.origin.x = -screenSize.width
        }
        // Moves the nature frames by the velocity
        else {
            currNatureFrame.origin.x -= velocityOfNatureX
            currNatureRightFrame.origin.x -= velocityOfNatureX
        }
    
        // Sets the temp frames to the actual UIImageView frames
        natureImageView.frame = CGRectMake(currNatureFrame.origin.x, posY, groundWidth, groundHeight)
        natureImageRightView.frame = CGRectMake(currNatureRightFrame.origin.x, posY, groundWidth, groundHeight)
    }
    
    private func initNatureImages() {
        for i in 1...12 {
            let natureName = "nature_\(i)"
            let img = UIImage(named: "\(natureName)")
            imageList.append(img!)
        }
    }
    
    func getNatureImage() -> UIImageView! {
        return natureImageView!
    }

    func getNatureRightImage() -> UIImageView! {
        return natureImageRightView!
    }
}
