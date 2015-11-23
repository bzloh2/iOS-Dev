//
//  SimpleStopwatch.swift
//  StopWatch
//
//  Created by Brian Loh on 11/12/15.
//  Copyright © 2015 Brian Loh. All rights reserved.
//

import Foundation
import AudioToolbox
class SimpleStopwatch{
    private var startTime: NSDate?
    
    var elapsedTime: NSTimeInterval {
        guard let startTime = self.startTime  else{
            return 0
        }
        return -startTime.timeIntervalSinceNow
    }
    var elapsedTimeAsString: String{
        if (abs(elapsedTime%60) <= 0.1)  {
        AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
        }
        return String(format: "%02d:%02d.%d",
            Int(elapsedTime / 60), Int(elapsedTime % 60), Int(elapsedTime * 10 % 10))
        
    }
    var isRunning: Bool{
        return startTime != nil
    }
    
    func start() {
        startTime = NSDate()
    }
    
    func stop(){
        startTime = nil
    }
}
