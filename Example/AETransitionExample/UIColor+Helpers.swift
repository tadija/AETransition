/**
 *  https://github.com/tadija/AETransition
 *  Copyright (c) Marko Tadić 2014-2018
 *  Licensed under the MIT license. See LICENSE file.
 */

import UIKit
import CoreGraphics

public extension UIColor {
    
    // MARK: - HEX
    
    public convenience init(hex: String) {
        var red: CGFloat = 0.0, green: CGFloat = 0.0, blue: CGFloat = 0.0, alpha: CGFloat = 1.0, hex = hex
        
        if (hex.hasPrefix("#")) {
            hex = String(hex.dropFirst())
        }
        
        let scanner = Scanner(string: hex)
        var hexValue: UInt32 = 0
        if scanner.scanHexInt32(&hexValue) {
            if hex.count == 8 {
                red   = CGFloat((hexValue & 0xFF000000) >> 24) / 255.0
                green = CGFloat((hexValue & 0x00FF0000) >> 16) / 255.0
                blue  = CGFloat((hexValue & 0x0000FF00) >> 8) / 255.0
                alpha = CGFloat((hexValue & 0x000000FF)) / 255.0
            } else if hex.count == 6 {
                red   = CGFloat((hexValue & 0xFF0000) >> 16) / 255.0
                green = CGFloat((hexValue & 0x00FF00) >> 8) / 255.0
                blue  = CGFloat((hexValue & 0x0000FF)) / 255.0
            }
        }
        
        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }
    
    // MARK: - Random

    public static func random() -> UIColor {
        let hue = CGFloat(arc4random() % 256) / 256.0
        let saturation = CGFloat(arc4random() % 256) / 256.0
        let brightness = CGFloat(arc4random() % 256) / 256.0
        return UIColor(hue: hue, saturation: saturation, brightness: brightness, alpha: 1.0)
    }

    public static func randomVivid() -> UIColor {
        let hue = CGFloat(arc4random() % 256) / 256.0
        let saturation = (CGFloat(arc4random() % 128) / 256.0) + 0.5 // 0.5 to 1.0 (away from white)
        let brightness = (CGFloat(arc4random() % 128) / 256.0) + 0.5 // 0.5 to 1.0 (away from white)
        return UIColor(hue: hue, saturation: saturation, brightness: brightness, alpha: 1.0)
    }
    
    // MARK: - Shades
    
    public func lighter(withFactor factor: CGFloat = 0.5) -> UIColor {
        guard let colorSpaceModel = cgColor.colorSpace?.model
        else { return UIColor.white }
        
        var hue: CGFloat = 0.0
        var saturation: CGFloat = 0.0
        var brightness: CGFloat = 0.0
        var alpha: CGFloat = 0.0
        var white: CGFloat = 0.0
        
        var lighterColor = UIColor.white
        
        switch colorSpaceModel {
        case .rgb:
            if getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha) {
                brightness += (1.0 - brightness) * factor
                saturation -= saturation * factor
                lighterColor = UIColor(hue: hue, saturation: saturation, brightness: brightness, alpha: alpha)
            }
        case .monochrome:
            if getWhite(&white, alpha: &alpha) {
                white += factor
                white = (white > 1.0) ? 1.0 : white
                lighterColor = UIColor(white: white, alpha: alpha)
            }
        default:
            debugPrint("CGColorSpaceModel: \(colorSpaceModel) is not implemented")
        }
        
        return lighterColor
    }
    
    public func darker(withFactor factor: CGFloat = 0.5) -> UIColor {
        guard let colorSpaceModel = cgColor.colorSpace?.model
        else { return UIColor.black }
        
        var hue: CGFloat = 0.0
        var saturation: CGFloat = 0.0
        var brightness: CGFloat = 0.0
        var alpha: CGFloat = 0.0
        var white: CGFloat = 0.0
        
        var darkerColor = UIColor.white
        
        switch colorSpaceModel {
        case .rgb:
            if getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha) {
                brightness -= brightness * factor
                saturation += (1.0 - saturation) * factor
                darkerColor = UIColor(hue: hue, saturation: saturation, brightness: brightness, alpha: alpha)
            }
        case .monochrome:
            if getWhite(&white, alpha: &alpha) {
                white -= factor
                white = (white < 0.0) ? 0.0 : white
                darkerColor = UIColor(white: white, alpha: alpha)
            }
        default:
            debugPrint("CGColorSpaceModel: \(colorSpaceModel) is not implemented")
        }
        
        return darkerColor
    }
    
    // MARK: - Image
    
    public func toImage() -> UIImage {
        let rect : CGRect = CGRect(x: 0, y: 0, width: 1, height: 1)
        
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()!
        context.setFillColor(self.cgColor)
        context.fill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        return image
    }
    
}
