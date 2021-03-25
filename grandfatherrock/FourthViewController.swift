//
//  SecondViewController.swift
//  grandfatherrock
//
//  Created by Micah Gomez on 4/15/20.
//  Copyright © 2020 Micah Gomez. All rights reserved.
//

import UIKit
import AudioToolbox


class FourthViewController: UIViewController, UIPickerViewDelegate{
	
	@IBOutlet var gradientView: UIView!
	
	let defaults = UserDefaults.standard
	
	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view.
		
		/*let message = "\n\n\n\n\n\n"
		let alert = UIAlertController(title: "Please Select Note", message: message, preferredStyle: UIAlertController.Style.actionSheet)
		alert.isModalInPopover = true
		 
		let pickerFrame = UIPickerView(frame: CGRect(x: 5, y: 20, width: 400 - 20, height: 140)) // CGRectMake(left, top, width, height) - left and top are like margins
		pickerFrame.tag = 555
		//set the pickers datasource and delegate
		pickerFrame.delegate = self
		 
		//Add the picker to the alert controller
		alert.view.addSubview(pickerFrame)
		let okAction = UIAlertAction(title: "OK", style: .default, handler: {
			(alert: UIAlertAction!) -> Void in
		  //Perform Action
		})
		alert.addAction(okAction)
		let cancelAction = UIAlertAction(title: "Cancel", style: .destructive, handler: nil)
		alert.addAction(cancelAction)
		self.parent!.present(alert, animated: true, completion: {  })
		*/
	}
	
	override func viewWillAppear(_ animated: Bool) {
		
		let prevHour = GlobalVars.hour
		GlobalVars.hour = Calendar.current.component(.hour, from: Date())
		if GlobalVars.hour != prevHour {
			musicHandler.updateMusic()
		}
		
		// create the gradient layer
		let gradient = CAGradientLayer()
		gradient.frame = self.view.bounds
		//print("time: ", GlobalVars.hour)
		if((GlobalVars.hour >= 8) && (GlobalVars.hour <= 19)){ //Daytime
			//print("day")
			gradient.colors = [UIColor(red: 0.39, green: 0.69, blue: 1.00, alpha: 1).cgColor, UIColor(red: 0.07, green: 0.45, blue: 0.87, alpha: 1).cgColor]
		} else if((GlobalVars.hour >= 20) && (GlobalVars.hour <= 21)){//Sunset
			//print("sunset")
			gradient.colors = [UIColor(red: 0.00, green: 0.31, blue: 0.59, alpha: 1).cgColor, UIColor(red: 1.00, green: 0.78, blue: 0.88, alpha: 1).cgColor]
		} else if((GlobalVars.hour >= 22) || (GlobalVars.hour <= 5)){//Night
			//print("night")
			gradient.colors = [UIColor(red: 0.08, green: 0.27, blue: 0.59, alpha: 1).cgColor, UIColor(red: 0.00, green: 0.20, blue: 0.29, alpha: 1).cgColor]
		} else if((GlobalVars.hour >= 6) && (GlobalVars.hour <= 7)){//Sunrise
			//print("sunrise")
			gradient.colors = [UIColor(red: 0.02, green: 0.26, blue: 0.49, alpha: 1).cgColor, UIColor(red: 0.89, green: 0.68, blue: 0.60, alpha: 1).cgColor]
		}
		
		gradient.locations =  [0.00, 1.00]
		
		gradientView.layer.addSublayer(gradient)
		
		/// Create a sequence
		var sequence : MusicSequence? = nil
		var musicSequenceStatus = NewMusicSequence(&sequence)
		var track : MusicTrack? = nil
		/// Create a music track containg a sequence and a music track
		var musicTrack = MusicSequenceNewTrack(sequence!, &track)
		var time = MusicTimeStamp(1.0)


		// The notes of the song
		var notes: [UInt8] = [50,47,48,50/*,128*/,40,48,/*128,*/47,43,45,47/*,128*/,38,45]

		for index:Int in 0...11 {
			var note = MIDINoteMessage(channel: 0,
									   note: notes[index],
									   velocity: 64,
									   releaseVelocity: 0,
									   duration: 1.0)
			guard let track = track else {fatalError()}
			musicTrack = MusicTrackNewMIDINoteEvent(track, time, &note)
			time += 1
		}


		// Creating a player
		var musicNotePlayer : MusicPlayer? = nil
		var player = NewMusicPlayer(&musicNotePlayer)

		player = MusicPlayerSetSequence(musicNotePlayer!, sequence)
		player = MusicPlayerStart(musicNotePlayer!)
	}
	
	override func viewDidDisappear(_ animated: Bool) {
		gradientView.layer.sublayers?.forEach { $0.removeFromSuperlayer() }
	}
	
	
}

