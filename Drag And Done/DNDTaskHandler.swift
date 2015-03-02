//
//  DNDTaskHandler.swift
//  Drag And Done
//
//  Created by Ricardo Gonzalez on 2015-02-27.
//  Copyright (c) 2015 FreakoSoft. All rights reserved.
//

import Foundation

struct DNDTaskHandlerKeys {
    static let CurrentFolder = "DNDTaskHandlerDefaultKeys.currentFolder"
    static let TaskName = "DNDTaskHandlerKeys.taskName"
    static let TaskImageName = "DNDTaskHandlerKeys.taskImageName"
    static let Tasks = "DNDTaskHandlerKeys.tasks"
    static let PlistFile = "DNDTasks.plist"
    static let Color = "DNDTaskHandlerDictionaryKeys.color"
}

struct DNDTask {
    var name: String
    var imageName: String
    
    func taskDictionary() -> Dictionary<String, String>
    {
        return [DNDTaskHandlerKeys.TaskName:name, DNDTaskHandlerKeys.TaskImageName:imageName]
    }
    func taskFromDictionary(dictionary: Dictionary<String, String>) ->DNDTask
    {
        return DNDTask(name: dictionary[DNDTaskHandlerKeys.TaskName]!, imageName: dictionary[DNDTaskHandlerKeys.TaskImageName]!)
    }
}

class DNDTaskHandler
{
    // FILE HANDLING
    func plist() -> AnyObject
    {
        if let plist = NSKeyedUnarchiver.unarchiveObjectWithFile(plistPath()) as? Dictionary<String, AnyObject>
        {
            return plist
        } else {
            return Dictionary<String, AnyObject>()
        }
    }
    
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
    
    
    // FOLDER STUFF

    func selectFolderNamed(name: String)
    {
        println("SELECT FOLDER NAMED \(name)")
        NSUserDefaults.standardUserDefaults().setObject(name, forKey: DNDTaskHandlerKeys.CurrentFolder)
        NSUserDefaults.standardUserDefaults().synchronize()
    }
    
    func currentFolder() -> String?
    {
        println("CURRENT FOLDER")
        if let folder = NSUserDefaults.standardUserDefaults().objectForKey(DNDTaskHandlerKeys.CurrentFolder) as? String
        {
            println("YEAH: \(folder)")
            return folder
        }
        return nil
    }
    
    func createFolderNamed(name: String, select: Bool) -> Bool
    {
        println("CREATE FOLDER NAMED \(name)")

        if let myPlist = plist() as? Dictionary<String, AnyObject>
        {
            println("MY PLIST IS A DICTIONARY")
            var myDictionary = myPlist
            if myDictionary[name] == nil
            {
                println("THERE IS NO FOLDER NAMED \(name)")
                var folderDictionary = Dictionary<String, AnyObject>()
                myDictionary[name] = folderDictionary
                NSKeyedArchiver.archiveRootObject(myDictionary, toFile: plistPath())
                if select
                {
                    NSUserDefaults.standardUserDefaults().setObject(name, forKey: DNDTaskHandlerKeys.CurrentFolder)
                }
            } else {
                println("THERE ALREADY IS A FOLDER NAMED \(name)")
            }
        }
        return false
    }

    func folders() -> Array<String>?
    {
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
    func tasks() -> Array<Dictionary<String, AnyObject>>?
    {
        return nil
    }
    
    func createTaskNamed(name: String, imageName: String) -> Bool
    {
        println("CREATE TASK NAMED \(name)")
        if let folder = currentFolder()
        {
            println("LET FOLDER = CURRENT FOLDER! \(folder)")
            if let plist = plist() as? Dictionary<String, AnyObject>
            {
                var myPlist = plist
                println("LET PLIST = PLIST()")
                if let folderDict = myPlist[folder] as? Dictionary<String, AnyObject>
                {
                    println("LET FOLDERDICT = PLIST FOLDER \(folder)")
                    let nuTask = DNDTask(name: name, imageName: imageName)
                    var myFolderDict = folderDict
                    if myFolderDict[DNDTaskHandlerKeys.Tasks] == nil
                    {
                        println("FANNS INGA TASKS! SKAPAR ARRAY OCH ADDAR TASK")
                        let tasksArray = [nuTask.taskDictionary()]
                        myFolderDict[DNDTaskHandlerKeys.Tasks] = tasksArray
                    } else {
                        println("FANNS TASKS! SKAPAR ARRAY, KOPIERAR IN GAMLA TASKS OCH ADDAR TASK")
                        if let tasksArray = myFolderDict[DNDTaskHandlerKeys.Tasks] as? Array<Dictionary<String, String>>
                        {
                            var myTasksArray = tasksArray
                            myTasksArray.append(nuTask.taskDictionary())
                            myFolderDict[DNDTaskHandlerKeys.Tasks] = myTasksArray
                        }
                    }
                    myPlist[folder] = myFolderDict
                    println("MY PLIST \(myPlist)")
                    NSKeyedArchiver.archiveRootObject(myPlist, toFile: plistPath())
                    println("MY FOLDER DICT \(myFolderDict)")
                }
            }
        }
        return false
    }
    
    func removeTaskNamed(name: String) -> Bool
    {
        return false
    }
    

    
    
}