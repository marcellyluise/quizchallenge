//
//  TimeManager.swift
//  Quiz Challenge
//
//  Created by INDRA BRASIL SOLUCOES E SERVICOS TECNOLOGICOS on 30/10/19.
//  Copyright © 2019 Celly Corp. All rights reserved.
//

import Foundation
import Combine

class TimerManager {
    
    static let shared = TimerManager()
    
    private var timer: Timer?
    private var timeLimit: TimeInterval = 0
    private var timeElapsed: TimeInterval = Double.fiveMinutes
    
    var currentTimerValue: TimeInterval {
        return timeElapsed
    }
    
    var currentTimeString: String {
        return timeElapsed.countdownString()
    }
    
    var timerIsValid: Bool {
        return timer?.isValid ?? false
    }
    
    private init() {
        
    }
    
    func startTimer(with timeLimit: TimeInterval) {
        self.timeLimit = timeLimit
        self.timeElapsed = timeLimit
        
        if !timerIsValid {
            timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTimerCountdown), userInfo: nil, repeats: true)
            timer?.fire()
        }
    }
    
    func pauseTimer() {
        timer?.invalidate()
    }
    
    func resetTimer() {
        
        timer?.invalidate()
        timer = nil
        
        timeElapsed = timeLimit
        
    }
    
    @objc private func updateTimerCountdown() {
        
        if timeElapsed == 0 {
            pauseTimer()
            NotificationCenter.default.post(name: Notification.Name("TimeDidFinish"), object: nil)
        } else {
            timeElapsed -= 1
            
            NotificationCenter.default.post(name: Notification.Name("UpdateUI"), object: nil)
        }
    }
}
