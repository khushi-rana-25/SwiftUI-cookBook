//
//  MockData.swift
//  SwiftUIPartTwo
//
//  Created by Khushi Rana on 03/01/26.
//

import Foundation

class SongStore{
    static let instance = SongStore()
    
    let songs: [Song] = [
        Song(songName: "Breaking Dishes", artistName: "Rihanna", image: "breakingdishes", audio: "breakingdishes", duration: "3:15"),
        Song(songName: "Timeless", artistName: "The Weeknd", image: "timeless", audio: "timeless", duration: "4:16"),
        Song(songName: "End of Beginning", artistName: "Joe Keery", image: "endofbeginning", audio: "endofbeginning", duration: "2:39"),
        Song(songName: "Attention", artistName: "Charlie Puth", image: "attention", audio: "attention", duration: "3:28"),
        Song(songName: "Criminal", artistName: "Britney Spears", image: "criminal", audio: "criminal", duration: "3:45"),
        Song(songName: "Side To Side", artistName: "Ariana Grande", image: "sidetoside", audio: "sidetoside", duration: "3:46"),
        Song(songName: "Chanel", artistName: "Tyla", image: "chanel", audio: "chanel", duration: "3:05")
    ]
}
