//
//  ViewController.swift
//  PowerHour2
//
//  Created by Dylan Elliott on 23/9/17.
//  Copyright © 2017 Dylan Elliott. All rights reserved.
//

import UIKit

class ViewController: UIViewController, PowerHourGameDelegate, AppStateDelegate {
    
    @IBOutlet weak var fractionLabel : UILabel!
    @IBOutlet weak var timerLabel : UILabel!
    
    let drinkSoundPlayer = PowerHourGameSoundPlayer()
    let powerHourGame = PowerHourGame()
        
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.powerHourGame.delegate = self
        self.powerHourGame.start()
        self.updateLabels()
        
        
        self.view.mask(withPercentage: 0.0, angle: 0.2, inverse: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.appStateDelegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func updateLabels() {
        let timeRemaining = self.powerHourGame.gameLength - self.powerHourGame.gameTime()
        let secondsRemaining = timeRemaining % 60
        let minutesRemaining = (timeRemaining - secondsRemaining) / 60
        self.timerLabel.text = "\(minutesRemaining):\(String(format: "%02d", secondsRemaining))"
        
        self.fractionLabel.text = "\(self.powerHourGame.drinksCompleted())/\(self.powerHourGame.totalDrinks())"
    }
    
    func powerHourGameDidStep(powerHourGame: PowerHourGame) {
        updateLabels()
    }
    
    func userShouldDrink(powerHourGame: PowerHourGame) {
        self.drinkSoundPlayer.play()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for _ in touches {
            self.powerHourGame.gameStartTime! -= 1
            self.updateLabels()
        }
    }

    func applicationWillEnterBackground() { // Is all of this notification business happening properly?
        PowerHourGameNotificationManager.createDrinkNotificationsIfPossible(for: self.powerHourGame)
    }
    
    func applicationWillReEnterForeground() {
        PowerHourGameNotificationManager.clearDrinkNotificationsIfPossible()
    }
    
    func applicationWillTerminate() {
        PowerHourGameNotificationManager.clearDrinkNotificationsIfPossible()
    }

}

