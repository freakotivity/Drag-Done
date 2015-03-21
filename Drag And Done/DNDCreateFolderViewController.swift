//
//  DNDCreateFolderViewController.swift
//  Drag And Done
//
//  Created by Ricardo Gonzalez on 2015-03-20.
//  Copyright (c) 2015 FreakoSoft. All rights reserved.
//

import UIKit

class DNDCreateFolderViewController: UIViewController {
    let taskHandler = DNDTaskHandler()

    @IBOutlet weak var textField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        textField?.becomeFirstResponder()
    }
    
    @IBAction func Done(sender: UIBarButtonItem) {
        taskHandler.createFolderNamed(textField.text, select: true, overwrite: true)
        self.navigationController?.popViewControllerAnimated(true)
    }
}
