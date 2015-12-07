//
//  Game.swift
//  Sir Prance
//
//  Created by Randy Truong on 10/5/15.
//  Copyright © 2015 Vent Origins. All rights reserved.
//

import UIKit
import AVFoundation

class Game: UIViewController {
    
    // MARK: Private Variables
    
    // Tick counters
    private let heroTicks = 3
    private let enemyTicks = 3
    private let enemyUpdateTicks = 2
    private let natureTicks = 10
    private var heroTickCount = 0
    private var enemyTickCount = 0
    private var enemyTickUpdateCount = 0
    private var natureTicksCount = 0
    
    // MARK: UIViews
    @IBOutlet private var backgroundImage: UIImageView!
    
    // MARK: Objects
    private var timerObj: Timer!
    private var backgroundObj: Background!
    private var natureObj: Nature!
    private var buttonsObj: Buttons!
    private var groundObj: Ground!
    private var scoreObj: GameScore!
    private var heroObj: Hero!
    private var enemyObj: EnemyCreator!
    private var transitionObj: Transitions!
    
    // The x position in where the hero touches an enemy
    private var heroCollidingPos: CGFloat!
    private var heroCollidingDeadPos: CGFloat!
    
    // In order for viewDidAppear to only get called once
    private var ifAlreadyFadedIn = false

    // If the hero animations are going, do not let the buttons have an event to them
    // A spam of button events causes the entire game to lag
    private var ifButtonsDisabled = false
    
    // When game begins, sets this to true
    private var ifGameBegins = false
    
    // When game is over, sets this to false
    private var ifGameOver = false
    private var ifGameOverIsDone = false
    
    // Screen size
    private let screenSize: CGRect = UIScreen.mainScreen().bounds
    
    // MARK: Overriden functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // Initializes the game
        gameInit()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        // Sets the handlers for exitting and entering app
        setUIApplications()

        if (!ifAlreadyFadedIn) {
            ifAlreadyFadedIn = true
            transitionObj.fadeIn(self)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        
        timerObj = nil
        backgroundObj = nil
        natureObj = nil
        buttonsObj = nil
        groundObj = nil
        scoreObj = nil
        heroObj = nil
        enemyObj = nil
        transitionObj = nil
    }
    
    // MARK: UIApplication functions
    
    func setUIApplications() {
        // Used to set up the event handlers for moving in and out of the app
        
        // When app is in foreground
        NSNotificationCenter.defaultCenter().addObserver(
            self,
            selector: "onApplicationActive",
            name: UIApplicationWillEnterForegroundNotification,
            object: nil )
        
        // When app is in background
        NSNotificationCenter.defaultCenter().addObserver(
            self,
            selector: "onApplicationBackground",
            name: UIApplicationDidEnterBackgroundNotification,
            object: nil )
    }
    
    @objc func onApplicationActive() {
        SirPranceState.ifInActiveState = true
        startGame()
        // If the game is over, play the game over music instead of the game music
        if (!ifGameOver) {
            Sound.soundObj.getGameMusic()?.play()
        }
        else {
            Sound.soundObj.getScoreScreenMusic()?.play()
        }
    }
    
    @objc func onApplicationBackground() {
        SirPranceState.ifInActiveState = false
        stopGame()
        Sound.soundObj.stopMusic()
    }
    
    func startGame() {
        if (!ifGameOverIsDone) {
            timerObj.startGameTimer()
        }
        else {
            gameOver()
        }
    }
    
    func stopGame() {
        timerObj.getTimer().invalidate()
    }
    
    // MARK: Initialization functions
    
    func gameInit() {
        timerObj = Timer(game: self)
        backgroundObj = Background(backgroundImage: backgroundImage)
        groundObj = Ground()
        natureObj = Nature(groundObj: groundObj)
        buttonsObj = Buttons(groundObj: groundObj)
        scoreObj = GameScore()
        heroObj = Hero(groundObj: groundObj)
        enemyObj = EnemyCreator(heroObj: heroObj, scoreObj: scoreObj)
        transitionObj = Transitions()
        gameRender()
        
        // The position set for where the enemy and hero (In attack position) meet
        heroCollidingPos = heroObj.getHeroView().frame.origin.x + (heroObj.getHeroView().frame.width / 2)
        
        // This is the position for where the enemy and hero meet if not in attack stance
        heroCollidingDeadPos = heroObj.getHeroView().frame.origin.x + (heroObj.getHeroView().frame.width / 5)
        
        Sound.soundObj.stopMusic()
        Sound.soundObj.getGameMusic()?.play()
        
        // Start the timer for the game updates
        timerObj.startGameTimer()
    }
    
    // MARK: Update function
    
    func gameUpdate() -> Bool {
        // When the game is over, returns true for the ticks to end
        if (ifGameOverIsDone) {
            return true
        }
        
        // When the hero is fully dead, goes to set the game to be over
        if (ifGameOver && heroObj.getIfHeroIsFullyDead()) {
            heroObj.setIfHeroIsFullyDead(false)
            gameOver()
        }
        
        // The hero portion is put before the game starts because we want the hero to be moving before the enemies spawn
        
        // Hero
        if (heroTickCount == heroTicks) {
            heroTickCount = 0
            heroObj.update()
        }
        heroTickCount++

        // If buttons are disabled, reactivate them
        if (ifGameOver) {
            removeAbilityToButtonPress()
        }
        else {
            enableButtonsIfDisabled()
        }
        
        // When the game did not start yet, does not update the game with ticks
        if (!ifGameBegins) {
            return false
        }
        
        // Nature and ground
        if (natureTicksCount == natureTicks) {
            natureTicksCount = 0
            // Nature
            natureObj.update()
        }
        
        // Ground
        groundObj.update()
        
        // Enemies
        if (enemyTickUpdateCount == enemyUpdateTicks) {
            enemyTickUpdateCount = 0
            if (enemyObj.waveSpawningWhenWaveIsNotAlive()) {
                for var i = 0; i < enemyObj.getEnemyList().count; ++i {
                    self.view.addSubview(enemyObj.getEnemyList()[i].getEnemyImageView())
                }
            }
            enemyObj.update()
        }
        
        if (enemyTickCount == enemyTicks) {
            enemyTickCount = 0
            enemyObj.animateUpdate()
        }
        
        if (!ifGameOver) {
            checkAllCollisions()
        }
        
        // Increments the ticks for each view
        enemyTickCount++
        enemyTickUpdateCount++
        natureTicksCount++
        
        return false
    }
    
    // MARK Collision updates
    
    func checkAllCollisions() {
        // Checks if there are any enemies
        if (enemyObj.getEnemyList().count <= 0) {
            return
        }
        
        // Get the two enemies closest to the hero
        for (var i = enemyObj.getEnemyList().count-1; i >= enemyObj.getEnemyList().count - 2 && i >= 0; i--) {
            // The position of the enemy
            let enemyCollidingPos = enemyObj.getEnemyList()[i].getEnemyImageView().frame.origin.x

            // This first check is to see if the hero's attack stance comes in contact with the enemy
            // If an enemy is in contact with the hero, checks which stance the hero and enemy is in
            if (heroCollidingPos >= enemyCollidingPos) {
                // If the stance for the hero beats the stance of the enemy, kills off the enemy
                if (enemyObj.getEnemyList()[i].ifHeroStanceKillsEnemy() && !enemyObj.getEnemyList()[i].isDead()) {
                    enemyObj.getEnemyList()[i].enemyBeginsToDie()
                    scoreObj.setScore(scoreObj.getScore() + 1)
                }
            
                // This second check is to see the collision in where the enemy may potentially kill of the hero if close enough and in the incorrect stance
                // If the stance for the hero loses to the stance of the enemy, kills off the hero and goes to the game over view
                else {
                    // If the hero collides with the enemy while in the wrong stance, kills the hero and game overs
                    if (heroCollidingDeadPos >= enemyCollidingPos) {
                        if (heroObj.getIfHeroIsAlive() && !enemyObj.getEnemyList()[i].isDead()) {
                            ifGameOver = true
                            Sound.soundObj.stopMusic()
                            Sound.soundObj.getScoreScreenMusic()?.play()
                            heroObj.heroAnimateDeath()
                        }
                    }
                }
            }
        }
    }
    
    func gameRender() {
        // Background is already in the storyboard
        
        // Nature
        self.view.addSubview(natureObj.getNatureImage())
        self.view.addSubview(natureObj.getNatureRightImage())
        
        // Ground
        self.view.addSubview(groundObj.getGroundView())
        self.view.addSubview(groundObj.getGroundRightView())
        self.view.addSubview(groundObj.getGroundBackgroundView())
        
        // Buttons 
        enableButtonsIfDisabled()
        buttonsObj.getSSImageButtonView().addTarget(self, action: "heroSSAnimate", forControlEvents: .TouchUpInside)
        buttonsObj.getBowImageButtonView().addTarget(self, action: "heroBowAnimate", forControlEvents: .TouchUpInside)
        buttonsObj.getStaffImageButtonView().addTarget(self, action: "heroStaffAnimate", forControlEvents: .TouchUpInside)
        self.view.addSubview(buttonsObj.getSSImageButtonView())
        self.view.addSubview(buttonsObj.getBowImageButtonView())
        self.view.addSubview(buttonsObj.getStaffImageButtonView())
        
        // Score Text
        self.view.addSubview(scoreObj.getScoreTextView())
        
        // Hero
        self.view.addSubview(heroObj.getHeroView())
        
        // White fading in screen
        self.view.addSubview(transitionObj.getWhiteBackgroundImageView())
        
        // Enemies are rendered via the update function
    }
    
    func gameOver() {
        // Go to the score screen view
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let gameViewControllerObject = storyboard.instantiateViewControllerWithIdentifier("ScoreScreen") as? ScoreScreen
        gameViewControllerObject?.setScoreAndHighestScore(scoreObj.getScore())
        transitionObj.fadeOut(self, gameViewControllerObject: gameViewControllerObject, timer: timerObj.getTimer())
    }
    
    // MARK: Event functions for when a button is clicked
    
    func heroSSAnimate() {
        if (!heroObj.getIfCurrInAttackStance()) {
            removeAbilityToButtonPress()
            heroObj.heroSSAnimating()
        }
    }
    
    func heroBowAnimate() {
        if (!heroObj.getIfCurrInAttackStance()) {
            removeAbilityToButtonPress()
            heroObj.heroBowAnimating()
        }
    }
    
    func heroStaffAnimate() {
        if (!heroObj.getIfCurrInAttackStance()) {
            removeAbilityToButtonPress()
            heroObj.heroStaffAnimating()
        }
    }
    
    // MARK: These functions are necessary to deal with lag when the buttons are pressed quickly and continously
    
    func removeAbilityToButtonPress() {
        ifButtonsDisabled = true
        buttonsObj.getSSImageButtonView().removeTarget(self, action: "heroSSAnimate", forControlEvents: .TouchUpInside)
        buttonsObj.getBowImageButtonView().removeTarget(self, action: "heroBowAnimate", forControlEvents: .TouchUpInside)
        buttonsObj.getStaffImageButtonView().removeTarget(self, action: "heroStaffAnimate", forControlEvents: .TouchUpInside)
    }
    
    func enableButtonsIfDisabled() {
        if (heroObj.getIfCurrInAttackStance()) {
            if (ifButtonsDisabled == true) {
                buttonsObj.getSSImageButtonView().addTarget(self, action: "heroSSAnimate", forControlEvents: .TouchUpInside)
                buttonsObj.getBowImageButtonView().addTarget(self, action: "heroBowAnimate", forControlEvents: .TouchUpInside)
                buttonsObj.getStaffImageButtonView().addTarget(self, action: "heroStaffAnimate", forControlEvents: .TouchUpInside)
                ifButtonsDisabled = false
            }
        }
    }
    
    // MARK: Accessors
    
    func getIfGameBegins() -> Bool {
        return ifGameBegins
    }
    
    func getIfGameOver() -> Bool {
        return ifGameOver
    }
    
    func getIfGameOverIsDone() -> Bool {
        return ifGameOverIsDone
    }
    
    // MARK: Mutators
    
    func setIfGameBegins(ifGameBegins: Bool) {
        self.ifGameBegins = ifGameBegins
    }
    
    func setIfGameOver(ifGameOver: Bool) {
        self.ifGameOver = ifGameOver
    }
    
    func setIfGameOverIsDone(ifGameOverIsDone: Bool) {
        self.ifGameOverIsDone = ifGameOverIsDone
    }
}