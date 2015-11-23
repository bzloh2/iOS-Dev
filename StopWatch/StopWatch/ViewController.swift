//
//  ViewController.swift
//  StopWatch
//
//  Created by Brian Loh on 11/12/15.
//  Copyright © 2015 Brian Loh. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var clockLabel: UILabel!
    @IBOutlet weak var startButton: UIButton!
    
    let stopwatch = SimpleStopwatch()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func startTapped(sender: AnyObject) {
        if !stopwatch.isRunning {
            NSTimer.scheduledTimerWithTimeInterval(0.1, target: self, selector: "updateClockLabel:",userInfo: nil, repeats: true)
            startButton.setTitle("Stop", forState: .Normal)
            stopwatch.start()
        }
        else{
            startButton.setTitle("Start", forState: .Normal)
            stopwatch.stop()
        }
    }
    func updateClockLabel(timer: NSTimer){
        if stopwatch.isRunning{
            clockLabel.text = stopwatch.elapsedTimeAsString}
        else{
            timer.invalidate()
            
        }
        
    }

}

