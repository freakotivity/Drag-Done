//
//  DragAndDoneMainViewController.swift
//  Drag And Done
//
//  Created by Ricardo Gonzalez on 2015-02-27.
//  Copyright (c) 2015 FreakoSoft. All rights reserved.
//

import UIKit

struct ZOrder {
    static let UIStuff: CGFloat = 100
    static let Taskviews: CGFloat = 200
    static let Topbar: CGFloat = 300
}

class DragAndDoneMainViewController: UIViewController {
    
    @IBOutlet weak var dotsView: DNDDotsView!
    let taskHandler = DNDTaskHandler()
    let topBarHeight:CGFloat = 64
    var taskViewSize:CGFloat!
    var todoXPosition:CGFloat!
    var doneXPosition:CGFloat!
    var taskViews = [DNDTaskView]()
    var doneTaskViews = [DNDTaskView]()
    //    let topBarView = UIView()
    //    let titleLabel = UILabel()
    var entryPoint:CGFloat!
    let placeHolder = Placeholder()
    //    var showsTopPage = false
    //    var showsBottomPage = false
    
    override func viewDidLoad() {
        //                taskHandler.createFolderNamed("EMPTY", select: true, overwrite: true)
        //                taskHandler.createFolderNamed("FIRST", select: true, overwrite: true)
        //                taskHandler.createTaskNamed("Spork One", imageName: " ")
        //                taskHandler.createTaskNamed("Spork Two", imageName: " ")
        //                taskHandler.createTaskNamed("Spork Three", imageName: " ")
        //                taskHandler.createTaskNamed("Spork FORK", imageName: " ")
        //                taskHandler.createTaskNamed("Spork FIVE", imageName: "")
        //                taskHandler.createFolderNamed("SECOND", select: true, overwrite: true)
        //                taskHandler.createTaskNamed("Spork One", imageName: " ")
        //                taskHandler.createTaskNamed("Spork Two", imageName: " ")
        //                taskHandler.createTaskNamed("Spork Three", imageName: " ")
        //                taskHandler.createTaskNamed("Spork FORK", imageName: " ")
        //                taskHandler.createTaskNamed("Spork FIVE", imageName: "")
        //                taskHandler.createFolderNamed("THIRD", select: true, overwrite: true)
        //                        taskHandler.createTaskNamed("Spork One", imageName: " ")
        //                        taskHandler.createTaskNamed("Spork Two", imageName: " ")
        //                        taskHandler.createTaskNamed("Spork Three", imageName: " ")
        //                        taskHandler.createTaskNamed("Spork FORK", imageName: " ")
        //                        taskHandler.createTaskNamed("Spork FIVE", imageName: "")
        //                taskHandler.createTaskNamed("Spork On", imageName: "")
        //                taskHandler.createTaskNamed("Spork In", imageName: "")
        //                taskHandler.createTaskNamed("Spork Off", imageName: "")
        //                taskHandler.createTaskNamed("Spork Away", imageName: "")
        //        //println("PLIST: \(taskHandler.plist())")
        
        println("MAIN VIEW DID LOAD!!")
        
        let placeHolderTap = UITapGestureRecognizer(target: self, action: "tappedPlaceHolder:")
        placeHolder.addGestureRecognizer(placeHolderTap)
        placeHolder.backgroundColor = UIColor.clearColor()
        placeHolder.layer.zPosition = ZOrder.UIStuff
        self.view.addSubview(placeHolder)
        UIApplication.sharedApplication().setStatusBarStyle(UIStatusBarStyle.LightContent, animated: true)
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "Back", style: UIBarButtonItemStyle.Bordered, target: nil, action: nil)
        
//        self.navigationItem.backBarButtonItem =
//            [[[UIBarButtonItem alloc] initWithTitle:@"Custom Title"
//        style:UIBarButtonItemStyleBordered
//        target:nil
//        action:nil] autorelease];
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        println("MAIN VIEW WILL APPEAR")
        
        for tv in taskViews
        {
            tv.removeFromSuperview()
        }
        taskViews.removeAll()
        doneTaskViews.removeAll()
        
        //        topBarView.frame = CGRectMake(0, 0, self.view.bounds.size.width, topBarHeight)
        //        topBarView.backgroundColor = DNDColors.freakoGreen
        //        topBarView.layer.zPosition = ZOrder.Topbar
        //        self.view.addSubview(topBarView)
        //
        //        topBarView.addSubview(titleLabel)
        //        titleLabel.textColor = UIColor.whiteColor()
        //        titleLabel.font = UIFont(name: "Helvetica Neue", size: 20)
        
        taskViewSize = (self.view.bounds.size.height - topBarHeight) / 6
        println("TASK VIEW SIZE \(taskViewSize)")
        
        todoXPosition = self.view.bounds.size.width / 4
        doneXPosition = self.view.bounds.size.width * 3 / 4
        
        entryPoint = self.view.bounds.size.height + taskViewSize
        
        
        loadCurrentFolder()
        refreshUI()
    }
    
    func addFolder()
    {
        self.performSegueWithIdentifier("Add Folder", sender: nil)
    }
    
    func tappedPlaceHolder(tap: UITapGestureRecognizer)
    {
        addTask()
    }
    
    func addTask()
    {
        self.performSegueWithIdentifier("Add Task", sender: nil)
    }
    
    func handleLongPress(lp: UILongPressGestureRecognizer)
    {
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
            //            //println("TRANSLATION IN VIEW \(pan.translationInView(self.view))")
            switch pan.state
            {
            case .Changed: dotsView.hidden = false
            default: dotsView.hidden = true
            }
            if pan.translationInView(self.view).y < -70
            {
                pan.setTranslation(CGPointZero, inView: self.view)
                nextFolder()
            }
            if pan.translationInView(self.view).y > 70
            {
                pan.setTranslation(CGPointZero, inView: self.view)
                prevFolder()
            }
        }
        
    }
    
    func refreshUI()
    {
        arrangeTaskviews()
        arrangeDots(false)
        
    }
    
    func clearDots(fade: Bool)
    {
        
    }
    
    func countDots()
    {
        
    }
    
    func toggleDotView()
    {
        dotsView.hidden = !dotsView.hidden
    }
    
    func arrangeDots(fade: Bool)
    {
        //println("ARRANGE DOTS")
        dotsView.colors = taskHandler.foldersColors()!
        if let folders = taskHandler.foldersTitles()
        {
            dotsView.numberOfDots = folders.count
            if let folderIndex = find(folders, taskHandler.currentFolderString()!)
            {
                println("FOLDER INDEX: \(folderIndex)")
                dotsView.selectedDot = folderIndex
            }
        }
        dotsView.setNeedsDisplay()
    }
    
    func arrangeTaskviews()
    {
        var counter:CGFloat = 1.0
        var doneCounter:CGFloat = 1.0
        let ySpace: CGFloat = self.view.bounds.size.height / 6
        
        for tv in taskViews
        {
            if tv.task?.done != true
            {
                let yPos = self.view.bounds.size.height - (ySpace * counter) + (taskViewSize / 3)
                tv.sendTo(CGPointMake(todoXPosition, yPos))
                counter += 1.0
            }
        }
        
        if taskViews.count < 5 && taskHandler.currentFolderString() != nil
        {
            placeHolder.bounds.size = CGSizeMake(taskViewSize, taskViewSize)
            placeHolder.center = CGPointMake(todoXPosition, self.view.bounds.size.height - (ySpace * counter) + (taskViewSize / 3))
        } else {
            hidePlaceholder()
        }
        
        for dtv in doneTaskViews
        {
            let yPos = self.view.bounds.size.height - (ySpace * doneCounter) + (taskViewSize / 3)
            dtv.sendTo(CGPointMake(doneXPosition, yPos))
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
    
    func tappedTaskView(tap: UITapGestureRecognizer)
    {
        println("TAPPED TASK VIEW")
        resetTaskviews()
        if let tv = tap.view as? DNDTaskView
        {
            tv.showsWholeName = true
            tv.setNeedsDisplay()
        }
    }
    
    func loadCurrentFolder()
    {
        taskViews.removeAll()
        doneTaskViews.removeAll()
        
        if let folderString = taskHandler.currentFolderString() as String?
        {
            //        setTitle(folderString)
            self.title = folderString
        }
        
        var clr:UIColor!
        if let colStr = taskHandler.currentFolderColor()
        {
            clr = colorFromString(colStr)
            navigationController?.navigationBar.barTintColor = clr
            //            topBarView.backgroundColor = clr
        }
        
        if let tasks = taskHandler.tasks()
        {
            //println("TASK COUNT \(tasks.count)")
            for i in 0..<tasks.count
            {
                let tv = DNDTaskView()
                tv.taskColor = clr
                tv.bounds.size = CGSizeMake(taskViewSize * 0.99, taskViewSize * 0.99)
                tv.task = taskHandler.tasks()![i]
                let panRec = UIPanGestureRecognizer(target: self, action: "handlePan:")
                tv.addGestureRecognizer(panRec)
                
                let tvTap = UITapGestureRecognizer(target: self, action: "tappedTaskView:")
                tv.addGestureRecognizer(tvTap)
                
                let longPress = UILongPressGestureRecognizer(target: self, action: "handleLongPress:")
                tv.addGestureRecognizer(longPress)
                
                tv.center.y = entryPoint
                tv.center.x = tv.task!.done ? doneXPosition : todoXPosition
                tv.layer.zPosition = ZOrder.Taskviews
                self.view.addSubview(tv)
                self.taskViews.append(tv)
                
                if tv.task?.done == true
                {
                    doneTaskViews.append(tv)
                }
            }
            if tasks.count < 4
            {
                //println("TASK COUNT NOLL!!")
                placeHolder.frame.size = CGSizeMake(taskViewSize * 0.8, taskViewSize * 0.8)
                placeHolder.popUp()
            } else {
                placeHolder.center = CGPointMake(-666, -666)
            }
        }
        refreshUI()
    }
    
    func clearTaskViews()
    {
        for tv in taskViews
        {
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                tv.exitUp()
            })
        }
    }
    
    func prevFolder()
    {
        if let folders = taskHandler.foldersTitles()
        {
            for tv in taskViews
            {
                tv.exitUp()
            }
            clearTaskViews()
            taskViews.removeAll()
            doneTaskViews.removeAll()
            entryPoint = -taskViewSize
            
            if let cfs = taskHandler.currentFolderString() as String?
            {
                if let folderIndex = find(folders, taskHandler.currentFolderString()!)
                {
                    if folderIndex == folders.count - 1
                    {
                        taskHandler.selectFolderNamed(folders.first!)
                    } else {
                        taskHandler.selectFolderNamed(folders[folderIndex + 1])
                    }
                    loadCurrentFolder()
                }
            }
        }
        
        
    }
    func nextFolder()
    {
        if let folders = taskHandler.foldersTitles()
        {
            for tv in taskViews
            {
                tv.exitUp()
            }
            taskViews.removeAll()
            doneTaskViews.removeAll()
            entryPoint = self.view.bounds.size.height + taskViewSize

            if let cfs = taskHandler.currentFolderString() as String?
            {
                if let folderIndex = find(folders, taskHandler.currentFolderString()!)
                {
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
        
        
    }
    
    func hidePlaceholder()
    {
        placeHolder.center = CGPointMake(-placeHolder.bounds.size.width, -placeHolder.bounds.size.height)
    }
    
    @IBAction func tappedDotsView(tap: UITapGestureRecognizer) {
        let height:CGFloat = dotsView.bounds.size.height
        let dotSpace:CGFloat = height / CGFloat(dotsView.numberOfDots + 1)
        println("TAPPED DOTS VIEW \(Int(round(tap.locationInView(dotsView).y / dotSpace)))")
        if let folders = taskHandler.foldersTitles()
        {
            for tv in taskViews
            {
                tv.exitUp()
            }
            taskViews.removeAll()
            doneTaskViews.removeAll()
            entryPoint = self.view.bounds.size.height + taskViewSize
            taskHandler.selectFolderNamed(folders[Int(round(tap.locationInView(dotsView).y / dotSpace)) - 1])
            loadCurrentFolder()
        }
    }
    
    @IBAction func handleTap(sender: UITapGestureRecognizer) {
        println("TAPPED WHOLE VIEW")
        toggleDotView()
        resetTaskviews()
    }
    
    func resetTaskviews()
    {
        for tv in taskViews
        {
            tv.showsWholeName = false
            tv.setNeedsDisplay()
        }
    }
    
    @IBAction func tappedActionArrow(tap: UITapGestureRecognizer) {
        println("TAPPED ACTION ARROW")
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet)
        let nuFolder = UIAlertAction(title: "New Folder", style: UIAlertActionStyle.Default) { (action) -> Void in
            println("NEW FOLDER")
            self.clearTaskViews()
            self.performSegueWithIdentifier("Add Folder", sender: nil)
        }
        let nuTask = UIAlertAction(title: "New Task", style: UIAlertActionStyle.Default) { (action) -> Void in
            println("NEW TASK")
            self.clearTaskViews()
            self.performSegueWithIdentifier("Add Task", sender: nil)
        }
        let editFolder = UIAlertAction(title: "Edit Folder", style: UIAlertActionStyle.Default) { (action) -> Void in
            println("EDIT FOLDER")
            self.clearTaskViews()
            self.performSegueWithIdentifier("Edit Folder", sender: nil)
        }
        let editTasks = UIAlertAction(title: "Edit Tasks", style: UIAlertActionStyle.Default) { (action) -> Void in
            println("EDIT TASKS")
            self.clearTaskViews()
            self.performSegueWithIdentifier("Add Task", sender: nil)
        }
        let settings = UIAlertAction(title: "Settings", style: UIAlertActionStyle.Default) { (action) -> Void in
            println("SETTINGS")
            self.performSegueWithIdentifier("settings", sender: nil)
        }
        let cancel = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel) { (action) -> Void in
            println("CANCEL")
        }
        actionSheet.addAction(nuFolder)
        actionSheet.addAction(nuTask)
        actionSheet.addAction(editFolder)
        actionSheet.addAction(editTasks)
        actionSheet.addAction(settings)
        actionSheet.addAction(cancel)
        presentViewController(actionSheet, animated: true, completion: nil)
    }
}
