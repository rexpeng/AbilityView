//
//  ViewController.swift
//  AbilityView
//
//  Created by Rex Peng on 2019/10/4.
//  Copyright © 2019 Rex Peng. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        configureAbilityView()
    }

    func configureAbilityView() {
        let abilityview = AbilityView(frame: CGRect(x: UIScreen.main.bounds.width * 0.5 - 75, y: 150, width: 150, height: 450), pointCount: 7)
        view.addSubview(abilityview)
        abilityview.setValuesName(strings: ["項目一", "項目二", "項目三", "項目四", "項目五", "項目六"])
        abilityview.setValues(values: [0.8, 0.2, 0.74, 0.3, 0.55, 0.68])
        abilityview.strokeColor = UIColor(red: 130/255, green: 130/255, blue: 130/255, alpha: 0.4)
        abilityview.textColor = UIColor.black
    }

}

