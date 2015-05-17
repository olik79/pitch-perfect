//
//  PlaySoundsViewController.swift
//  Pitch Perfect
//
//  Created by Oliver Körber on 11/05/15.
//  Copyright (c) 2015 Oliver Körber. All rights reserved.
//

import UIKit
import AVFoundation

class PlaySoundsViewController: UIViewController {

    var audioPlayer = AVAudioPlayer()
    var receivedAudio: RecordedAudio!
    var audioEngine: AVAudioEngine!
    var audioFile: AVAudioFile!
    
    func playSoundWithSpeed(soundRate: Float) {
        stopAllAudio()
        
        audioPlayer.rate = soundRate
        audioPlayer.play()
    }
    
    func playSoundWithVariablePitch(pitch: Float) {
        stopAllAudio()
        
        var audioNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioNode)
        
        var audioPitchEffect = AVAudioUnitTimePitch()
        audioPitchEffect.pitch = pitch
        audioEngine.attachNode(audioPitchEffect)
        
        audioEngine.connect(audioNode, to: audioPitchEffect, format: nil)
        audioEngine.connect(audioPitchEffect, to:audioEngine.outputNode, format: nil)
        
        audioNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        audioEngine.startAndReturnError(nil)
        audioNode.play()
    }
    
    func playSoundWithEcho(delay: NSTimeInterval) {
        stopAllAudio()
        
        var audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)

        var audioDelayNode = AVAudioUnitDelay()
        audioDelayNode.delayTime = delay
        audioEngine.attachNode(audioDelayNode)

        audioEngine.connect(audioPlayerNode, to: audioDelayNode, format: nil)
        audioEngine.connect(audioDelayNode, to: audioEngine.outputNode, format: nil)
        
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        
        audioEngine.startAndReturnError(nil)
        audioPlayerNode.play()
        
    }
    
    func playSoundWithReverb(wetDry: Float) {
        stopAllAudio()
        
        var audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        
        var audioReverbNode = AVAudioUnitReverb()
        audioReverbNode.wetDryMix = wetDry
        audioEngine.attachNode(audioReverbNode)
        
        audioEngine.connect(audioPlayerNode, to: audioReverbNode, format: nil)
        audioEngine.connect(audioReverbNode, to: audioEngine.outputNode, format: nil)
        
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        
        audioEngine.startAndReturnError(nil)
        audioPlayerNode.play()
    }
    
    func stopAllAudio() {
        audioPlayer.stop()
        audioPlayer.currentTime = 0.0
        
        audioEngine.stop()
        audioEngine.reset()
    }
    
    @IBAction func snailButtonPressed(sender: UIButton) {
        playSoundWithSpeed(0.5)
    }
    
    @IBAction func rabbitButtonPressed(sender: UIButton) {
        playSoundWithSpeed(2.0)
    }
    
    @IBAction func chipMunkButtonPressed(sender: UIButton) {
        playSoundWithVariablePitch(1000)
    }
    
    @IBAction func darthVaderButtonPressed(sender: UIButton) {
        playSoundWithVariablePitch(-1000)
    }
    
    @IBAction func echoButtonPressed(sender: UIButton) {
        playSoundWithEcho(0.5)
    }
    
    @IBAction func reverbButtonPressed(sender: UIButton) {
        playSoundWithReverb(50)
    }
    
    @IBAction func stopButtonPressed(sender: UIButton) {
        stopAllAudio()
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        audioEngine = AVAudioEngine()
        audioFile = AVAudioFile(forReading: receivedAudio.filePathUrl, error: nil)
        
        let url = receivedAudio.filePathUrl
        var errorPointer = NSErrorPointer()
        
        audioPlayer = AVAudioPlayer(contentsOfURL: url, error: nil)
        audioPlayer.enableRate = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
