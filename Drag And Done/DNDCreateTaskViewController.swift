//
//  DNDCreateTaskViewController.swift
//  Drag And Done
//
//  Created by Ricardo Gonzalez on 2015-03-21.
//  Copyright (c) 2015 FreakoSoft. All rights reserved.
//

import UIKit

class DNDCreateTaskViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    let taskHandler = DNDTaskHandler()
    var image:UIImage?

    @IBOutlet weak var textFiled: UITextField!
    @IBOutlet weak var picButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func takePicture(sender: UIButton) {
        println("TAKE PICTURE")
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        picker.sourceType = UIImagePickerControllerSourceType.Camera
        self.presentViewController(picker, animated: true, completion: nil)
    }

    @IBAction func done(sender: UIBarButtonItem) {
        let docDir = taskHandler.docDir()
        let now = NSDate()
        var formatter = NSDateFormatter()
        formatter.dateFormat = "yyMMdd-HHmmss"
        let stringFromDate = formatter.stringFromDate(now)
        let fileName = stringFromDate + "-\(arc4random_uniform(10000)).png"
        let picPath = docDir.stringByAppendingPathComponent(fileName)
        if let saveImage = self.image as UIImage?
        {
            UIImagePNGRepresentation(saveImage).writeToFile(picPath, atomically: true)
        }
        taskHandler.createTaskNamed(textFiled.text, imageName: fileName)
    }
    
    
    func imagePickerController(picker: UIImagePickerController!, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
        self.image = image!
        self.picButton.setImage(image!, forState: UIControlState.Normal)
        picker.dismissViewControllerAnimated(true, completion: nil)
    }

}
