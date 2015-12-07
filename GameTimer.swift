//
//  GameTimer.swift
//  Sir Prance
//
//  Created by Randy Truong on 10/28/15.
//  Copyright © 2015 Vent Origins. All rights reserved.
//

import UIKit

class Timer {
    
    // MARK: Private Variables
    private var gameObj: Game!
    private var displayLink: CADisplayLink!
    
    init(game: Game) {
        gameObj = game
    }
    
    func startGameTimer() {
        // If App is in Active state, continue
        if (!SirPranceState.ifInActiveState) {
            return
        }
        
        //Start the timer
        displayLink = CADisplayLink(target: self, selector: "timerTick")
        displayLink.addToRunLoop(NSRunLoop.currentRunLoop(), forMode: NSRunLoopCommonModes)
    }

    @objc func timerTick() {
        if (gameObj.gameUpdate()) {
            self.displayLink.invalidate()
        }
    }
    
    func timerStop() {
        displayLink.invalidate()
    }
    
    // MARK: Accessors
    
    func getTimer() -> CADisplayLink {
        return displayLink
    }
}
