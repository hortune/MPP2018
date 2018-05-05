//
//  DetailViewController.swift
//  Airport List
//
//  Created by hortune on 2018/5/5.
//  Copyright © 2018年 hortune. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    var airportData: Airport!
    @IBOutlet weak var desc: UILabel!
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var country: UILabel!
    @IBOutlet weak var city: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        desc.text = self.airportData.name
        country.text = self.airportData.country
        city.text = self.airportData.city
        // Do any additional setup after loading the view.
        let url = "Airports Data/" + self.airportData.iata
        let path = Bundle.main.path(forResource:url, ofType: "jpg")
        image?.image = UIImage(contentsOfFile: path!)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
