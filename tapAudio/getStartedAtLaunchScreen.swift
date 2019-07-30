//
//  getStartedAtLaunchScreen.swift
//  tapAudio
//
//  Created by 김준우 on 2018-07-18.
//  Copyright © 2018 김준우. All rights reserved.
//

import UIKit

class getStartedAtLaunchScreen: UIViewController {
    
    @IBOutlet var getStartedLaunchView: UIView!
    @IBOutlet var swipUpLabel: UILabel!
    @IBOutlet var tapAudioLabel: UILabel!
    @IBOutlet var progressView: UIProgressView!
    @IBOutlet var swipeUpLabelConstraint: NSLayoutConstraint!
var timer = Timer()
    var up = false
    var down = true
    var initialYLocation: CGFloat?
    
    
    var hasTopNotch: Bool {
        if #available(iOS 11.0,  *) {
            return UIApplication.shared.delegate?.window??.safeAreaInsets.top ?? 0 > 20
        }
        
        return false
    }

    
    override func viewWillAppear(_ animated: Bool) {
        swipUpLabel.alpha = 0
        progressView.alpha = 0
        if hasTopNotch == true {
            
            self.swipeUpLabelConstraint.constant = -20
        }
    }
    


    override func viewDidAppear(_ animated: Bool) {
        
        
        timer = Timer.scheduledTimer(timeInterval: 2.7, target: self, selector: #selector(getStartedAtLaunchScreen.swipeUpAnimation), userInfo: nil, repeats: true)

    }
    
    
    @objc func swipeUpAnimation() {
        
            if up == false && down == true{
                
                UIView.animate(withDuration: 1, animations: {
                    self.swipUpLabel.alpha = 1
                    })
                UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseInOut, animations: {
                    self.swipUpLabel.transform = CGAffineTransform.init(translationX: 0, y: -20)
                }, completion: nil)
                UIView.animate(withDuration: 1.7, delay: 0.5, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseInOut, animations: {
                    
                    self.swipUpLabel.transform = CGAffineTransform.init(translationX: 0, y: -30)
                }, completion: nil)
                up = true
                down = false
                
            } else if down == false && up == true{
                
                UIView.animate(withDuration: 1.2, delay: 0.4, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseInOut, animations: {
                    self.swipUpLabel.alpha = 0
                }, completion: nil)
                
                UIView.animate(withDuration: 0.1, delay: 1.6, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseInOut, animations: {
                    self.swipUpLabel.transform = CGAffineTransform.init(translationX: 0, y: 0)
                }, completion: nil)
                up = false
                down = true
            }
        
        
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first as UITouch?
        var location = touch?.location(in: getStartedLaunchView)
        
        if touch?.view == getStartedLaunchView{
            
            initialYLocation = location!.y
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseInOut, animations: {
                self.swipUpLabel.alpha = 0
                self.swipUpLabel.transform = CGAffineTransform.init(translationX: 0, y: 0)
            }, completion: nil)
            
        }
    }
    
    var moveOnValidNumber: CGFloat?
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first as UITouch?
        
        var location = touch?.location(in: getStartedLaunchView)
        
        if touch?.view == getStartedLaunchView  {
            //print("moved:\(location!.y)")
            //print("calculated: \(( initialYLocation! - location!.y) / 80)")
            moveOnValidNumber =  ((initialYLocation! - location!.y) / 280) + 1.4
            
            
            if moveOnValidNumber! >= CGFloat(1.0) {
                UIView.animate(withDuration: 0.45, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseInOut, animations: {
                    
                    //self.getStartedLaunchView.transform = CGAffineTransform.init(scaleX: (( self.initialYLocation! - location!.y) / 280) + 1, y: (( self.initialYLocation! - location!.y) / 280) + 1)
                    self.getStartedLaunchView.transform = CGAffineTransform.init(translationX: 0, y: -(self.initialYLocation! - (location?.y)!))
                    //self.tapAudioLabel.alpha = 2 -  ((( self.initialYLocation! - location!.y) / 280) + 1)
                }, completion: nil)
                
            }
            
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first as UITouch?
        
            if moveOnValidNumber! > CGFloat(2.0) {
                
                UIView.animate(withDuration: 0.75, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseIn, animations: {
                    
                    //self.getStartedLaunchView.transform = CGAffineTransform.init(scaleX: (( self.initialYLocation! - location!.y) / 280) + 1, y: (( self.initialYLocation! - location!.y) / 280) + 1)
                    self.getStartedLaunchView.transform = CGAffineTransform.init(translationX: 0, y: -700)
                    //self.tapAudioLabel.alpha = 2 -  ((( self.initialYLocation! - location!.y) / 280) + 1)
                }, completion: nil)
                
        
        
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.75, execute:{
                    let mainStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
                    let vc : UIViewController = mainStoryboard.instantiateViewController(withIdentifier: "musicViewController") as UIViewController
                    self.present(vc, animated: false, completion: nil)
                    tapticDataArray.remove(at: 0)
                })
                
                
                
                
             
            } else if moveOnValidNumber! < CGFloat(2.0) {
                UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseInOut, animations: {
                    
                    self.getStartedLaunchView.transform = .init(translationX: 0, y: 0)
                    
                    
                }, completion: nil)
                
                
            }
            
        
        
    }
    
}
