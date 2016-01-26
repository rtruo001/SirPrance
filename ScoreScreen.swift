//
//  ScoreScreen.swift
//  Sir Prance
//
//  Created by Randy Truong on 10/15/15.
//  Copyright © 2015 Vent Origins. All rights reserved.
//

//import iAd
import UIKit
import AVFoundation
import GoogleMobileAds

// If using iADs
//class ScoreScreen: UIViewController, ADBannerViewDelegate {
class ScoreScreen: UIViewController, GADBannerViewDelegate {
    
    // MARK: Private Variables
    
    // UI Views
    private var bannerView: UIImageView!

    // IAd
//    private var adView: ADBannerView!
    // Admob
    private var adView: GADBannerView!
    
    private var scoreTextView: UITextView!
    private var highestScoreTextView: UITextView!
    private var replayButtonView: UIButton!
    private var menuButtonView: UIButton!
    
    // Deals with entering and exiting the Score Screen view
    private var ifAlreadyFadedIn = false
    private var ifFadingOut = false;
    
    // Objects
    private var transitionObj: Transitions!
    
    // Used for screen size
    private var score = 0
    private var highestScore = 0
    private let screenSize: CGRect = UIScreen.mainScreen().bounds
    
    // MARK: Overriden functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Initializes the score screen
        scoreScreenInit()
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
        print("Active")
        addButtonTargets()
        SirPranceState.ifInActiveState = true
        Sound.soundObj.getScoreScreenMusic()?.play()
    }
    
    @objc func onApplicationBackground() {
        print("Background")
        removeButtonTargets()
        SirPranceState.ifInActiveState = false
        Sound.soundObj.stopMusic()
    }
    
    // MARK: iADs event handlers
    
//    func bannerViewActionShouldBegin(banner: ADBannerView!, willLeaveApplication willLeave: Bool) -> Bool {
//        // When ad is tapped while in the middle of leaving the score screen view
//        if (ifFadingOut) {
//            return false
//        }
//        
//        // Tap to view the ad
//        removeButtonTargets()
//        Sound.soundObj.stopMusic()
//        return true
//    }
//    
//    func bannerViewActionDidFinish(banner: ADBannerView!) {
//        // Return back to the App after exiting app
//        addButtonTargets()
//        Sound.soundObj.getScoreScreenMusic()?.play()
//    }
//    
//    func bannerViewDidLoadAd(banner: ADBannerView!) {
//        self.adView?.hidden = false
//    }
//    
//    func bannerView(banner: ADBannerView!, didFailToReceiveAdWithError error: NSError!) {
//        self.adView?.hidden = true
//    }
    
    // MARK: ADMOB event handlers
    
    func adViewDidReceiveAd(bannerView: GADBannerView!) {
        // If the ad is loaded, reveals the ad
        adView.hidden = false
    }
    
    // Actually not called, UIApplicationBackground actually gets called over this function
    func adViewWillPresentScreen(bannerView: GADBannerView!) {
        // When the game exits to the full screen ad
        print("Leaving to Ad")
        onApplicationBackground()
    }
    
    // MARK: Init functions
    
    func scoreScreenInit() {
        bannerInit()
        scoreInit()
        highestScoreInit()
        replayButtonInit()
        menuButtonInit()
        transitionObj = Transitions()
        scoreScreenRender()
    }
    
    private func bannerInit() {
        adView = GADBannerView.init(adSize: kGADAdSizeBanner)
        
//        IAd
//        adView = GADBannerView(frame: CGRect.zero)

        // Initializes the ad, the size of the ad is built during runtime
        adView.center = CGPoint(x: screenSize.width / 2, y: adView.frame.size.height / 2)
        // Used for when ad is loading, it will has the same color as the banner
        adView.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.0)
        // Need this line for ads to call the event functions

//        IAd
//        adView = ADBannerView(frame: CGRect.zero)
//        self.canDisplayBannerAds = true
//        self.adView?.delegate = self
//        self.adView?.hidden = true
        

        print("Google Mobile Ads SDK version: " + GADRequest.sdkVersion())
        // TESTING
//        adView.adUnitID = "ca-app-pub-3940256099942544/2934735716"
        // REAL
        adView.adUnitID = "ca-app-pub-3408865786344995/1644061664"

        self.adView?.delegate = self
        adView.rootViewController = self
        self.adView?.hidden = true

        let request = GADRequest()
        request.testDevices = ["kGADSimulatorID"]
        adView.loadRequest(request)
        
        // Arguments for the banner
        let bannerWidth = screenSize.width
        let bannerHeight = adView.frame.size.height
        let bannerPosX = CGFloat(0.0)
        let bannerPosY = CGFloat(0.0)
        
        // Creates the bannerView with the same height as the ad
        bannerView = UIImageView(frame: CGRectMake(bannerPosX, bannerPosY, bannerWidth, bannerHeight))
        bannerView.image = UIImage(named: "ad_bg.jpg")
    }
    
    private func scoreInit() {
        // Arguments for the text view frame
        let textWidth = CGFloat(300)
        let textHeight = CGFloat(50)
        let textPosX = screenSize.width * 0.50 - (textWidth / 2)
        let textPosY = screenSize.height * 0.15
        
        // Sets the position and size of the text view
        scoreTextView = UITextView()
        scoreTextView.frame.origin.x = textPosX
        scoreTextView.frame.origin.y = textPosY
        scoreTextView.frame.size = CGSize(width: textWidth, height: textHeight)
        scoreTextView.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.0)
        scoreTextView.userInteractionEnabled = false
        scoreTextView.text = String(score)
        scoreTextView.font = UIFont(name: "Archer", size: 40.0)
        scoreTextView.textColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.4)
        scoreTextView.textAlignment = NSTextAlignment.Center
    }
    
    private func highestScoreInit() {
        // Arguments for the text view frame
        let textWidth = CGFloat(300)
        let textHeight = CGFloat(50)
        let textPosX = screenSize.width * 0.50 - (textWidth / 2)
        let textPosY = screenSize.height * 0.28
        
        // Sets the position and size of the text view
        highestScoreTextView = UITextView()
        highestScoreTextView.frame.origin.x = textPosX
        highestScoreTextView.frame.origin.y = textPosY
        highestScoreTextView.frame.size = CGSize(width: textWidth, height: textHeight)
        highestScoreTextView.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.0)
        highestScoreTextView.text = "Best Score: " + String(highestScore)
        highestScoreTextView.userInteractionEnabled = false
        highestScoreTextView.font = UIFont(name: "Archer", size: 40.0)
        highestScoreTextView.textColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.4)
        highestScoreTextView.textAlignment = NSTextAlignment.Center
    }
    
    private func replayButtonInit() {
        // Sets arguments for the replay button view
        let buttonWidth = screenSize.width * 0.20
        let buttonHeight = screenSize.height * 0.15
        let posX = (screenSize.width / 2) - (buttonWidth / 2)
        let posY = screenSize.height * 0.45
        
        // For the replay button view
        replayButtonView = UIButton(frame: CGRectMake(posX, posY, buttonWidth, buttonHeight))
        let replayButtonImageIdle = UIImage(named: "replaybutton_idle")
        let replayButtonImagePressed = UIImage(named: "replaybutton_pressed")
        replayButtonView.setBackgroundImage(replayButtonImageIdle, forState: .Normal)
        replayButtonView.setBackgroundImage(replayButtonImagePressed, forState: .Selected)
        replayButtonView.addTarget(self, action: "replayButtonIsPressed", forControlEvents: .TouchUpInside)
    }
    
    private func menuButtonInit() {
        // Sets arguments for the menu button view
        let buttonWidth = screenSize.width * 0.20
        let buttonHeight = screenSize.height * 0.15
        let posX = (screenSize.width / 2) - (buttonWidth / 2)
        let posY = screenSize.height * 0.65
        
        // For the menu button view
        menuButtonView = UIButton(frame: CGRectMake(posX, posY, buttonWidth, buttonHeight))
        let menuButtonImageIdle = UIImage(named: "menubutton_idle")
        let menuButtonImagePressed = UIImage(named: "menubutton_pressed")
        menuButtonView.setBackgroundImage(menuButtonImageIdle, forState: .Normal)
        menuButtonView.setBackgroundImage(menuButtonImagePressed, forState: .Selected)
        menuButtonView.addTarget(self, action: "menuButtonIsPressed", forControlEvents: .TouchUpInside)
    }
    
    // MARK: Render function
    
    private func scoreScreenRender() {
        // Adds the views into the storyboard
        self.view.addSubview(bannerView)
        self.view.addSubview(adView)
        self.view.addSubview(scoreTextView)
        self.view.addSubview(highestScoreTextView)
        self.view.addSubview(replayButtonView)
        self.view.addSubview(menuButtonView)
        self.view.addSubview(transitionObj.getWhiteBackgroundImageView())
    }
    
    // MARK: Button event functions
    
    func replayButtonIsPressed() {
        removeButtonTargets()
        ifFadingOut = true
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let gameViewControllerObject = storyboard.instantiateViewControllerWithIdentifier("Game") as? Game
        transitionObj.fadeOut(self, gameViewControllerObject: gameViewControllerObject)

    }
    
    func menuButtonIsPressed() {
        removeButtonTargets()
        ifFadingOut = true
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let gameViewControllerObject = storyboard.instantiateViewControllerWithIdentifier("Menu") as? ViewController
        transitionObj.fadeOut(self, gameViewControllerObject: gameViewControllerObject)
    }
    
    private func addButtonTargets() {
        // Allows the ability to press the buttons again
        replayButtonView.addTarget(self, action: "replayButtonIsPressed", forControlEvents: .TouchUpInside)
        menuButtonView.addTarget(self, action: "menuButtonIsPressed", forControlEvents: .TouchUpInside)
    }
    
    private func removeButtonTargets() {
        // Removes the ability to press the buttons while transitioning to the game view
        menuButtonView.removeTarget(self, action: "menuButtonIsPressed", forControlEvents: .TouchUpInside)
        replayButtonView.removeTarget(self, action: "replayButtonIsPressed", forControlEvents: .TouchUpInside)
    }
    
    // MARK: Setters
    
    func setScoreAndHighestScore(score: Int) {
        // Sets the score and highetScore from the game played
        self.score = score
        let preferences = NSUserDefaults.standardUserDefaults()
        let highestScoreKey = "highestScore"
        let storedScore = preferences.integerForKey(highestScoreKey)
        
        if (storedScore < score) {
            // If higher score, set new higher score and stores it
            self.highestScore = score
            preferences.setInteger(self.highestScore, forKey: highestScoreKey)
            
            //  Save to disk
            let didSave = preferences.synchronize()
            
            // If it did not save“
            if !didSave {
                print("Function setScoreAndHighestScore ERROR: DID NOT SAVE")
            }
        }
        else {
            // If not a higher score, than use the previous highest score stored
            self.highestScore = storedScore
        }
    }
}



