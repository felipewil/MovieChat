//
//  UIImage+Color.swift
//  MovieChat
//
//  Created by Felipe Leite on 11/11/19.
//  Copyright © 2019 FL. All rights reserved.
//

import UIKit

extension UIImage {
    
    /// Creates a image with the given color.
    ///
    /// - Parameter color: the color the create a image from.
    /// - Returns: an UIImage for the given color, or nil if some error occurs.
    static func from(_ color: UIColor) -> UIImage? {
        let rect = CGRect(x: 0.0, y: 0.0, width: 1.0, height: 1.0)
        
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        
        context?.setFillColor(color.cgColor)
        context?.fill(rect)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image
    }
    
}
