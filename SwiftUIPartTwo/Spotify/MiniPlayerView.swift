//
//  MiniPlayerView.swift
//  SwiftUIPartTwo
//
//  Created by Khushi Rana on 02/01/26.
//

import SwiftUI

struct MiniPlayerView: View {
    @Bindable var spotifyManager = SpotifyManager.shared
    var songs: [Song]
    
    var currentSong: Song? {
        songs.first(where: { $0.id == spotifyManager.currentSongID })
    }
    
    var body: some View {
        if let song = currentSong {
            VStack(spacing: 0) {
                
                playerContentView(song: song)
        
                ProgressView(value: spotifyManager.currentTime, total: spotifyManager.duration)
                    .progressViewStyle(.linear)
                    .tint(.white)
                    .background(Color.white.opacity(0.2))
                    .frame(height: 2)
            }
            .background(
                Image(song.image)
                    .resizable()
                    .scaledToFill()
                    .blur(radius: 60)
                    .overlay(Color.black.opacity(0.45))
            )
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .padding(.horizontal)
            .foregroundStyle(.white)
        }
    }
    
    func playerContentView(song: Song) -> some View {
        HStack(spacing: 15) {
            Image(song.image)
                .resizable()
                .frame(width: 50, height: 50)
                .clipShape(RoundedRectangle(cornerRadius: 5))
            
            VStack(alignment: .leading) {
                Text(song.songName)
                    .font(.headline)
                    .fontWeight(.bold)
                    .lineLimit(1)
                Text(song.artistName)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            
            Spacer()
            
            Button{
                spotifyManager.toggleLike(songId: song.id)
            }
            label:{
                Image(systemName: spotifyManager.likedSongs.contains(song.id) ? "heart.fill" : "heart")
                        .foregroundStyle(spotifyManager.likedSongs.contains(currentSong?.id ?? UUID()) ? .green : .white)
                        .font(.title3)
            }
            
            Button {
                spotifyManager.toggleSound(song: song)
            } label: {
                Image(systemName: spotifyManager.isPlaying ? "pause.fill" : "play.fill")
                    .font(.title3)
            }
        }
        .padding(.horizontal)
        .padding(.vertical, 10)
    }
}
