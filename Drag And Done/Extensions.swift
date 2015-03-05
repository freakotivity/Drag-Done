//
//  UIView Extension.swift
//  Drag And Done
//
//  Created by Ricardo Gonzalez on 2015-03-02.
//  Copyright (c) 2015 FreakoSoft. All rights reserved.
//

import UIKit

extension UIView {
    
    func popUp()
    {
        let originalCenter = self.center
        let originalSize = self.bounds.size
        
        self.bounds.size = CGSizeZero
        
        UIView.animateWithDuration(0.5,
            delay: 0.0,
            usingSpringWithDamping: 0.7,
            initialSpringVelocity: 0.5,
            options: UIViewAnimationOptions.CurveEaseInOut,
            animations: { () -> Void in
                self.bounds.size = originalSize
                self.center = originalCenter
            },
            completion: nil)
    }
    
    func sendTo(point: CGPoint)
    {
        UIView.animateWithDuration(0.5,
            delay: 0.0,
            usingSpringWithDamping: 0.7,
            initialSpringVelocity: 0.5,
            options: UIViewAnimationOptions.CurveEaseInOut,
            animations: { () -> Void in
                self.center = point
            },
            completion: nil)
    }
    
    func exitUp()
    {
        UIView.animateWithDuration(0.5,
            delay: 0.0,
            usingSpringWithDamping: 0.7,
            initialSpringVelocity: 0.5,
            options: UIViewAnimationOptions.CurveEaseInOut,
            animations: { () -> Void in
                self.center.y = -self.frame.size.height
            },
            completion: {
                (completed) -> Void in
                self.removeFromSuperview()
        })
    }

    func exitDown()
    {
        UIView.animateWithDuration(0.5,
            delay: 0.0,
            usingSpringWithDamping: 0.7,
            initialSpringVelocity: 0.5,
            options: UIViewAnimationOptions.CurveEaseInOut,
            animations: { () -> Void in
                self.center.y = self.superview!.bounds.size.height + self.bounds.size.height
            },
            completion:  {
                (completed) -> Void in
                self.removeFromSuperview()
        })
    }
}

extension String {
    func initials() -> String
    {
        let stringArray = split(self) {$0 == " "}
        var firsts = ""
                    for word in stringArray
                    {
                        firsts += word.substringToIndex(advance(word.startIndex, 1)).capitalizedString
                    }
                    
                    return firsts

    }
    func toBool() -> Bool? {
        switch self {
        case "True", "true", "yes", "1":
            return true
        case "False", "false", "no", "0":
            return false
        default:
            return nil
        }
    }
}
