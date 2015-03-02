//
//  DNDTaskView.swift
//  Drag And Done
//
//  Created by Ricardo Gonzalez on 2015-02-28.
//  Copyright (c) 2015 FreakoSoft. All rights reserved.
//

import UIKit

class DNDTaskView: UIView {
    var taskColor:UIColor = DNDColors.freakoBlue
    var taskShortName = "D D"
    var taskFullName = "Drag Done"
    
    override init() {
        super.init()
        commonInit()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    func commonInit()
    {
        self.backgroundColor = UIColor.clearColor()
    }
    
    override func drawRect(rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()
        self.taskColor.setFill()
        CGContextFillEllipseInRect(context, self.bounds)
        
        (taskShortName as NSString).drawAtPoint(self.bounds.origin, withAttributes: nil)
    }
}
