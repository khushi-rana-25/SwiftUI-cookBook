//
//  Helper.swift
//  SwiftUIPartTwo
//
//  Created by Khushi Rana on 02/01/26.
//

import Foundation
import SwiftUI
import DominantColors

class Helper {
    
    nonisolated static let helper = Helper()
     
    @MainActor
    func updateBackground(image: String, backgroundColor: Binding<Color>) async {
        let color = await Task.detached(priority: .utility) { () -> Color in
            guard let uiImage = UIImage(named: image),
                  let smallImage = await uiImage.downSampled(to: CGSize(width: 100, height: 100)) else {
                return Color.black
            }
            
            if let dominant = try? smallImage.dominantColors(max: 3).first {
                return Color(uiColor: dominant)
            }
            
            return Color.black
        }.value
        
        backgroundColor.wrappedValue = color
    }
    
    nonisolated func calculateScale(proxy: GeometryProxy, minSize: Double) -> CGFloat {
        let minY = proxy.frame(in: .scrollView).minY
        let width = proxy.size.width
        
        if (minY < 0){
            let newHeight = width - abs(minY)
            let scale = newHeight / width
            
            let minScale = minSize / width
            return max(minScale, scale)
        }
        
        return 1.0
    }

    nonisolated func calculateOffset(proxy: GeometryProxy, minSize: Double) -> CGFloat {
        let minY = proxy.frame(in: .scrollView).minY
        let width = proxy.size.width
        let currentScale = calculateScale(proxy: proxy, minSize: minSize)
        let minScale = minSize / width
        
        if minY < 0 {
            if currentScale > minScale {
                return abs(minY)
            }else{
                let diff = width - minSize
                return diff
            }
        }
        
        return 0
    }
    
    nonisolated func calculateOpacity(proxy: GeometryProxy, minSize: Double) -> Double {
        let minY = proxy.frame(in: .scrollView).minY
        let width = proxy.size.width
        let scrollLimit = width - minSize
        let excessScroll = abs(minY) - scrollLimit
        
        return 1.0 - (excessScroll / 100)
    }
}
