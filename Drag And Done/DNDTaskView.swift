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

    var task:DNDTask? {
        didSet {
            //println("TASK SET \(task) \(self)")
            updateView()
        }
    }
    
    var shortNameLabel:UILabel!
    
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
        shortNameLabel = UILabel()
        self.addSubview(shortNameLabel)
        shortNameLabel.textColor = UIColor.whiteColor()
    }
    
    override func drawRect(rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()
        self.taskColor.setFill()
        UIColor.blackColor().setStroke()
        
        CGContextFillEllipseInRect(context, self.bounds)
//        CGContextStrokeEllipseInRect(context, self.bounds)
    }
    
    override func setNeedsDisplay() {
        super.setNeedsDisplay()
        updateView()
    }
    
    func updateView()
    {
        shortNameLabel?.text = task?.shortName
        shortNameLabel?.sizeToFit()
        shortNameLabel?.center = CGPointMake(self.bounds.size.width / 2, self.bounds.size.height / 2)
    }
}
