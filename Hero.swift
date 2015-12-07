//
//  Hero.swift
//  Sir Prance
//
//  Created by Randy Truong on 10/9/15.
//  Copyright © 2015 Vent Origins. All rights reserved.
//

import UIKit

class Hero {

    // MARK: Private Variables
    private var heroImageView: UIImageView!
    
    // Handles the hero's images
    private var imageHeroRunList = [UIImage]()
    private var imageHeroSSList = [UIImage]()
    private var imageHeroBowList = [UIImage]()
    private var imageHeroStaffList = [UIImage]()
    private var imageHeroDeathList = [UIImage]()
    private var imageIndex = 0
    
    // Current stance of the hero
    private var currStance = heroStance.run
    // If the hero is in an attack stance or not
    private var ifCurrInAttackStance = false
    // If the hero is alive or not
    private var ifHeroIsAlive = true
    // When the hero is fully dead
    private var ifHeroIsFullyDead = false
    // Interacts with ifHeroIsFullyDead to ensure it gets called once
    private var ifGameOverStateWhenFullyDead = false
    
    // Screen size
    private let screenSize: CGRect = UIScreen.mainScreen().bounds
    
    // MARK: Internal variables
    
    // Each stance for the hero
    internal enum heroStance {
        case ss
        case bow
        case staff
        case run
        case death
    }
    
    // MARK: Functions
    
    init(groundObj: Ground) {
        // Creates a UIImage which is hero_run1.png
        let heroImage = UIImage(named: "hero_run1")
        
        // Arguments used for the UIImageView Constructor
        let heroWidth = screenSize.width * 0.24
        let heroHeight = screenSize.height * 0.28
        let posX = 0.03 * screenSize.width
        let posY = (groundObj.getGroundView().frame.origin.y) - (heroHeight * 0.7)
        
        // Creates the hero image at its specified position and size
        heroImageView = UIImageView(frame: CGRectMake(posX, posY, heroWidth, heroHeight))
        heroImageView.image = heroImage
        heroImageView.clipsToBounds = true
        
        // Begins the animation
        initHeroImagesForAnimation()
        heroRunAnimating()
    }
    
    // Sets each animation hero image list to contain their specific images
    func initHeroImagesForAnimation() {
        var heroName = ""
        var img: UIImage!
        
        for i in 1...8 {
            // Increments through each hero_run image and puts it into the imageHeroRunList
            heroName = "hero_run\(i)"
            img = UIImage(named: "\(heroName)")
            imageHeroRunList.append(img!)
            
            // Increments through each hero_ss image and puts it into the imageHeroSSList
            heroName = "hero_ss\(i)"
            img = UIImage(named: "\(heroName)")
            imageHeroSSList.append(img!)
            
            // Increments through each hero_bow image and puts it into the imageHeroBowList
            heroName = "hero_bow\(i)"
            img = UIImage(named: "\(heroName)")
            imageHeroBowList.append(img!)
            
            // Increments through each hero_staff image and puts it into the imageHeroStaffList
            heroName = "hero_staff\(i)"
            img = UIImage(named: "\(heroName)")
            imageHeroStaffList.append(img!)
            
            // Increments through each hero_death image and puts it into the imageHeroDeathList
            heroName = "hero_death\(i)"
            img = UIImage(named: "\(heroName)")
            imageHeroDeathList.append(img!)
        }
    }
    
    func update() {
        // Resets the image to the first image after a full cycle and exits out of an attack stance
        // Ensures not to animate new stance when currently in an attack stance
        if (imageIndex >= imageHeroRunList.count) {
            // Resets to the regular stance run after an attack animation
            if (currStance != heroStance.death) {
                imageIndex = 0
                ifCurrInAttackStance = false
                currStance = heroStance.run
            }
            // If hero is dead, stays in death mode
            else if (currStance == heroStance.death && !ifGameOverStateWhenFullyDead) {
                ifHeroIsFullyDead = true
                ifGameOverStateWhenFullyDead = true
                return
            }
            else {
                return
            }
        }
        
        // Sets the stance and the next image in the list
        chooseHeroStance()
        imageIndex++
    }
    
    func chooseHeroStance() {
        switch currStance {
            case .ss:
                heroImageView.image = imageHeroSSList[imageIndex]
            case .bow:
                heroImageView.image = imageHeroBowList[imageIndex]
            case .staff:
                heroImageView.image = imageHeroStaffList[imageIndex]
            case .run:
                heroImageView.image = imageHeroRunList[imageIndex]
            case .death:
                heroImageView.image = imageHeroDeathList[imageIndex]
        }
    }
    
    // MARK: Hero Animation Stances
    
    private func initAttackStance(stance: heroStance) {
        // This if statement ensures that the hero would not start a new stance if the hero is currently in the middle of an attack stance
        if (!ifCurrInAttackStance && ifHeroIsAlive) {
            ifCurrInAttackStance = true
            currStance = stance
            imageIndex = 0
        }
    }
    
    internal func heroSSAnimating() {
        initAttackStance(heroStance.ss)
        Sound.soundObj.getSsSound()?.play()
    }
    
    internal func heroBowAnimating() {
        initAttackStance(heroStance.bow)
        Sound.soundObj.getBowSound()?.play()
    }
    
    internal func heroStaffAnimating() {
        initAttackStance(heroStance.staff)
        Sound.soundObj.getStaffSound()?.play()
    }
    
    internal func heroRunAnimating() {
        currStance = heroStance.run
    }
    
    internal func heroAnimateDeath() {
        imageIndex = 0
        currStance = heroStance.death
        ifHeroIsAlive = false
    }
    
    // MARK: Accessors
    
    internal func getHeroView() -> UIImageView! {
        return heroImageView!
    }
    
    internal func getHeroStance() -> heroStance {
        return currStance
    }
    
    internal func getIfHeroIsAlive() -> Bool {
        return ifHeroIsAlive
    }
    
    internal func getIfHeroIsFullyDead() -> Bool {
        return ifHeroIsFullyDead
    }
    
    internal func getIfCurrInAttackStance() -> Bool {
        return ifCurrInAttackStance
    }
    
    // MARK: Setters
    
    internal func setIfHeroIsFullyDead(bool: Bool) {
        ifHeroIsFullyDead = bool
    }
}