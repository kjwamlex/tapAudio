//
//  ViewController.swift
//  tapAudio
//
//  Created by 김준우 on 2018-07-04.
//  Copyright © 2018 김준우. All rights reserved.
//

import UIKit
import MediaPlayer
import AVFoundation
import WebKit

var songNameArray:[String] = []
var songIDArray:[Int] = []
var albumArtArray:[UIImage] = []
var artistName:[String] = []
var tapticDataArray:[[Int]] = [[]]
var proceedLoop  = true
var indexedIndexPath = 0
var indexMusicsNow = false
class MusicPlayerCell: UITableViewCell {
    @IBOutlet var labelMusicTitle: UILabel!
    @IBOutlet var labelMusicDescription: UILabel!
    @IBOutlet var imageMusic: UIImageView!
}



class ViewController: UIViewController,WKNavigationDelegate  {

    var beatmapDownloadView: WKWebView?
   // var albums: [AlbumInfo] = []
    //var songQuery: SongQuery = SongQuery()
    var audio: AVAudioPlayer?
    @IBOutlet var progressLabel: UILabel!
    @IBOutlet var indexingProgressBar: UIProgressView!
    @IBOutlet var progressView: UIView!
    @IBOutlet var workView: UIView!
    @IBOutlet var promptLabelBottom: UILabel!
    @IBOutlet var userStartUsingScreen: UIView!
    @IBOutlet var skip: UIButton!
    @IBOutlet var swipUpLabel: UILabel!
    @IBOutlet var oneTap: UIView!
    @IBOutlet var twoTap: UIView!
    @IBOutlet var threeTap: UIView!
    @IBOutlet var hapticChooseView: UIView!
    @IBOutlet var tapAudioLabel: UILabel!
    @IBOutlet var applePleaseFixThisWebKitBug: WKWebView!
    @IBOutlet var setupLogo: UIImageView!
    override func viewWillAppear(_ animated: Bool) {
        let statusBar: UIView = UIApplication.shared.value(forKey: "statusBar") as! UIView
        statusBar.isHidden = true
        
        setupLogo.alpha = 0
        swipUpLabel.alpha = 0
        self.promptLabelBottom.text = ""

        progressLabel.alpha = 0
        indexingProgressBar.alpha = 0
        self.userStartUsingScreen.transform = CGAffineTransform.init(translationX: 500, y: 0)
        
        self.hapticChooseView.transform = CGAffineTransform.init(translationX: 500, y: 0)
        skip.alpha = 0
        
        oneTap.layer.cornerRadius = 40
        oneTap.clipsToBounds = true
        
        twoTap.layer.cornerRadius = 40
        twoTap.clipsToBounds = true

        
        threeTap.layer.cornerRadius = 40
        threeTap.clipsToBounds = true

    }
    
    let weakTap = UIImpactFeedbackGenerator(style: .light)
    
    let mediumTap = UIImpactFeedbackGenerator(style: .medium)
    
    let heavyTap = UIImpactFeedbackGenerator(style: .heavy)
    
    @IBAction func weak() {
        
        weakTap.impactOccurred()
    }
    
    @IBAction func medium() {
        
        mediumTap.impactOccurred()

    }
    
    @IBAction func heavy() {
        heavyTap.impactOccurred()

        
    }
    
    @IBAction func getStartedWithIndexing() {
        swipUpLabel.alpha = 0
startedWorking = true
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseInOut, animations: {
            
            self.progressView.transform = CGAffineTransform.init(scaleX: 2.3, y: 2.3)

        }, completion: nil)
        
        UIView.animate(withDuration: 0.5, delay: 0.5, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseInOut, animations: {

            self.progressView.transform = CGAffineTransform.init(scaleX: 1, y: 1)
            self.setupLogo.alpha = 1
            self.progressLabel.alpha = 1
            self.indexingProgressBar.alpha = 1

        }, completion: nil)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute:{

            self.promptLabelBottom.text = "tapAudio scans your Music Library and adds haptic data to the app."

        })

        
        self.title = "Songs"
        MPMediaLibrary.requestAuthorization { (status) in
            if status == .authorized {
                //self.albums = self.songQuery.get(songCategory: "")
            } else {
            }
        }
        self.beatmapDownloadView = WKWebView()
        self.beatmapDownloadView?.navigationDelegate = self
        self.beatmapDownloadView = WKWebView()
        self.workView = self.beatmapDownloadView!
        self.beatmapDownloadView?.navigationDelegate = self
        let url = URL(string:"http://www.apple.com/")
        let req = URLRequest(url:url!)
        
        self.beatmapDownloadView!.load(req)
        
        //print(albums.count)
        
        view.bringSubviewToFront(progressView)
        
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 5.0, execute:{
            
            
            /*
            for x in 0...self.albums.count - 1 {
                
                print(x - 1)
                
                self.indexingProgressBar.progress = Float(Float(x - 1)/Float((self.albums.count - 1)))
                
                for y in 0...self.albums[x].songs.count - 1 {
                    tapticDelayUserSetting.append(0)
                    songNameArray.append(self.albums[x].songs[y].songTitle)
                    songIDArray.append(Int(truncating: self.albums[x].songs[y].songId))
                    artistName.append(self.albums[x].songs[y].artistName)
                    albumArtArray.append(self.albums[x].songs[y].songImage)
                    print(self.albums[x].songs[y].songId)
                    print(self.albums[x].songs[y].songTitle)
                    print(self.albums[x].songs[y].artistName)
                }
            }*/
            
            for song in MPMediaQuery.songs().items! {
                //songTitleTest.append(song.title!)
                //songArtitstTest.append(song.albumTitle!)
                //songIDTest.append(Int(song.persistentID))
                tapticDelayUserSetting.append(0)
                songNameArray.append(song.title!)
                songIDArray.append(Int(song.persistentID))
                artistName.append(song.artist!)
                //albumArtArray.append(song.artwork?.image(at: CGSize(width: 50, height: 250)) ?? UIImage(named:"InfiniteView Icon.png")!)
                //print(song.persistentID.description)
                //print(song.title!)
                //print(song.albumArtist! ?? "Unknown")
                //print(song.albumTitle ?? "Unknown")
            }
            
            
            //MARK: User Song Data Check
            UserDefaults.standard.set(songNameArray, forKey: "songNameCheck")
            UserDefaults.standard.set(songIDArray, forKey: "songIDCheck")
            UserDefaults.standard.set(artistName, forKey: "artistNameCheck")
            UserDefaults.standard.set(tapticDelayUserSetting, forKey: "tapticDelays")


            indexMusicsNow = true
            self.beatmapDownloadView?.reload()
            self.skip.alpha = 1

        })
        
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
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
    
    
    override func viewDidLoad() {
        
        
        promptLabelBottom.text = "tapAudio provides haptic feedback when music is playing."
        
        super.viewDidLoad()

        
        
 
        
    }
    var count = 10
    
    var timer = Timer()
    var up = false
    var down = true
    override func viewDidAppear(_ animated: Bool) {

        
        timer = Timer.scheduledTimer(timeInterval: 1.6, target: self, selector: #selector(ViewController.swipeUpAnimation), userInfo: nil, repeats: true)

        

  
        
     
    }
    
    @objc func swipeUpAnimation() {
        
        if startedWorking == false {
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
        
    }
    
    
    @IBAction func skipIndex() {
        
        indexMusicsNow = false
        
        UIView.animate(withDuration: 0.4, animations: {
            self.progressView.transform = CGAffineTransform.init(translationX: -500, y: 0)

            self.hapticChooseView.transform = CGAffineTransform.init(translationX: 0, y: 0)

        })
    }
    
    
    @IBAction func continueAndLetUserStart() {
        
        
        UIView.animate(withDuration: 0.4, animations: {
            self.hapticChooseView.transform = CGAffineTransform.init(translationX: -500, y: 0)
            
            self.userStartUsingScreen.transform = CGAffineTransform.init(translationX: 0, y: 0)
            
        })
    }

    
    @IBAction func getStartedUsingtapAudio() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute:{
            let mainStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
            let vc : UIViewController = mainStoryboard.instantiateViewController(withIdentifier: "musicViewController") as UIViewController
            self.present(vc, animated: false, completion: nil)
            tapticDataArray.remove(at: 0)
        })

        
        
        
        UIView.animate(withDuration: 0.5, animations: {
            self.userStartUsingScreen.backgroundColor = UIColor.black

        })
        
    }
    
    
    func delay(_ delay:Double, closure:@escaping ()->()) {
        DispatchQueue.main.asyncAfter(
            deadline: DispatchTime.now() + Double(Int64(delay * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: closure)
    }
    
    func loadDownloadWeb(Key: String) {
        print("loading")
        print("Done")

        
    }
 
    
    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
        
    }
    
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        
        if webView == beatmapDownloadView {
        proceedLoop = false
            
        }
    }
    var startedWorking = false
    var initialYLocation: CGFloat?
    var dataIDArray:[Int] = []
    var beatmapIDArray:[Int] = []
    var doneIndexingMusic = false
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first as UITouch?
        var location = touch?.location(in: progressView)

        if touch?.view == progressView && startedWorking == false {

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
        
        var location = touch?.location(in: progressView)
        
        if touch?.view == progressView && startedWorking == false {
            //print("moved:\(location!.y)")
            //print("calculated: \(( initialYLocation! - location!.y) / 80)")
            moveOnValidNumber =  ((initialYLocation! - location!.y) / 280) + 1
            
            if moveOnValidNumber! >= CGFloat(1.0) {
                UIView.animate(withDuration: 0.45, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseInOut, animations: {

                    self.progressView.transform = CGAffineTransform.init(scaleX: (( self.initialYLocation! - location!.y) / 280) + 1, y: (( self.initialYLocation! - location!.y) / 280) + 1)
                    self.tapAudioLabel.alpha = 2 -  ((( self.initialYLocation! - location!.y) / 280) + 1)
                }, completion: nil)

            }
            
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first as UITouch?
        
        if startedWorking == false {
        if moveOnValidNumber! > CGFloat(2.0) {
            getStartedWithIndexing()
            self.tapAudioLabel.alpha = 0
        } else if moveOnValidNumber! < CGFloat(2.0) {
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseInOut, animations: {
                self.progressView.transform = CGAffineTransform.init(scaleX: 1, y: 1)
                
                self.tapAudioLabel.alpha = 1

            }, completion: nil)

            
        }
            
        }
        
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
    var removeFirstdataInArray = false
    var counterInDataIDArray = 0
    var counterInBeatmapArray = 0
    var downloadTimer = Timer()
    var appleWebKitBugFixTimer = Timer()
    var usingWebKitFixView = false
    
    @objc func applePleaseFixThisWebKitBugItsReallyAnnoying() {
        
        if dataIDArray[counterInDataIDArray - 1] == 0 {
            beatmapIDArray.append(0)
            counterInDataIDArray += 1
            print(beatmapIDArray)
        } else {
            var newURLToLoad = "https://osu.ppy.sh/s/\(dataIDArray[counterInDataIDArray - 1])"
            
            print("loading New Data Website... if hangs here fix the code.")
            if let encoded = newURLToLoad.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed),
                let url = URL(string: encoded){
                print(url)
                
                let req = URLRequest(url:url)
                usingWebKitFixView = true

                self.applePleaseFixThisWebKitBug!.load(req)
                self.appleWebKitBugFixTimer.invalidate()
            }

            
        }

        
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("didFInishLoading")
        if doneIndexingMusic == false {
        proceedLoop = true
        var key: String?
        indexedIndexPath += 1
        var proceedProvess = true
        if beatmapDownloadView?.url == URL(string: "https://www.apple.com/") {
            proceedProvess = false
            //print("Apple's Site")
            
        }
        
        if indexedIndexPath - 1  <= songNameArray.count  && proceedLoop == true && indexMusicsNow == true {
            
            
            
            //self.indexingProgressBar.setProgress(Float(CGFloat(indexedIndexPath / songNameArray.count)), animated: true)
            
            self.indexingProgressBar.progress = Float(Float(indexedIndexPath - 1) / Float(songNameArray.count))
                //print(Float(Float(indexedIndexPath) / Float(songNameArray.count)))
                //print(Double(songNameArray.count/songNameArray.count))
                //print(songNameArray.count)
                //print(indexedIndexPath)
            progressLabel.text = "\(indexedIndexPath - 1) out of \(songNameArray.count) remaining..."
            
            var keyword: String!
            
            if songNameArray.indices.contains(indexedIndexPath - 2) == false {
                
                keyword = songNameArray[indexedIndexPath - 1] as String
            } else {
               keyword = songNameArray[indexedIndexPath - 2] as String

                
            }
           // var keyword = songNameArray[indexedIndexPath - 2] as String
            
          //  var artistNameString = artistName[indexedIndexPath - 2] as String
            
            var artistNameString: String!

            
            if artistName.indices.contains(indexedIndexPath - 2) == false {
                
                artistNameString = artistName[indexedIndexPath - 1] as String
                if songNameArray[indexedIndexPath - 1].range(of: " ") != nil && indexedIndexPath - 1 < songNameArray.count + 1{
                    
                    //keyword = keyword.replacingOccurrences(of: " ", with: "%20")
                    keyword = keyword.replacingOccurrences(of: "(", with: "")
                    keyword = keyword.replacingOccurrences(of: ")", with: "")
                    keyword = replaceText(string:keyword)
                    print(keyword)
                    key = keyword
                    
                    artistNameString = replaceText(string: artistNameString)
                    
                    artistNameString = artistNameString.replacingOccurrences(of: " - ilKPOPcom", with: "")
                    artistNameString = artistNameString.replacingOccurrences(of: "ilKPOP.com", with: "")
                    artistNameString = artistNameString.replacingOccurrences(of: "-", with: "")
                    artistNameString = artistNameString.replacingOccurrences(of: " - ilKPOP.com", with: "")
                    print(artistNameString)
                    
                    
                    
                }
            } else {
                artistNameString = artistName[indexedIndexPath - 2] as String
                if songNameArray[indexedIndexPath - 2].range(of: " ") != nil && indexedIndexPath - 1 < songNameArray.count + 1{
                    
                    //keyword = keyword.replacingOccurrences(of: " ", with: "%20")
                    keyword = keyword.replacingOccurrences(of: "(", with: "")
                    keyword = keyword.replacingOccurrences(of: ")", with: "")
                    keyword = replaceText(string:keyword)
                    //print(keyword)
                    key = keyword
                    
                    artistNameString = replaceText(string: artistNameString)
                    artistNameString = artistNameString.replacingOccurrences(of: " - ilKPOPcom", with: "")
                    artistNameString = artistNameString.replacingOccurrences(of: "ilKPOP.com", with: "")
                    artistNameString = artistNameString.replacingOccurrences(of: "-", with: "")
                    //ilKPOP.com
                    artistNameString = artistNameString.replacingOccurrences(of: " - ilKPOP.com", with: "")
                    //print(artistNameString)
                    print(artistNameString)
                    
                    
                }
                
                
            }

            if  indexedIndexPath  - 1 < songNameArray.count + 1 {

     
            } else if indexedIndexPath - 1 == songNameArray.count{
                
                print("done")
                progressLabel.text = "Processing Files..."
                doneIndexingMusic = true
            }
            var original = "https://bloodcat.com/osu/?q=\(String(describing: keyword!)) \(String(describing:artistNameString!))&c=b&s=&m=&g=&l=&mod=json"
            original = original.replacingOccurrences(of: "%25", with: "%")
            //%20-%20ilKPOP.co
            original = original.replacingOccurrences(of: "ilKPOP.com", with: "")
            original = original.replacingOccurrences(of: " - ", with: "")
            if let encoded = original.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed),
                let url = URL(string: encoded){
                
                let req = URLRequest(url:url)
                
                self.beatmapDownloadView!.load(req)
                
                print(url)
            }
            
            
        }
        
        self.beatmapDownloadView?.evaluateJavaScript("document.documentElement.outerHTML.toString()",completionHandler: { (html: Any?, error: Error?) in
            
            
            //print(html as! String)
            var htmlAsString = html as! String
            if htmlAsString != "" {
                
                
                 if let dotRange = htmlAsString.range(of: "</main>") {
                 //htmlAsString.removeSubrange(htmlAsString.startIndex..<dotRange.lowerBound)
                 htmlAsString.removeSubrange(dotRange.lowerBound..<htmlAsString.endIndex)
                 // print(htmlAsString)
                 
                 }

                 
                if let dotRange = htmlAsString.range(of: "id\":\"") {
                 htmlAsString.removeSubrange(htmlAsString.startIndex..<dotRange.upperBound)
                 //htmlAsString.removeSubrange(dotRange.lowerBound..<htmlAsString.endIndex)
                 print("yes")
                 } else {
                 self.dataIDArray.append(0)
                 
                 
                 }
                 
                 if let dotRange = htmlAsString.range(of: "\",\"beatmaps") {
                 htmlAsString.removeSubrange(dotRange.lowerBound..<htmlAsString.endIndex)
                 //htmlAsString.removeSubrange(dotRange.lowerBound..<htmlAsString.endIndex)
                 print(htmlAsString)
                 
                 if (htmlAsString.rangeOfCharacter(from: CharacterSet.letters) == nil) {
                 self.dataIDArray.append(Int(htmlAsString)!)
                 print("Appended To dataIDArray")
                 //print(key)
                 //print(self.dataIDArray)
                 }
                 }
 
                 
            
 
                /*
                 
                 if let dotRange = htmlAsString.range(of: "</main>") {
                 //htmlAsString.removeSubrange(htmlAsString.startIndex..<dotRange.lowerBound)
                 htmlAsString.removeSubrange(dotRange.lowerBound..<htmlAsString.endIndex)
                 // print(htmlAsString)
                 
                 }

                if let dotRange = htmlAsString.range(of: "osu.ppy.sh/s/") {
                    htmlAsString.removeSubrange(htmlAsString.startIndex..<dotRange.upperBound)
                    //htmlAsString.removeSubrange(dotRange.lowerBound..<htmlAsString.endIndex)
                    
                } else {
                    self.dataIDArray.append(0)
                    

                }
                
                if let dotRange = htmlAsString.range(of: "\">") {
                    htmlAsString.removeSubrange(dotRange.lowerBound..<htmlAsString.endIndex)
                    //htmlAsString.removeSubrange(dotRange.lowerBound..<htmlAsString.endIndex)
                    print(htmlAsString)
                    
                    if (htmlAsString.rangeOfCharacter(from: CharacterSet.letters) == nil) {
                        self.dataIDArray.append(Int(htmlAsString)!)
                        print("Appended To dataIDArray")
                        //print(key)
                        //print(self.dataIDArray)
                    }
                }

*/
                
            }
            print(self.dataIDArray)
            if self.dataIDArray.count == songNameArray.count  {
                print("done")
                self.progressLabel.text = "Processing Files..."
                self.doneIndexingMusic = true
                self.beatmapDownloadView?.reload()
            }
            
            if self.removeFirstdataInArray == false && self.dataIDArray.count > 2{
                self.dataIDArray.remove(at: 0)
                self.dataIDArray.remove(at: 0)
                self.removeFirstdataInArray = true
                print("removed")
                print(self.dataIDArray)
            }

            if self.beatmapDownloadView?.title != "Apple" {
               // print(htmlAsString)
                
            }
            
            if self.dataIDArray.count == songNameArray.count && self.beatmapDownloadView!.url!.absoluteString.range(of: "apple") == nil{
                print("done")
                self.progressLabel.text = "Preparing for next stage..."
                self.doneIndexingMusic = true
                self.beatmapDownloadView?.reload()
            }

            
        })
        
            if self.doneIndexingMusic == true {
                
       
        }
   
            
        } else {
            
            if usingWebKitFixView == false {
            print(beatmapDownloadView?.url)
            var urlLink:String! = beatmapDownloadView!.url!.absoluteString
            if ((beatmapDownloadView?.url?.absoluteString.range(of: "osu.ppy.sh")) != nil) && ((beatmapDownloadView?.url?.absoluteString.range(of: "#osu")) != nil){
                print("Valid URL")
                
                if let dotRange = urlLink!.range(of: "#osu/") {
                    //htmlAsString.removeSubrange(htmlAsString.startIndex..<dotRange.lowerBound)
                    print(urlLink)
                    urlLink.removeSubrange(urlLink.startIndex..<dotRange.upperBound)
                    print(urlLink)
                    beatmapIDArray.append(Int(urlLink)!)
                    
                    //print("beatmapID ARRAY: \(beatmapIDArray) and Appended.")
                    // print(htmlAsString)
                    
                }

                tapticDataArray.removeAll()
                
            } else if ((beatmapDownloadView?.url?.absoluteString.range(of: "osu.ppy.sh")) != nil) && ((beatmapDownloadView?.url?.absoluteString.range(of: "#osu")) == nil) {
                beatmapIDArray.append(0)

            }
            print(counterInDataIDArray)
            print(dataIDArray)
            counterInDataIDArray += 1
                beatmapDownloadView = nil
                beatmapDownloadView = WKWebView()
                beatmapDownloadView?.navigationDelegate = self
            //There is a probelm not adding the last music into very first ID Array/
            if counterInDataIDArray - 1 < dataIDArray.count {

                
                print("SKIP THIS")
                
                var original = "https://osu.ppy.sh/s/\(dataIDArray[counterInDataIDArray - 1])"
                self.indexingProgressBar.progress = Float(Float(counterInDataIDArray - 1) / Float(songNameArray.count))
                self.progressLabel.text = "Identifying Music IDs: \(counterInDataIDArray - 1) out of \(songNameArray.count)"
                print("loading New Data Website... if hangs here fix the code.")
                if let encoded = original.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed),
                    let url = URL(string: encoded){
                        
                    let req = URLRequest(url:url)
                        
                    self.beatmapDownloadView!.load(req)
                        
                    }
            
            } else {
                
                downloadTimer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(ViewController.downloadBeatmapsAndProcessThem), userInfo: nil, repeats: true)
                //downloadBeatmapsAndProcessThem()
                }
            
            } else {
/*
                for beatmapIDs in beatmapIDArray {
                    
                    counterInBeatmapArray += 1
                downloadAndExtractBeatmapData(dataIDNumber: beatmapIDs)
                    
                }
                if counterInBeatmapArray < beatmapIDArray.count {
                } else {
                    
                    skipIndex()
                }*/
            }

        }
            
        

    }
    
    var doneIndex = false
    var anotherTimerForBugFix = Timer()
    @objc func downloadBeatmapsAndProcessThem() {
        counterInBeatmapArray += 1

        // counyrtInbeatmapArray = 0, 1, 2,3,4, 5 beatmap.count = 6
        if counterInBeatmapArray - 1 < beatmapIDArray.count  {
            
            print(beatmapIDArray[counterInBeatmapArray - 1])

            self.downloadAndExtractBeatmapData(dataIDNumber: beatmapIDArray[counterInBeatmapArray - 1])
            
            
            self.indexingProgressBar.progress = Float(Float(counterInBeatmapArray) / Float(songNameArray.count))

            self.progressLabel.text = "Downloading beatmaps: \(self.counterInBeatmapArray) out of \(songNameArray.count)"
           
        } else if  counterInBeatmapArray  - 1 == songNameArray.count{
            
            print("Done Downloading")
            anotherTimerForBugFix = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(ViewController.doneDownloadingAndNowItIsTimeToExtractData), userInfo: nil, repeats: true)
           
                //self.doneDownloadingAndNowItIsTimeToExtractData()
                self.downloadTimer.invalidate()
            
        }
            
        
    }
    
    
    var doneExtracting = false
    var dataExtractedCounter = 0
    @objc func doneDownloadingAndNowItIsTimeToExtractData() {
        dataExtractedCounter += 1

        if doneExtracting == false && tapticDataArray.count < beatmapIDArray.count {
            
            
            if beatmapIDArray[dataExtractedCounter - 1] != 0 {
                availableBeatmapMusicIndex.append(dataExtractedCounter - 1)
                availableBeatmapMusicTitle.append(songNameArray[dataExtractedCounter - 1])
                availableBeatmapMusicID.append(songIDArray[dataExtractedCounter - 1])
                availableBeatmapMusicArtistName.append(artistName[dataExtractedCounter - 1])
                
                
                UserDefaults.standard.set(availableBeatmapMusicIndex, forKey: "availableBeatmapMusicIndex")
                UserDefaults.standard.set(availableBeatmapMusicTitle, forKey: "availableBeatmapMusicTitle")
                UserDefaults.standard.set(availableBeatmapMusicID, forKey: "availableBeatmapMusicID")
                UserDefaults.standard.set(availableBeatmapMusicArtistName, forKey: "availableBeatmapMusicArtistName")

                self.indexingProgressBar.progress = Float(Float(indexedIndexPath - 1) / Float(availableBeatmapMusicID.count))

                self.progressLabel.text = "Extracting..."
                    self.extractBeatmapData(dataIDNumber: self.beatmapIDArray[self.dataExtractedCounter - 1])

                
            } else {
                tapticDataArray.append([0])
            }
            
            
            
        } else if tapticDataArray.count == beatmapIDArray.count {
            
            //print(tapticDataArray)
            
            //print(availableBeatmapMusicIndex)
            //print(availableBeatmapMusicTitle)
            
            //print(availableBeatmapMusicID)
            
            //tapticDataArray.remove(at: 0)
            
            //MARK: Save The user beatmap data
            UserDefaults.standard.set(tapticDataArray, forKey: "tapticBeatmapData")
            tapticDataInUseArray = tapticDataArray
            //print(tapticDataArray.count)
            skipIndex()
            doneIndex = true
            anotherTimerForBugFix.invalidate()

        }
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
                print(fileURL)
                
                
                var savedData = try String(contentsOf: fileURL)
                
                if let dotRange = savedData.range(of: "[HitObjects]") {
                    savedData.removeSubrange(savedData.startIndex..<dotRange.upperBound)
                    
                }
                
                savedData =  savedData.replacingOccurrences(of:"\n", with: "*")
                
                
                
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
                
                
                //print(testDataSaveArray)
                print("appending to tapticDataArray...")
                tapticDataArray.append(testDataSaveArray)
                //print(tapticDataArray)
                
                // define the string/text to be saved
                // writing to disk
                //try savedData.write(to: fileURL, atomically: false, encoding: .utf8)
                //print("saving was successful")
               // doneDownloadingAndNowItIsTimeToExtractData()
                doneDownloadingAndNowItIsTimeToExtractData()

 

            }
        } catch {

            }
            
        } else if dataIDNumber == 0 {
            tapticDataArray.append([0])

            
        }
        
        
    }
    
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


                }
                
                do {
                    try FileManager.default.copyItem(at: tempLocalUrl, to: destinationFileUrl)
                    self.downloadBeatmapsAndProcessThem()
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
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute:{
                self.downloadBeatmapsAndProcessThem()
                
            })

        }
        
        

    }
    
    
    func extractDataPoints(dataToBeExtracted: String!){
        
        
    }

}

