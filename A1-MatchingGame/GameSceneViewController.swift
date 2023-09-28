//
//  GameSceneViewController.swift
//  A1-MatchingGame
//
//  Created by Dylan Sarell on 9/22/23.
// Mobile Apps Assingment 1 - Basic Matching Game

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var label1: UILabel!
    @IBOutlet weak var scoreTimerLabel: UILabel!
    @IBOutlet var startButtonOutlet: UIButton!
    
    //var rectButtons: [UIButton]?
    
    var matchRect: [UIButton: Int] = [:] // Dictionary for Matching
    var matchButton: UIButton?
    
    var gameTimerInterval: TimeInterval = 1.0
    var newRectInterval: TimeInterval = 1.0
    var gameTimer: Timer?
    var newRectTimer: Timer?
    
    var gameRunning = false
    
    var buttonTag = 0
    var rectCount = 0 {
        didSet {
            self.updateLabel()
        }
    }
    var score = 0 {
        didSet {
            self.updateLabel()
        }
    }
    var timeRemaining = 12 {
        didSet {
            self.updateLabel()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func startButton(_ sender: UIButton) {
        if self.gameRunning == false {
            self.gameRunning = true
            startButtonOutlet.setTitle("Restart", for: .normal)
            sender.removeFromSuperview()
            StartGame()
        }
        else {
            //let startBtn = UIButton()
            self.view.backgroundColor = .white
            //self.view.addSubview(sender) //add back to superview
            //startBtn.text = "start"
            timeRemaining = 12;
        }
    }
    
    func StartGame() {
        self.gameTimer = Timer.scheduledTimer(withTimeInterval: self.gameTimerInterval, repeats: true, block: { Timer in
            if self.timeRemaining > 0 {
                self.timeRemaining -= 1
            }
            else {
                self.newRectTimer?.invalidate()
                self.view.backgroundColor = .red
                Timer.invalidate()
                self.gameRunning = false
                self.view.addSubview(self.startButtonOutlet)
            }
        })
        self.newRectTimer = Timer.scheduledTimer(withTimeInterval: newRectInterval, repeats: true, block: { Timer in
            self.createButton()
            self.rectCount += 2
        })
    }
    func updateLabel() {
        self.scoreTimerLabel.text = "Created \(self.rectCount) - Time: \(self.timeRemaining) - Score: \(self.score)"
    }
    func createButton() { // Creates 2 Rectangles with the same size and color but in random locations.
        let rectSize = self.randSize()
        let rectloc = self.randLocation(rectSize)
        let rectMatch = CGRect(origin: rectloc, size: rectSize)
        let rectloc2 = self.randLocation(rectSize)
        let rectMatch2 = CGRect(origin: rectloc2, size: rectSize)
        
        let buttonMatch = UIButton(frame: rectMatch)
        let buttonMatch2 = UIButton(frame: rectMatch2)
        
        buttonMatch.addTarget(self, action: #selector(handleTap(_:)), for: .touchUpInside)
        buttonMatch2.addTarget(self, action: #selector(handleTap(_:)), for: .touchUpInside)
        
        let matchColor = self.randColor()
        buttonMatch.backgroundColor = matchColor
        buttonMatch2.backgroundColor = matchColor
        
        buttonMatch.tag = self.buttonTag
        buttonMatch2.tag = self.buttonTag
        self.buttonTag += 1
        self.view.addSubview(buttonMatch)
        self.view.addSubview(buttonMatch2)
        
        self.matchRect.updateValue(self.buttonTag, forKey: buttonMatch)
        self.matchRect.updateValue(self.buttonTag, forKey: buttonMatch2)
        //self.rectButtons?.append(buttonMatch)
        //self.rectButtons?.append(buttonMatch2)
    }
    @objc func handleTap(_ sender: UIButton) {
        if self.gameRunning == true {
            print(self.matchRect[sender]!)
            if let a = self.matchButton {
                if self.matchRect[a] == self.matchRect[sender] {
                   a.removeFromSuperview()
                   sender.removeFromSuperview()
                   self.score += 1
                } else {
                   self.matchButton = nil
                }
            } else {
                self.matchButton = sender
                sender.setTitle("@", for: .normal)
            }
        }
    }
  // ---------- Random Size, Location and Color Functions
    func randSize() -> CGSize {
        let width = CGFloat.random(in: 25.0...100.0)
        let height = CGFloat.random(in: 25.0...100.0)
        return CGSize(width: width, height: height)
    }
    func randLocation(_ rectSize: CGSize) -> CGPoint {
        let x = CGFloat.random(in: 0...(self.view.frame.width - (rectSize.width/2)))
        let topSafeInset = self.view.safeAreaInsets.bottom + 60
        let bottomSafeInset = self.view.safeAreaInsets.top + 70
        let y = CGFloat.random(in: (bottomSafeInset + (rectSize.height/2))...(self.view.frame.height - topSafeInset - (rectSize.height/2)))
        return CGPoint(x: x, y: y)
    }
    func randColor() -> UIColor {
        return UIColor(red: CGFloat.random(in: 0...1), green: CGFloat.random(in: 0...1), blue: CGFloat.random(in: 0...1), alpha: 1.0)
    }
}

