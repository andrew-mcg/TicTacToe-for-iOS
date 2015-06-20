//
//  ViewController.swift
//  iTTT
//
//  Created by Andrew McG on 13/06/2015.
//  Copyright (c) 2015 Andrew McG. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    
    @IBOutlet weak var button: UIButton!
    
    @IBOutlet weak var textLabel: UILabel!
    
    @IBOutlet weak var playAgainButton: UIButton!
    
    @IBOutlet weak var line0: UIImageView!
    @IBOutlet weak var line1: UIImageView!
    @IBOutlet weak var line2: UIImageView!
    @IBOutlet weak var line3: UIImageView!
    @IBOutlet weak var line4: UIImageView!
    @IBOutlet weak var line5: UIImageView!
    @IBOutlet weak var line6: UIImageView!
    @IBOutlet weak var line7: UIImageView!
    
    
    // indicate which player is next in turn; 1 = noughts, -1 = crosses
    // also used in cell state to indicate who placed what where
    var activePlayer = 1
    // set boolean flag to indicate if game play is active
    var gameActive = true
    // create array to record where noughts (1's) and crosses (-1's) are placed
    // cellState[0] is used to progressively tally the number of game moves
    // cellState[1] to [9] store if a 1 (nought) or -1 (cross0 has been placed
    var cellState = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
    // create array of each potentially winning column, row & diagonal
    var winningLines = [[0,1,2], [3,4,5], [6,7,8], [0,3,6], [1,4,7], [2,5,8], [0,4,8], [2,4,6]]
    // variable to be used to tally score over winning lines
    var lineScore = 0
    
    
    // prepare audioplayer for sounds
    var audioPlayer = AVAudioPlayer()
    var dingSound = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("ding", ofType: "mp3")!)
    var dongSound = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("dong", ofType: "mp3")!)
    var buzzSound = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("buzz", ofType: "mp3")!)
    var winSound = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("win", ofType: "mp3")!)
    
    
    // Player presses upon one of the buttons in the 3x3 grid area
    @IBAction func buttonPressed(sender: AnyObject) {
        
        // Game play must be active and selected cell must be empty
        if gameActive && cellState[sender.tag] == 0 {
            
            var image = UIImage()
            cellState[sender.tag] = activePlayer
            
            if activePlayer == 1 {
                
                audioPlayer = AVAudioPlayer(contentsOfURL: dingSound, error: nil)
                image = UIImage(named: "nought.png")!
                cellState[0]++
                audioPlayer.play()
                // next move set to crosses
                activePlayer = -1
                textLabel.text="Crosses turn"
                
            } else { // player is obviously crosses
                
                audioPlayer = AVAudioPlayer(contentsOfURL: dongSound, error: nil)
                image = UIImage(named: "cross.png")!
                cellState[0]++
                audioPlayer.play()
                // next move set to noughts
                activePlayer = 1
                textLabel.text="Noughts turn"
                
            }
            
            sender.setImage(image, forState: .Normal)
            
            // calculate 'score' for each potentially winning column, row & diagonal
            for line in 0...7 {
                // calcuate net result of summing noughts (1's) and crosses (-1's) in winningLine[line]
                // offset by 1 because cellState[0] is used to record number of turns played
                lineScore = cellState[winningLines[line][0]+1] + cellState[winningLines[line][1]+1] + cellState[winningLines[line][2]+1]
                // check if a winning line has been created
                if abs(lineScore) == 3 {
                    // check who wins and display message
                    if activePlayer == -1 {
                        textLabel.text="Noughts win!"
                    } else {
                        textLabel.text="Crosses win!"
                    }
                    audioPlayer = AVAudioPlayer(contentsOfURL: winSound, error: nil)
                    audioPlayer.play()
                    gameActive = false
                    playAgainButton.hidden = false
                    // unhide line corresponding to winning line
                    switch line {
                    case 0: line0.hidden = false
                    case 1: line1.hidden = false
                    case 2: line2.hidden = false
                    case 3: line3.hidden = false
                    case 4: line4.hidden = false
                    case 5: line5.hidden = false
                    case 6: line6.hidden = false
                    case 7: line7.hidden = false
                    default: print("")
                    }
                } // end checking for winning line
                
                // if no win but all nine cells have been filled then game is a draw
                if gameActive && cellState[0] == 9 {
                    textLabel.text="It's a draw!"
                    playAgainButton.hidden = false
                    gameActive = false
                } // end checking for draw
            } // end valid move
            
        } else {
            
            // player has clicked on an invalid cell so play error buzz sound
            audioPlayer = AVAudioPlayer(contentsOfURL: buzzSound, error: nil)
            audioPlayer.play()
            
        } // end invalid move
        
    } // end buttonPressed
    
    
    // Reset game ready to be played again
    @IBAction func playAgainButton(sender: AnyObject) {
        cellState = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
        playAgainButton.hidden = true
        activePlayer = 1
        gameActive = true
        textLabel.text="Noughts turn"
        var button:UIButton
        for i in 1...9 {
            button = view.viewWithTag(i) as! UIButton
            button.setImage(nil, forState: .Normal)
        }
        line0.hidden = true
        line1.hidden = true
        line2.hidden = true
        line3.hidden = true
        line4.hidden = true
        line5.hidden = true
        line6.hidden = true
        line7.hidden = true
    } // end playAgainButton
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

