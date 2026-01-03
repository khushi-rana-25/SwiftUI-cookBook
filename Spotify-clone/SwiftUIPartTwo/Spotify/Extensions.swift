//
//  Extensions.swift
//  SwiftUIPartTwo
//
//  Created by Khushi Rana on 02/01/26.
//

import Foundation
import UIKit

extension UIImage{
    func downSampled(to size: CGSize) -> UIImage? {
        let renderer = UIGraphicsImageRenderer(size: size)
        return renderer.image { _ in
            self.draw(in: CGRect(origin: .zero, size: size))
        }
    }
}
