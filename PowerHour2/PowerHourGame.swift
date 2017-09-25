//
//  PowerHourGame.swift
//  PowerHour2
//
//  Created by Dylan Elliott on 23/9/17.
//  Copyright © 2017 Dylan Elliott. All rights reserved.
//

import Foundation
import UserNotifications

protocol PowerHourGameDelegate {
    func powerHourGameWillStep(powerHourGame : PowerHourGame)
    func powerHourGameDidStep(powerHourGame : PowerHourGame)
    func userShouldDrink(powerHourGame : PowerHourGame)
    func powerHourGameDidEnd(powerHourGame : PowerHourGame)
}

extension PowerHourGameDelegate {
    func powerHourGameWillStep(powerHourGame : PowerHourGame) {}
    func powerHourGameDidStep(powerHourGame : PowerHourGame) {}
    func userShouldDrink(powerHourGame : PowerHourGame) {}
    func powerHourGameDidEnd(powerHourGame : PowerHourGame) {}
}

class PowerHourGame {
    
    let gameLength : Int // in seconds
    var gameStartTime : Int?
    
    let drinkInterval : Int = 60 // in s
    
    private lazy var gameTimer : Timer  = Timer(timeInterval: 1, target: self, selector: #selector(timerCallback), userInfo: nil, repeats: true)
    
    var delegate : PowerHourGameDelegate?
    
    init(lengthInMinutes : Int = 60) {
        self.gameLength = lengthInMinutes * 60
        
    }
    
    func gameTime() -> Int {
        if let gameStartTime = gameStartTime {
            return Int(NSDate().timeIntervalSinceReferenceDate) - gameStartTime
        } else {
            return 0
        }
    }
    
    func timeRemaining() -> Int {
        return gameLength - gameTime()
    }
    
    func totalDrinks() -> Int {
        return gameLength / drinkInterval
    }
    
    func drinksCompleted() -> Int {
        return (gameTime() - (gameTime() % drinkInterval)) / drinkInterval
    }
    
    func drinkRemaining() -> Int {
        return totalDrinks() - drinksCompleted()
    }
    
    func secondsUntilNextDrink() -> Int {
        return drinkInterval - (gameTime() % drinkInterval)
    }
    
    func start() {
        RunLoop.main.add(self.gameTimer, forMode: .defaultRunLoopMode)
        self.gameStartTime = Int(NSDate().timeIntervalSinceReferenceDate)
    }
    
    func step() {
        guard self.gameTime() < self.gameLength else {
            self.gameTimer.invalidate()
            return
        }
        
        if self.gameTime() % self.drinkInterval == 0 {
            self.delegate?.userShouldDrink(powerHourGame: self)
        }
    }
    
    @objc func timerCallback() {
        self.delegate?.powerHourGameWillStep(powerHourGame: self)
        step()
        self.delegate?.powerHourGameDidStep(powerHourGame: self)
    }
}
