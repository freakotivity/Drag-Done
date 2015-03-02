//
//  DragAndDoneMainViewController.swift
//  Drag And Done
//
//  Created by Ricardo Gonzalez on 2015-02-27.
//  Copyright (c) 2015 FreakoSoft. All rights reserved.
//

import UIKit

class DragAndDoneMainViewController: UIViewController {
    
    let taskHandler = DNDTaskHandler()

    override func viewDidLoad() {
        println("PLIST: \(taskHandler.plist())")
        
        
        for i in 1...5
        {
        let tv = DNDTaskView()
        let panRec = UIPanGestureRecognizer(target: self, action: "handlePan:")
        tv.frame = CGRectMake(100, 100 * CGFloat(i), 100, 100)
        tv.addGestureRecognizer(panRec)
        self.view.addSubview(tv)
        }
    }
    
    func handlePan(pan: UIPanGestureRecognizer)
    {
        if let pannedView = pan.view as? DNDTaskView
        {
            switch pan.state
            {
            case UIGestureRecognizerState.Changed:
                pannedView.center.x += pan.translationInView(self.view).x
                pannedView.center.y += pan.translationInView(self.view).y
                pan.setTranslation(CGPointZero, inView: self.view)
            default: break
            }
        }
    }
}
