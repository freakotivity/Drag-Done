//
//  DNDColors.swift
//  Drag And Done
//
//  Created by Ricardo Gonzalez on 2015-02-28.
//  Copyright (c) 2015 FreakoSoft. All rights reserved.
//

import UIKit

class RainbowColors: UIView {
    let chooseRedColor: () = FreakoColors.drawFreakoRedCircle()
    let chooseOrangeColor: () = FreakoColors.drawFreakoOrangeCircle()
    let chooseYellowColor: () = FreakoColors.drawFreakoYellowCircle()
    let chooseGreenColor: () = FreakoColors.drawFreakoGreenCircle()
    let chooseBlueColor: () = FreakoColors.drawFreakoBlueCircle()
    let chooseDarkblueColor: () = FreakoColors.drawFreakoDarkBlueCircle()
    let chooseVioletColor: () = FreakoColors.drawFreakoVioletCircle()
}

struct DNDColors {
//    static var freakoGreen: UIColor = UIColor(red: 0.102, green: 0.706, blue: 0.267, alpha: 1.000)
//    static var freakoDarkBlue: UIColor = UIColor(red: 0.227, green: 0.286, blue: 0.706, alpha: 1.000)
//    static var freakoViolet: UIColor = UIColor(red: 0.533, green: 0.251, blue: 0.655, alpha: 1.000)
//    static var freakoBlue: UIColor = UIColor(red: 0.169, green: 0.518, blue: 0.827, alpha: 1.000)
//    static var freakoOrange: UIColor = UIColor(red: 0.973, green: 0.580, blue: 0.024, alpha: 1.000)
//    static var freakoRed: UIColor = UIColor(red: 0.886, green: 0.231, blue: 0.149, alpha: 1.000)
//    static var freakoYellow: UIColor = UIColor(red: 0.953, green: 0.792, blue: 0.153, alpha: 1.000)

    static var freakoGreen: UIColor = UIColor(red: 0.149, green: 0.651, blue: 0.357, alpha: 1.000)
    static var freakoDarkBlue: UIColor = UIColor(red: 0.227, green: 0.286, blue: 0.706, alpha: 1.000)
    static var freakoViolet: UIColor = UIColor(red: 0.533, green: 0.251, blue: 0.655, alpha: 1.000)
    static var freakoBlue: UIColor = UIColor(red: 0.169, green: 0.518, blue: 0.827, alpha: 1.000)
    static var freakoOrange: UIColor = UIColor(red: 0.973, green: 0.580, blue: 0.024, alpha: 1.000)
    static var freakoRed: UIColor = UIColor(red: 0.886, green: 0.231, blue: 0.149, alpha: 1.000)
    static var freakoYellow: UIColor = UIColor(red: 0.953, green: 0.792, blue: 0.153, alpha: 1.000)
    static var menuSpaceGray: UIColor = UIColor(red: 0.941, green: 0.941, blue: 0.941, alpha: 1.000)

    static var allColorStrings = ["freakoGreen", "freakoDarkBlue", "freakoViolet", "freakoBlue", "freakoOrange", "freakoRed", "freakoYellow"]
    
    static func colorFromString(colorString: String) -> UIColor
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
}