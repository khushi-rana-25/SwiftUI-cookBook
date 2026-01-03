//
//  SpotifyManager.swift
//  SwiftUIPartTwo
//
//  Created by Khushi Rana on 01/01/26.
//

import Foundation
import AVKit
import SwiftUI


enum RepeatMode {
    case off, all, one
}

@Observable
class SpotifyManager: NSObject, AVAudioPlayerDelegate {
    
    static let shared = SpotifyManager()
    var currentSongID: UUID?
    var playlist: [Song] = []
    var player: AVAudioPlayer?
    var isPlaying: Bool = false
    var currentTime: Double = 0
    var duration: Double = 0
    var timer: Timer?
    var isDraggingDuration: Bool = false
    var isDraggingVolume: Bool = false
    var volume: Float = 0.5
    var isShuffle: Bool = false
    var repeatMode: RepeatMode = .off
    
    var likedSongs: Set<UUID> = []{
        didSet{
            saveLikes()
        }
    }
    private var likesKey = "liked_songs_save_key"
    
    override init() {
        super.init( )
        loadLikes()
    }
    
    func toggleSound(song: Song){
        if song.id != currentSongID {
            setupPlayer(song)
            return
        }
        
        if let player = player {
            if isPlaying {
                player.pause()
                stopTimer()
            }
            else{
                player.play()
                startTimer()
            }
            isPlaying = player.isPlaying
        }
        else{
            setupPlayer(song)
        }
    }
    
    func setupPlayer(_ song: Song){
        player?.stop()
        stopTimer()
        
        guard let url = Bundle.main.url(forResource: song.audio, withExtension: ".mp3") else  {
            return
        }
        
        do{
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
            
            player = try AVAudioPlayer(contentsOf: url)
            player?.delegate = self
            self.currentSongID = song.id
            self.duration = player?.duration ?? 0
            self.currentTime = 0
            player?.volume = volume
            player?.play()
            isPlaying = true
            startTimer()
        }catch let error {
            print("Error playing song \(error)")
        }
    }
    
    func startTimer(){
        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true, block: { [weak self] _ in
            guard let self = self, let player = player  else { return }
            
            if !isDraggingDuration{
                self.currentTime = player.currentTime
            }
        })
    }
    
    func stopTimer(){
        timer?.invalidate()
        timer = nil
    }
    
    func formatTime(_ time: Double) -> String{
        let minutes = Int(time) / 60
        let seconds = Int(time) % 60
        
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
    func seek(to time: Double){
        player?.currentTime = time
        currentTime = time
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        switch repeatMode {
            case .one:
                seek(to: 0)
                player.play()
            case .all:
                skipForward()
            case .off:
                let currentIndex = playlist.firstIndex(where: { $0.id == currentSongID }) ?? 0
                if currentIndex < playlist.count - 1 {
                    skipForward()
                } else {
                    isPlaying = false
                    stopTimer()
                    currentTime = 0
                }
        }
    }
    
    func skipForward(){
        
        guard !playlist.isEmpty else { return }
        
        if isShuffle{
            let randomSong = playlist.randomElement() ?? playlist[0]
            setupPlayer(randomSong)
        }else{
            guard let currentId = currentSongID ,
                let currentIndex = playlist.firstIndex(where: { $0.id == currentId }) else { return }
            
            let nextIndex = (currentIndex + 1) % playlist.count
            setupPlayer(playlist[nextIndex])
        }
    }
    
    func skipBackward(){
        if currentTime > 3{
            seek(to: 0)
        }
        
        guard let currentIndex = playlist.firstIndex(where: { $0.id == currentSongID }) else {
            return
        }
        
        let previousIndex = currentIndex - 1
        
        if previousIndex >= 0 {
            setupPlayer(playlist[previousIndex])
        }
        else {
            setupPlayer(playlist[playlist.count - 1])
        }
    }
    
    func updateVolume(to volume: Float){
        self.volume = volume
        player?.volume = volume
    }
    
    func toggleShuffle(){
        isShuffle.toggle()
    }
    
    func toggleRepeat() {
        switch repeatMode {
        case .off: repeatMode = .all
        case .all: repeatMode = .one
        case .one: repeatMode = .off
        }
    }
    
    func toggleLike(songId: UUID){
        if likedSongs.contains(songId){
            likedSongs.remove(songId)
        }else{
            likedSongs.insert(songId)
        }
    }
    
    func loadLikes(){
        if let data = UserDefaults.standard.data(forKey: likesKey){
            if let decodedData = try? JSONDecoder().decode(Set<UUID>.self, from: data){
                self.likedSongs = decodedData
            }
        }
    }
    
    func saveLikes(){
        if let encodeData = try? JSONEncoder().encode(likedSongs){
            UserDefaults.standard.set(encodeData, forKey: likesKey)
        }
    }
}
