//
//  musicPlayViewController.swift
//  tapAudio
//
//  Created by 김준우 on 2018-05-21.
//  Copyright © 2018 김준우. All rights reserved.
//

import UIKit
import AVFoundation
import MediaPlayer
import WebKit
var tapticDataInUseArray:[[Int]] = [[]]
var tapticDelayUserSetting: [Int] = []
var availableBeatmapMusicTitle: [String] = []
var availableBeatmapMusicArtistName: [String] = []

var availableBeatmapMusicID: [Int] = []
var availableBeatmapMusicIndex: [Int] = []
var availableBeatmapMusicArt: [UIImage] = []


var alternativeBeatmapsString: [String] = []


class availableMusicCell: UICollectionViewCell {
    
    @IBOutlet weak var albumArt: UIImageView!
    @IBOutlet weak var artistName: UILabel!
    @IBOutlet weak var musicName: UILabel!
    /*
    override func prepareForReuse() {
        super.prepareForReuse()
        albumArt.image = nil
       // albumArt.removeFromSuperview()
       // albumArt = nil
    }*/
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        if superview != nil {
            albumArt.layer.cornerRadius = 10
            albumArt.clipsToBounds = true
        }
    }
}
//custom class for table view cell
class musicCustomTableViewCell: UITableViewCell {
    
    //album art view of the table view cell
    @IBOutlet weak var albumArtView: UIImageView!
    
    //music creator label of the table view cell
    @IBOutlet weak var musicCreator: UILabel!
    
    //release date label of the table view cell
    @IBOutlet weak var releaseDate: UILabel!
    
    //music title label of the table view cell
    @IBOutlet weak var musicTitle: UILabel!
    
}





class alternativeBeatmaps: UICollectionViewCell {
    
    @IBOutlet weak var beatmapImageView: UIImageView!
    @IBOutlet weak var beatmapTitle: UILabel!
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        if superview != nil {
            beatmapImageView.layer.cornerRadius = 10
            beatmapImageView.clipsToBounds = true
        }
    }

    
}



//1332969
//https://osu.ppy.sh/osu/1209790
//1209790
//1681914
//1208548
//1532967

class musicViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, WKNavigationDelegate, WKUIDelegate {
    
    
    @IBOutlet weak var availableCollectionView: UICollectionView!
    
    @IBOutlet weak var alternativeCollectionView: UICollectionView!
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView == availableCollectionView {
            
            return availableBeatmapMusicIndex.count
        } else if collectionView == alternativeCollectionView {
            
            return alternativeBeatmapsString.count
        } else {
            
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        var emptyCell:UICollectionViewCell!
        if collectionView == availableCollectionView {
            
            
            let cell = availableCollectionView.dequeueReusableCell(withReuseIdentifier: "availableMusic", for: indexPath as IndexPath) as! availableMusicCell
            
            cell.albumArt.image = MPMediaQuery.songs().items?[availableBeatmapMusicIndex[indexPath.row]].artwork?.image(at: CGSize(width: 50, height: 50))
            cell.musicName.text = availableBeatmapMusicTitle[indexPath.row]
            
            var artist = availableBeatmapMusicArtistName[indexPath.row]
            cell.artistName.text = artist.replacingOccurrences(of: " - ilKPOP.com", with: "")
            //artist.replacingOccurrences(of: " - ilKPOP.com", with: "")
            
            return cell

            
        }else if collectionView == alternativeCollectionView {
            
            let alternativeCollectionVIewCell = alternativeCollectionView.dequeueReusableCell(withReuseIdentifier: "alternatives", for: indexPath as IndexPath) as! alternativeBeatmaps
            alternativeCollectionVIewCell.beatmapTitle.text = alternativeBeatmapsString[indexPath.row]
            alternativeCollectionVIewCell.beatmapImageView.image = miniPlayerAlbumArt.image

          
            return alternativeCollectionVIewCell

            
        } else {
            
            
            return emptyCell
        }

    }
    var dataExtractingStage = false
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if collectionView == availableCollectionView {
        play(index: indexPath.row, identifier: "CollectionView")
        
        UIView.animate(withDuration: 0.5) {
            self.playOrPauseButton.setImage(UIImage(named: "Pause.png"), for: .normal)
            
        }
        UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.7, options: .curveEaseOut, animations: {
            
            self.miniPlayerAlbumArt.transform = CGAffineTransform.init(scaleX: 1, y: 1)
            
        }, completion: nil)
            
        } else if collectionView == alternativeCollectionView {
            
            var original = "https://osu.ppy.sh/s/\(alternativeBeatmapsString[indexPath.row])"
            original = original.replacingOccurrences(of: "%25", with: "%")
            //%20-%20ilKPOP.co

            if let encoded = original.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed),
                let url = URL(string: encoded){
                
                let req = URLRequest(url:url)
                
                self.alternativeBeatmapChecker!.load(req)
                self.dataExtractingStage = true
                //downloadAndExtractBeatmapData(dataIDNumber: Int?)
                //extractBeatmapData(dataIDNumber: beatmapIDArray[dataExtractedCounter - 1])

                
            }
            
            print("let's select this beatmap instead...")
        }
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {


        
        //        return CGSize(width: ((UIWindow.init().bounds.width - 20 ) /   2 ) - 5, height: (((UIWindow.init().bounds.width - 20 ) /   2 ) - 5) + 33) -> 6s resolution

        if collectionView == availableCollectionView {
        return CGSize(width: ((UIWindow.init().bounds.width - 20 ) /   2 ) - 5, height: (((UIWindow.init().bounds.width - 20 ) /   2 ) - 5) + 50)
            
        } else if collectionView == alternativeCollectionView {
            
            return CGSize(width: 176, height:189)

        } else {
            
            return CGSize(width: 176, height:185)
        }
    }
    
    
    //array for music datas
    var albumArtView = ["InfiniteView Icon.png", "BLACKPINK_As_If_It's_Your_Last_cover_art.png"]
    var musicCreator = ["iOS App Developer", "BlackPink"]
    var releaseData = ["Released in 2016", "Released in 2017"]
    var musicTitle = ["infiniteView Teaser", "As if it's last"] //https://pixabay.com/en/geometric-triangle-wallpaper-3037169/
    
    
    var player: AVAudioPlayer?
    
    var timer = Timer()

    
    //Set up the references to UIComponents in Storyboard
    @IBOutlet weak var miniPlayer: UIView!
    @IBOutlet weak var miniPlayerAlbumArt: UIImageView!
    @IBOutlet weak var musicPlayerBackground: UIImageView!
    @IBOutlet weak var miniPlayerHeight:NSLayoutConstraint!
    @IBOutlet weak var widthOfAlbumArt: NSLayoutConstraint!
    @IBOutlet weak var heightOfAlbumArt: NSLayoutConstraint!
    @IBOutlet weak var albumArtTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var bottomMiniPlayerConstraint: NSLayoutConstraint!
    @IBOutlet weak var miniPlayerMusicTitle: UILabel!
    @IBOutlet weak var miniPlayerArtistLabel: UILabel!
    @IBOutlet weak var playOrPauseButton: UIButton!
    @IBOutlet weak var miniPlayerBackgroundVisualEffectView: UIVisualEffectView!
    @IBOutlet weak var navigationBarLabel: UILabel!
    @IBOutlet weak var volumeControlVisualEffectView: UIVisualEffectView!
    @IBOutlet weak var repeatControlVisualEffectView: UIVisualEffectView!
    @IBOutlet weak var hapticControlVisualEffectView: UIVisualEffectView!
    @IBOutlet weak var musicTableView: UITableView!
    @IBOutlet weak var musicProgress: UISlider!
    @IBOutlet var threeDTouchVolumeInteractionView: UIVisualEffectView!
    @IBOutlet var threeDTouchRepeatInteractionView: UIVisualEffectView!
    @IBOutlet var threeDTouchStrengthInteractionView: UIVisualEffectView!
    @IBOutlet var settingsPerMusicView: UIView!
    @IBOutlet var doneButtonSettingsItSelf: UIButton!
    @IBOutlet var doneButtonWithEditingDelay: UIButton!
    @IBOutlet var delayTextField: UITextField!

    @IBOutlet var musicHeader: UILabel!
    @IBOutlet var alternativeBeatmapChecker: WKWebView!
    @IBOutlet var loadingAlternativeBeatmapView: UIActivityIndicatorView!
    
    
    //set up the new function bars in mini player view
    @IBOutlet weak var functionBar: UIView!
    @IBOutlet weak var musicControlBar: UIView!
    @IBOutlet weak var volumeSlider: UIVisualEffectView!
    @IBOutlet weak var repetitionSlider: UIVisualEffectView!
    @IBOutlet weak var hapticSlider: UIVisualEffectView!
    
    
    
    //set up the 3D Touch Functionality - EXTRA MARK!
    @IBOutlet weak var volume3DTouchView: UIView!
    @IBOutlet weak var repeat3DTouchView: UIView!
    @IBOutlet weak var haptic3DTouchView: UIView!
    
    
    var beatmapAlternativeToBeDownloadedID: Int?
    
    @IBOutlet var testView: UIView!
    var timerPLEASELOAD = Timer()
    
    var testBeatmapArray = [306, 760, 1896, 2124, 3260, 3942, 4396, 5306, 5760, 6215, 6556, 6896, 7578, 8033, 9169, 9851, 10533, 11215, 12578, 14624, 14851, 15533, 15760, 17351, 17578, 18942, 19965, 21215, 22124, 22806, 23033, 24624, 24851, 26215, 28487, 29851, 30306, 31215, 31669, 32351, 32578, 33033, 33487, 33942, 34851, 35306, 35987, 36669, 37351, 37692, 38033, 38487, 38942, 39624, 39965, 40306, 40760, 41215, 41669, 42578, 43033, 43487, 43715, 43942, 46215, 46669, 47237, 47578, 49851, 50533, 51215, 53487, 54396, 54851, 55306, 57124, 58033, 58487, 58942, 59624, 60306, 60760, 61442, 61669, 62351, 62578, 62806, 63487, 63942, 65306, 65533, 65760, 73033, 73487, 73942, 75306, 75760, 75987, 76215, 76442, 77124, 77578, 78033, 79056, 79851, 80078, 80306, 80760, 81215, 82578, 83033, 83260, 83487, 83715, 84396, 85760, 86215, 86896, 87124, 87351, 87578, 88260, 88487, 90078, 90305, 91669, 92692, 93942, 94851, 95533, 95760, 97351, 97578, 98942, 100760, 101215, 102465, 102806, 103033, 103374, 103715, 104851, 105078, 105306, 105760, 106101, 106442, 107124, 107578, 108487, 108942, 109396, 111215, 112578, 113033, 113942, 114169, 114396, 114624, 116215, 116669, 117124, 117806, 118487, 118942, 119624, 119851, 120533, 120760, 120987, 121669, 122124, 123488, 123715, 123942, 131215, 131669, 132124, 133487, 133942, 134169, 134396, 134624, 135306, 135760, 136215, 137237, 138033, 138260, 138487, 138942, 139396, 140760, 141215, 141442, 141669, 141897, 142578, 143942, 144396, 145306, 145760, 153033, 154283, 154624, 160306, 161669, 161896, 162124, 168942, 169396, 169851, 172578, 173033, 175760, 176215, 176669, 183260, 183487, 183715, 183942, 187124, 187578, 190306, 190533, 190761, 190988, 191215, 191669, 192124, 193715, 193942, 195306, 196329, 197578, 198487, 199169, 199396, 200987, 201215, 202578, 204396, 204851]
    
    @IBOutlet weak var THREEDTouchHierachyVisualEffect: UIVisualEffectView!
    
    
    //3D Touch Capabilities
    var currentForce: CGFloat! = 0
    var tareForce: CGFloat! = 0
    var completed3DTouch = false
    
    //timer for infinite execution
    
    //progress value of the UISlider
    var progressValue = 0
    
    
    //before the view appears...
    override func viewWillAppear(_ animated: Bool) {
        
        if passedTest == false {
            navigationBarLabel.transform = CGAffineTransform.init(scaleX: 0.5, y: 0.5)
            navigationBarLabel.transform = CGAffineTransform.init(translationX: 0, y: 20)
            navigationBarLabel.alpha = 0
            self.availableCollectionView.alpha = 0
            self.availableCollectionView.transform = CGAffineTransform.init(scaleX: 2, y: 2)
        } else if passedTest == true {
            
            //self.animatingFirstView.transform = CGAffineTransform.init(scaleX: 2, y: 2)
            self.availableCollectionView.transform = CGAffineTransform.init(translationX: 0, y: 700)
            self.navigationBarLabel.transform = CGAffineTransform.init(translationX: 0, y: 700)
            self.miniPlayer.transform = CGAffineTransform.init(translationX: 0, y: 700)
        }
        alternativeCollectionView.layer.cornerRadius = 10
        alternativeCollectionView.clipsToBounds = true

        tapticStrengthTwo = true
        doneButtonWithEditingDelay.layer.cornerRadius = 20
        doneButtonWithEditingDelay.clipsToBounds = true
        settingsPerMusicView.layer.cornerRadius = 30
        settingsPerMusicView.clipsToBounds = true
        
        doneButtonSettingsItSelf.layer.cornerRadius = 20
        doneButtonSettingsItSelf.clipsToBounds = true
        availableCollectionView.delegate = self
        
        self.settingsPerMusicView.transform = CGAffineTransform.init(translationX: 0, y: 600)

        
        //set the thumb size of the UISlider
        self.musicProgress.setThumbImage(UIImage(named: "SLiderGrabber.png")!, for: .normal)
        
        
        //set the corner radius of the mini player
        miniPlayer.layer.cornerRadius = 30
        miniPlayer.clipsToBounds = true
        
        

        
        
        //set the 3D Touch bar alpha to 0
        functionBar.alpha = 0
        
        //set the music controller bar alpha to 0
        musicControlBar.alpha = 0
        

        
        //set the corner radius of 3D Touch View for volume control
        volumeControlVisualEffectView.layer.cornerRadius  = 12
        volumeControlVisualEffectView.clipsToBounds = true
        
        //set the corner radius of 3D Touch View for repeating option control
        repeatControlVisualEffectView.layer.cornerRadius  = 12
        repeatControlVisualEffectView.clipsToBounds = true
        
        //set the corner radius of 3D Touch View for haptic control
        hapticControlVisualEffectView.layer.cornerRadius  = 12
        hapticControlVisualEffectView.clipsToBounds = true
        
        //threeDTouchVolumeInteractionView
        //threeDTouchRepeatInteractionView
        //threeDTouchStrengthInteractionView
        
        
        //set the corner radius of 3D Touch View for volume control
        threeDTouchVolumeInteractionView.layer.cornerRadius  = 12
        threeDTouchVolumeInteractionView.clipsToBounds = true
        
        //set the corner radius of 3D Touch View for repeating option control
        threeDTouchRepeatInteractionView.layer.cornerRadius  = 12
        threeDTouchRepeatInteractionView.clipsToBounds = true
        
        //set the corner radius of 3D Touch View for haptic control
        threeDTouchStrengthInteractionView.layer.cornerRadius  = 12
        threeDTouchStrengthInteractionView.clipsToBounds = true

        
        
        //set the corner radius of album art
        miniPlayerAlbumArt.layer.cornerRadius = 15
        miniPlayerAlbumArt.clipsToBounds = true
        
        

        
        //set the alpha of 3D Touch View for volume control
        volumeControlVisualEffectView.alpha = 0
        
        //set the alpha of 3D Touch View for repetition option control
        repeatControlVisualEffectView.alpha = 0
        
        //set the alpha of 3D Touch View for haptic control
        hapticControlVisualEffectView.alpha = 0
        
       // navigationBarLabel.frame = CGRect.init(x: 20, y: 64, width: 94.5, height: 41)
        

        
       // musicTableView.alpha = 0

        

        
        
        //self.miniPlayer.transform = CGAffineTransform.init(translationX: 0, y: 500)
        //self.miniPlayer.transform = CGAffineTransform.init(scaleX: 2, y: 2)

        self.musicTableView.transform = CGAffineTransform.init(translationX: UIWindow.init().bounds.width , y: 0)
        self.musicHeader.transform = CGAffineTransform.init(translationX: UIWindow.init().bounds.width, y: 0)
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        

        //print(tapticDataInUseArray[0])
        UIApplication.shared.statusBarStyle = .lightContent
        //animate new constraints
        
        /*
*/
        
        self.testView = alternativeBeatmapChecker
        
        alternativeBeatmapChecker.load(URLRequest(url: URL(string: "https://www.apple.com/")!))
        print(UIWindow.init().frame.height)
        
      //  self.availableCollectionView.setContentOffset(CGPoint(x:0,y:-12), animated: true)

        UIView.animate(withDuration: 0.6, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {


            self.availableCollectionView.alpha = 1
            
            self.availableCollectionView.transform = CGAffineTransform.init(translationX: 0, y: 0)
            self.navigationBarLabel.transform = CGAffineTransform.init(translationX: 0, y: 0)
            self.miniPlayer.transform = CGAffineTransform.init(translationX: 0, y: 0)
            
            
            //translate the function bar to the bottom
            self.functionBar.transform = CGAffineTransform.init(translationX: 0, y: 300)
            
            self.repeatControlVisualEffectView.transform = CGAffineTransform.init(translationX: 0, y: 300)
            
            self.volumeControlVisualEffectView.transform = CGAffineTransform.init(translationX: 0, y: 300)
            
            self.hapticControlVisualEffectView.transform = CGAffineTransform.init(translationX: 0, y: 300)
            
            
            //translate music control bar to the bottom
            self.musicControlBar.transform = CGAffineTransform.init(translationX: 0, y: 300)

        }, completion: nil)


    }
    @IBOutlet var settingsAndDismissButton: UIButton!

    var dataArray:[Int] = []
    override func viewDidLoad() {
        super.viewDidLoad()

        alternativeCollectionView.delegate = self
        alternativeCollectionView.dataSource = self
        
        alternativeBeatmapChecker = WKWebView()
        alternativeBeatmapChecker.navigationDelegate = self
        alternativeBeatmapChecker.uiDelegate = self
        
        musicTableView.delegate = self
        let longGesture = UILongPressGestureRecognizer(target: self, action: #selector(musicViewController.didChangeDelaySettings))
        settingsAndDismissButton.addGestureRecognizer(longGesture)

        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    var hasTopNotch: Bool {
        if #available(iOS 11.0,  *) {
            return UIApplication.shared.delegate?.window??.safeAreaInsets.top ?? 0 > 20
        }
        
        return false
    }
    
    @IBAction func expand() {

        //if the mini player is in low position
        if miniPlayerHeight.constant == 95 {
            
            
            //set the width of the album art image
            widthOfAlbumArt.constant = UIWindow.init().bounds.width - (22.67*2)
            
            //set the height of the album art image
            heightOfAlbumArt.constant = UIWindow.init().bounds.width - (22.67*2)
            albumArtTopConstraint.constant = 12.67+100
            
            if hasTopNotch == false{
                //set the height of the mini player
                miniPlayerHeight.constant = UIWindow.init().bounds.height - 15
           
                
                //if the phone is iPhone X
            } else if hasTopNotch == true {
                

                //set the height of the mini player
                miniPlayerHeight.constant = UIWindow.init().bounds.height - 30
                
                //set the constraints of the bottom of the mini player due to Home Bar
                bottomMiniPlayerConstraint.constant = -26
            
            }
            //self.miniPlayerMusicTitle.animate(font: self.miniPlayerMusicTitle.font.withSize(44), duration: 0.65, frame: self.miniPlayerMusicTitle.frame)
            //Animate the following:
            UIView.animate(withDuration: 0.65, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                
                //set the navigation label alpha to 0
                self.navigationBarLabel.alpha = 0
                
                //set the mini player music label alpha to 0
                //self.miniPlayerMusicTitle.alpha = 0
                
                //set the mini player music artist alpha to 0
               // self.miniPlayerArtistLabel.alpha = 0
                
                
                self.miniPlayerMusicTitle.transform = CGAffineTransform.init(translationX: -self.widthOfAlbumArt.constant-7, y: 0)
                self.miniPlayerMusicTitle.font = self.miniPlayerMusicTitle.font.withSize(44)
                self.miniPlayerArtistLabel.transform = CGAffineTransform.init(translationX: -self.widthOfAlbumArt.constant-7, y: 0)
                self.musicProgress.transform = CGAffineTransform.init(translationX: 0, y: 0)
                
                //set the function alpha to 1
                self.functionBar.alpha = 1
                
                //set the music controller bar alpha to 1
                self.musicControlBar.alpha = 1
                
                
                //translate the function bar to the bottom
                self.functionBar.transform = CGAffineTransform.init(translationX: 0, y: 0)
                
                //translate music control bar to the bottom
                self.musicControlBar.transform = CGAffineTransform.init(translationX: 0, y: 0)
                
                self.repeatControlVisualEffectView.transform = CGAffineTransform.init(translationX: 0, y: 0)
                
                self.volumeControlVisualEffectView.transform = CGAffineTransform.init(translationX: 0, y: 0)
                
                self.hapticControlVisualEffectView.transform = CGAffineTransform.init(translationX: 0, y: 0)

                

                
                // set the volume control visual effect alpha to 1
                self.volumeControlVisualEffectView.alpha = 1
                
                // set the repetition control visual effect alpha to 1
                self.repeatControlVisualEffectView.alpha = 1
                
                // set the haptic control visual effect alpha to 1
                self.hapticControlVisualEffectView.alpha = 1
                
                
            }, completion: nil)
            
            
            //animate new constraints
            UIView.animate(withDuration: 0.65, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                
                //set the new constraints
                self.view.layoutIfNeeded()
                
            }, completion: nil)
            
            //animate the following:
            UIViewPropertyAnimator(duration: 0.65, curve: .linear, animations: {
                
                //change the corner radius of the album art of the mini player
                self.miniPlayerAlbumArt.layer.cornerRadius = 25
                self.miniPlayerAlbumArt.clipsToBounds = true
                
                
            }).startAnimation()
            
            
            // if the mini player is expanded
        } else if miniPlayerHeight.constant != 95 {
            
            //set the new width of the album art to smaller one
            widthOfAlbumArt.constant = 70
            
            //set the height of the album art to smaller one
            heightOfAlbumArt.constant = 70
            
            //set the height of the mini player
            miniPlayerHeight.constant = 95
            albumArtTopConstraint.constant = 12.67
            //if the iPhone has 4.7 inches screen
            if hasTopNotch == false {
                
                //set the bottom constraint of the music player to 10
                bottomMiniPlayerConstraint.constant = 10
                
                
                ///fix the following for 3x@5.5
                //if the iPhone has bigger or equal to 5.5 inches display
            } else if hasTopNotch == true {
                
                //set the bottom mini player constraint to 9
                bottomMiniPlayerConstraint.constant = 9
                
                
            }
            //self.miniPlayerMusicTitle.animate(font: self.miniPlayerMusicTitle.font.withSize(20), duration: 0.65, frame: self.miniPlayerMusicTitle.frame)
            //animate the following
            UIView.animate(withDuration: 0.65, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                
                
                //translate the function bar to the bottom
                self.functionBar.transform = CGAffineTransform.init(translationX: 0, y: 300)
                
                self.repeatControlVisualEffectView.transform = CGAffineTransform.init(translationX: 0, y: 300)
                
                self.volumeControlVisualEffectView.transform = CGAffineTransform.init(translationX: 0, y: 300)
                
                self.hapticControlVisualEffectView.transform = CGAffineTransform.init(translationX: 0, y: 300)
                self.musicProgress.transform = CGAffineTransform.init(translationX: 0, y: 300)
                
                //translate music control bar to the bottom
                self.musicControlBar.transform = CGAffineTransform.init(translationX: 0, y: 300)
                
                //animate the constraints
                self.view.layoutIfNeeded()
                
                //set the new alpha of the navigation label
                self.navigationBarLabel.alpha = 1
                self.miniPlayerAlbumArt.transform = CGAffineTransform.init(translationX: 0, y: 0)
                self.miniPlayerMusicTitle.transform = CGAffineTransform.init(translationX: 0, y: 0)
                self.miniPlayerMusicTitle.font = self.miniPlayerMusicTitle.font.withSize(20)
                self.miniPlayerArtistLabel.transform = CGAffineTransform.init(translationX: 0, y: 0)
                

                
                //set the function bar alpha to 0
                self.functionBar.alpha = 0
                
                //set alpha of the music controler bar to 0
                self.musicControlBar.alpha = 0
                
                //set the alpha of the volume control view to 0
                self.volumeControlVisualEffectView.alpha = 0
                
                //set the alpha of the repeat control view to 0
                self.repeatControlVisualEffectView.alpha = 0
                
                //set the haptic of the volume control view to 0
                self.hapticControlVisualEffectView.alpha = 0
                
            }, completion: nil)
            
            //animate the following:
            UIViewPropertyAnimator(duration: 0.65, curve: .linear, animations: {
                
                //set the corner radius of the mini player album art
                self.miniPlayerAlbumArt.layer.cornerRadius = 15
                self.miniPlayerAlbumArt.clipsToBounds = true
                
                
            }).startAnimation()
            
            
        }
        
    }
    
    var moveOnValidNumber: CGFloat?
    var initialXLocation: CGFloat?

    //when the touch began
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        //touch input variable
        let touch = touches.first as UITouch?
        
        
        //touch location within mini player view
        var secondaryLocation = touch?.location(in: view)
        
        
        //y location of the touch input
        var xlocation = secondaryLocation!.x
        
        if touch!.view == view {
            initialXLocation = xlocation
           // moveOnValidNumber =  ((initialXLocation! - location!.y) / 280) + 1
           // musicTableView = UITableView()
            //availableCollectionView = UICollectionView()
            availableCollectionView.reloadData()
        } else if touch!.view == volume3DTouchView{
            
            //current force variable gets the touch force variable
            currentForce = touch!.force
            
        }else if touch!.view == repeat3DTouchView {
            
        }else if touch!.view == haptic3DTouchView {
            
        }
        
        
        
        
    }
    
    
    
    //change volume boolean variable
    var changeVolume = false
    
    //change repetition variable settings boolean variable
    var changeRepetitionSettings = false
    
    //change the taptic strength boolean variable
    var changeTapticStrength = false
    
    
    //y axis finger location variable
    var yAxisFingerLocation: CGFloat!
    
    var tapticStrengthOne: Bool?
    var tapticStrengthTwo: Bool?
    var tapticStrengthThree: Bool?
    
    
    //when touch moved
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        //touch variable
        let touch = touches.first as UITouch?
        
        //touch location within mini player view
        var location = touch?.location(in: miniPlayer)
        
        
        //y location of the touch input
        var ylocation = location!.y
        
        
        
        //touch location within mini player view
        var secondaryLocation = touch?.location(in: view)
        
        
        //y location of the touch input
        var xlocation = secondaryLocation!.x

        
        //External variable gets the same value as the ylocation
        yAxisFingerLocation = ylocation
        
        
        //update the visual element of the volume bar
        updateVolume()
        
        if touch!.view == view {
            print(xlocation)
            
            
            
            moveOnValidNumber =  secondaryLocation!.x - self.availableCollectionView.frame.width
            
            
                   // self.getStartedLaunchView.transform = CGAffineTransform.init(scaleX: (( self.initialXLocation! - secondaryLocation!.x) / 280) + 1, y: (( self.initialXLocation! - secondaryLocation!.x) / 280) + 1)
            UIView.animate(withDuration: 0.2, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseInOut, animations: {
                    self.availableCollectionView.transform = CGAffineTransform.init(translationX: secondaryLocation!.x - self.availableCollectionView.frame.width, y: 0)
                    self.navigationBarLabel.transform = CGAffineTransform.init(translationX: secondaryLocation!.x - self.availableCollectionView.frame.width, y: 0)

                    self.musicTableView.transform = CGAffineTransform.init(translationX: secondaryLocation!.x , y: 0)
                    self.musicHeader.transform = CGAffineTransform.init(translationX: secondaryLocation!.x, y: 0)
                    //self.tapAudioLabel.alpha = 2 -  ((( self.initialYLocation! - location!.y) / 280) + 1)
            
                              }, completion: nil)

            
        }else  if touch!.view == volume3DTouchView {
            
            //3D Touch force variable value
            currentForce = touch!.force
            
            //if the touch force is over 4
            if  Int(currentForce.grams(tareForce))! > 4 {
                
                //if 3D Touch is not completed
                if completed3DTouch == false {
                    changeVolume = true

                    presentThreeDTouchMenu(threeDimensionalTouchMenu: volumeControlVisualEffectView , x: 20, y: self.miniPlayer.frame.height - 280, width: 50, height: 200, changeWhat: changeVolume)
               
                }
                
            }
            
        } else if touch!.view == repeat3DTouchView {
            
            
            //                        self.repeatControlVisualEffectView.frame  = CGRect(x: UIWindow.init().frame.width/2 - 50, y: 640/2 - 150, width: 100, height: 300)

            
            
            //3D Touch force variable value
            currentForce = touch!.force
            
            //if the force is over 4
            if  Int(currentForce.grams(tareForce))! > 4 {
                
                //if 3D Touch Gesture is not completed
                if completed3DTouch == false {
                    changeRepetitionSettings = true

                    presentThreeDTouchMenu(threeDimensionalTouchMenu: repeatControlVisualEffectView, x: UIWindow.init().frame.width/2 - 50, y: 640/2 - 150, width: 100, height: 300, changeWhat: changeRepetitionSettings)
                    
                    
                }
                
            }
            
            
        }else if touch!.view == haptic3DTouchView {
            
            //3D Touch force variable value
            currentForce = touch!.force
            if  Int(currentForce.grams(tareForce))! > 4 {
                if completed3DTouch == false {
                    
                    changeTapticStrength = true

                    presentThreeDTouchMenu(threeDimensionalTouchMenu: hapticControlVisualEffectView, x: UIWindow.init().frame.width/2 - 50, y: 640/2 - 150, width: 100, height: 300, changeWhat: changeTapticStrength)
                    
                }
                
            }
            
            
        }
        
    }
    
    
    func presentThreeDTouchMenu(threeDimensionalTouchMenu: UIVisualEffectView, x: CGFloat, y: CGFloat, width: CGFloat, height: CGFloat, changeWhat: Bool) {
        
        
        //Play haptic feedback
        let hapticFeedback = UIImpactFeedbackGenerator(style: .heavy)
        hapticFeedback.prepare()
        hapticFeedback.impactOccurred()
        
        
        //3D Touch force variable value
        //currentForce = touch!.force
        
        //3D Touch Gesture is completed
        completed3DTouch = true
        
        //change taptic strength settings is enabled

        
        
        //animate the following:
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            
            
            //set the frame of the haptic control settings view
            threeDimensionalTouchMenu.frame  = CGRect(x: x, y: y, width: width, height: height)
            
            //set the alpha of the visual effect hierachy view to 1
            self.THREEDTouchHierachyVisualEffect.alpha = 1
            
            
        }, completion: nil)
        
        
        self.THREEDTouchHierachyVisualEffect.alpha = 1

        UIView.animate(withDuration: 0.3, animations: {
            //  EITHER...
            self.THREEDTouchHierachyVisualEffect.effect = UIBlurEffect(style: .light)
        }, completion: nil)
        
        
        
        //animate the following:
        UIViewPropertyAnimator(duration: 0.3, curve: .linear, animations: {
            
            //set the new corner radius of the haptic settings
            threeDimensionalTouchMenu.layer.cornerRadius = 20
            threeDimensionalTouchMenu.clipsToBounds = true
            
            
            
        }).startAnimation()
        
    }
    
    
    @IBAction func doneButton() {
        requestOnce = false

        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.availableCollectionView.transform = CGAffineTransform.init(scaleX: 1, y: 1)

            self.settingsPerMusicView.transform = CGAffineTransform.init(translationX: 0, y: 600)
            self.miniPlayer.transform = CGAffineTransform.init(scaleX: 1, y: 1)
            self.navigationBarLabel.alpha = 1
            self.musicTableView.transform = CGAffineTransform.init(scaleX: 1, y: 1)

        }, completion: nil)
        
        alternativeBeatmapChecker.load(URLRequest(url: URL(string: "about:blank")!))

        dataExtractingStage = false
    }
    
    
    
    //choices boolean used in haptic and repetition settings
    var choiceOne = false
    var choiceTwo  = false
    var choiceThree = false
    
    
    func updateVolume() {
        
        
        //if change volume settings is enabled
        if changeVolume == true   {
            
            
            //if the finger location is over 0.1
            if (miniPlayer.frame.height - yAxisFingerLocation - 32) > 0.1 {
                
                //change the height of the volume slider depending on the finger location
                volumeSlider.frame = CGRect(x: 0, y: volumeControlVisualEffectView.frame.height - volumeSlider.frame.height, width: volumeControlVisualEffectView.frame.width, height: miniPlayer.frame.height - yAxisFingerLocation - 32)
               
                //print(Float(Float(miniPlayer.frame.height - yAxisFingerLocation - 32)/Float(volumeControlVisualEffectView.frame.height)))
                //(MPVolumeView().subviews.filter{NSStringFromClass($0.classForCoder) == "MPVolumeSlider"}.first as? UISlider)?.setValue(Float(Float(miniPlayer.frame.height - yAxisFingerLocation - 32)/Float(volumeControlVisualEffectView.frame.height)), animated: false)
                
                MPVolumeView.setVolume(Float(Float(miniPlayer.frame.height - yAxisFingerLocation - 32)/Float(volumeControlVisualEffectView.frame.height)))
                //if the finger location is over the height of the volume settings
            } else if (miniPlayer.frame.height - yAxisFingerLocation - 32) >= volumeControlVisualEffectView.frame.height {
                
                //set the volume control settings to 100% instead of going over
                volumeSlider.frame = CGRect(x: 0, y: volumeControlVisualEffectView.frame.height - volumeSlider.frame.height, width: volumeControlVisualEffectView.frame.width, height: miniPlayer.frame.height)
                
                MPVolumeView.setVolume(Float(1.0))

                //if the finger location is negative value
            } else if (miniPlayer.frame.height - yAxisFingerLocation - 32) < 0 {
                
                
                //show 0% in volume control settings
                volumeSlider.frame = CGRect(x: 0, y: volumeControlVisualEffectView.frame.height - volumeSlider.frame.height, width: volumeControlVisualEffectView.frame.width, height: 0)
                MPVolumeView.setVolume(Float(0.0))

            }
            
            
            //if change repetition settings is enabled
        } else if changeRepetitionSettings == true {
            
            
            //if the finger location is over 0.1
            if (miniPlayer.frame.height - yAxisFingerLocation - 32) > 0.1 {
                
                //if finger location is less than 199
                if miniPlayer.frame.height - yAxisFingerLocation - 32 < 199{
                    
                    //set the height of the repetition settings to 100
                    repetitionSlider.frame = CGRect(x: 0, y: repeatControlVisualEffectView.frame.height - 100, width: repeatControlVisualEffectView.frame.width, height: 100)
                    
                    //if choice one is false
                    if choiceOne == false {
                        
                        //play the haptic feedback
                        let hapticFeedback = UIImpactFeedbackGenerator(style: .light)
                        hapticFeedback.prepare()
                        hapticFeedback.impactOccurred()
                        
                        //choice one is true but other ones isn't
                        choiceOne = true
                        choiceThree = false
                        choiceTwo = false
                    }
                }
                
                //if the finger location is somewhere between 200 and 299
                if miniPlayer.frame.height - yAxisFingerLocation - 32 > 200 && miniPlayer.frame.height - yAxisFingerLocation - 32 < 299{
                    
                    //if the choice two is false
                    if choiceTwo == false {
                        
                        //play haptic feedback
                        let hapticFeedback = UIImpactFeedbackGenerator(style: .light)
                        hapticFeedback.prepare()
                        hapticFeedback.impactOccurred()
                        
                        //set the height of the repetition slider to 200
                        repetitionSlider.frame = CGRect(x: 0, y: repeatControlVisualEffectView.frame.height - 200, width: repeatControlVisualEffectView.frame.width, height: 200)
                        
                        //choice two is true and other ones are false
                        choiceOne = false
                        choiceTwo = true
                        choiceThree = false
                    }
                }
                
                //if the finger location is over 300
                if miniPlayer.frame.height - yAxisFingerLocation - 32 > 300 && miniPlayer.frame.height - yAxisFingerLocation - 32 < 399{
                    
                    //if choice three is flase
                    if choiceThree == false {
                        
                        //play haptic feedback
                        let hapticFeedback = UIImpactFeedbackGenerator(style: .light)
                        hapticFeedback.prepare()
                        hapticFeedback.impactOccurred()
                        
                        //set the height of the repeition slide to 300
                        repetitionSlider.frame = CGRect(x: 0, y: repeatControlVisualEffectView.frame.height - 300, width: repeatControlVisualEffectView.frame.width, height: 300)
                        
                        
                        //other settings are false except third choice
                        choiceOne = false
                        choiceThree = true
                        choiceTwo = false
                    }
                }
                
                
                //if the finger location is over the height of the repetition settings
            } else if (miniPlayer.frame.height - yAxisFingerLocation - 32) >= repeatControlVisualEffectView.frame.height {
                
                //set the height of the repetition control panel to maximum instead of going over
                repetitionSlider.frame = CGRect(x: 0, y: repeatControlVisualEffectView.frame.height - repetitionSlider.frame.height, width: repeatControlVisualEffectView.frame.width, height: miniPlayer.frame.height)
                
                
                
                
            }
            
            
            //if change taptic strength settings is enabled
        } else if changeTapticStrength == true {
            
            
            //if the finger location is over 0.1
            if (miniPlayer.frame.height - yAxisFingerLocation - 32) > 0.1 {
                
                //if finger location is less than 199
                if miniPlayer.frame.height - yAxisFingerLocation - 32 < 199{
                    
                    //set the height of the haptic settings to 100
                    hapticSlider.frame = CGRect(x: 0, y: hapticControlVisualEffectView.frame.height - 100, width: hapticControlVisualEffectView.frame.width, height: 100)
                    
                    if choiceOne == false {
                        
                        //play haptic feedback
                        let hapticFeedback = UIImpactFeedbackGenerator(style: .light)
                        hapticFeedback.prepare()
                        hapticFeedback.impactOccurred()
                        
                        
                        tapticStrengthOne = true
                        tapticStrengthTwo = false
                        tapticStrengthThree = false
                        //choice one is true but other ones isn't
                        choiceOne = true
                        choiceThree = false
                        choiceTwo = false
                    }
                }
                if miniPlayer.frame.height - yAxisFingerLocation - 32 > 200 && miniPlayer.frame.height - yAxisFingerLocation - 32 < 299{
                    if choiceTwo == false {
                        
                        
                        //play haptic feedback
                        let hapticFeedback = UIImpactFeedbackGenerator(style: .light)
                        hapticFeedback.prepare()
                        hapticFeedback.impactOccurred()
                        
                        tapticStrengthOne = false
                        tapticStrengthTwo = true
                        tapticStrengthThree = false
                        //set the height of the haptic settings to 200
                        hapticSlider.frame = CGRect(x: 0, y: hapticControlVisualEffectView.frame.height - 200, width: hapticControlVisualEffectView.frame.width, height: 200)
                        
                        //choice two is true and other ones are false
                        choiceOne = false
                        choiceTwo = true
                        choiceThree = false
                    }
                }
                
                if miniPlayer.frame.height - yAxisFingerLocation - 32 > 300 && miniPlayer.frame.height - yAxisFingerLocation - 32 < 399{
                    if choiceThree == false {
                        
                        
                        //play haptic feedback
                        let hapticFeedback = UIImpactFeedbackGenerator(style: .light)
                        hapticFeedback.prepare()
                        hapticFeedback.impactOccurred()
                        
                        tapticStrengthOne = false
                        tapticStrengthTwo = false
                        tapticStrengthThree = true
                        //set the height of the haptic settings to 300
                        hapticSlider.frame = CGRect(x: 0, y: hapticControlVisualEffectView.frame.height - 300, width: hapticControlVisualEffectView.frame.width, height: 300)
                        
                        //other settings are false except third choice
                        choiceOne = false
                        choiceThree = true
                        choiceTwo = false
                    }
                }
                
                //if the finger location is over the height of the haptic settings
            } else if (miniPlayer.frame.height - yAxisFingerLocation - 32) >= repeatControlVisualEffectView.frame.height {
                
                //set the height of the haptic control panel to maximum instead of going over
                hapticSlider.frame = CGRect(x: 0, y: hapticControlVisualEffectView.frame.height - hapticSlider.frame.height, width: hapticControlVisualEffectView.frame.width, height: miniPlayer.frame.height)
                
                
                
                
            }
        }
        
        
        
    }
    
    var otherView = false
    //if the touch ended
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first as UITouch?

        
        if touch!.view == view {
            
            
            
            
            if  otherView == false {
                UIView.animate(withDuration: 0.65, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseInOut, animations: {
                    
                    // self.getStartedLaunchView.transform = CGAffineTransform.init(scaleX: (( self.initialXLocation! - secondaryLocation!.x) / 280) + 1, y: (( self.initialXLocation! - secondaryLocation!.x) / 280) + 1)
                    self.musicHeader.transform = CGAffineTransform.init(translationX: 0, y: 0)
                    self.availableCollectionView.transform = CGAffineTransform.init(translationX: -UIWindow.init().bounds.width, y: 0)
                    self.musicTableView.transform = CGAffineTransform.init(translationX: 0 , y: 0)
                    self.navigationBarLabel.transform = CGAffineTransform.init(translationX: -UIWindow.init().bounds.width , y: 0)

                    //self.tapAudioLabel.alpha = 2 -  ((( self.initialYLocation! - location!.y) / 280) + 1)
                }, completion: nil)
               // availableCollectionView = nil
                otherView = true
            } else if  otherView == true{
                
                UIView.animate(withDuration: 0.65, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseInOut, animations: {
                    
                    // self.getStartedLaunchView.transform = CGAffineTransform.init(scaleX: (( self.initialXLocation! - secondaryLocation!.x) / 280) + 1, y: (( self.initialXLocation! - secondaryLocation!.x) / 280) + 1)
                    
                    self.availableCollectionView.transform = CGAffineTransform.init(translationX: 0, y: 0)
                    self.navigationBarLabel.transform = CGAffineTransform.init(translationX: 0 , y: 0)
                    self.musicTableView.transform = CGAffineTransform.init(translationX: UIWindow.init().bounds.width , y: 0)
                    self.musicHeader.transform = CGAffineTransform.init(translationX: UIWindow.init().bounds.width, y: 0)

                    //self.tapAudioLabel.alpha = 2 -  ((( self.initialYLocation! - location!.y) / 280) + 1)
                }, completion: nil)
                
                //musicTableView = nil
                
                otherView = false

            }
            
        }else {
        
        //make all choice booleans to false
        choiceOne = false
        choiceTwo  = false
        choiceThree = false
        
        //the force user putting on the screen is 9
        currentForce = 0
        
        //user did not do any 3D Touch gesture
        completed3DTouch = false
        
        //user does not want to change any settings
        changeVolume = false
        changeRepetitionSettings = false
        changeTapticStrength = false
        
        
        //aniamte the following:
        UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            
            
            //restore all setting control views to the icons
            self.volumeControlVisualEffectView.frame  = CGRect(x: 20, y: self.miniPlayer.frame.height - 22 - 50, width: 50, height: 50)
            self.repeatControlVisualEffectView.frame  = CGRect(x: self.miniPlayer.frame.width/2 - 25, y: self.miniPlayer.frame.height - 22 - 50, width: 50, height: 50)
            self.hapticControlVisualEffectView.frame  = CGRect(x: self.miniPlayer.frame.width - 50 - 20, y: self.miniPlayer.frame.height - 22 - 50, width: 50, height: 50)
            
            
            //set the visual blur effect hierachy view to 0
            self.THREEDTouchHierachyVisualEffect.alpha = 0
            
        }, completion: nil)
        self.THREEDTouchHierachyVisualEffect.alpha = 0

        UIView.animate(withDuration: 0.4, animations: {
            //  EITHER...
            self.THREEDTouchHierachyVisualEffect.effect = nil
            //  OR...
        }, completion: nil)
        
        //animate the following:
        UIViewPropertyAnimator(duration: 0.4, curve: .linear, animations: {
            
            //change the haptic control setting's corner radius to 12
            self.hapticControlVisualEffectView.layer.cornerRadius = 12
            self.hapticControlVisualEffectView.clipsToBounds = true
            
            
            //change the volume control setting's corner radius to 12
            self.volumeControlVisualEffectView.layer.cornerRadius = 12
            self.volumeControlVisualEffectView.clipsToBounds = true
            
            //change the repeat control setting's corner radius to 12
            self.repeatControlVisualEffectView.layer.cornerRadius = 12
            self.repeatControlVisualEffectView.clipsToBounds = true
        }).startAnimation()
        // forceStrengthLabel.text = "\(tareForce > 0 ? "-" : "")\(tareForce.grams(0))"
        
        }
    }
    
    @IBAction func pauseOrPlay() {
        //myMediaPlayer.playbackState == MPMoviePlaybackState ? myMediaPlayer.pause() : myMediaPlayer.play()
        
        
        if myMediaPlayer.playbackState == MPMusicPlaybackState.paused {
            
            UIView.animate(withDuration: 0.5) {
                self.playOrPauseButton.setImage(UIImage(named: "Pause.png"), for: .normal)

            }
            UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.7, options: .curveEaseOut, animations: {

            self.miniPlayerAlbumArt.transform = CGAffineTransform.init(scaleX: 1, y: 1)

                
            }, completion: nil)

            myMediaPlayer.play()
        } else if myMediaPlayer.playbackState == MPMusicPlaybackState.playing {
            
            UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.7, options: .curveEaseOut, animations: {
                
                self.miniPlayerAlbumArt.transform = CGAffineTransform.init(scaleX: 0.85, y: 0.85)

            }, completion: nil)

            myMediaPlayer.pause()
            
            UIView.animate(withDuration: 0.5) {

            self.playOrPauseButton.setImage(UIImage(named: "PlayButton.png"), for: .normal)
            }

        } else {
            
        }
        
    }
    
    
    
    //the height of the table view cell?
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        //it will be 189 pixels
        return 162
    }
    
    
    //number of cells in table view?
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        //number of elements in music title array
        return songNameArray.count
    }
    
    
    var requestOnce = false
    var urlToLoad: String!
    
    @objc func didChangeDelaySettings() {
        var tempVarForUserDelayInteger: Int?
        loadingAlternativeBeatmapView.alpha = 1
        alternativeCollectionView.backgroundColor = UIColor.lightGray
        alternativeBeatmapsString.removeAll()
        alternativeCollectionView.reloadData()
        invalidateState = false
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.availableCollectionView.transform = CGAffineTransform.init(scaleX: 0.9, y: 0.9)

            self.settingsPerMusicView.transform = CGAffineTransform.init(translationX: 0, y: 0)
            self.miniPlayer.transform = CGAffineTransform.init(scaleX: 0.9, y: 0.9)
            self.navigationBarLabel.alpha = 0
            self.musicTableView.transform = CGAffineTransform.init(scaleX: 0.75, y: 0.75)
             }, completion: nil)
        
        //alternativeBeatmapChecker.load(URLRequest(url: URL(string: "https://www.apple.com")!))
        
        var keyword = miniPlayerMusicTitle.text!
        
        var artistNameString = miniPlayerArtistLabel.text!
        
            if miniPlayerMusicTitle.text! != nil {
                
                //keyword = keyword.replacingOccurrences(of: " ", with: "%20")
                keyword = keyword.replacingOccurrences(of: "(", with: "")
                keyword = keyword.replacingOccurrences(of: ")", with: "")
                keyword = replaceText(string:keyword)
                print(keyword)
                
                artistNameString = replaceText(string: artistNameString)
                print(artistNameString)
                
                
                
            }
        
        
        if requestOnce == false {
        var original = "https://bloodcat.com/osu/?q=\(keyword) \(artistNameString)&c=b&s=&m=&g=&l="
            
        original = original.replacingOccurrences(of: "%25", with: "%")
            
            original = original.replacingOccurrences(of: "ilKPOP.com", with: "")
            original = original.replacingOccurrences(of: "ilKPOPcom", with: "")
            original = original.replacingOccurrences(of: " - ", with: "")
            urlToLoad = original
            
            
            if let encoded = urlToLoad.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed),
                let url = URL(string: encoded){
                
                let req = URLRequest(url:url)
                
                self.alternativeBeatmapChecker!.load(req)
                
                print(url)
                print("LoadingURLRN")
            }
            timerPLEASELOAD = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(musicViewController.load), userInfo: nil, repeats: true)



          requestOnce = true
        }
        print(alternativeBeatmapChecker.url)
        //tapticDelayUserSetting[index] = Int(delayTextField.text!)!
        //tapticDelayUserSetting.append(tempVarForUserDelayInteger!)
        print("Long Gesture Recognized")
        
        
        
    }
    
    
    
    @objc func load() {
        print("checking")
        if alternativeBeatmapChecker.isLoading == false   {
            if let encoded = urlToLoad.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed),
                let url = URL(string: encoded){
                
                let req = URLRequest(url:url)
                
                self.alternativeBeatmapChecker!.load(req)
                
                print(url)
                print("LoadingURLRN")
            }
            
        }
        
    }
    
    func replaceText(string: String!) -> String! {
        /* So first we take the inverted set of the characters we want to keep,
         this will act as the separator set, i.e. those characters we want to
         take out from the user input */
        let inverseSet = NSCharacterSet(charactersIn:"ABCDEFGHIJKLMNOPQRSTUVWXYUZabcdefghijklmnopqrstuvwxyuz 1234567890-").inverted
        
        /* We then use this separator set to remove those unwanted characters.
         So we are basically separating the characters we want to keep, by those
         we don't */
        let components = string.components(separatedBy: inverseSet)
        
        /* We then join those characters together */
        
        let filtered = components.joined(separator: "")
        
        return filtered
    }
    
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        print("DidStartLoading")

    }
    
    var savedString: String?

    func checkAndProceedTextRemoval(htmlString: String!) {
        
        var stringToCheck = htmlString!
        if let dotRange = stringToCheck.range(of: "osu.ppy.sh/s/") {
            stringToCheck.removeSubrange(stringToCheck.startIndex..<dotRange.upperBound)
            //htmlAsString.removeSubrange(dotRange.lowerBound..<htmlAsString.endIndex)
            
        }
        
        
        if let dotRange = stringToCheck.range(of: "\">") {
            savedString = stringToCheck
 
            
            
            stringToCheck.removeSubrange(dotRange.lowerBound..<stringToCheck.endIndex)
            //htmlAsString.removeSubrange(dotRange.lowerBound..<htmlAsString.endIndex)
            //print(htmlAsString)
            alternativeBeatmapsString.append(stringToCheck)
            self.alternativeCollectionView.reloadData()
            UIView.animate(withDuration: 0.5, animations: {
                self.alternativeCollectionView.backgroundColor = UIColor.white
                self.loadingAlternativeBeatmapView.alpha = 0
                
            })
            
            if let dotRange = savedString?.range(of: "osu.ppy.sh/s/") {
                checkAndProceedTextRemoval(htmlString: savedString)

                //htmlAsString.removeSubrange(dotRange.lowerBound..<htmlAsString.endIndex)
                
            }
            
            
        }
    }
    
    
    
    
    var invalidateState = false
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        
        if invalidateState == false {
        if dataExtractingStage == false {
        requestOnce = false

        print("DidFinishedLoading")
        
        var secondCheckString:String!
        alternativeBeatmapChecker?.evaluateJavaScript("document.documentElement.outerHTML.toString()",completionHandler: { (html: Any?, error: Error?) in
            
            
            //print(html as! String)
            var htmlAsString = html as! String
            /*
            if let dotRange = htmlAsString.range(of: "<script src=") {
                htmlAsString.removeSubrange(dotRange.lowerBound..<htmlAsString.endIndex)

 
            }*/
                if let dotRange = htmlAsString.range(of: "</main>") {
                    //htmlAsString.removeSubrange(htmlAsString.startIndex..<dotRange.lowerBound)
                    htmlAsString.removeSubrange(dotRange.lowerBound..<htmlAsString.endIndex)
                     print(htmlAsString)
                    
                }
                
                if let dotRange = htmlAsString.range(of: "osu.ppy.sh/s/") {
                    secondCheckString = htmlAsString
                    htmlAsString.removeSubrange(htmlAsString.startIndex..<dotRange.upperBound)
                    //htmlAsString.removeSubrange(dotRange.lowerBound..<htmlAsString.endIndex)
                    
                } else {
                }
         
         
                if let dotRange = htmlAsString.range(of: "\">") {
                    secondCheckString = htmlAsString
                    
                    
                    if let dotRange = secondCheckString.range(of: "osu.ppy.sh/s/") {
                        self.checkAndProceedTextRemoval(htmlString: secondCheckString)
                        
                        //htmlAsString.removeSubrange(dotRange.lowerBound..<htmlAsString.endIndex)
                        
                    }

                    
                    htmlAsString.removeSubrange(dotRange.lowerBound..<htmlAsString.endIndex)
                    //htmlAsString.removeSubrange(dotRange.lowerBound..<htmlAsString.endIndex)
                    //print(htmlAsString)
                    alternativeBeatmapsString.append(htmlAsString)
                    self.alternativeCollectionView.reloadData()
                    UIView.animate(withDuration: 0.5, animations: {
                        self.alternativeCollectionView.backgroundColor = UIColor.white
                        self.loadingAlternativeBeatmapView.alpha = 0

                    })

                    
                }
                

        })
        
        
        timerPLEASELOAD.invalidate()
            
            if invalidateState == true {
                
                alternativeBeatmapChecker.load(URLRequest(url: URL(string: "about:blank")!))

            }

        } else if dataExtractingStage == true {
            var urlLink:String! = alternativeBeatmapChecker!.url!.absoluteString

            if ((alternativeBeatmapChecker?.url?.absoluteString.range(of: "osu.ppy.sh")) != nil) && ((alternativeBeatmapChecker?.url?.absoluteString.range(of: "#osu")) != nil){
                print("Valid URL")
                
                if let dotRange = urlLink!.range(of: "#osu/") {
                    //htmlAsString.removeSubrange(htmlAsString.startIndex..<dotRange.lowerBound)
                    print(urlLink)
                    urlLink.removeSubrange(urlLink.startIndex..<dotRange.upperBound)
                    print(urlLink)
                    beatmapAlternativeToBeDownloadedID = Int(urlLink)!
                    downloadAndExtractBeatmapData(dataIDNumber: beatmapAlternativeToBeDownloadedID)
                    //beatmapIDArray.append(Int(urlLink)!)
                   // print("beatmapID ARRAY: \(beatmapIDArray)")
                    // print(htmlAsString)
                    
                }
                
                //tapticDataArray.removeAll()
                
            } else if ((alternativeBeatmapChecker?.url?.absoluteString.range(of: "osu.ppy.sh")) != nil) && ((alternativeBeatmapChecker?.url?.absoluteString.range(of: "#osu")) == nil) {
                
               // beatmapIDArray.append(0)
                
            }
            
        }
            
            
        }
    }
    
    var success = false
    
    func downloadAndExtractBeatmapData(dataIDNumber: Int?) {
        print("Downloading")
        //Download text file
        if dataIDNumber != 0 {
            let documentsUrl:URL =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first as URL!
            let destinationFileUrl = documentsUrl.appendingPathComponent("\(dataIDNumber!).txt")
            
            //Create URL to the source file you want to download
            let fileURL = URL(string: "https://osu.ppy.sh/osu/\(dataIDNumber!)")
            
            let sessionConfig = URLSessionConfiguration.default
            let session = URLSession(configuration: sessionConfig)
            
            let request = URLRequest(url:fileURL!)
            
            let task = session.downloadTask(with: request) { (tempLocalUrl, response, error) in
                if let tempLocalUrl = tempLocalUrl, error == nil {
                    // Success
                    if let statusCode = (response as? HTTPURLResponse)?.statusCode {
                        print("Successfully downloaded. Status code: \(statusCode)")
                        self.success = true
                    }
                    
                    do {
                        try FileManager.default.copyItem(at: tempLocalUrl, to: destinationFileUrl)
                        print(destinationFileUrl)
                    } catch (let writeError) {
                        print("Error creating a file \(destinationFileUrl) : \(writeError)")
                    }
                    
                } else {
                    print("Error took place while downloading a file. Error description: %@", error?.localizedDescription);
                }
            }
            task.resume()
            
            
            
        } else if dataIDNumber == 0 {
            
            
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute:{

            self.extractBeatmapData(dataIDNumber: dataIDNumber)
            
        })

        

        
    }
    
    
    func extractBeatmapData(dataIDNumber:Int?) {
        print("Extracting")
        
        if dataIDNumber != 0 {
            //OPEN AND READ TEXT FILE
            //https://stackoverflow.com/questions/24097826/read-and-write-a-string-from-text-file
            do {
                // get the documents folder url
                if let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
                    // create the destination url for the text file to be saved
                    let fileURL = documentDirectory.appendingPathComponent("\(dataIDNumber!).txt")
                    //print(fileURL)
                    print(fileURL)
                    
                    var savedData = try String(contentsOf: fileURL)
                    print(savedData)
                    if let dotRange = savedData.range(of: "[HitObjects]") {
                        savedData.removeSubrange(savedData.startIndex..<dotRange.upperBound)
                        //htmlAsString.removeSubrange(dotRange.lowerBound..<htmlAsString.endIndex)
                        //print(savedData)
                        
                    }
                    
                    savedData =  savedData.replacingOccurrences(of:"\n", with: "*")
                    //print(savedData)
                    
                    
                    
                    var testDataSaveArray:[Int] = []
                    testDataSaveArray.removeAll()
                    var savedString = savedData
                    
                    
                    
                    var indexChar = 0
                    var commaCount = 0
                    var dataExtracted = ""
                    var dataBackedUp = ""
                    var removedFirstCommas = false
                    var commaCountRepetitionProtection = true
                    var commaCountRepetitionProtectionSecond = true
                    
                    for x in savedString {
                        
                        if x == ","  {
                            commaCount += 1
                            
                        } else if commaCount == 1 {

                            let dotRange = savedString.range(of: ",")
                            if dotRange != nil && commaCountRepetitionProtection{
                                savedString.removeSubrange(savedString.startIndex..<(dotRange?.upperBound)!)
                                commaCountRepetitionProtection = false
                            }
                            
                            
                        } else if commaCount == 2 {
                            
                            let dotRange = savedString.range(of: ",")
                            if dotRange != nil && commaCountRepetitionProtectionSecond{
                                savedString.removeSubrange(savedString.startIndex..<(dotRange?.upperBound)!)
                                commaCountRepetitionProtectionSecond = false
                            }
                            
                        }else if commaCount == 3 {
                            dataBackedUp = savedString
                            
                            if let dotRange = savedString.range(of:",") {
                                savedString.removeSubrange(dotRange.lowerBound..<savedString.endIndex)
                                dataExtracted = savedString
                                savedString = dataBackedUp
                                testDataSaveArray.append(Int(dataExtracted)!)
                                
                            }
                            
                            
                            if let starRange = savedString.range(of: "*"){
                                savedString.removeSubrange(savedString.startIndex..<starRange.upperBound)
                                
                                removedFirstCommas = false
                                commaCount = 0
                                dataExtracted = ""
                                dataBackedUp = ""
                                commaCountRepetitionProtectionSecond = true
                                commaCountRepetitionProtection = true
                            }
                            
                            
                        }
                        
                        indexChar += 1
                        
                        
                    }
                    
                    
                    print(testDataSaveArray)
                    print("appending to tapticDataArray...")
                    
                    if selectionIdentity ==  "CollectionView" {
                        print(indexNumberForBeatMapLocation)

                    tapticDataInUseArray[availableBeatmapMusicIndex[indexNumberForBeatMapLocation!]] =  testDataSaveArray
                        play(index: indexNumberForBeatMapLocation, identifier: "CollectionView")
                        doneButton()
                        expand()
                        //  tapticDataInUseArray = UserDefaults.standard.object(forKey: "tapticBeatmapData") as! [[Int]]

                        UserDefaults.standard.set(tapticDataInUseArray, forKey: "tapticBeatmapData")

                        
                    } else if selectionIdentity == "tableView" {
                        tapticDataInUseArray[indexNumberForBeatMapLocation] =  testDataSaveArray
                        play(index: indexNumberForBeatMapLocation, identifier: "tableView")
                        doneButton()
                        expand()

                        //  tapticDataInUseArray = UserDefaults.standard.object(forKey: "tapticBeatmapData") as! [[Int]]
                        
                        UserDefaults.standard.set(tapticDataInUseArray, forKey: "tapticBeatmapData")

                        
                    }
                    print(tapticDataArray)
                    
                    // define the string/text to be saved
                    // writing to disk
                    try savedData.write(to: fileURL, atomically: false, encoding: .utf8)
                    print("saving was successful")
                    // any code posterior code goes here
                    // reading from disk
                    let savedText = try String(contentsOf: fileURL)
                    print("savedText:", savedText)   // "Hello World !!!\n"
                    
                    
                }
            } catch {
                 print("error:", error)
            }
            
        } else if dataIDNumber == 0 {
            //tapticDataArray.append([0])
            print("unavailable")
            
        }
        
        
        dataExtractingStage = false
        
    }

    
    
    
    func webView(_ webView: WKWebView,
                 didReceive challenge: URLAuthenticationChallenge,
                 completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void)
    {
        if(challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust)
        {
            let cred = URLCredential(trust: challenge.protectionSpace.serverTrust!)
            completionHandler(.useCredential, cred)
        }
        else
        {
            completionHandler(.performDefaultHandling, nil)
        }
    }
    
    
    
    
    @IBAction func doneEditingDelay() {
        delayTextField.resignFirstResponder()
        var indexToSave: Int!
        if playingFrom == "CollectionView" {
            //indexToSave = availableBeatmapMusicIndex[index]
            
        } else if playingFrom == "TableView" {
            
            //indexToSave = index - 1
        }
        
        tapticDelayUserSetting[indexForDelayEdit] = Int(delayTextField.text!)!
        print(tapticDelayUserSetting[indexForDelayEdit])
        UserDefaults.standard.set(tapticDelayUserSetting, forKey: "tapticDelays")
    }
    
    
    var index = 0
    var userDelayInput: Int!
    //when tableview cell is tapped
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        index = indexPath.row

        play(index: indexPath.row, identifier: "tableView")
        musicTableView.deselectRow(at: indexPath, animated: false)

      
    }
    
    var selectionIdentity:String?
    var indexNumberForBeatMapLocation: Int!
    var indexForDelayEdit: Int!
    var playingFrom: String?
    func play(index: Int!, identifier: String!) {
        //print(index)
        selectionIdentity = identifier


        let songQuery = MPMediaQuery()
        //MARK: DEBUGING STUFF
        /*
         print(tapticDataInUseArray[indexPath.row])
         print(tapticDataInUseArray)
         print(indexPath.row)
         print(tapticDataInUseArray[indexPath.row])
         */
        
        if identifier == "CollectionView" {
            playingFrom = "CollectionView"
            userDelayInput = tapticDelayUserSetting[availableBeatmapMusicIndex[index]]
            
            testBeatmapArray.removeAll()
            testBeatmapArray = tapticDataInUseArray[availableBeatmapMusicIndex[index]]
            print(tapticDelayUserSetting[availableBeatmapMusicIndex[index]])
            
            self.delayTextField.text = String(tapticDelayUserSetting[availableBeatmapMusicIndex[index]])
            indexNumberForBeatMapLocation = index
            
            self.indexForDelayEdit = availableBeatmapMusicIndex[index]
            
            dataCount = 0
            timer.invalidate()

            playAudio(userLibrarySongID: songIDArray[availableBeatmapMusicIndex[index]])
            miniPlayerAlbumArt.image = myMediaPlayer.nowPlayingItem?.artwork?.image(at: CGSize(width: 500, height: 500))
            musicPlayerBackground.image = myMediaPlayer.nowPlayingItem?.artwork?.image(at: CGSize(width: 500, height: 500))
            
            
            //set the music title to the one in array
            miniPlayerMusicTitle.text = availableBeatmapMusicTitle[index]
            
            
            var artist = availableBeatmapMusicArtistName[index]
            miniPlayerMusicTitle.text = availableBeatmapMusicTitle[index]
            miniPlayerArtistLabel.text = artist
            miniPlayerArtistLabel.text = artist
            
        } else if identifier == "tableView" {
            playingFrom = "tableView"
            indexNumberForBeatMapLocation = index
            indexForDelayEdit = index

            userDelayInput = tapticDelayUserSetting[index]
            testBeatmapArray.removeAll()
            testBeatmapArray = tapticDataInUseArray[index]
            print(tapticDelayUserSetting[index])
            self.delayTextField.text = String(tapticDelayUserSetting[index])
            //expand the music player
            dataCount = 0
            timer.invalidate()

            playAudio(userLibrarySongID: songIDArray[index])
            
            //set the album art image view to the one in the album art array
            miniPlayerAlbumArt.image =  myMediaPlayer.nowPlayingItem?.artwork?.image(at: CGSize(width: 500, height: 500))
            musicPlayerBackground.image = myMediaPlayer.nowPlayingItem?.artwork?.image(at: CGSize(width: 500, height: 500))
            
            var artist = artistName[index]
            miniPlayerMusicTitle.text = songNameArray[index]
            miniPlayerArtistLabel.text = artist
            miniPlayerMusicTitle.text = songNameArray[index]
            miniPlayerArtistLabel.text = artist
            

        
        }
        timer = Timer.scheduledTimer(timeInterval: 0, target: self, selector: #selector(musicViewController.playTapticAudio), userInfo: nil, repeats: true)
        RunLoop.main.add(timer, forMode: .common)
        expand()
        

        //delselect the selected music table cell
        
    }
    
    
    let lightTaptic = UIImpactFeedbackGenerator(style: .light)
    let mediumTaptic = UIImpactFeedbackGenerator(style: .medium)
    let heavyTaptic = UIImpactFeedbackGenerator(style: .heavy)
var songPlayer = AVAudioPlayer()
    var dataCount = 0
    @objc func playTapticAudio() {
        //print(songPlayer.currentTime * 1000)
        //print(Int(player!.currentTime * 1000))
        //musicProgress.setValue(Float(Float(myMediaPlayer.currentPlaybackTime)/Float((myMediaPlayer.nowPlayingItem?.playbackDuration)!)), animated: true)
        
        
//instead of currentPlayBackTime, replace it with timer. put a new timer that checks rhw xueewnrPlatBack Time for optimization.
        if dataCount < testBeatmapArray.count  {
            
            if Int(myMediaPlayer.currentPlaybackTime * 1000)  > testBeatmapArray[dataCount] - userDelayInput {
                
                if dataCount + 1 < testBeatmapArray.count {
                    dataCount += 1
                    
                    if tapticStrengthOne == true {
                        lightTaptic.impactOccurred()
                    } else if tapticStrengthTwo == true {
                   // AudioServicesPlaySystemSound(1519)
                        mediumTaptic.impactOccurred()
                    }else if tapticStrengthThree == true {
                        heavyTaptic.impactOccurred()
                    
                    }
                }
            }
            
            /*
            if Int(myMediaPlayer.currentPlaybackTime * 1000)  == testBeatmapArray[dataCount] - userDelayInput{
                
               // lightTaptic.impactOccurred()
                if tapticStrengthOne == true {
                    lightTaptic.impactOccurred()
                    
                } else if tapticStrengthTwo == true {
                    //AudioServicesPlaySystemSound(1519)
                    mediumTaptic.impactOccurred()
                }else if tapticStrengthThree == true {
                    heavyTaptic.impactOccurred()
                    
                }

                dataCount += 1

            }*/
        }
        if Int(myMediaPlayer.currentPlaybackTime)  == Int((myMediaPlayer.nowPlayingItem?.playbackDuration)!) {
            
            skipToNextSong()
        }
    }

    var indexNo: Int!
    @IBAction func skipToNextSong() {
        
        
        if playingFrom == "CollectionView" {
            indexNo = availableBeatmapMusicIndex[index + 1]
            
        } else if playingFrom == "TableView" {
            
            indexNo = index + 1
        }
        
        userDelayInput = tapticDelayUserSetting[indexNo]
        testBeatmapArray.removeAll()
        testBeatmapArray = tapticDataInUseArray[indexNo]
        
        playAudio(userLibrarySongID: songIDArray[indexNo])
        
        
        UIView.transition(with: miniPlayerAlbumArt, duration: 0.5, options: .transitionCrossDissolve,animations: {
                            
                           //MPMediaQuery.songs().items?[availableBeatmapMusicIndex[indexPath.row]].artwork?.image(at: CGSize(width: 50, height: 50))
            //set the album art image view to the one in the album art array
            self.miniPlayerAlbumArt.image =  self.myMediaPlayer.nowPlayingItem?.artwork?.image(at: CGSize(width: 500, height: 500))

                            
        },completion: nil)
        
        UIView.transition(with: musicPlayerBackground, duration: 0.5, options: .transitionCrossDissolve,animations: {
            
            
            //set the music player background image view to the one in the album art array
            self.musicPlayerBackground.image = self.myMediaPlayer.nowPlayingItem?.artwork?.image(at: CGSize(width: 500, height: 500))
            
            
        },completion: nil)

        
        miniPlayerMusicTitle.text = songNameArray[indexNo]
        miniPlayerArtistLabel.text = artistName[indexNo]
        dissolveLabel(label: miniPlayerMusicTitle, toString: songNameArray[indexNo])
        dissolveLabel(label: miniPlayerArtistLabel, toString: artistName[indexNo])

        dataCount = 0
        
        index += 1

    }
    
    
    @IBAction func skipToPreviousSOng() {
        
        
        if playingFrom == "CollectionView" {
            indexNo = availableBeatmapMusicIndex[index - 1]
            
        } else if playingFrom == "TableView" {
            
            indexNo = index - 1
        }
        
        userDelayInput = tapticDelayUserSetting[indexNo]
        testBeatmapArray.removeAll()
        testBeatmapArray = tapticDataInUseArray[indexNo]
        
        playAudio(userLibrarySongID: songIDArray[indexNo])
        
        
        
        UIView.transition(with: miniPlayerAlbumArt, duration: 0.5, options: .transitionCrossDissolve,animations: {
            
            
            //set the album art image view to the one in the album art array
            self.miniPlayerAlbumArt.image =  self.myMediaPlayer.nowPlayingItem?.artwork?.image(at: CGSize(width: 500, height: 500))
            
            
        },completion: nil)
        
        UIView.transition(with: musicPlayerBackground, duration: 0.5, options: .transitionCrossDissolve,animations: {
            
            
            //set the music player background image view to the one in the album art array
            self.musicPlayerBackground.image = self.myMediaPlayer.nowPlayingItem?.artwork?.image(at: CGSize(width: 500, height: 500))
            
            
        },completion: nil)
        

        
        //set the music title to the one in array
        miniPlayerMusicTitle.text = songNameArray[indexNo]
        

        //set the music creator title to the one in array
        miniPlayerArtistLabel.text = artistName[indexNo]
        
        //set the music title in maxed out view to the one in array
        //miniPlayerMusicTitle.text = songNameArray[index - 1]
        dissolveLabel(label: miniPlayerMusicTitle, toString: songNameArray[indexNo])
        
        
        //set the music artist title in maxed out view to the one in array
        //miniPlayerArtistLabel.text = artistName[index - 1]
        
        dissolveLabel(label: miniPlayerArtistLabel, toString: artistName[indexNo])

        dataCount = 0
        
        index -= 1

    }
    
    
    func dissolveLabel(label: UILabel!, toString: String!) {
        
        UIView.transition(with: label,duration: 0.5,options: .transitionCrossDissolve,animations: { [weak self] in
               label.text = toString
            }, completion: nil)
    }
    //what properties will each cell have?
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        //tableView Cell with my own custom class with its identifier "musicTableViewCell"
        let musicCell = musicTableView.dequeueReusableCell(withIdentifier: "musicTableViewCell", for: indexPath) as!
        musicCustomTableViewCell
        
        
        var artist = artistName[indexPath.row]
        
        //set music title text to labels in each cell
        musicCell.musicTitle.text = songNameArray[indexPath.row]
        
        
        //set the image of album art in each cell
        musicCell.albumArtView.image =  MPMediaQuery.songs().items?[indexPath.row].artwork?.image(at: CGSize(width: 40, height: 40))
        
        //set the music creator title to the one in array in each cell
        musicCell.musicCreator.text = artist.replacingOccurrences(of: " - ilKPOP.com", with: "")
        
   
        musicCell.albumArtView.layer.cornerRadius = 20
        musicCell.albumArtView.clipsToBounds = true
        
        
        
        
        
        //return musicCell for my music list view
        return musicCell
        
    }
    let myMediaPlayer = MPMusicPlayerApplicationController.applicationMusicPlayer
    

    func playAudio(userLibrarySongID: Int!) {
        
        let musicProperties = MPMediaPropertyPredicate(value: userLibrarySongID, forProperty: MPMediaItemPropertyPersistentID)
        
        let songQuery = MPMediaQuery()
        songQuery.addFilterPredicate(musicProperties)
        myMediaPlayer.prepareToPlay()
        myMediaPlayer.setQueue(with: songQuery.collections![0])
        myMediaPlayer.play()
        
        
        
    }
    
    
    
}

extension CGFloat {
    
    func grams(_ tare: CGFloat) -> String {
        
        //returns the amount of user puts pressure on to the screen
        return String(format: "%.0f", (self - tare) / CGFloat(0.65))
    }
}

extension MPVolumeView {
    static func setVolume(_ volume: Float) {
        let volumeView = MPVolumeView()
        let slider = volumeView.subviews.first(where: { $0 is UISlider }) as? UISlider
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.01) {
            slider?.value = volume;
        }
    }
}

extension UIView {
    func fadeTransition(duration:CFTimeInterval) {
        let animation:CATransition = CATransition()
        animation.timingFunction = CAMediaTimingFunction(name:
            CAMediaTimingFunctionName.easeInEaseOut)
        animation.type = .fade
        animation.duration = duration
        self.layer.add(animation, forKey: "Transition")
    }
    
}
/*
extension UILabel {
    func animate(font: UIFont, duration: TimeInterval, frame: CGRect) {
         let oldFrame = frame
        let labelScale = self.font.pointSize / font.pointSize
        self.font = font
        let oldTransform = transform
        transform = transform.scaledBy(x: labelScale, y: labelScale)
        let newOrigin = frame
         frame.origin = oldFrame.origin // only for left aligned text
        // frame.origin = CGPoint(x: oldFrame.origin.x + oldFrame.width - frame.width, y: oldFrame.origin.y) // only for right aligned text
        setNeedsUpdateConstraints()
        UIView.animate(withDuration: duration, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {

            self.frame.origin = newOrigin
            self.transform = oldTransform
            self.layoutIfNeeded()
        }, completion: nil)
    }
}
*/
