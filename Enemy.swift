//
//  Enemy.swift
//  Sir Prance
//
//  Created by Randy Truong on 10/15/15.
//  Copyright © 2015 Vent Origins. All rights reserved.
//

import UIKit

// CONSTANTS
let ADDEDSIZEFORENEMIESTOLOOKBIGGERTHANHERO = CGFloat(12)

class Enemy {
    
    // MARK: Private Variables
    
    // MARK: UIViews
    private var enemyImageView: UIImageView!
    
    // Stances of the enemy
    private enum enemyStance {
        case ss
        case bow
        case staff
    }
    
    // A pointer to the hero
    private var heroObj: Hero!
    
    // Stance of the enemy
    private var currStance = enemyStance.ss
    
    // Handles the images of the enemey
    private var imageEnemyList = [UIImage]()
    private var imageIndex = 0
    
    // Distance the enemy moves per update
    private var enemySpeed: CGFloat!
    
    // Bool for if the enemy is alive or not
    private var ifEnemyDied = false
    
    // Used for the EnemyCreator to remove the enemy after it finished the dying animation
    private var finishedDeathAnimation = false
    
    // Used for screen size
    private let screenSize: CGRect = UIScreen.mainScreen().bounds
    
    // MARK: Public Functions
    
    init() {
        chooseEnemyStance()
        initEnemyImagesForAnimation()
        
        // Arguments for the frame
        let posX = screenSize.width
        let posY = screenSize.width - CGFloat(100)
        let enemyWidth = CGFloat(100)
        let enemyHeight = CGFloat(100)
        
        enemyImageView = UIImageView(frame: CGRectMake(posX, posY, enemyWidth, enemyHeight))
        enemyImageView.image = imageEnemyList[0]
    }
    
    init(distance: CGFloat, movementSpeed: CGFloat, hero: Hero!) {
        enemySpeed = movementSpeed
        heroObj = hero
        
        chooseEnemyStance()
        initEnemyImagesForAnimation()
        
        // Arguments for the frame
        let posX = screenSize.width + distance
        let posY = hero.getHeroView().frame.origin.y - ADDEDSIZEFORENEMIESTOLOOKBIGGERTHANHERO
        let enemyWidth = hero.getHeroView().frame.width + ADDEDSIZEFORENEMIESTOLOOKBIGGERTHANHERO
        let enemyHeight = hero.getHeroView().frame.height + ADDEDSIZEFORENEMIESTOLOOKBIGGERTHANHERO
        
        enemyImageView = UIImageView(frame: CGRectMake(posX, posY, enemyWidth, enemyHeight))
        enemyImageView.image = imageEnemyList[0]
        enemyImageView.contentMode = .ScaleAspectFit
        enemyImageView.clipsToBounds = true
    }
    
    // MARK: Two different updates dependent on the timing ticks in the actual game class
    
    func update() {
        // Every update consists of moving the position of enemy by the enemySpeed
        enemyImageView.frame.origin.x -= enemySpeed
        
        // Removes the enemy if goes out of the screen
        if (enemyImageView.frame.origin.x <= -enemyImageView.frame.width) {
            remove()
        }
    }
    
    func animateUpdate() {
        // Every animate update consists of switching to the new image of the imageList
        enemyAnimateImage()
    }
    
    func enemyBeginsToDie() {
        // When an enemy is hit with the wrong stance against the hero begins to die by calling the animation death
        enemyAnimateDeath()
    }
    
    func ifHeroStanceKillsEnemy() -> Bool {
        if (heroObj.getHeroStance() == .ss && currStance == enemyStance.bow ||
            heroObj.getHeroStance() == .bow && currStance == enemyStance.staff ||
            heroObj.getHeroStance() == .staff && currStance == enemyStance.ss) {
                return true
        }
        else {
            return false
        }
    }
    
    func enemyRespawn(distance: CGFloat, movementSpeed: CGFloat) {
        enemySpeed = movementSpeed
        
        chooseEnemyStance()
        initEnemyImagesForAnimation()
        
        ifEnemyDied = false
        finishedDeathAnimation = false
        imageIndex = 0
        
        let posX = screenSize.width + distance
        let posY = heroObj.getHeroView().frame.origin.y - ADDEDSIZEFORENEMIESTOLOOKBIGGERTHANHERO
        let enemyWidth = heroObj.getHeroView().frame.width + ADDEDSIZEFORENEMIESTOLOOKBIGGERTHANHERO
        let enemyHeight = heroObj.getHeroView().frame.height + ADDEDSIZEFORENEMIESTOLOOKBIGGERTHANHERO
        
        enemyImageView = UIImageView(frame: CGRectMake(posX, posY, enemyWidth, enemyHeight))
        enemyImageView.image = imageEnemyList[imageIndex]
        enemyImageView.contentMode = .ScaleAspectFit
        enemyImageView.clipsToBounds = true
    }
    
    // MARK: Private Functions
    
    private func chooseEnemyStance() {
        let randomStance = Int(arc4random_uniform(3))
        if (randomStance == 0) {
            currStance = enemyStance.ss
        }
        else if (randomStance == 1) {
            currStance = enemyStance.bow
        }
        else if (randomStance == 2) {
            currStance = enemyStance.staff
        }
        else {
            print("ERROR IN CLASS: Enemy FUNCTION: chooseEnemyStance(), should never get here")
        }
    }
    
    private func initEnemyImagesForAnimation() {
        var enemyName = ""
        var img: UIImage!
        
        if (currStance == enemyStance.ss) {
            enemyName = "enemyss"
        }
        else if (currStance == enemyStance.bow) {
            enemyName = "enemybow"
        }
        else if (currStance == enemyStance.staff) {
            enemyName = "enemystaff"
        }
        
        for i in 1...8 {
            // Increments through each hero_run image and puts it into the imageHeroRunList
            img = UIImage(named: "\(enemyName)\(i)")
            if (imageEnemyList.count == 8) {
                imageEnemyList[i-1] = img!
            }
            else {
                imageEnemyList.append(img!)
            }
        }
    }
    
    private func enemyAnimateImage() {
        // If iterates through an entire animation cycle, would go back to the first image in the list if enemy is not dead
        if (imageIndex >= imageEnemyList.count) {
            // If the enemy is dead, starts the phase for when the enemy is dead
            if (ifEnemyDied) {
                finishedDeathAnimation = true
                return
            }
            // Reset to the initial position
            imageIndex = 0
        }
        // Sets the current image of the enemy and increments to the next enemy animation image
        enemyImageView.image = imageEnemyList[imageIndex]
        imageIndex++
    }
    
    private func enemyAnimateDeath() {
        var enemyName = ""
        var img: UIImage!
        
        if (currStance == enemyStance.ss) {
            enemyName = "enemyssdeath"
            Sound.soundObj.getStaffKillEnemySound()?.play()
        }
        else if (currStance == enemyStance.bow) {
            enemyName = "enemybowdeath"
            Sound.soundObj.getSsKillEnemySound()?.play()
        }
        else if (currStance == enemyStance.staff) {
            enemyName = "enemystaffdeath"
            Sound.soundObj.getBowKillEnemySound()?.play()
        }

        for i in 1...8 {
            // Increments through each hero_run image and puts it into the imageHeroRunList
            img = UIImage(named: "\(enemyName)\(i)")
            // Replaces the image array with the death animation images
            imageEnemyList[i-1] = img!
        }
        
        imageIndex = 0
        ifEnemyDied = true
    }
    
    private func remove() {
        // Removes the enemy's image
        enemyImageView.image = nil
    }
    
    // MARK: Accessors
    
    internal func getEnemyImageView() -> UIImageView! {
        return enemyImageView!
    }
    
    internal func isDead() -> Bool{
        return ifEnemyDied
    }
    
    internal func ifFinishedDeathAnimation() -> Bool {
        return finishedDeathAnimation
    }
    
    internal func setEnemyMovementSpeed(newSpeed: CGFloat) {
        enemySpeed = newSpeed
    }
}
