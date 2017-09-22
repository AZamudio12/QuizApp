//
//  ViewController.swift
//  TrueFalseStarter
//
//  Created by Pasan Premaratne on 3/9/16.
//  Copyright © 2016 Treehouse. All rights reserved.
//

import UIKit
import GameKit
import AudioToolbox

class ViewController: UIViewController {
    
    let questionsPerRound = 4
    var questionsAsked = 0
    var correctQuestions = 0
    var indexOfSelectedQuestion: Int = 0
    var randomNumArray = [Int]()

    
    var gameSound: SystemSoundID = 0
    
    let triviaProvider = TriviaProvider()
    
    @IBOutlet weak var questionField: UILabel!
    @IBOutlet weak var trueButton: UIButton!
    @IBOutlet weak var falseButton: UIButton!
    @IBOutlet weak var playAgainButton: UIButton!
    @IBOutlet weak var button3: UIButton!
    @IBOutlet weak var button4: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadGameStartSound()
        // Start game
        playGameStartSound()
        displayQuestion()
        displayAnswers()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func displayQuestion() {
        
        
        
        
        indexOfSelectedQuestion = GKRandomSource.sharedRandom().nextInt(upperBound: triviaProvider.trivia.count)
        
        //setup a random Num array to keep track of previous generated random numbers if they have not already been selected then the question is displaed
        //if they have been selected then the method is called again.
        
        if !randomNumArray.contains(indexOfSelectedQuestion) {
            let questionDictionary = triviaProvider.trivia[indexOfSelectedQuestion]
            questionField.text = questionDictionary["Question"]
            playAgainButton.isHidden = true
            randomNumArray.append(indexOfSelectedQuestion)
            
        } else {
            displayQuestion()
        }
        
        
        
        
    }
    
    func displayAnswers() {
        let selectedQuestionDict = triviaProvider.trivia[indexOfSelectedQuestion]
        
                
        trueButton.setTitle(selectedQuestionDict["Option 1"], for: .normal)
        falseButton.setTitle(selectedQuestionDict["Option 2"], for: .normal)
        button3.setTitle(selectedQuestionDict["Option 3"], for: .normal)
        button4.setTitle(selectedQuestionDict["Option 4"], for: .normal)

    }
    
    func displayScore() {
        // Hide the answer buttons
        trueButton.isHidden = true
        falseButton.isHidden = true
        button3.isHidden = true
        button4.isHidden = true
        
        // Display play again button
        playAgainButton.isHidden = false
        
        questionField.text = "Way to go!\nYou got \(correctQuestions) out of \(questionsPerRound) correct!"
        
        print("\(randomNumArray)")
        
    }
    
    @IBAction func checkAnswer(_ sender: UIButton) {
        // Increment the questions asked counter
        questionsAsked += 1
        
        let selectedQuestionDict = triviaProvider.trivia[indexOfSelectedQuestion]
        let correctAnswer = selectedQuestionDict["Correct Answer"]
        
        
        if (sender === trueButton &&  correctAnswer == "1")
            || (sender === falseButton && correctAnswer == "2")
            || (sender === button3 && correctAnswer == "3")
            || (sender === button4 && correctAnswer == "4"){
            correctQuestions += 1
            questionField.text = "Correct!"
        } else {
            questionField.text = "Sorry, wrong answer!"
        }
        
        /**if (sender.title(for: .normal) == correctAnswer){
            correctQuestions += 1
            questionField.text = "Correct!"
            print("\(correctAnswer!)")
        } else {
            questionField.text = "Sorry, wrong answer!"
        }**/
        
        //original part of code
        /**if (sender === trueButton &&  correctAnswer == "True") || (sender === falseButton && correctAnswer == "False") {
            correctQuestions += 1
            questionField.text = "Correct!"
        } else {
            questionField.text = "Sorry, wrong answer!"
        }**/
        
        loadNextRoundWithDelay(seconds: 2)
    }
    
    func nextRound() {
        if questionsAsked == questionsPerRound {
            // Game is over
            randomNumArray.removeAll()
            displayScore()
        } else {
            // Continue game
            displayQuestion()
            displayAnswers()

        }
    }
    
    @IBAction func playAgain() {
        // Show the answer buttons
        trueButton.isHidden = false
        falseButton.isHidden = false
        button3.isHidden = false
        button4.isHidden = false
        
        questionsAsked = 0
        correctQuestions = 0
        nextRound()
    }
    

    
    // MARK: Helper Methods
    
    func loadNextRoundWithDelay(seconds: Int) {
        // Converts a delay in seconds to nanoseconds as signed 64 bit integer
        let delay = Int64(NSEC_PER_SEC * UInt64(seconds))
        // Calculates a time value to execute the method given current time and delay
        let dispatchTime = DispatchTime.now() + Double(delay) / Double(NSEC_PER_SEC)
        
        // Executes the nextRound method at the dispatch time on the main queue
        DispatchQueue.main.asyncAfter(deadline: dispatchTime) {
            self.nextRound()
        }
    }
    
    func loadGameStartSound() {
        let pathToSoundFile = Bundle.main.path(forResource: "GameSound", ofType: "wav")
        let soundURL = URL(fileURLWithPath: pathToSoundFile!)
        AudioServicesCreateSystemSoundID(soundURL as CFURL, &gameSound)
    }
    
    func playGameStartSound() {
        AudioServicesPlaySystemSound(gameSound)
    }
}

