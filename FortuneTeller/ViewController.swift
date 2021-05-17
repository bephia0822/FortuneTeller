//
//  ViewController.swift
//  FortuneTeller
//
//  Created by Sophia Wang on 2021/3/18.
//

import UIKit
import GameKit
import AudioToolbox
import AVFoundation

class ViewController: UIViewController {
    
    var player: AVAudioPlayer?
    
    override var prefersStatusBarHidden: Bool{
           return true
       }
       
       @IBOutlet weak var yourFortune: UIImageView!
       @IBAction func tellMeSomething(_ sender: UIButton) {
           showAnswer()
           yourFortune.shake(times: 5)
       }
       
   
    func playSound() {
        guard let url = Bundle.main.url(forResource: "1", withExtension: "mp3") else { return }

        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)

            /* The following line is required for the player to work on iOS 11. Change the file type accordingly*/
            player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)

            /* iOS 10 and earlier require the following line:
            player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileTypeMPEGLayer3) */

            guard let player = player else { return }
            player.play()

        } catch let error {
            print(error.localizedDescription)
        }

    }
                
    
    
    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        if event?.subtype == .motionShake{
            showAnswer()
        }
    }
    func showAnswer(){
        if yourFortune.isHidden == true{
            //show me the answer
            //1.make a random number 1~6
            let answer = GKRandomSource.sharedRandom().nextInt(upperBound: 6) + 1
            
            //2.change image
            yourFortune.image = UIImage(named: "\(answer)")
            yourFortune.isHidden = false
            
            //3.sound
        if yourFortune.image == UIImage(named: "1"){
            playSound()

        }else{
            AudioServicesPlayAlertSound(1006)
        }
        }else{
            //hide image
            yourFortune.isHidden = true
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        }
   
}

extension UIView {
    func shake(times: Int, delaX:CGFloat = 5) {
        let shakeAnimator = UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.1, delay: 0, options: [.curveEaseIn], animations: {
            self.layer.setAffineTransform(CGAffineTransform(translationX: delaX, y: 0))
        }){(_) in
            if times != 0 {
                self.shake(times: times - 1, delaX: -delaX)
            } else {
                self.layer.setAffineTransform(CGAffineTransform.identity)
            }
        }
        shakeAnimator.startAnimation()
    }
}

