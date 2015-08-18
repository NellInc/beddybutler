//
//  AudioFile.swift
//  Beddy Butler
//
//  Created by David Garces on 18/08/2015.
//  Copyright (c) 2015 David Garces. All rights reserved.
//

import Foundation
import Cocoa
import AVFoundation
import AVKit

class AudioPlayer {
    
    
    var audioPlayer: AVAudioPlayer?
    var soundFileURL: NSURL?
    
    
    enum AudioFiles {
        case Insistent, Shy, Zombie
        func description() -> String {
            switch self  {
            case .Insistent:
                return "Insistent"
            case .Shy:
                return "Shy"
            case .Zombie:
                return "Zombie"
            }
        }
    }
    
    /// Plays the audio file for the given file name: AudioFiles.Shy, AudioFiles.Insistent or AudioFiles.Zombie
    func playFile(file: AudioFiles) {
        
        let soundFileURL = NSBundle.mainBundle().URLForResource(file.description(),
            withExtension: "aiff")

        // play the file
        var error: NSError?
        audioPlayer = AVAudioPlayer(contentsOfURL: soundFileURL, error: &error)
        audioPlayer?.play()
        
    }
    

    
}
