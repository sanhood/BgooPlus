//
//  Page6.swift
//  Begoo
//
//  Created by Danoosh Chamani on 6/27/17.
//  Copyright © 2017 Axaan. All rights reserved.
//

import UIKit
import AVFoundation
import Gifu
class Page6: UIViewController , AVAudioRecorderDelegate , AVAudioPlayerDelegate{
    @IBOutlet weak var recordBtn: UIButton!
    @IBOutlet weak var playBtn: UIButton!
    @IBOutlet weak var rec_playProgress: UIProgressView!
    var audioRecorder: AVAudioRecorder!
    var audioPlayer : AVAudioPlayer!
    var meterTimer:Timer!
    var isAudioRecordingGranted: Bool!
    var isRecording = false
    var isPlaying = false
    @IBOutlet weak var imageView : GIFImageView!
    @IBOutlet weak var Label : UILabel!
    var player: AVAudioPlayer?
    var currentIndex = 0
    var ID = [Int]()
    var Name = [String]()
    var ParentID = 0
    var ParentParentID = 0
    var A = false
    var timer2 : Timer!
    override func viewDidLoad() {
        super.viewDidLoad()
        A = UserDefaults.standard.value(forKey: "AState") as! Bool
        check_record_permission()
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipe(gesture:)))
        swipeRight.direction = UISwipeGestureRecognizerDirection.right
        self.imageView.addGestureRecognizer(swipeRight)
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipe(gesture:)))
        swipeRight.direction = UISwipeGestureRecognizerDirection.left
        self.imageView.addGestureRecognizer(swipeLeft)
        
        
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        rec_playProgress.progress = 0
        self.playBtn.setImage(UIImage(named: "play_deactive"), for: .normal)
        self.playBtn.isEnabled = false
        self.recordBtn.setImage(UIImage(named: "rec_active"), for: .normal)
        self.recordBtn.isEnabled = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidLayoutSubviews() {
        let path: String? = Bundle.main.path(forResource: "\(ID[currentIndex])", ofType: "gif", inDirectory: "names/begoo/\(ParentParentID)/\(ParentID)")
        imageView.animate(withGIFNamed: path!)
        
        Label.text = Name[currentIndex]
        
    }
    
    @IBAction func ChangerPressed(_ sender: UIButton) {
        if (sender.tag==0 && currentIndex != 0){
            player?.stop()
            isRecording = false
            isPlaying = false
            rec_playProgress.setProgress(0, animated: false)
            currentIndex=currentIndex-1
            let path: String? = Bundle.main.path(forResource: "\(ID[currentIndex])", ofType: "gif", inDirectory: "names/begoo/\(ParentParentID)/\(ParentID)")
            imageView.animate(withGIFNamed: path!)
            if #available(iOS 10.0, *) {
                timer2 = Timer.scheduledTimer(withTimeInterval: 0.2, repeats: false, block: {void in
                    self.Label.text = self.Name[self.currentIndex]
                    self.timer2.invalidate()
                })
            } else {
                Label.text = Name[currentIndex]
            }
            self.playBtn.setImage(UIImage(named: "play_deactive"), for: .normal)
            self.playBtn.isEnabled = false
            self.recordBtn.setImage(UIImage(named: "rec_active"), for: .normal)
            self.recordBtn.isEnabled = true
        }
        else if(sender.tag==1 && currentIndex != ID.count-1){
            player?.stop()
            if currentIndex > 4 {
                if A || (preActive=="yes"){
                    isRecording = false
                    isPlaying = false
                    rec_playProgress.setProgress(0, animated: false)
                    currentIndex=currentIndex+1
                    let path: String? = Bundle.main.path(forResource: "\(ID[currentIndex])", ofType: "gif", inDirectory: "names/begoo/\(ParentParentID)/\(ParentID)")
                    imageView.animate(withGIFNamed: path!)
                    if #available(iOS 10.0, *) {
                        timer2 = Timer.scheduledTimer(withTimeInterval: 0.2, repeats: false, block: {void in
                            self.Label.text = self.Name[self.currentIndex]
                            self.timer2.invalidate()
                        })
                    } else {
                        Label.text = Name[currentIndex]
                    }
                    self.playBtn.setImage(UIImage(named: "play_deactive"), for: .normal)
                    self.playBtn.isEnabled = false
                    self.recordBtn.setImage(UIImage(named: "rec_active"), for: .normal)
                    self.recordBtn.isEnabled = true

                }else{
                    isRecording = false
                    isPlaying = false
                    rec_playProgress.setProgress(0, animated: false)
                    let message  = "در حال حاضر این نسخه٬دمو می باشد.\nلطفا برای استفاده ازامکانات و اطلاعات بیشتر اقدام به فعال سازی فرمایید."
                    let alert = UIAlertController(title: "پیام", message: message, preferredStyle: .alert)
                    let ok = UIAlertAction(title: "فعلا نمیخوام", style: .default , handler: nil)
                    let settings = UIAlertAction(title: "فعال سازی", style: .default , handler: { void in
                        self.performSegue(withIdentifier: "toActive", sender: nil)
                    })
                    alert.addAction(ok)
                    alert.addAction(settings)
                    DispatchQueue.main.async {
                        self.present(alert, animated: true, completion: nil)
                    }
                }
            }else{
                currentIndex=currentIndex+1
                isRecording = false
                isPlaying = false
                rec_playProgress.setProgress(0, animated: false)
                self.playBtn.setImage(UIImage(named: "play_deactive"), for: .normal)
                self.playBtn.isEnabled = false
                self.recordBtn.setImage(UIImage(named: "rec_active"), for: .normal)
                self.recordBtn.isEnabled = true
                let path: String? = Bundle.main.path(forResource: "\(ID[currentIndex])", ofType: "gif", inDirectory: "names/begoo/\(ParentParentID)/\(ParentID)")
                imageView.animate(withGIFNamed: path!)
                if #available(iOS 10.0, *) {
                    timer2 = Timer.scheduledTimer(withTimeInterval: 0.2, repeats: false, block: {void in
                        self.Label.text = self.Name[self.currentIndex]
                        self.timer2.invalidate()
                    })
                } else {
                    Label.text = Name[currentIndex]
                }
            }
        }
    }
  
    
    @IBAction func backPressed(_ sender: Any) {
        player?.stop()
        performSegue(withIdentifier: "BacktoPage5", sender: nil)
    }
    
    @IBAction func PlaySound(_ sender: Any) {
        let path: String? = Bundle.main.path(forResource: "\(ID[currentIndex])", ofType: "mp3", inDirectory: "names/begoo/\(ParentParentID)/\(ParentID)/s")
        let url = URL(fileURLWithPath: path!)
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
            try AVAudioSession.sharedInstance().setActive(true)
            
            player = try AVAudioPlayer(contentsOf: url)
            guard let player = player else { return }
            
            player.play()
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "BacktoPage5"{
            if let vc = segue.destination as? Page5 {
                vc.ParentID = ParentID
                vc.ParentParentID = ParentParentID
            }
        }
    }
    
    
    
    
    
    //RECORD AND PLAY THINGS
    @IBAction func record(_ sender: Any) {
        if(!isRecording)
        {
            rec_playProgress.setProgress(0, animated: false)
            setup_recorder()
            audioRecorder.record()
            meterTimer = Timer.scheduledTimer(timeInterval: 0.1, target:self, selector:#selector(self.updateAudioMeter(timer:)), userInfo:nil, repeats:true)
          
            recordBtn.isEnabled = false
         
            playBtn.isEnabled = false
            isRecording = true
            
            DispatchQueue.main.async {
//                   self.playBtn.setBackgroundImage(UIImage(named: "play_deactive"), for: .normal)
//                  self.recordBtn.setBackgroundImage(UIImage(named: "rec_deactive"), for: .normal)
                    self.playBtn.setImage(UIImage(named: "play_deactive"), for: .normal)
                    self.recordBtn.setImage(UIImage(named: "rec_deactive"), for: .normal)
            }
        }
    }
   
    @IBAction func play(_ sender: Any) {
        if(isPlaying)
        {
            audioPlayer.stop()
            recordBtn.isEnabled = true
            DispatchQueue.main.async {
//                self.playBtn.setBackgroundImage(UIImage(named: "play_active"), for: .normal)
                self.playBtn.setImage(UIImage(named: "play_active"), for: .normal)
                
            }
            isPlaying = false
        }
        else
        {
            if FileManager.default.fileExists(atPath: getFileUrl().path)
            {
                recordBtn.isEnabled = false
                DispatchQueue.main.async {
                    self.playBtn.setImage(UIImage(named: "pause-5"), for: .normal)
                    self.recordBtn.setImage(UIImage(named: "rec_deactive"), for: .normal)
                }
                rec_playProgress.setProgress(0, animated: false)
                prepare_play()
                audioPlayer.isMeteringEnabled = true
                audioPlayer.play()
                meterTimer = Timer.scheduledTimer(timeInterval: 0.1, target:self, selector:#selector(self.updateAudioMeter(timer:)), userInfo:nil, repeats:true)
                isPlaying = true
            }
            else
            {
                display_alert(msg_title: "Error", msg_desc: "Audio file is missing.", action_title: "OK")
            }
        }
    }
    
    
    func check_record_permission(){
        switch AVAudioSession.sharedInstance().recordPermission() {
        case AVAudioSessionRecordPermission.granted:
            isAudioRecordingGranted = true
            break
        case AVAudioSessionRecordPermission.denied:
            isAudioRecordingGranted = false
            break
        case AVAudioSessionRecordPermission.undetermined:
            AVAudioSession.sharedInstance().requestRecordPermission() { [unowned self] allowed in
                DispatchQueue.main.async {
                    if allowed {
                        self.isAudioRecordingGranted = true
                    } else {
                        self.isAudioRecordingGranted = false
                    }
                }
            }
            break
        default:
            break
        }
    }
    
    func getDocumentsDirectory() -> URL{
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
    
    func getFileUrl() -> URL{
        let filename = "myRecordingplus.m4a"
        let filePath = getDocumentsDirectory().appendingPathComponent(filename)
        return filePath
    }
    
    func setup_recorder()
    {
        if isAudioRecordingGranted
        {
            let session = AVAudioSession.sharedInstance()
            do
            {
                try session.setCategory(AVAudioSessionCategoryPlayAndRecord, with: .defaultToSpeaker)
                try session.setActive(true)
                let settings = [
                    AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
                    AVSampleRateKey: 44100,
                    AVNumberOfChannelsKey: 2,
                    AVEncoderAudioQualityKey:AVAudioQuality.high.rawValue
                ]
                audioRecorder = try AVAudioRecorder(url: getFileUrl(), settings: settings)
                audioRecorder.delegate = self
                audioRecorder.isMeteringEnabled = true
                audioRecorder.prepareToRecord()
            }
            catch let error {
                display_alert(msg_title: "Error", msg_desc: error.localizedDescription, action_title: "OK")
            }
        }
        else
        {
            display_alert(msg_title: "Error", msg_desc: "Don't have access to use your microphone.", action_title: "OK")
        }
    }
    func updateAudioMeter(timer: Timer)
    {
        if let recorder = audioRecorder as? AVAudioRecorder {
            if isRecording{
                let milisec = Double(audioRecorder.currentTime.truncatingRemainder(dividingBy: 6000))
                if milisec > RecTime {
                    finishAudioRecording(success: true)
                    
                    recordBtn.isEnabled = true
                    playBtn.isEnabled = true
                    isRecording = false
                    timer.invalidate()
                    DispatchQueue.main.async {
    //                  self.playBtn.setBackgroundImage(UIImage(named: "play_active"), for: .normal)
    //                    self.recordBtn.setBackgroundImage(UIImage(named: "rec_active"), for: .normal)
                        self.playBtn.setImage(UIImage(named: "play_active"), for: .normal)
                        self.recordBtn.setImage(UIImage(named: "rec_active"), for: .normal)
                    }
                }else{
                rec_playProgress.setProgress(Float(milisec/RecTime), animated: true)
                audioRecorder.updateMeters()
                }
            }
        }
        else if let player = audioPlayer as? AVAudioPlayer {
            if isPlaying {
                let milisec = Double(audioPlayer.currentTime.truncatingRemainder(dividingBy: 6000))
                rec_playProgress.setProgress(Float(milisec/RecTime), animated: true)
                audioPlayer.updateMeters()
            }else{
                    timer.invalidate()
                    player.stop()
                    self.playBtn.setImage(UIImage(named: "play_active"), for: .normal)
                    self.recordBtn.setImage(UIImage(named: "rec_active"), for: .normal)
                    self.recordBtn.isEnabled = true
                    self.rec_playProgress.setProgress(0, animated: false)
            }
            isPlaying = player.isPlaying
        }
    }
    
    func finishAudioRecording(success: Bool)
    {
        if success
        {
            audioRecorder.stop()
            audioRecorder = nil
            meterTimer.invalidate()
       //     print("recorded successfully.")
        }
        else
        {
            display_alert(msg_title: "Error", msg_desc: "Recording failed.", action_title: "OK")
        }
    }
    func prepare_play()
    {
        do
        {
            audioPlayer = try AVAudioPlayer(contentsOf: getFileUrl())
            audioPlayer.delegate = self
            audioPlayer.prepareToPlay()
        }
        catch{
            print("Error")
        }
    }
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool)
    {
        if !flag
        {
            finishAudioRecording(success: false)
        }
        playBtn.isEnabled = true
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool)
    {
        recordBtn.isEnabled = true
    }
    func display_alert(msg_title : String , msg_desc : String ,action_title : String)
    {
        let ac = UIAlertController(title: msg_title, message: msg_desc, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: action_title, style: .default)
        {
            (result : UIAlertAction) -> Void in
            _ = self.navigationController?.popViewController(animated: true)
        })
        present(ac, animated: true)
    }
    
    
    func respondToSwipe (gesture: UIGestureRecognizer) {
       // print("swiped")
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            if swipeGesture.direction == .right {
                let btn = UIButton()
                btn.tag = 0
                ChangerPressed(btn)
            }
            else if swipeGesture.direction == .left {
                let btn = UIButton()
                btn.tag = 1
                ChangerPressed(btn)
            }
        }
    }
    //
}
