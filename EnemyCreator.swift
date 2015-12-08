//
//  EnemyCreator.swift
//  Sir Prance
//
//  Created by Randy Truong on 10/15/15.
//  Copyright © 2015 Vent Origins. All rights reserved.
//

import UIKit

// CONSTANTS
let MOVEMENTSPEEDRATIOMAX = CGFloat(0.0175)
let MOVEMENTSPEEDCHANGE = CGFloat(0.0012)
let RATIOFORINCREASESPEEDCHECK = 1.4
let ROUNDUP = 1.0

class EnemyCreator {
    
    // MARK: Private Variables
    
    // Pointing to the hero
    private var heroObj: Hero!
    
    // Pointing to the score
    private var scoreObj: GameScore!
    
    // List of enemies that are alive and enemies that are dead
    private var enemyList = [Enemy]()
    // The dead list is used to reiterate through previous Enemies instead of creating more enemies, this potentially saves memory usage
    private var enemyDeadList = [Enemy]()

    // If the wave of enemies are alive or not
    // Each wave will consist a set of enemies, after all are killed, a new wave will be spanwed with a new set of stats
    private var ifWaveIsAlive = false
    
    // Amount of enemies in the wave
    private var numOfEnemiesInWave = 1
    
    // Used for screen size
    private let screenSize: CGRect = UIScreen.mainScreen().bounds
    
    // Enemies movement speed
    private var movementSpeed: CGFloat!
    private var movementSpeedRatio = CGFloat(0.01)
    
    // EVERY 1.4 times the score starting from 8
    var scoreToIncreaseSpeedOn = 8
    
    // MARK: Public Functions
    
    init(heroObj: Hero, scoreObj: GameScore) {
        self.heroObj = heroObj
        self.scoreObj = scoreObj
        movementSpeed = screenSize.width * movementSpeedRatio
    }
    
    func update() {
        // When every enemy in the list is killed, the wave is not alive
        if (enemyList.count <= 0) {
            ifWaveIsAlive = false
        }
        // Otherwise, the wave is alive
        else {
            ifWaveIsAlive = true
        }
        
        chooseMovementSpeedInWave()
        
        // If there are enemies, updates each enemy in the list
        for var i = 0; i < enemyList.count; ++i {
            enemyList[i].setEnemyMovementSpeed(movementSpeed)
            enemyList[i].update()
            
            // If enemies finished dying, removes the enemy from the list and adds it to the dead enemy list
            if (enemyList.last!.ifFinishedDeathAnimation()) {
                enemyDeadList.append(enemyList.last!)
                enemyList.removeLast()
            }
        }

    }
    
    func animateUpdate() {
        // Does the animate update of every enemy in the list
        for var i = 0; i < enemyList.count; ++i {
            enemyList[i].animateUpdate()
        }
    }
    
    func waveSpawningWhenWaveIsNotAlive() -> Bool{
        // Do not spawn enemies if there exists a wave that is still alive
        if (ifWaveIsAlive) {
            return false
        }
        
        // Sets the enemy movement speed in the wave
        chooseMovementSpeedInWave()
        
        // Sets the number of enemies in the wave
        let enemiesInWave = chooseNumOfEnemiesInWave()
        
        // Given distance
        var distance = CGFloat(0.0)
        
        // When spawning the enemies in the wave, set them a distance a part from each other
        // Puts enemies that come first at the end of the list and enemies that come last at the front of the list
        // Do this in order for O(1) access and removal for end of list changes
        for var i = enemiesInWave - 1; i >= 0; --i {
            // Used for the very first enemy in the wave
            if (i == enemiesInWave - 1) {
                // Do Nothing
            }
            else {
                distance = findDistanceBetweenEnemies(distance)
            }
            
            // Adds the new enemy into the very beginning of the list for O(1) access
            if (enemyDeadList.count > 0) {
                
                enemyDeadList[0].enemyRespawn(distance, movementSpeed: movementSpeed)
                enemyList.insert(enemyDeadList[0], atIndex: 0)
                enemyDeadList.removeAtIndex(0)
            }
            // If there are no enemies in the dead list, create a new enemy and adds it to beginning of the list for O(1) access
            else {
                enemyList.insert(Enemy(distance: distance, movementSpeed: movementSpeed, hero: heroObj), atIndex: 0)
            }
        }
        
        // If there are no waves, spawn a new wave of enemies
        return true
    }
    
    // MARK: Private Helper Functions
    
    // Chooses the movement speed for every enemy in the wave
    private func chooseMovementSpeedInWave() {
        // Only increases speed whenever the score is high enough to increase the speed
        if (scoreObj.getScore() < scoreToIncreaseSpeedOn) {
            return
        }
        // Rounds up the number of the score to increase speed on
        scoreToIncreaseSpeedOn = Int(Double(scoreToIncreaseSpeedOn) * RATIOFORINCREASESPEEDCHECK + ROUNDUP)
        
        // Increases the speed by a ratio. Continues to increase the speed until hitting the movement speed max
        if (movementSpeedRatio <= MOVEMENTSPEEDRATIOMAX) {
            movementSpeedRatio = movementSpeedRatio + MOVEMENTSPEEDCHANGE
        }
        movementSpeed = screenSize.width * movementSpeedRatio
    }
    
    // Chooses a random number of enemies in a wave
    private func chooseNumOfEnemiesInWave() -> Int {
        // Whenever the score is divisible by 3, increase the potential number of enemies in a wave
        if (scoreObj.getScore() % 3 == 0) {
            numOfEnemiesInWave++
        }
        return Int(arc4random_uniform(UInt32(numOfEnemiesInWave))) + 1
    }
    
    // This is the old method of finding the enemies given each enemy already has a default given position in respect to their position in the array
    private func findDistanceBetweenEnemies(i: Int) -> CGFloat {
        let randPos = arc4random_uniform(10)
        if(randPos < 4) {
            return (CGFloat(i) * (heroObj.getHeroView().frame.width * 1.5))
        }
        else if (randPos >= 4 && randPos < 8){
            return (CGFloat(i) * (heroObj.getHeroView().frame.width * 1.5)) + (heroObj.getHeroView().frame.width / 1.5)
        }
        else {
            return (CGFloat(i) * (heroObj.getHeroView().frame.width * 1.5)) + CGFloat(arc4random_uniform(UInt32(heroObj.getHeroView().frame.width / 1.5)))
        }
    }
    
    // Returns the appropriate distance of the previous enemy to the current enemy
    private func findDistanceBetweenEnemies(prevEnemyDistance: CGFloat) -> CGFloat {
        return prevEnemyDistance + (heroObj.getHeroView().frame.width * 0.8) + CGFloat(arc4random_uniform(UInt32(heroObj.getHeroView().frame.width / 1.5)))
    }
    
    // MARK: Accessors

    internal func getNewestEnemyInList() -> Enemy {
        return enemyList[enemyList.count - 1]
    }
    
    internal func getEnemyList() -> [Enemy] {
        return enemyList
    }
    
    internal func getEnemiesMovementSpeed() -> CGFloat {
        return movementSpeed
    }
    
    // MARK: Setters
    
    internal func setWaveIsAlive(ifWaveIsAlive: Bool) {
        self.ifWaveIsAlive = ifWaveIsAlive
    }
    
    internal func setEnemiesMovementSpeed(newSpeed: CGFloat) {
        self.movementSpeed = newSpeed
    }
}
