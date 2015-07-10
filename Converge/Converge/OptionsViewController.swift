//
//  OptionsViewController.swift
//  Converge
//
//  Created by Andrew Perrault on 2015-06-23.
//  Copyright (c) 2015 Andrew Perrault. All rights reserved.
//

import UIKit

class OptionsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func sfxToggle(toggle: UISwitch) {
        if toggle.on {
            Audio.instance().sfxOn()
        } else {
            Audio.instance().sfxOff()
        }
    }
    
    @IBAction func musicToggle(toggle: UISwitch) {
        if toggle.on {
            Audio.instance().musicOn()
        } else {
            Audio.instance().musicOff()
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
