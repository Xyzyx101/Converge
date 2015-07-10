//
//  Audio.swift
//  Converge
//
//  Created by Andrew Perrault on 2015-07-09.
//  Copyright (c) 2015 Andrew Perrault. All rights reserved.
//

import Foundation

public class Audio {
    private var music: Bool = true
    private var sfx: Bool = true
    
    public class func instance() -> Audio {
        return sharedAudioInstance
    }
    
    func musicOn() {
        SKTAudio.sharedInstance().resumeBackgroundMusic()
        music = true
    }
    
    func musicOff() {
        SKTAudio.sharedInstance().pauseBackgroundMusic()
        music = false
    }
    
    func sfxOn() {
        SKTAudio.sharedInstance().playSoundEffect("player_score.mp3")
        sfx = true
    }
    
    func sfxOff() {
        sfx = false
    }
    
    func playMusic() {
        if let player = SKTAudio.sharedInstance().backgroundMusicPlayer {
            if player.playing {
                return
            }
        }
        if music {
            SKTAudio.sharedInstance().playBackgroundMusic("LightlessDawn.mp3")
        }
    }
    
    enum Sound {
        case AI_SCORE
        case PLAYER_SCORE
        case COUNT_BIT
        case SELECT_POOL
    }
    
    func play(sound: Sound) {
        if !sfx {
            return
        }
        switch sound {
        case .AI_SCORE:
            SKTAudio.sharedInstance().playSoundEffect("ai_score.mp3")
        case .PLAYER_SCORE:
            SKTAudio.sharedInstance().playSoundEffect("player_score.mp3")
        case .COUNT_BIT:
            SKTAudio.sharedInstance().playSoundEffect("count_bit.mp3")
        case .SELECT_POOL:
            SKTAudio.sharedInstance().playSoundEffect("select_pool.mp3")
        }
    }
}

private let sharedAudioInstance = Audio()