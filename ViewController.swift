//
//  Menu.swift
//  Sir Prance
//
//  Created by Randy Truong on 10/2/15.
//  Copyright © 2015 Vent Origins. All rights reserved.
//

import UIKit
import AVFoundation

// State of Sir Prance
struct SirPranceState {
    static var ifInActiveState = true
}

class ViewController: UIViewController {
    
    // MARK: UIViews
    var groundImageView: UIImageView!
    var groundImageViewRight: UIImageView!
    var heroImageView: UIImageView!
    var titleImageView: UIImageView!
    var startButtonView: UIButton!
    var rulesButtonView: UIButton!
    var rulesImageView: UIImageView!
    var invisibleButton: UIButton!
    
    // MARK: Private Variables
    private var ifAlreadyFadedIn = false
    private var transitionObj: Transitions!
    
    // MARK: Public Variables
    var imageList = [UIImage]()
    let screenSize: CGRect = UIScreen.mainScreen().bounds
    
    // MARK: Overridden functions
    override func viewDidLoad() {
        super.viewDidLoad()
        // Initializes the menu
        menuInit()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)

        // Sets the handlers for exitting and entering app
        setUIApplications()

        // Animates the ground and the fade into the menu
        if (!ifAlreadyFadedIn) {
            ifAlreadyFadedIn = true
            groundAnimate()
            transitionObj.fadeIn(self)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        
        groundImageView = nil
        groundImageViewRight = nil
        heroImageView = nil
        titleImageView = nil
        startButtonView = nil
        rulesButtonView = nil
        rulesImageView = nil
        invisibleButton = nil
        transitionObj = nil
        imageList = [UIImage]()
    }
    
    // MARK: UIApplication functions
    
    func setUIApplications() {
        // Used to set up the event handlers for moving in and out of the app
        
        // When app is in foreground
        NSNotificationCenter.defaultCenter().addObserver(
            self,
            selector: "onApplicationActive",
            name: UIApplicationDidBecomeActiveNotification,
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
        startAllAnimation()
        Sound.soundObj.getMenuMusic()?.play()
    }
    
    @objc func onApplicationBackground() {
        SirPranceState.ifInActiveState = false
        stopAllAnimation()
        Sound.soundObj.stopMusic()
    }
    
    func startAllAnimation() {
        heroStartAnimation()
        groundAnimate()
    }
    
    func stopAllAnimation() {
        heroStopAnimation()
        groundStopAnimation()
    }
    
    // MARK: Initialization functions
    
    func menuInit() {        
        // Views
        initGroundSize()
        initHeroSize()
        initGameTitle()
        initStartButtonSize()
        initRulesButtonSize()
        initHeroImagesForAnimation()
        heroStartAnimation()

        // Transitions
        transitionObj = Transitions()
        self.view.addSubview(transitionObj.getWhiteBackgroundImageView())
        
        // Sound
        Sound.soundObj.stopMusic()
        Sound.soundObj.getMenuMusic()?.play()
    }
    
    func initGroundSize() {
        // Creates a UIImage which is gameground.png
        let groundImage = UIImage(named: "gameground")
        
        // Creates the image at the bottom of the screen
        groundImageView = UIImageView(frame: CGRectMake(0, screenSize.height * 0.90, screenSize.width, 0.10 * screenSize.height))
        groundImageView.image = groundImage
        groundImageView.contentMode = .ScaleToFill
        groundImageView.clipsToBounds = true
        
        // Creates the second groundImage in order for the scroll of the ground to look infinite
        groundImageViewRight = UIImageView(frame: CGRectMake(screenSize.width, screenSize.height * 0.90, screenSize.width, 0.10 * screenSize.height))
        groundImageViewRight.image = groundImage
        groundImageViewRight.contentMode = .ScaleToFill
        groundImageViewRight.clipsToBounds = true
        
        // Adds the views
        self.view.addSubview(groundImageView)
        self.view.addSubview(groundImageViewRight)
    }
    
    func initHeroSize() {
        // Creates a UIImage which is hero_run1.png
        let heroImage = UIImage(named: "hero_run1")
        
        // Arguments used for the UIImageView Constructor
        let posX = (screenSize.width / 2) - (screenSize.width * 0.08)
        let posY = screenSize.height * 0.68
        let heroWidth = screenSize.width * 0.24
        let heroHeight = screenSize.height * 0.28
        
        //Creates the hero image at its specified position and size
        heroImageView = UIImageView(frame: CGRectMake(posX, posY, heroWidth, heroHeight))
        heroImageView.image = heroImage
        heroImageView.clipsToBounds = true
        
        // Adds the view
        self.view.addSubview(heroImageView)
    }
    
    func initGameTitle() {
        // Sets the arguments for the UIImage
        let titleWidth = screenSize.width * 0.60
        let titleHeight = screenSize.height * 0.25
        let posX = (screenSize.width / 2) - (titleWidth / 2)
        let posY = screenSize.height * 0.05
        
        // Creates the title image view
        titleImageView = UIImageView(frame: CGRectMake(posX, posY, titleWidth, titleHeight))
        titleImageView.image = UIImage(named: "title")
        titleImageView.contentMode = .ScaleAspectFit
        
        // Adds the view into the storyboard
        self.view.addSubview(titleImageView)
    }
    
    func initStartButtonSize() {
        // Sets the arguments for the UIButton
        let startButtonWidth = screenSize.width * 0.23
        let startButtonHeight = screenSize.height * 0.15
        let posX = (screenSize.width / 2) - (startButtonWidth / 2)
        let posY = screenSize.height * 0.32
        
        // Creates the background images for the idle and pressed states of the button
        startButtonView = UIButton(frame: CGRectMake(posX, posY, startButtonWidth, startButtonHeight))
        let startButtonImageIdle = UIImage(named: "startbutton_idle")
        let startButtonImagePressed = UIImage(named: "startbutton_pressed")
        startButtonView.setBackgroundImage(startButtonImageIdle, forState: .Normal)
        startButtonView.setBackgroundImage(startButtonImagePressed, forState: .Selected)
        
        // When button is pressed, go to function startButtonIsPressed()
        startButtonView.addTarget(self, action: "startButtonIsPressed", forControlEvents: .TouchUpInside)
        
        // Adds the view into the storyboard
        self.view.addSubview(startButtonView)
    }
    
    func initRulesButtonSize() {
        // Sets the arguments for the UIButton
        let rulesButtonWidth = screenSize.width * 0.23
        let rulesButtonHeight = screenSize.height * 0.15
        let posX = (screenSize.width / 2) - (rulesButtonWidth / 2)
        let posY = screenSize.height * 0.50
        
        // Creates the background images for the idle and pressed states of the button
        rulesButtonView = UIButton(frame: CGRectMake(posX, posY, rulesButtonWidth, rulesButtonHeight))
        let rulesButtonImageIdle = UIImage(named: "rules_idle")
        let rulesButtonImagePressed = UIImage(named: "rules_pressed")
        rulesButtonView.setBackgroundImage(rulesButtonImageIdle, forState: .Normal)
        rulesButtonView.setBackgroundImage(rulesButtonImagePressed, forState: .Selected)
        
        // When button is pressed, go to function rulesButtonIsPressed()
        rulesButtonView.addTarget(self, action: "rulesButtonIsPressed", forControlEvents: .TouchUpInside)
        
        // Adds the view into the storyboard
        self.view.addSubview(rulesButtonView)
    }
    
    func startButtonIsPressed() {
        // Removes the ability to press the start button while transitioning to the game view
        startButtonView.removeTarget(self, action: "startButtonIsPressed", forControlEvents: .TouchUpInside)
        rulesButtonView.removeTarget(self, action: "rulesButtonIsPressed", forControlEvents: .TouchUpInside)
        
        // Go to the next view by fading into the white screen
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let gameViewControllerObject = storyboard.instantiateViewControllerWithIdentifier("Game") as? Game
        transitionObj.fadeOut(self, gameViewControllerObject: gameViewControllerObject!)
    }
    
    func rulesButtonIsPressed() {
        // Sets the arguments for the UIImageView
        let rulesWidth = screenSize.width * 0.45
        let rulesHeight = screenSize.height * 0.90
        let posX = (screenSize.width / 2) - (rulesWidth / 2)
        let posY = screenSize.height * 0.05
        
        // Creates the rules image view
        rulesImageView = UIImageView(frame: CGRectMake(posX, posY, rulesWidth, rulesHeight))
        rulesImageView.image = UIImage(named: "rules")
        rulesImageView.contentMode = .ScaleAspectFill
        
        // Creates the invisible button throughout the entire screen view
        invisibleButton = UIButton(frame: CGRectMake(0, 0, screenSize.width, screenSize.height))
        invisibleButton.addTarget(self, action: "removeRulesFromView", forControlEvents: .TouchUpInside)
        
        // Adds the view into the storyboard
        self.view.addSubview(rulesImageView)
        self.view.addSubview(invisibleButton)
    }
    
    func removeRulesFromView() {
        // When screen is tapped when the rules are displayed, removes the rules display
        rulesImageView.removeFromSuperview()
        invisibleButton.removeFromSuperview()
    }

    func initHeroImagesForAnimation() {
        // Increments through each hero_run image and puts it into the imageList
        for i in 1...8 {
            let heroName = "hero_run\(i)"
            let img = UIImage(named: "\(heroName)")
            imageList.append(img!)
        }
    }
    
    func groundAnimate() {
        // Sets the initial ground position
        self.groundImageView.frame = CGRect(x: 0.0, y: self.screenSize.height * 0.90, width: self.screenSize.width + CGFloat(10.0), height: 0.10 * self.screenSize.height)
        self.groundImageViewRight.frame = CGRect(x: screenSize.width, y: self.screenSize.height * 0.90, width: self.screenSize.width + CGFloat(10.0), height: 0.10 * self.screenSize.height)
        
        //Animates the ground
        UIView.animateWithDuration(3.0, delay: 0.0, options: [.Repeat, .CurveLinear], animations: {
            // any changes entered in this block will be animated
            self.groundImageView.frame = CGRect(x: -self.screenSize.width, y: self.screenSize.height * 0.90, width: self.screenSize.width + CGFloat(10.0), height: 0.10 * self.screenSize.height)
            self.groundImageViewRight.frame = CGRect(x: 0.0, y: self.screenSize.height * 0.90, width: self.screenSize.width + CGFloat(10.0), height: 0.10 * self.screenSize.height)
        }, completion: nil)
    }
    
    func groundStopAnimation() {
        self.groundImageView.layer.removeAllAnimations()
        self.groundImageViewRight.layer.removeAllAnimations()
    }
    
    func heroStartAnimation() {
        // Animates the hero
        heroImageView.animationImages = imageList
        heroImageView.animationDuration = 0.5
        heroImageView.startAnimating()
    }
    
    func heroStopAnimation() {
        heroImageView.stopAnimating()
    }
}

