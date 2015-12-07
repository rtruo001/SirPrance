//
//  GameScore.swift
//  Sir Prance
//
//  Created by Randy Truong on 10/22/15.
//  Copyright © 2015 Vent Origins. All rights reserved.
//

import UIKit

class GameScore {
    
    // MARK: Private Variables
    private var scoreTextView: UITextView!
    private var score = 0
    
    // Screen size
    private let screenSize: CGRect = UIScreen.mainScreen().bounds
    
    init() {
        // Arguments for the text view frame
        let textWidth = CGFloat(300)
        let textHeight = CGFloat(50)
        let posX = screenSize.width * 0.50 - (textWidth / 2)
        let posY = screenSize.height * 0.08
        
        // Sets the position and size of the text view
        scoreTextView = UITextView()
        scoreTextView.frame.origin.x = posX
        scoreTextView.frame.origin.y = posY
        scoreTextView.frame.size = CGSize(width: textWidth, height: textHeight)

        // Makes the background transparent for the text
        scoreTextView.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.0)
        
        // Text view settings
        scoreTextView.text = String(score)
        scoreTextView.textColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        scoreTextView.userInteractionEnabled = false
        scoreTextView.font = UIFont(name: "Archer", size: 40.0)
        scoreTextView.textAlignment = NSTextAlignment.Center
    }
    
    // MARK: Accessors
    
    func getScoreTextView() -> UITextView! {
        return scoreTextView
    }
    
    func getScore() -> Int {
        return score
    }
    
    // MARK: Setters
    
    func setScore(score: Int) {
        self.score = score
        scoreTextView.text = String(self.score)
    }
    
}
