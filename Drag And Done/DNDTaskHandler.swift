//
//  DNDTaskHandler.swift
//  Drag And Done
//
//  Created by Ricardo Gonzalez on 2015-02-27.
//  Copyright (c) 2015 FreakoSoft. All rights reserved.
//

/*
FOLDER:
namn
färg
tasks
update freq

Task
namn
bild
done


*/

import Foundation

//protocol DNDTaskHandlerDelegate {
//    func didSelectFolder()
//}

enum DNDUpdateFrequency: String
{
    case Daily = "Daily"
    case Weekly = "Weekly"
    case Monthly = "Monthly"
    case Yearly = "Yearly"
    case Custom = "Custom"
}

struct DNDTaskHandlerKeys {
    static let CurrentFolder = "DNDTaskHandlerDefaultKeys.currentFolder"
    static let TaskName = "DNDTaskHandlerKeys.taskName"
    static let TaskImageName = "DNDTaskHandlerKeys.taskImageName"
    static let Tasks = "DNDTaskHandlerKeys.tasks"
    static let PlistFile = "DNDTasks.plist"
    static let Color = "DNDTaskHandlerDictionaryKeys.color"
}

struct DNDTask: Printable {
    var done = false
    var name: String!
    var imageName: String!
    var taskID:String!
    var shortName: String {
        get { return name.initials() }
    }
    
    var description: String {
        return "Name: \(name) ImageName: \(imageName) ShortName: \(shortName) Done: \(done)"
    }
    
    var toDictionary: Dictionary<String, String> {
        return ["done":done.description, "name":name, "imageName":imageName, "taskID":taskID]
    }
}

struct DNDFolder: Printable {
    var name: String!
    var colorString: String!
    var updateFrequency = "Daily"
    var tasks: Array<DNDTask>!
    var doneTasks: Array<String>!
    
    var toDictionary: Dictionary<String, AnyObject> {
        var dictTasks = Array<Dictionary<String, String>>()
        for task in tasks
        {
            dictTasks.append(task.toDictionary)
        }
        return ["name":name, "colorString":colorString, "updateFrequency":updateFrequency, "tasks":dictTasks, "doneTasks":doneTasks]
    }
    
    var description: String {
        return "Folder Name: \(name) Color: \(colorString) Updatefrequency: \(updateFrequency) Tasks: \(tasks)"
    }
}

class DNDTaskHandler
{
    //    var delegate:DNDTaskHandlerDelegate?
    
    
    
    // FILE HANDLING
    
    func docDir() -> String
    {
        let paths = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)
        return paths.first as String
    }
    
    
    func plistPath() -> String
    {
        let path = docDir().stringByAppendingPathComponent(DNDTaskHandlerKeys.PlistFile)
        println("PLIST PATH \(path)")
        return path
    }
    
    func currentFolderString() -> String?
    {
        if let currFol = NSUserDefaults.standardUserDefaults().objectForKey(DNDTaskHandlerKeys.CurrentFolder) as String?
        {
            return currFol
        }
        return nil
    }
    
    func currentFolderColor() -> String?
    {
        var myPlist = NSMutableDictionary(contentsOfFile: plistPath())
        if let currentFolderString = self.currentFolderString() as String?
        {
            if let folder = myPlist?[currentFolderString] as? NSDictionary
            {
                return folder["colorString"] as String?
            }
        }
        return nil
    }
    
    func foldersColors() -> Array<String>?
    {
        if let myPlist = NSDictionary(contentsOfFile: plistPath())
        {
            var colorsArray = [String]()
            for (title, folder) in myPlist
            {
                if let fldr = folder as? Dictionary<String, AnyObject>
                {
                    if let colStr = fldr["colorString"] as? String
                    {
                        colorsArray.append(colStr)
                    }
                }
            }
            println("COLORS ARRAY: \(colorsArray)")
            return colorsArray
        }
        return nil
    }
    
    func foldersTitles() -> Array<String>?
    {
        if let myPlist = NSDictionary(contentsOfFile: plistPath())
        {
            if let titles = myPlist.allKeys as? Array<String>
            {
            return titles
            }
        }
        return nil
    }
    
    func numberOfFolders() ->Int?
    {
        if let myPlist = NSDictionary(contentsOfFile: plistPath())
        {
            if let titles = myPlist.allKeys as? Array<String>
            {
                return titles.count
            }
        }
        return nil
    }
    
    func plist() ->NSDictionary?
    {
        return NSDictionary(contentsOfFile: plistPath())
    }
    
    func selectFolderNamed(name: String)
    {
        //println("SELECT FOLDER NAMED \(name)")
        NSUserDefaults.standardUserDefaults().setObject(name, forKey: DNDTaskHandlerKeys.CurrentFolder)
        NSUserDefaults.standardUserDefaults().synchronize()
        //        delegate?.didSelectFolder()
    }
    
    func unselectCurrentFolder()
    {
        NSUserDefaults.standardUserDefaults().setObject(nil, forKey: DNDTaskHandlerKeys.CurrentFolder)
        NSUserDefaults.standardUserDefaults().synchronize()
    }
    func createFolderNamed(name: String, select: Bool, overwrite: Bool) -> Bool
    {
        var myPlist:NSMutableDictionary!
        myPlist = NSMutableDictionary(contentsOfFile: plistPath())
        if myPlist == nil
        {
            myPlist = NSMutableDictionary()
        }
        // TODO: GET NEXT COLOR IN LINE!!
        
        if overwrite
        {
            if myPlist[name] != nil
            {
                return false
            }
        }
        
        if select
        {
            selectFolderNamed(name)
        }
        
        let nuFolder = DNDFolder(name: name, colorString: nextColor(), updateFrequency: "Daily", tasks: [], doneTasks: [])
        myPlist.setObject(nuFolder.toDictionary, forKey: name)
        
        return myPlist.writeToFile(plistPath(), atomically: true)
    }
    
    func createTaskNamed(name: String, imageName: String) -> DNDTask?
    {
        //println("CREATE TASK NAMED \(name)")
        var myPlist = NSMutableDictionary(contentsOfFile: plistPath())
        if let folder = myPlist?[currentFolderString()!] as? NSMutableDictionary
        {
            //println("YES LET")
            var foldrr = folder
            var tasks = foldrr["tasks"] as NSMutableArray
            let nuTask = DNDTask(done: false, name: name, imageName: imageName, taskID: randomStringWithLength(10))
            tasks.addObject(nuTask.toDictionary)
            foldrr.setObject(tasks, forKey: "tasks")
            myPlist?.setObject(foldrr, forKey: currentFolderString()!)
            myPlist?.writeToFile(plistPath(), atomically: true)
            return nuTask
        }
        
        return nil
    }
    
    func tasks() -> Array<DNDTask>?
    {
        var myPlist = NSMutableDictionary(contentsOfFile: plistPath())
        if let cfs = currentFolderString() as String?
        {
            if let folder = myPlist?[cfs] as? NSDictionary
            {
                var taskArray = [DNDTask]()
                for task in (folder["tasks"] as NSArray)
                {
                    let nuTask = DNDTask(done: (task["done"] as String).toBool()!, name: task["name"] as String, imageName: task["imageName"] as String, taskID: task["taskID"] as String)
                    taskArray.append(nuTask)
                }
                return taskArray
            }
        }
        return nil
    }
    
    func taskDone(doneTask: DNDTask, done: Bool)
    {
        //println("TASK DONE")
        var myPlist = NSMutableDictionary(contentsOfFile: plistPath())
        //println("MY PLIST FÖRE: \(myPlist)")
        if let folder = myPlist?[currentFolderString()!] as? NSMutableDictionary
        {
            var foldrr = folder
            var tasks = foldrr["tasks"] as NSMutableArray
            //println("TASKS \(tasks)")
            for task in tasks
            {
                if (task["taskID"] as String) == doneTask.taskID
                {
                    //println("jo")
                    let taskIndex = tasks.indexOfObject(task)
                    let nuTask = DNDTask(done: done, name: doneTask.name, imageName: doneTask.imageName, taskID: doneTask.taskID).toDictionary
                    tasks.insertObject(nuTask, atIndex: taskIndex)
                    tasks.removeObject(task)
                    var doneTasks = foldrr["doneTasks"] as NSMutableArray
                    if done
                    {
                        doneTasks.addObject(doneTask.taskID)
                    } else {
                        doneTasks.removeObject(doneTask.taskID)
                    }
                    foldrr.setObject(doneTasks, forKey: "doneTasks")
                    break
                }
            }
            //            tasks.addObject(DNDTask(done: false, name: name, imageName: imageName).toDictionary)
            foldrr.setObject(tasks, forKey: "tasks")
            //println("THE FOLDRRR \(foldrr)")
            myPlist?.setObject(foldrr, forKey: currentFolderString()!)
            //println("MY PLIST: \(myPlist)")
            
            if myPlist!.writeToFile(plistPath(), atomically: true)
            {
                //println("SUCCESS!!")
            } else {
                //println("FAIL!!")
            }
        }
    }
    
    func randomStringWithLength (len : Int) -> NSString {
        
        let letters : NSString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        
        var randomString : NSMutableString = NSMutableString(capacity: len)
        
        for (var i=0; i < len; i++){
            var length = UInt32 (letters.length)
            var rand = arc4random_uniform(length)
            randomString.appendFormat("%C", letters.characterAtIndex(Int(rand)))
        }
        
        return randomString
    }
    
    func nextColor() -> String
    {
        if let usedColors = NSUserDefaults.standardUserDefaults().objectForKey("usedColors") as? Array<String>
        {
            //println("USED COLORS \(usedColors)")
            for color in DNDColors.allColorStrings
            {
                //println("TESTAR COLOR \(color)")
                if find(usedColors, color) == nil
                {
                    var usedColorsArray = usedColors
                    usedColorsArray.append(color)
                    NSUserDefaults.standardUserDefaults().setObject(usedColorsArray, forKey: "usedColors")
                    NSUserDefaults.standardUserDefaults().synchronize()
                    return color
                }
            }
        } else {
            let firstColor = DNDColors.allColorStrings.first
            NSUserDefaults.standardUserDefaults().setObject([firstColor!], forKey: "usedColors")
            NSUserDefaults.standardUserDefaults().synchronize()
            return firstColor!
        }
        return "freakoViolet"
    }
    
}

/*    // COLORS
func usedColorStrings() -> Array<String>
{
return []
}


// FOLDER STUFF






func currentFolder() -> DNDFolder?
{
//println("CURRENT FOLDER")
return nil
}




func removeFolderNamed(name: String) -> Bool
{
return false
}

func renameFolder(oldName: String, newName: String) -> Bool
{
return false
}

// TASKS STUFF









func removeTaskNamed(name: String) -> Bool
{
return false
}
*/