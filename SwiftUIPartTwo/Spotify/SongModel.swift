//
//  SongModel.swift
//  SwiftUIPartTwo
//
//  Created by Khushi Rana on 01/01/26.
//

import Foundation

struct Song: Identifiable {
    var id = UUID()
    var songName: String
    var artistName: String
    var image: String
    var audio: String
    var duration: String
}

