//
//  GameSound.swift
//  Sir Prance
//
//  Created by Randy Truong on 11/6/15.
//  Copyright © 2015 Vent Origins. All rights reserved.
//

import UIKit
import AVFoundation

// MARK: CONSTANTS
let INFINITE = -1
let ONCE = 0
let VOLUME: Float = 0.3

// MARK: Global Sound Object
struct Sound {
    static let soundObj = GameSound()
}

class GameSound {
    
    // MARK: Private variables
    
    //Sounds
    private var ssSound: AVAudioPlayer?
    private var bowSound: AVAudioPlayer?
    private var staffSound: AVAudioPlayer?
    
    private var ssKillEnemySound: AVAudioPlayer?
    private var bowKillEnemySound: AVAudioPlayer?
    private var staffKillEnemySound: AVAudioPlayer?
    
    // In Game Music
    private var menuMusic: AVAudioPlayer?
    private var gameMusic: AVAudioPlayer?
    private var scoreScreenMusic: AVAudioPlayer?
    
    init() {
        // Initializes all of the sounds and music
        
        if let sound = self.setupAudioPlayerWithFile("SwordSwing", type: "wav") {
            ssSound = sound
            ssSound?.volume = VOLUME
            ssSound?.numberOfLoops = ONCE
        }
        
        if let sound = self.setupAudioPlayerWithFile("ArrowRelease", type: "wav") {
            bowSound = sound
            bowSound?.volume = VOLUME
            bowSound?.numberOfLoops = ONCE
        }
        
        if let sound = self.setupAudioPlayerWithFile("StaffCast", type: "wav") {
            staffSound = sound
            staffSound?.volume = VOLUME
            staffSound?.numberOfLoops = ONCE
        }
        
        if let sound = self.setupAudioPlayerWithFile("ss", type: "wav") {
            ssKillEnemySound = sound
            ssKillEnemySound?.volume = VOLUME
            ssKillEnemySound?.numberOfLoops = ONCE
        }
        
        if let sound = self.setupAudioPlayerWithFile("arrow", type: "wav") {
            bowKillEnemySound = sound
            bowKillEnemySound?.volume = VOLUME
            bowKillEnemySound?.numberOfLoops = ONCE
        }
        
        if let sound = self.setupAudioPlayerWithFile("StaffHit", type: "wav") {
            staffKillEnemySound = sound
            staffKillEnemySound?.volume = VOLUME
            staffKillEnemySound?.numberOfLoops = ONCE
        }
        
        if let music = self.setupAudioPlayerWithFile("title", type: "wav") {
            menuMusic = music
            menuMusic?.volume = VOLUME
            menuMusic?.numberOfLoops = INFINITE
        }
        
        if let music = self.setupAudioPlayerWithFile("BattleLoop", type: "wav") {
            gameMusic = music
            gameMusic?.volume = VOLUME
            gameMusic?.numberOfLoops = INFINITE
        }
        
        if let music = self.setupAudioPlayerWithFile("death", type: "wav") {
            scoreScreenMusic = music
            scoreScreenMusic?.volume = VOLUME
            scoreScreenMusic?.numberOfLoops = INFINITE
        }
    }
    
    // MARK: Accessor Helper Functions
    
    private func setupAudioPlayerWithFile(file:NSString, type:NSString) -> AVAudioPlayer?  {
        // Sets the audio with the correct audio
        let path = NSBundle.mainBundle().pathForResource(file as String, ofType: type as String)
        let url = NSURL.fileURLWithPath(path!)
        var audioPlayer: AVAudioPlayer?
        
        do {
            try audioPlayer = AVAudioPlayer(contentsOfURL: url)
        }
        catch {
            print("Player not available")
        }
        
        return audioPlayer
    }
    
    // MARK: ACCESSORS
    
    // MARK: Accessor: Regular Attack Sounds
    func getSsSound() -> AVAudioPlayer? {
        ssSound?.currentTime = 0
        return ssSound
    }
    func getBowSound() -> AVAudioPlayer? {
        bowSound?.currentTime = 0
        return bowSound
    }
    func getStaffSound() -> AVAudioPlayer? {
        staffSound?.currentTime = 0
        return staffSound
    }
    
    // MARK: Accessor: Killing Sounds
    func getSsKillEnemySound() -> AVAudioPlayer? {
        ssKillEnemySound?.currentTime = 0
        return ssKillEnemySound
    }
    func getBowKillEnemySound() -> AVAudioPlayer? {
        bowKillEnemySound?.currentTime = 0
        return bowKillEnemySound
    }
    func getStaffKillEnemySound() -> AVAudioPlayer? {
        staffKillEnemySound?.currentTime = 0
        return staffKillEnemySound
    }
    
    // MARK: Accessor: In Game Music
    func getMenuMusic() -> AVAudioPlayer? {
        return menuMusic
    }
    func getGameMusic() -> AVAudioPlayer? {
        return gameMusic
    }
    func getScoreScreenMusic() -> AVAudioPlayer? {
        return scoreScreenMusic
    }
    
    func stopMusic() {
        // Stops every music soundtrack as well as reset them to the beginning
        menuMusic?.stop()
        gameMusic?.stop()
        scoreScreenMusic?.stop()
        
        menuMusic?.currentTime = 0
        gameMusic?.currentTime = 0
        scoreScreenMusic?.currentTime = 0
    }
}
