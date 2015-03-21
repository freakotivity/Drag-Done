//
//  DNDTaskView.swift
//  Drag And Done
//
//  Created by Ricardo Gonzalez on 2015-02-28.
//  Copyright (c) 2015 FreakoSoft. All rights reserved.
//

import UIKit

class DNDTaskView: UIView {
    let taskHandler = DNDTaskHandler()
    var taskColor:UIColor = DNDColors.freakoBlue
    var showsWholeName = false
    
    var task:DNDTask? {
        didSet {
            //println("TASK SET \(task) \(self)")
            updateView()
        }
    }
    
    var shortNameLabel:UILabel!
    var wholeNameLabel:UILabel!
    
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
        shortNameLabel.font = UIFont(name: "Helvetica Neue", size: 20.0)
        self.addSubview(shortNameLabel)
        shortNameLabel.textColor = UIColor.whiteColor()
        
        wholeNameLabel = UILabel()
        wholeNameLabel.layer.borderColor = UIColor.grayColor().CGColor
        wholeNameLabel.layer.borderWidth = 1.0
        wholeNameLabel.layer.cornerRadius = 5.0
        wholeNameLabel.layer.masksToBounds = true
        wholeNameLabel.textAlignment = NSTextAlignment.Center
        wholeNameLabel.backgroundColor = UIColor.whiteColor()
        wholeNameLabel.font = UIFont(name: "Helvetica Neue", size: 15.0)
        self.addSubview(wholeNameLabel)
        wholeNameLabel.textColor = UIColor.blackColor()
    }
    
    override func drawRect(rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()
        self.taskColor.setFill()
        UIColor.blackColor().setStroke()
        
        CGContextFillEllipseInRect(context, self.bounds)
        CGContextAddEllipseInRect(context, self.bounds)
        CGContextClip(context)
        
        if let imageName = self.task?.imageName?
        {
            
            let docDir = taskHandler.docDir()
            let picPath = docDir.stringByAppendingPathComponent(self.task!.imageName!)
            
            
            if let image = UIImage(contentsOfFile: picPath)
            {
                image.drawInRect(self.bounds)
                shortNameLabel.hidden = true
            } else {
                shortNameLabel.hidden = false
            }
        }
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
        
        wholeNameLabel?.text = task?.name
        wholeNameLabel?.sizeToFit()
        wholeNameLabel?.bounds.size.height *= 1.2
        wholeNameLabel?.bounds.size.width *= 1.2
        wholeNameLabel?.center = CGPointMake(self.bounds.size.width / 2, self.bounds.size.height * 0.8)
        
        wholeNameLabel?.hidden = !self.showsWholeName
    }
}
