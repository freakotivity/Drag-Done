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
    let topBarHeight:CGFloat = 51
    var taskViewSize:CGFloat!
    var todoXPosition:CGFloat!
    var doneXPosition:CGFloat!
    var taskViews = [DNDTaskView]()
    var doneTaskViews = [DNDTaskView]()
    let topBarView = UIView()
    let titleLabel = UILabel()
    var entryPoint:CGFloat!
    let placeHolder = Placeholder()
    
    override func viewDidLoad() {
        //        taskHandler.createFolderNamed("EMPTY", select: true, overwrite: true)
        //        taskHandler.createFolderNamed("FIRST", select: true, overwrite: true)
        //        taskHandler.createTaskNamed("Spork One", imageName: " ")
        //        taskHandler.createTaskNamed("Spork Two", imageName: " ")
        //        taskHandler.createTaskNamed("Spork Three", imageName: " ")
        //        taskHandler.createTaskNamed("Spork FORK", imageName: " ")
        //        taskHandler.createTaskNamed("Spork FIVE", imageName: "")
        //        taskHandler.createFolderNamed("SECOND", select: true, overwrite: true)
        //        taskHandler.createTaskNamed("Spork One", imageName: " ")
        //        taskHandler.createTaskNamed("Spork Two", imageName: " ")
        //        taskHandler.createTaskNamed("Spork Three", imageName: " ")
        //        taskHandler.createTaskNamed("Spork FORK", imageName: " ")
        //        taskHandler.createTaskNamed("Spork FIVE", imageName: "")
        //        taskHandler.createFolderNamed("THIRD", select: true, overwrite: true)
        //                taskHandler.createTaskNamed("Spork One", imageName: " ")
        //                taskHandler.createTaskNamed("Spork Two", imageName: " ")
        //                taskHandler.createTaskNamed("Spork Three", imageName: " ")
        //                taskHandler.createTaskNamed("Spork FORK", imageName: " ")
        //                taskHandler.createTaskNamed("Spork FIVE", imageName: "")
        //        taskHandler.createTaskNamed("Spork On", imageName: "")
        //        taskHandler.createTaskNamed("Spork In", imageName: "")
        //        taskHandler.createTaskNamed("Spork Off", imageName: "")
        //        taskHandler.createTaskNamed("Spork Away", imageName: "")
        //        println("PLIST: \(taskHandler.plist())")
        
        let placeHolderTap = UITapGestureRecognizer(target: self, action: "tappedPlaceHolder:")
        placeHolder.addGestureRecognizer(placeHolderTap)
        placeHolder.backgroundColor = UIColor.clearColor()
        self.view.addSubview(placeHolder)
        
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        topBarView.frame = CGRectMake(0, 0, self.view.bounds.size.width, topBarHeight)
        topBarView.backgroundColor = DNDColors.freakoGreen
        self.view.addSubview(topBarView)
        
        topBarView.addSubview(titleLabel)
        titleLabel.textColor = UIColor.whiteColor()
        titleLabel.font = UIFont(name: "Helvetica Neue", size: 20)
        
        taskViewSize = (self.view.bounds.size.height - topBarHeight) / 5
        
        let addFolderButton = UIButton(frame: CGRectMake(0, 0, 44, 44))
        addFolderButton.setTitle("+", forState: UIControlState.Normal)
        addFolderButton.addTarget(self, action: "addFolder:", forControlEvents: UIControlEvents.TouchUpInside)
        addFolderButton.center = CGPointMake(self.view.bounds.size.width - 23, topBarHeight - addFolderButton.bounds.size.height / 2)
        topBarView.addSubview(addFolderButton)

        
        todoXPosition = self.view.bounds.size.width / 4
        doneXPosition = self.view.bounds.size.width * 3 / 4
        
        entryPoint = self.view.bounds.size.height + taskViewSize
        
        
        loadCurrentFolder()
        refreshUI()
    }
    
    func addFolder(sender: UIButton)
    {
        println("ADD FOLDER: \(sender)")
        let addFolderAction = UIAlertController(title: "Add Folder", message: nil, preferredStyle: UIAlertControllerStyle.Alert)
        addFolderAction.addTextFieldWithConfigurationHandler { (textField) -> Void in
            
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil)
        let addAction = UIAlertAction(title: "Add", style: UIAlertActionStyle.Default) { (action) -> Void in
            println("ADD \((addFolderAction.textFields?.first as UITextField).text)")
            self.taskHandler.createFolderNamed((addFolderAction.textFields?.first as UITextField).text, select: true, overwrite: true)
            self.loadCurrentFolder()
            
        }
        addFolderAction.addAction(cancelAction)
        addFolderAction.addAction(addAction)
        self.presentViewController(addFolderAction, animated: true, completion: nil)
    }
    
    func tappedPlaceHolder(tap: UITapGestureRecognizer)
    {
        println("TAPPED PLACEHOLDER")
        let addTaskAction = UIAlertController(title: "Add Task", message: nil, preferredStyle: UIAlertControllerStyle.Alert)
        addTaskAction.addTextFieldWithConfigurationHandler { (textField) -> Void in
            
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil)
        let addAction = UIAlertAction(title: "Add", style: UIAlertActionStyle.Default) { (action) -> Void in
            println("ADD \((addTaskAction.textFields?.first as UITextField).text)")
            self.taskHandler.createTaskNamed((addTaskAction.textFields?.first as UITextField).text, imageName: "")
            self.loadCurrentFolder()
            
        }
        addTaskAction.addAction(cancelAction)
        addTaskAction.addAction(addAction)
        self.presentViewController(addTaskAction, animated: true, completion: nil)
    }
    
    func handleLongPress(lp: UILongPressGestureRecognizer)
    {
        println("LONG PRESS! START DANCING!")
        for tv in taskViews
        {
            tv.startDancing()
        }
    }
    
    @IBAction func handlePan(pan: UIPanGestureRecognizer)
    {
        if let pannedView = pan.view as? DNDTaskView
        {
            switch pan.state
            {
            case UIGestureRecognizerState.Changed:
                pannedView.center.x += pan.translationInView(self.view).x
                pannedView.center.y += pan.translationInView(self.view).y
                pan.setTranslation(CGPointZero, inView: self.view)
            case UIGestureRecognizerState.Ended:
                if pannedView.center.x > self.view.bounds.width / 2
                {
                    if pannedView.task?.done != true
                    {
                        taskHandler.taskDone(pannedView.task!, done: true)
                        pannedView.task?.done = true
                        doneTaskViews.append(pannedView)
                    }
                } else {
                    if pannedView.task?.done == true
                    {
                        taskHandler.taskDone(pannedView.task!, done: false)
                        pannedView.task?.done = false
                        doneTaskViews.removeAtIndex(find(doneTaskViews, pannedView)!)
                    }
                }
                refreshUI()
            default: break
            }
        } else {
            println("TRANSLATION IN VIEW \(pan.translationInView(self.view))")
            if pan.translationInView(self.view).y < -70
            {
                println("NEXT FOLDER")
                pan.setTranslation(CGPointZero, inView: self.view)
                nextFolder()
            }
            if pan.translationInView(self.view).y > 70
            {
                println("PREV FOLDER")
                pan.setTranslation(CGPointZero, inView: self.view)
                prevFolder()
            }
        }
        
    }
    
    func refreshUI()
    {
        arrangeTaskviews()
    }
    
    func arrangeTaskviews()
    {
        var counter:CGFloat = 0.0
        var doneCounter:CGFloat = 0.0
        
        let firstY:CGFloat = self.view.bounds.size.height - (taskViewSize / 2)
        for tv in taskViews
        {
            if tv.task?.done != true
            {
                tv.sendTo(CGPointMake(todoXPosition, firstY - (taskViewSize * counter)))
                counter += 1.0
            }
        }
        placeHolder.bounds.size = CGSizeMake(taskViewSize, taskViewSize)
        placeHolder.center = CGPointMake(todoXPosition, firstY - (taskViewSize * counter))
        
        for dtv in doneTaskViews
        {
            dtv.sendTo(CGPointMake(doneXPosition, firstY - (taskViewSize * doneCounter)))
            doneCounter += 1.0
        }
    }
    
    func colorFromString(colorString: String) -> UIColor
    {
        switch colorString
        {
        case "freakoGreen": return DNDColors.freakoGreen
        case "freakoDarkBlue": return DNDColors.freakoDarkBlue
        case "freakoViolet": return DNDColors.freakoViolet
        case "freakoBlue": return DNDColors.freakoBlue
        case "freakoOrange": return DNDColors.freakoOrange
        case "freakoRed": return DNDColors.freakoRed
        case "freakoYellow": return DNDColors.freakoYellow
        default: return UIColor.blackColor()
        }
    }
    
    func loadCurrentFolder()
    {
        taskViews.removeAll()
        doneTaskViews.removeAll()
        
        titleLabel.text = taskHandler.currentFolderString()
        titleLabel.sizeToFit()
        titleLabel.center.x = self.view.center.x
        titleLabel.center.y = topBarHeight - titleLabel.bounds.size.height / 2
        
        var clr:UIColor!
        if let colStr = taskHandler.currentFolderColor()
        {
            clr = colorFromString(colStr)
            topBarView.backgroundColor = clr
        }
        
        if let tasks = taskHandler.tasks()
        {
            println("TASK COUNT \(tasks.count)")
            for i in 0..<tasks.count
            {
                let tv = DNDTaskView()
                tv.taskColor = clr
                tv.bounds.size = CGSizeMake(taskViewSize * 0.99, taskViewSize * 0.99)
                tv.task = taskHandler.tasks()![i]
                let panRec = UIPanGestureRecognizer(target: self, action: "handlePan:")
                tv.addGestureRecognizer(panRec)
                
                let longPress = UILongPressGestureRecognizer(target: self, action: "handleLongPress:")
                tv.addGestureRecognizer(longPress)
                
                tv.center.y = entryPoint
                tv.center.x = tv.task!.done ? doneXPosition : todoXPosition
                
                self.view.addSubview(tv)
                self.taskViews.append(tv)
                
                if tv.task?.done == true
                {
                    doneTaskViews.append(tv)
                }
            }
            if tasks.count < 4
            {
                println("TASK COUNT NOLL!!")
                placeHolder.frame.size = CGSizeMake(taskViewSize * 0.8, taskViewSize * 0.8)
                placeHolder.popUp()
            } else {
                placeHolder.center = CGPointMake(-666, -666)
            }
        }
        refreshUI()
    }
    
    func nextFolder()
    {
        for tv in taskViews
        {
            tv.exitUp()
        }
        entryPoint = self.view.bounds.size.height + taskViewSize
        
        let folders = taskHandler.folders()
        if let folderIndex = find(folders, taskHandler.currentFolderString()!)
        {
            println("FOLDERINDEX \(folderIndex)")
            if folderIndex > (folders.count - 2)
            {
                taskHandler.selectFolderNamed(folders.first!)
            } else {
                taskHandler.selectFolderNamed(folders[folderIndex + 1])
            }
            loadCurrentFolder()
        }
        
    }
    func prevFolder()
    {
        for tv in taskViews
        {
            tv.exitDown()
        }
        entryPoint = -taskViewSize
        
        let folders = taskHandler.folders()
        if let folderIndex = find(folders, taskHandler.currentFolderString()!)
        {
            println("FOLDERINDEX \(folderIndex)")
            if folderIndex == 0
            {
                taskHandler.selectFolderNamed(folders.last!)
            } else {
                taskHandler.selectFolderNamed(folders[folderIndex - 1])
            }
            loadCurrentFolder()
        }
        
    }
}
