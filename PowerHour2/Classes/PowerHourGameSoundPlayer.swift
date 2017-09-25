//
//  PowerHourGameSoundPlayer.swift
//  PowerHour2
//
//  Created by Dylan Elliott on 25/9/17.
//  Copyright © 2017 Dylan Elliott. All rights reserved.
//

import AVFoundation

class PowerHourGameSoundPlayer {
    private let audioPlayer : AVAudioPlayer
    
    init() {
        do {
            let soundURL = Bundle.main.url(forResource: "Drink", withExtension: "m4a")!
            self.audioPlayer = try AVAudioPlayer(contentsOf: soundURL)
        } catch {
            fatalError("Could not load game sound")
        }
        
        self.audioPlayer.volume = 1.0
    }
    
    func play() {
        self.audioPlayer.play()
    }
}
