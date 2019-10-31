//
//  TimeInterval+Extension.swift
//  Quiz Challenge
//
//  Created by Marcelly Luise on 29/10/19.
//  Copyright © 2019 Celly Corp. All rights reserved.
//

import Foundation

extension TimeInterval {
    
    static var oneMinute: TimeInterval {
        return 60
    }
    
    static var fiveMinutes: TimeInterval {
        return 5
    }
    
    func countdownString() -> String {
        
        let seconds = Int(self.truncatingRemainder(dividingBy: Double.oneMinute))
        let minutes = Int((self/Double.oneMinute).truncatingRemainder(dividingBy: Double.oneMinute))
        
        return String(format: "%0.2d:%0.2d", minutes, seconds)
    }
}
