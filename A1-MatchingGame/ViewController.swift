//
//  ViewController.swift
//  A1-MatchingGame
//
//  Created by Dylan Sarell on 9/22/23.
// Mobile Apps Assingment 1 - Basic Matching Game

import UIKit

class ViewController: UIViewController {
    
    
    @IBOutlet weak var scoreTimerLabel: UILabel!
    var rectButtons: [UIButton]?
    var gameTimerInterval: TimeInterval = 12.0
    var newRectInterval: TimeInterval = 1.0
    var gameTimer: Timer?
    var newRectTimer: Timer?
    
    var buttonTag = 0
    var rectCount = 0
    var score = 0
    var timeRemaining = 12 {
        didSet {
            self.scoreTimerLabel.text = "Created \(self.rectCount) - Time: \(self.timeRemaining) - Score: \(self.score)"
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        print("Hello World")
        print("Hello GitHub!!!")
        self.rectButtons = []
    }
    override func viewDidAppear(_ animated: Bool) {
        self.createButton()
        self.createButton()
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
            }
        })
        self.newRectTimer = Timer.scheduledTimer(withTimeInterval: newRectInterval, repeats: true, block: { Timer in
            self.createButton()
        })
    }
    func createButton() {
        let rectSize = self.randSize()
        let rectloc = self.randLocation(rectSize)
        let rectFrame = CGRect(origin: rectloc, size: rectSize)
        
        let button = UIButton(frame: rectFrame)
        button.addTarget(self, action: #selector(handleTap(_:)), for: .touchUpInside)
        button.backgroundColor = self.randColor()
        button.tag = self.buttonTag
        //self.button += 1
        self.view.addSubview(button)
        self.rectButtons?.append(button)
    }
    @objc func handleTap(_ sender: UIButton) {
        print(sender.tag)
        sender.removeFromSuperview()
        self.score += 1
    }
    func randSize() -> CGSize {
        let width = CGFloat.random(in: 50.0...150.0)
        let height = CGFloat.random(in: 50.0...150.0)
        return CGSize(width: width, height: height)
    }
    func randLocation(_ rectSize: CGSize) -> CGPoint {
        let x = CGFloat.random(in: 0...(self.view.frame.width - (rectSize.width/2)))
        let topSafeInset = self.view.safeAreaInsets.bottom
        let bottomSafeInset = self.view.safeAreaInsets.top
        let y = CGFloat.random(in: (bottomSafeInset + (rectSize.height/2))...(self.view.frame.height - topSafeInset - (rectSize.height/2)))
        return CGPoint(x: x, y: y)
    }
    func randColor() -> UIColor {
        return UIColor(red: CGFloat.random(in: 0...1), green: CGFloat.random(in: 0...1), blue: CGFloat.random(in: 0...1), alpha: 1.0)
    }
}

