//
//  AISelectViewController.swift
//  Converge
//
//  Created by Andrew Perrault on 2015-07-07.
//  Copyright (c) 2015 Andrew Perrault. All rights reserved.
//

import UIKit

class AISelectViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        //if segue.description == "toMainMenu" {
        //    return
        //}
        
        if var dest = segue.destinationViewController as? GameViewController {
            switch segue.identifier! {
            case "potatoSegue":
                dest.setAI(AI_TYPE.POTATO)
            case "easySegue":
                dest.setAI(AI_TYPE.EASY)
            case "mediumSegue":
                dest.setAI(AI_TYPE.MED)
            case "hardSegue":
                dest.setAI(AI_TYPE.HARD)
            default:
                println("segue button failed")
            }
        }
    }
}
