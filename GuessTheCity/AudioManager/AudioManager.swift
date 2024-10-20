//
//  AudioManager.swift
//  GuessTheCity
//
//  Created by asia on 07.10.2024.
//

import Foundation
import AVFoundation

@Observable
class AudioManager {
    
    var isMusicPlaying: Bool = false
    var selectedTrack: String {
        didSet {
            setupAudioPlayer()
        }
    }
    
    private var audioPlayer: AVAudioPlayer?
    
    let musicTracks: [String] = [
        "Journeys",
        "Labyrinth",
        "Castlejam",
        "Celebrate 01",
        "Dark Time",
        "Draft Arranged",
        "Fiddle Solo",
        "Harpy 01",
        "Harpy 02",
        "Harpy 03",
        "The Life Of A Gong Farmer"
    ]
    
    init() {
        self.selectedTrack = musicTracks[0]
        setupAudioPlayer()
    }
    
    func toggleMusic() {
        if isMusicPlaying {
            audioPlayer?.pause()
        } else {
            audioPlayer?.play()
        }
        isMusicPlaying.toggle()
    }
    
    private func setupAudioPlayer() {
        guard let audioURL = Bundle.main.url(forResource: selectedTrack, withExtension: "mp3") else {
            print("Audio file not found")
            return
        }
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: audioURL)
            audioPlayer?.numberOfLoops = -1 // Loop indefinitely
            audioPlayer?.prepareToPlay()
            if isMusicPlaying {
                audioPlayer?.play()
            }
        } catch {
            print("Error setting up audio player: \(error)")
        }
    }
}
