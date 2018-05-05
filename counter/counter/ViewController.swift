//
//  ViewController.swift
//  counter
//
//  Created by hortune on 2018/4/11.
//  Copyright © 2018年 hortune. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var countLabel: UILabel!
    
    @IBOutlet var buttons: [UIButton]!
    var currentCount:Int = 0 {
        // Event Driven
        didSet{
            if self.currentCount < 0 {
                self.currentCount = 0
            } else {
                updateLabel()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        for button in self.buttons {
            button.layer.borderColor = button.tintColor.cgColor
            button.layer.borderWidth = 2.0
            button.layer.cornerRadius = 10
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func updateLabel(animated: Bool = true){
        if animated{
            self.countLabel.alpha = 0
            UIView.animate(withDuration: 2, animations : {
                self.countLabel.alpha = 1
                self.countLabel.text = "\(self.currentCount)"
            }){(completed:Bool) in }
        } else{
            self.countLabel.text = "\(currentCount)"
        }
    }

    @IBAction func increaseCounter(_ sender: UIButton) {
        currentCount += 1
    }
    @IBAction func decreaseCounter(_ sender: UIButton) {
        currentCount -= 1
    }
    @IBAction func resetCounter(_ sender: UIButton) {
        currentCount = 0
    }
}

