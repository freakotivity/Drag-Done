//
//  DNDDotsView.swift
//  Drag And Done
//
//  Created by Ricardo Gonzalez on 2015-03-19.
//  Copyright (c) 2015 FreakoSoft. All rights reserved.
//

import UIKit

@IBDesignable
class DNDDotsView: UIView {
    var numberOfDots:Int = 1
    var selectedDot:Int = 1
    var colors = [String]()

    override func drawRect(rect: CGRect) {
        UIColor.blackColor().setFill()
        let context = UIGraphicsGetCurrentContext()
        for i in 0..<numberOfDots
        {
            if colors.count > i
            {
                DNDColors.colorFromString(colors[i]).setFill()
            }
            var dia:CGFloat = (self.bounds.size.width / 2.0) / 5
            let space = (self.bounds.size.height) / CGFloat(numberOfDots + 1)
            if i == (selectedDot)
            {
                dia *= 2.0
            }
            let yPos:CGFloat = space * CGFloat(i + 1) //- (dia / 2) - (space / 2)
            CGContextFillEllipseInRect(context, CGRectMake((self.bounds.size.width / 2.0) - (dia / 2), yPos, dia, dia))
        }
    }

}
