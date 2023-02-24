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
		if let url = URL(string: "https://pogmom.me") {
			UIApplication.shared.open(url)
		}
	}
	
	@IBAction func privacyButton(_ sender: Any) {
	if let url = URL(string: "https://pogmom.me/Privacy.html") {
		UIApplication.shared.open(url)
	}
	}
	
	@IBAction func supportEmail(_ sender: Any) {
		if let url = URL(string: "mailto:support@pogmom.me") {
			UIApplication.shared.open(url)
		}
	}
	
	@IBAction func smallTipButton(_ sender: Any) {
		IAPHandler.shared.purchaseMyProduct(index: 2)
	}
	
	@IBAction func mediumTipButton(_ sender: Any) {
		IAPHandler.shared.purchaseMyProduct(index: 1)
	}
	
	@IBAction func largeTipButton(_ sender: Any) {
		IAPHandler.shared.purchaseMyProduct(index: 0)
	}
	
	@IBAction func dismiss(_ sender: Any) {
		dismiss(animated: true)
	}
	
	let defaults = UserDefaults.standard
	
	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view.
		//print("view loaded!")
		IAPHandler.shared.fetchAvailableProducts()
		
		IAPHandler.shared.purchaseStatusBlock = {[weak self] (type) in
			guard let strongSelf = self else{ return }
			if type == .purchased {
				let alertView = UIAlertController(title: type.title(), message: type.message(), preferredStyle: .alert)
				let action = UIAlertAction(title: "OK", style: .default, handler: { (alert) in
					
				})
				alertView.addAction(action)
				strongSelf.present(alertView, animated: true, completion: nil)
			}
		}
	}
	
	
	
}

