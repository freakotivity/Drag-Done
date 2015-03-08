//
//  DNDFolderDotView.swift
//  Drag And Done
//
//  Created by Ricardo Gonzalez on 2015-03-08.
//  Copyright (c) 2015 FreakoSoft. All rights reserved.
//

import UIKit

enum DotType {
    case dot, plus, stat
}

class DNDFolderDotView: UIView {
    var selected = false
    var color:UIColor = DNDColors.freakoRed
    var name = ""
    var type = DotType.dot
    
    override func drawRect(rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()
        let dotRect = CGRectMake((self.bounds.size.width / 2) - 3, (self.bounds.size.width / 2) - 3, 6, 6)
        if selected
        {
            UIColor.blackColor().setFill()
        let selRect = CGRectMake((self.bounds.size.width / 2) - 5, (self.bounds.size.width / 2) - 5, 10, 10)
        CGContextFillEllipseInRect(context, selRect)
        }
        
        switch type
        {
        case .dot:
            self.color.setFill()
            CGContextFillEllipseInRect(context, dotRect)
        case .plus:
            UIColor.blackColor().setStroke()
            CGContextMoveToPoint(context, dotRect.origin.x, dotRect.origin.y + (dotRect.size.height / 2))
            CGContextAddLineToPoint(context, dotRect.origin.x + dotRect.size.width, dotRect.origin.y + (dotRect.size.height / 2))
            CGContextMoveToPoint(context, dotRect.origin.x + (dotRect.size.width / 2), dotRect.origin.y)
            CGContextAddLineToPoint(context, dotRect.origin.x + (dotRect.size.width / 2), dotRect.origin.y + dotRect.size.height)
            CGContextStrokePath(context)
        case .stat:
            println("stat")
        }
        
    }
}
