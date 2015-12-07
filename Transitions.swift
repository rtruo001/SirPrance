//
//  Transitions.swift
//  Sir Prance
//
//  Created by Randy Truong on 10/28/15.
//  Copyright © 2015 Vent Origins. All rights reserved.
//

import UIKit

class Transitions {
    
    // Private variables
    
    // MARK: UIViews
    private var whiteBackgroundImageView: UIImageView!
    
    private let durationfOfFadeIn = 1.0
    private let durationOfFadeOut = 0.5
    private let screenSize: CGRect = UIScreen.mainScreen().bounds
    
    // MARK: Functions
    
    init() {
        // Inits the white image to be full screen
        whiteBackgroundImageView = UIImageView(frame: CGRectMake(0, 0, screenSize.width, screenSize.height))
        whiteBackgroundImageView.image = UIImage(named: "white.jpg")
        whiteBackgroundImageView.alpha = 1.0
    }
    
    // MARK: Menu Fade
    
    // Fade into the menu
    func fadeIn(menu: ViewController) {
        UIView.animateWithDuration(durationfOfFadeIn, delay: 0.0, options: UIViewAnimationOptions.CurveEaseOut, animations: {
            self.whiteBackgroundImageView.alpha = 0.0
        }, completion: { (complete: Bool) in
            self.whiteBackgroundImageView.removeFromSuperview()
        })
    }
    
    // Fade out of the menu
    func fadeOut(menu: ViewController, gameViewControllerObject: Game!) {
        whiteBackgroundImageView.alpha = 0.0
        menu.view.addSubview(whiteBackgroundImageView)
        
        // Animates the background to white, moving to the actual game after the screen is fully white
        UIView.animateWithDuration(durationOfFadeOut, delay: 0.0, options: UIViewAnimationOptions.CurveEaseOut, animations: {
            self.whiteBackgroundImageView.alpha = 1.0
            
        // Goes from menu to the game
        }, completion: {  (complete: Bool) in
            self.transitionFromViewToAnother(gameViewControllerObject)
        })
    }
    
    // MARK: Game Fade
    
    // Fade into the game
    func fadeIn(game: Game) {
        UIView.animateWithDuration(durationfOfFadeIn, delay: 0.0, options: UIViewAnimationOptions.CurveEaseOut, animations: {
            self.whiteBackgroundImageView.alpha = 0.0
        }, completion: { (complete: Bool) in
            self.whiteBackgroundImageView.removeFromSuperview()
            game.setIfGameBegins(true)
        })
    }
    
    // Fade out of the game to Score Screen
    func fadeOut(game: Game, gameViewControllerObject: ScoreScreen!, timer: CADisplayLink) {
        whiteBackgroundImageView.alpha = 0.0
        game.view.addSubview(whiteBackgroundImageView)
        
        // Animates the background to white. After it goes to white, the view goes to the ScoreScreen
        UIView.animateWithDuration(durationOfFadeOut, delay: 0.0, options: UIViewAnimationOptions.CurveEaseOut, animations: {
            self.whiteBackgroundImageView.alpha = 1.0
            
        // Goes to score screen after completion
        }, completion: { (complete: Bool) in
            // Before setting transitioning to the new view, ends the timing tick as well as setting the game to be truly over
            game.setIfGameOverIsDone(true)
            timer.invalidate()
            self.transitionFromViewToAnother(gameViewControllerObject)
        })
    }
    
    // MARK: ScoreScreen Fade
    
    // Fade into the score screen
    func fadeIn(scoreScreen: ScoreScreen) {
        UIView.animateWithDuration(durationfOfFadeIn, delay: 0.0, options: UIViewAnimationOptions.CurveEaseOut, animations: {
            self.whiteBackgroundImageView.alpha = 0.0
            }, completion: { (complete: Bool) in
                self.whiteBackgroundImageView.removeFromSuperview()
            })
    }
    
    // Fade out of the score screen and into the menu
    func fadeOut(scoreScreen: ScoreScreen, gameViewControllerObject: ViewController!) {
        whiteBackgroundImageView.alpha = 0.0
        scoreScreen.view.addSubview(whiteBackgroundImageView)
        
        // Animates the background to white. After it goes to white, the view goes to the menu
        UIView.animateWithDuration(durationOfFadeOut, delay: 0.0, options: UIViewAnimationOptions.CurveEaseOut, animations: {
            self.whiteBackgroundImageView.alpha = 1.0
            
            // Goes to menu after completion
            }, completion: { (complete: Bool) in
                self.transitionFromViewToAnother(gameViewControllerObject)
        })
    }
    
    // Fade out of the score screen and into the game
    func fadeOut(scoreScreen: ScoreScreen, gameViewControllerObject: Game!) {
        whiteBackgroundImageView.alpha = 0.0
        scoreScreen.view.addSubview(whiteBackgroundImageView)
        
        // Animates the background to white. After it goes to white, the view goes to the game
        UIView.animateWithDuration(durationOfFadeOut, delay: 0.0, options: UIViewAnimationOptions.CurveEaseOut, animations: {
            self.whiteBackgroundImageView.alpha = 1.0
            
            // Goes to game after completion
            }, completion: { (complete: Bool) in
                self.transitionFromViewToAnother(gameViewControllerObject)
        })
    }
    
    // MARK: Transitioning from one view to another
    
    // Transitioning from one view to another
    // FOR MENU
    func transitionFromViewToAnother(gameViewControllerObject: ViewController!) {
        let window = UIApplication.sharedApplication().windows[0] as UIWindow
        
        UIView.transitionFromView(
            window.rootViewController!.view,
            toView: gameViewControllerObject!.view,
            duration: self.durationOfFadeOut,
            options: .TransitionCrossDissolve,
            completion: {finished in
                window.rootViewController = gameViewControllerObject
        })
    }
    
    // Transitioning from one view to another
    // FOR GAME
    func transitionFromViewToAnother(gameViewControllerObject: Game!) {
        let window = UIApplication.sharedApplication().windows[0] as UIWindow
        
        UIView.transitionFromView(
            window.rootViewController!.view,
            toView: gameViewControllerObject!.view,
            duration: self.durationOfFadeOut,
            options: .TransitionCrossDissolve,
            completion: {finished in
                window.rootViewController = gameViewControllerObject
        })
    }
    
    // Transitioning from one view to another
    // FOR SCORESCREEN
    func transitionFromViewToAnother(gameViewControllerObject: ScoreScreen!) {
        let window = UIApplication.sharedApplication().windows[0] as UIWindow
        
        UIView.transitionFromView(
            window.rootViewController!.view,
            toView: gameViewControllerObject!.view,
            duration: self.durationOfFadeOut,
            options: .TransitionCrossDissolve,
            completion: {finished in
                window.rootViewController = gameViewControllerObject
        })
    }
    
    // MARK: Accessors
    
    func getWhiteBackgroundImageView() -> UIImageView! {
        return whiteBackgroundImageView
    }
}
