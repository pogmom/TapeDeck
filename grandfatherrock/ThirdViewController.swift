//
//  SecondViewController.swift
//  grandfatherrock
//
//  Created by Micah Gomez on 4/15/20.
//  Copyright © 2020 Micah Gomez. All rights reserved.
//

import UIKit
import MediaPlayer

class ThirdViewController: UIViewController {
	
	@IBAction func websiteButton(_ sender: Any) {
		if let url = URL(string: "https://micahpgomez.dev") {
			UIApplication.shared.open(url)
		}
	}
	
	@IBAction func supportEmail(_ sender: Any) {
		if let url = URL(string: "mailto:support@micahpgomez.dev") {
			UIApplication.shared.open(url)
		}
	}
	
	@IBAction func smallTipButton(_ sender: Any) {
		IAPHandler.shared.purchaseMyProduct(index: 0)
	}
	
	@IBAction func mediumTipButton(_ sender: Any) {
		IAPHandler.shared.purchaseMyProduct(index: 1)
	}
	
	@IBAction func largeTipButton(_ sender: Any) {
		IAPHandler.shared.purchaseMyProduct(index: 2)
	}
	
	let defaults = UserDefaults.standard
	
	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view.
		//print("view loaded!")
		
	}
	
	
	
}

