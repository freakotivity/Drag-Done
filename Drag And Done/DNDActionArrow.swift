//
//  DNDActionArrow.swift
//  Drag And Done
//
//  Created by Ricardo Gonzalez on 2015-03-10.
//  Copyright (c) 2015 FreakoSoft. All rights reserved.
//

import UIKit

@IBDesignable
class DNDActionArrow: UIView {

    override func drawRect(rect: CGRect) {
        UIColor.grayColor().setStroke()
        let context = UIGraphicsGetCurrentContext()
        CGContextMoveToPoint(context, self.bounds.size.width / 4, self.bounds.size.height * 2 / 4)
        CGContextAddLineToPoint(context, self.bounds.size.width / 2, self.bounds.size.height / 4)
        CGContextAddLineToPoint(context, self.bounds.size.width * 3 / 4, self.bounds.size.height * 2 / 4)
        CGContextStrokePath(context)
    }

}
