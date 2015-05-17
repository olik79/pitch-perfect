//
//  RecordSoundsViewController.swift
//  Pitch Perfect
//
//  Created by Oliver Körber on 09/05/15.
//  Copyright (c) 2015 Oliver Körber. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {

    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var pauseResumeButton: UIButton!
    
    var audioRecorder: AVAudioRecorder!
    var recordedAudio: RecordedAudio!
    
    var paused: Bool!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear(animated: Bool) {
        stopButton.hidden = true
        recordButton.enabled = true
        pauseResumeButton.hidden = true
        
        paused = false
        
        messageLabel.text = NSLocalizedString("tap_to_record", comment: "")
        messageLabel.hidden = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func recordAudio(sender: UIButton) {
        println("in recordAudio")
        messageLabel.text = NSLocalizedString("recording", comment: "")
        messageLabel.hidden = false
        
        stopButton.hidden = false
        recordButton.enabled = false
        
        pauseResumeButton.hidden = false
        pauseResumeButton.setTitle(NSLocalizedString("pause", comment: ""), forState: UIControlState.Normal)
        paused = false
        
        // start recording
        let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as! String
        
        let currentDateTime = NSDate()
        let formatter = NSDateFormatter()
        formatter.dateFormat = "ddMMyyyy-HHmmss"
        let recordingName = formatter.stringFromDate(currentDateTime)+".wav"
        let pathArray = [dirPath, recordingName]
        let filePath = NSURL.fileURLWithPathComponents(pathArray)
        println(filePath)
        
        var session = AVAudioSession.sharedInstance()
        session.setCategory(AVAudioSessionCategoryPlayAndRecord, error: nil)
        
        audioRecorder = AVAudioRecorder(URL: filePath, settings: nil, error: nil)
        audioRecorder.delegate = self
        audioRecorder.meteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
    }
    
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder!, successfully flag: Bool) {
        if (flag) {
            recordedAudio = RecordedAudio(url: recorder.url, title: recorder.url.lastPathComponent!)
            
            performSegueWithIdentifier("playSounds", sender: recordedAudio)
        } else {
            println("Error while recording")
            stopButton.hidden = true
            recordButton.enabled = true
        }
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "playSounds") {
            let playViewController = segue.destinationViewController as! PlaySoundsViewController
            playViewController.receivedAudio = sender as! RecordedAudio
        }
    }
    
    @IBAction func pauseResumeButtonPressed(sender: UIButton) {
        if (paused!) {
            // resume recording
            paused = false
            audioRecorder.record()
            pauseResumeButton.setTitle(NSLocalizedString("pause", comment: ""), forState: UIControlState.Normal)
            
        } else {
            // pause recording
            paused = true
            audioRecorder.pause()
            pauseResumeButton.setTitle(NSLocalizedString("resume", comment: ""), forState: UIControlState.Normal)
        }
    }
    
    @IBAction func stopRecording(sender: UIButton) {
        println("stop recording")
        
        stopButton.hidden = true
        recordButton.enabled = true
        
        // stop recording
        audioRecorder.stop()
    }
}

