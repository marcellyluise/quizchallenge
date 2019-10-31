//
//  NotificationName+Extension.swift
//  Quiz Challenge
//
//  Created by Marcelly Luise on 31/10/19.
//  Copyright © 2019 Celly Corp. All rights reserved.
//

import Foundation

extension Notification.Name {
    static let timerDidFinish = Notification.Name("TimerDidFinish")
    static let timerManagerDidFinish = Notification.Name("TimerManagerDidFinish")
    static let userDidResetTimer = Notification.Name("UserDidResetTimer")
    static let resetTimer = Notification.Name("ResetTimer")
    static let updateUI = Notification.Name("UpdateUI")
    static let pauseTimer = Notification.Name("PauseTimer")
    static let startTimer = Notification.Name("StartTimer")
    
}
