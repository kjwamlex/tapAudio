//
//  initialLaunchCheck.swift
//  tapAudio
//
//  Created by 김준우 on 2018-07-18.
//  Copyright © 2018 김준우. All rights reserved.
//

import UIKit
import MediaPlayer
var passedTest = true
class initialLaunchCheckViewController: UIViewController {
    
    var songNameArraySaved:[String] = []
    var songNameArrayRetrieved:[String] = []
    var albumArtwork:[UIImage] = []
  // var albums: [AlbumInfo] = []
   // var songQuery: SongQuery = SongQuery()
    var timer = Timer()
    var runOnlyOnce = false
    var allowedToAccess = false
    @IBOutlet var mainLabel: UILabel!
    @IBOutlet var mainWaitView: UIView!
    
    var hasTopNotch: Bool {
        if #available(iOS 11.0,  *) {
            return UIApplication.shared.delegate?.window??.safeAreaInsets.top ?? 0 > 20
        }
        
        return false
    }
    

    override func viewDidAppear(_ animated: Bool) {
        UIApplication.shared.statusBarStyle = .lightContent

        MPMediaLibrary.requestAuthorization { (status) in
            if status == .authorized {
               //self.albums = self.songQuery.get(songCategory: "")
                self.allowedToAccess = true
            } else {
            }
        }
        //UserDefaults.standard.set([], forKey: "albumArtWork")

       // albumArtwork = UserDefaults.standard.imageArray(forKey: "albumArtWork")!
        timer = Timer.scheduledTimer(timeInterval: 0.2, target: self, selector: #selector(initialLaunchCheckViewController.proceedAccess), userInfo: nil, repeats: true)

        
        
    }
    var goodToGo = true

    @objc func proceedAccess() {
        
        if allowedToAccess == true && runOnlyOnce == false{
            runOnlyOnce = true
            songNameArraySaved = UserDefaults.standard.object(forKey: "songNameCheck") as! [String]
            
            print(songNameArraySaved)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute:{
  
                for song in MPMediaQuery.songs().items! {
                    self.songNameArrayRetrieved.append(song.title!)
                    //songIDArray.append(Int(song.persistentID))
                   // artistName.append(song.albumArtist!)
                    print(song.persistentID.description)
                    print(song.title!)
                    print(song.artist!)
                    print(song.albumTitle ?? "Unknown")
                    //print(song.albumTitle ?? "Unknown")
                }
                
                print(self.songNameArrayRetrieved)
                
                if self.songNameArraySaved.count != self.songNameArrayRetrieved.count {
                    
                    self.goodToGo = false
                } else {
                
                    
                for x in 0...self.songNameArraySaved.count - 1 {
                    
                    
                    if self.songNameArraySaved[x] == self.songNameArrayRetrieved[x]{
                        print("Yes. Verified and good to go.")
                        self.goodToGo = true
                        
                    } else {
                        passedTest = false
                        self.goodToGo = false
                    }
                }
                }
 
 

                
                if self.goodToGo == true {
                    
                    
                    songNameArray = UserDefaults.standard.object(forKey: "songNameCheck") as! [String]
                    
                    songIDArray = UserDefaults.standard.object(forKey: "songIDCheck") as! [Int]
                    
                    
                    artistName = UserDefaults.standard.object(forKey: "artistNameCheck") as! [String]
                    
                    tapticDataInUseArray = UserDefaults.standard.object(forKey: "tapticBeatmapData") as! [[Int]]
                    
                    tapticDelayUserSetting = UserDefaults.standard.object(forKey: "tapticDelays") as! [Int]
                    
                    
                    
                    
                    availableBeatmapMusicIndex =  UserDefaults.standard.object(forKey: "availableBeatmapMusicIndex") as! [Int]

                    availableBeatmapMusicTitle =  UserDefaults.standard.object(forKey: "availableBeatmapMusicTitle") as! [String]

                    availableBeatmapMusicID =  UserDefaults.standard.object(forKey: "availableBeatmapMusicID") as! [Int]
                    
                    availableBeatmapMusicArtistName = UserDefaults.standard.object(forKey: "availableBeatmapMusicArtistName") as! [String]
                    
                    
                    for song in MPMediaQuery.songs().items! {
                        //songTitleTest.append(song.title!)
                        //songArtitstTest.append(song.albumTitle!)
                        //songIDTest.append(Int(song.persistentID))
                        // tapticDelayUserSetting.append(0)
                        //songIDArray.append(Int(song.persistentID))
                        // artistName.append(song.albumArtist!)
                       // albumArtArray.append(song.artwork?.image(at: CGSize(width: 250, height: 250)) ?? UIImage(named:"InfiniteView Icon.png")!)

                        //print(song.albumTitle ?? "Unknown")
                    }

                    
                    //        let images =


                    ///availableBeatmapMusicArt =  UserDefaults.standard.object(forKey: "tapticDelays") as! [S]

                    
                    for index in availableBeatmapMusicIndex {
                       // availableBeatmapMusicArt.append(albumArtArray[index])
                        
                    }
                    
                    
                    self.songNameArraySaved.removeAll()
                    //albumArtArray.removeAll()
                    self.songNameArrayRetrieved.removeAll()
                    self.timer.invalidate()
                    //artistNameCheck
                    //tapticDelayUserSetting = UserDefaults.standard.object(forKey: "userDelayValue") as! [Int]
                    let mainStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
                    let vc : UIViewController = mainStoryboard.instantiateViewController(withIdentifier: "getStartedLock") as UIViewController
                    self.present(vc, animated: false, completion: nil)

                    

                } else if self.goodToGo == false {
                    UIView.animate(withDuration: 2, animations: {
                        self.mainWaitView.backgroundColor = UIColor.white
                        self.view.backgroundColor = UIColor.white
                        self.mainLabel.textColor = UIColor.black
                        
                    })

                    UIView.transition(with: self.mainLabel, duration: 2, options: .transitionCrossDissolve, animations: {
                        
                        self.mainLabel.textColor = UIColor.black

                    }, completion: nil)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute:{
                        let mainStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
                        let vc : UIViewController = mainStoryboard.instantiateViewController(withIdentifier: "IndexingProcessVC") as UIViewController
                        self.present(vc, animated: false, completion: nil)
                        self.timer.invalidate()
                        UIApplication.shared.statusBarStyle = .default


                    })
                    
                    
                    
                    

                    

                }
                
                
            
            })
            
       
            
            
            

            
        }

    }
}


