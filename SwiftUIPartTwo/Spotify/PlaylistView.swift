//
//  PlaylistView.swift
//  SwiftUIPartTwo
//
//  Created by Khushi Rana on 01/01/26.
//

import SwiftUI

struct PlaylistView: View {
    @State private var backgroundColor: Color = .black
    @State private var playlistImage: String = "chanel"
    @State private var showSongView: Bool = false
    var songs: [Song] = SongStore.instance.songs
    @Bindable private var spotifyManager = SpotifyManager.shared
    
    let minSize: CGFloat = 150
    
    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottom) {
                LinearGradient(colors: [backgroundColor.opacity(0.8), .black], startPoint: .top, endPoint: .bottom)
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 20) {
                        headerImage
                        playlistControlsView
                        songListView
                    }
                }
                .safeAreaPadding(.bottom, 100)
                if spotifyManager.currentSongID != nil {
                    MiniPlayerView(songs: songs)
                        .contentShape(Rectangle())
                        .onTapGesture {
                            showSongView = true
                        }
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                }
            }
            .sheet(isPresented: $showSongView) {
                if let currentID = spotifyManager.currentSongID,
                   let currentSong = songs.first(where: { $0.id == currentID }) {
                    
                    SoundPageView(song: currentSong)
                        .presentationDetents([.large])
                        .presentationDragIndicator(.visible)
                }
            }
            .task{
                await Helper.helper.updateBackground(image: playlistImage, backgroundColor: $backgroundColor)
            }
            .onAppear {
                spotifyManager.playlist = songs
            }
        }
    }
    
    var headerImage: some View {
        Image(playlistImage)
            .resizable()
            .scaledToFit()
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .visualEffect { content, geometryProxy in
                content
                    .scaleEffect(
                        Helper.helper.calculateScale(proxy: geometryProxy, minSize: minSize), anchor: .top)
                    .offset(y: Helper.helper.calculateOffset(proxy: geometryProxy, minSize: minSize))
                    .opacity(Helper.helper.calculateOpacity(proxy: geometryProxy, minSize: minSize))
            }
            .zIndex(1)
            .padding(.horizontal, 50)
            .padding(.top, 20)
    }
    
    var playlistControlsView: some View {
        
        HStack(alignment: .center){
            Button {
                guard let currentId = spotifyManager.currentSongID else { spotifyManager.setupPlayer(songs[0])
                    return
                }
                
                guard let currentIndex = songs.firstIndex(where: { $0.id == currentId }) else { return }
                
                spotifyManager.toggleSound(song: songs[currentIndex])
            } label: {
                Image(systemName: spotifyManager.isPlaying ? "pause.circle.fill" : "play.circle.fill")
                    .foregroundStyle(.green)
                    .font(.largeTitle)
            }
            
            Button {
                spotifyManager.toggleShuffle()
            } label: {
                Image(systemName: "shuffle")
                    .foregroundStyle(spotifyManager.isShuffle ? Color.green : Color(UIColor.systemGray))
                    .font(.title)
            }
            
            Spacer()
        }
        .frame(maxWidth: .infinity)
        .padding(.horizontal)
    }
    
    var songListView: some View{
        LazyVStack(spacing: 20) {
            ForEach(songs) { song in
                listRowView(song: song)
                    .padding(.horizontal)
                    .contentShape(Rectangle())
                    .onTapGesture {
                        spotifyManager.toggleSound(song: song)
                    }
            }
        }
        .padding(.top, 20)
    }
}

struct listRowView: View{
    @Bindable private var spotifyManager = SpotifyManager.shared
    var song: Song
    
    var body: some View{
        HStack(spacing: 15){
            Image(song.image)
                .resizable()
                .scaledToFit()
                .clipShape(RoundedRectangle(cornerRadius: 5))
                .frame(width: 60, height: 60)
            
            VStack(alignment: .leading){
                Text(song.songName)
                    .foregroundStyle(Color(.secondarySystemBackground))
                    .font(.headline)
                Text(song.artistName)
                    .foregroundStyle(Color(.systemGray))
                    .font(.subheadline)
            }
            
            Spacer()
            
            if spotifyManager.likedSongs.contains(song.id){
                Image(systemName: "heart.fill")
                    .font(.title3)
                    .foregroundStyle(.green)
                    .opacity(spotifyManager.currentSongID == song.id ? 1 : 0)
            }
            
            Image(systemName: "ellipsis")
                .font(.title3)
                .foregroundStyle(Color(.secondarySystemBackground))
        }
    }
}

#Preview {
    PlaylistView()
}
