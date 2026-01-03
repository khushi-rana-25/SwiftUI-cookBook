//
//  SoundPageView.swift
//  SwiftUIPartTwo
//
//  Created by Khushi Rana on 31/12/25.
//

import SwiftUI

struct SoundPageView: View {
    @Bindable private var spotifyManager = SpotifyManager.shared
    var song: Song
    
    var body: some View {
            ZStack {
                VStack {
                    
                    mainImageView
                    
                    Spacer()
                    
                    themeView
                    
                    durationControlsView
                    
                    Spacer()
                    
                    playbackControlsView
                    
                    Spacer()
                    
                    soundControlsView
                    
                    Spacer()
                }
                .padding(.horizontal)
                .padding(.top, 20)
            }
            .background(
                Image(song.image)
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
                    .blur(radius: 60)
                    .overlay(Color.black.opacity(0.35))
            )
    }
    
    var mainImageView: some View{
        Image(song.image)
                .resizable()
                .scaledToFit()
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .shadow(radius: 20)
                .padding(.horizontal)
    }
    
    var themeView: some View {
        HStack{
            VStack(alignment: .leading, spacing: 5) {
                Text(song.songName)
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundStyle(.white)
                
                Text(song.artistName)
                    .font(.headline)
                    .foregroundColor(.white.opacity(0.7))
            }
            
            Spacer()
        }
        .padding(.horizontal)
    }
    
    var durationControlsView: some View {
        let isCurrentSong = spotifyManager.currentSongID == song.id
        
        return VStack(spacing: 5) {
            Slider(value: isCurrentSong ? $spotifyManager.currentTime : .constant(0), in: 0...(isCurrentSong ? spotifyManager.duration : 1)){ editing in
                spotifyManager.isDraggingDuration = editing
                spotifyManager.seek(to: spotifyManager.currentTime)
            }
                .tint(.white)
            
            HStack {
                Text(isCurrentSong ? spotifyManager.formatTime(spotifyManager.currentTime) : "0:00")
                    .font(.subheadline)
                Spacer()
                Text(isCurrentSong ? spotifyManager.formatTime(spotifyManager.duration) : song.duration)
                    .font(.subheadline)
            }
            .foregroundColor(.white)
        }
        .padding(.horizontal)
    }
    
    var playbackControlsView: some View {
        HStack(spacing: 50) {
            Spacer()
            
            Button{
                spotifyManager.skipBackward()
            }
            label:{
                Image(systemName: "backward.fill")
                    .font(.title)
            }
            
            Button{
                spotifyManager.toggleSound(song: song)
            }
            label: {
                Image(systemName: (spotifyManager.isPlaying && spotifyManager.currentSongID == song.id) ?  "pause.fill" : "play.fill")
                    .font(.largeTitle)
            }
            
            Button {
                spotifyManager.skipForward()
            }
            label: {
                Image(systemName: "forward.fill")
                    .font(.title)
            }
            
            Button{
                spotifyManager.toggleRepeat()
            }
        label:
            {
                Image(systemName:
                        (spotifyManager.repeatMode == .off || spotifyManager.repeatMode == .all) ? "repeat" : "repeat.1"
                )
                    .font(.title)
                    .foregroundStyle(spotifyManager.repeatMode == .off ? .white : .green)
            }
        }
        .foregroundColor(.white)
        .padding(.horizontal)
    }
    
    var soundControlsView: some View {
            HStack(spacing: 15) {
                Image(systemName: "speaker.fill")
                    .font(.title3)
                
                Slider(value: $spotifyManager.volume, in: 0...1)
                    .accentColor(.white)
                    .sliderThumbVisibility(.hidden)
                    .onChange(of: spotifyManager.volume) { oldValue, newValue in
                        spotifyManager.updateVolume(to: newValue)
                    }
                    .frame(height: 30)
                
                Image(systemName: "speaker.wave.3.fill")
                    .font(.title3)
            }
            .foregroundColor(.white)
            .padding(.horizontal)
    }
}

//#Preview {
//    SoundPageView(song: Song(songName: "Breaking Dishes", artistName: "Rihanna", image: "breakingdishes", audio: "breakingdishes", duration: "3:15"))
//}
