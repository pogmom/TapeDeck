//
//  SecondViewController.swift
//  grandfatherrock
//
//  Created by Micah Gomez on 4/15/20.
//  Copyright © 2020 Micah Gomez. All rights reserved.
//

import UIKit
import MediaPlayer

class hourDataCell : UITableViewCell {
	
	@IBOutlet weak var hourLabel: UILabel!
	@IBOutlet weak var songLabel : UILabel!
	
}

class SecondViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, MPMediaPickerControllerDelegate {
	
	var selectedSong: String = ""
	var tableHour: Int = 0
	let mediaPicker = MPMediaPickerController(mediaTypes: MPMediaType.music)
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return 24
	}
	
	func tableView(_ tableView: UITableView,
							accessoryButtonTappedForRowWith indexPath: IndexPath){
		let errorAlert = UIAlertController(title: "Song Error", message: "This song doesn't seem to be available. Please make sure that you've properly selected a song and that it is in your music library.", preferredStyle: .alert)
				
				// Create OK button
				let OKAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction!) in
					
					let helpAlert = UIAlertController(title: "Need Help Importing Music?", message: "A tutorial is available to help with importing music to use with this app. Would you like to view it?", preferredStyle: .alert)
							
							// Create OK button
					let HelpAction = UIAlertAction(title: "Yes Please!", style: .default) { (action:UIAlertAction!) in
						if let url = URL(string: "https://youtu.be/YtOC5YFCt7E") {
							UIApplication.shared.open(url)
						}
					}
					helpAlert.addAction(HelpAction)
					let NoHelpAction = UIAlertAction(title: "No Thanks", style: .default) { (action:UIAlertAction!) in
							  //print("Ok button tapped");
					}
					helpAlert.addAction(NoHelpAction)
							
							// Present Dialog message
					self.present(helpAlert, animated: true, completion:nil)
					
				}
				errorAlert.addAction(OKAction)
				
				// Present Dialog message
				self.present(errorAlert, animated: true, completion:nil)
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "hourcell", for: indexPath) as! hourDataCell
		
		var rowHour:Int = 12
		var hourString = String(rowHour)
		hourString.append(" AM")

		if (indexPath.row < 12) && (indexPath.row > 0) {
			rowHour = indexPath.row
			hourString = String(rowHour)
			hourString.append(" AM")
		} else if (indexPath.row > 11) {
			rowHour = indexPath.row
			if (indexPath.row > 12){
				rowHour = rowHour - 12
			}
			hourString = String(rowHour)
			hourString.append(" PM")
		}

		cell.hourLabel?.text = hourString
		
		switch GlobalVars.selectedMusicList {
			case 0:
				cell.songLabel?.text = GlobalVars.musicSelection0[indexPath.row]
				if (GlobalVars.musicSelectionID0[indexPath.row] == 0){
					cell.accessoryType = .detailButton
				} else {
					cell.accessoryType = .none
				}
			case 1:
				cell.songLabel?.text = GlobalVars.musicSelection1[indexPath.row]
				if (GlobalVars.musicSelectionID1[indexPath.row] == 0){
					cell.accessoryType = .detailButton
				} else {
					cell.accessoryType = .none
				}
			case 2:
				cell.songLabel?.text = GlobalVars.musicSelection2[indexPath.row]
				if (GlobalVars.musicSelectionID2[indexPath.row] == 0){
					cell.accessoryType = .detailButton
				} else {
					cell.accessoryType = .none
				}
			case 3:
				cell.songLabel?.text = GlobalVars.musicSelection3[indexPath.row]
				if (GlobalVars.musicSelectionID3[indexPath.row] == 0){
					cell.accessoryType = .detailButton
				} else {
					cell.accessoryType = .none
				}
			case 4:
				cell.songLabel?.text = GlobalVars.musicSelection4[indexPath.row]
				if (GlobalVars.musicSelectionID4[indexPath.row] == 0){
					cell.accessoryType = .detailButton
				} else {
					cell.accessoryType = .none
				}
			default:
				cell.songLabel?.text = "uh oh!"
				cell.accessoryType = .detailButton
		}
		
		return cell
	}
	
	func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool
	{
		return true
	}
	
	func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath){
		if editingStyle == .delete
		 {
			switch GlobalVars.selectedMusicList {
				case 0:
					GlobalVars.musicSelection0[indexPath.row] = ""
					GlobalVars.musicSelectionID0[indexPath.row] = 0
				case 1:
					GlobalVars.musicSelection1[indexPath.row] = ""
					GlobalVars.musicSelectionID1[indexPath.row] = 0
				case 2:
					GlobalVars.musicSelection2[indexPath.row] = ""
					GlobalVars.musicSelectionID2[indexPath.row] = 0
				case 3:
					GlobalVars.musicSelection3[indexPath.row] = ""
					GlobalVars.musicSelectionID3[indexPath.row] = 0
				case 4:
					GlobalVars.musicSelection4[indexPath.row] = ""
					GlobalVars.musicSelectionID4[indexPath.row] = 0
				default:
					GlobalVars.musicSelection0[indexPath.row] = ""
					GlobalVars.musicSelectionID0[indexPath.row] = 0
			}
			
			hoursTable.reloadData()
			
			if ((MPMusicPlayerController.applicationMusicPlayer.playbackState == MPMusicPlaybackState.playing) && (tableHour == GlobalVars.hour)){
				musicHandler.updateMusic()
			}
		 }
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
		
		//let mediaPicker = MPMediaPickerController(mediaTypes: MPMediaType.music)
		tableHour = indexPath.row
		//print(tableHour)
		present(mediaPicker, animated: true, completion: nil)
		/*if (selectedSong != "") {
			GlobalVars.musicSelection[indexPath.row] = selectedSong
			selectedSong = ""
		}
		self.hoursTable.reloadData()*/
	}
	
	
	let defaults = UserDefaults.standard
	
	
	/*func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
		
        return type.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return type[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        //print(type[row])
		//print(row)
		defaults.set(type[row], forKey: "selectedTitle")
		defaults.set(row, forKey: "titleNo")
		GlobalVars.selectedGame = type[row]
		GlobalVars.selectedGameNo = row
		GlobalVars.titleName = type[row]
		musicHandler.updateMusic()
		nowPlaying.text = GlobalVars.titleName! + " - " + String(GlobalVars.hour)
    }
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }*/
	
	func mediaPicker(_ mediaPicker: MPMediaPickerController, didPickMediaItems mediaItemCollection: MPMediaItemCollection){
		//let musicPlayer = MPMusicPlayerController.applicationMusicPlayer
		
		//musicPlayer.setQueue(with: mediaItemCollection)
		////print(mediaItemCollection)
		//musicPlayer.play()
		//print("selected song")
		selectedSong = String(mediaItemCollection.items[0].title ?? "NOTHING")
		//print(selectedSong)
		
		//print(GlobalVars.selectedMusicList)
		switch GlobalVars.selectedMusicList {
			case 0:
				GlobalVars.musicSelectionID0[tableHour] = mediaItemCollection.items[0].persistentID
				GlobalVars.musicSelection0[tableHour] = selectedSong
			case 1:
				GlobalVars.musicSelectionID1[tableHour] = mediaItemCollection.items[0].persistentID
				GlobalVars.musicSelection1[tableHour] = selectedSong
			case 2:
				GlobalVars.musicSelectionID2[tableHour] = mediaItemCollection.items[0].persistentID
				GlobalVars.musicSelection2[tableHour] = selectedSong
			case 3:
				GlobalVars.musicSelectionID3[tableHour] = mediaItemCollection.items[0].persistentID
				GlobalVars.musicSelection3[tableHour] = selectedSong
			case 4:
				GlobalVars.musicSelectionID4[tableHour] = mediaItemCollection.items[0].persistentID
				GlobalVars.musicSelection4[tableHour] = selectedSong
			default:
				GlobalVars.musicSelectionID0[tableHour] = mediaItemCollection.items[0].persistentID
				GlobalVars.musicSelection0[tableHour] = selectedSong
		}
		
		//GlobalVars.musicSelectionID1[tableHour] = mediaItemCollection.items[0].persistentID
		//GlobalVars.musicSelection1[tableHour] = selectedSong
		
		if ((MPMusicPlayerController.applicationMusicPlayer.playbackState == MPMusicPlaybackState.playing) && (tableHour == GlobalVars.hour)){
			musicHandler.updateMusic()
		}
		
		hoursTable.reloadData()
		dismiss(animated: true, completion: nil)
	}
	
	func mediaPickerDidCancel(_ mediaPicker: MPMediaPickerController) {
			dismiss(animated: true, completion: nil)
			hoursTable.reloadData()
		}
	
	@IBOutlet var hoursTable: UITableView!
	
	@IBOutlet var gradientView: UIView!
	
	@IBOutlet var selectListControl: UISegmentedControl!
	
	@IBAction func selectListControlChanged(_ sender: Any) {
		
		MPMusicPlayerController.applicationMusicPlayer.stop()
		
		GlobalVars.selectedMusicList = selectListControl.selectedSegmentIndex
		//print(GlobalVars.selectedMusicList)
		hoursTable.reloadData()
		/*var noSongs = false
		switch GlobalVars.selectedMusicList {
			case 0:
				for i in GlobalVars.musicSelectionID0 {
					if (i == 0){
						noSongs = true
					}
				}
			case 1:
				for i in GlobalVars.musicSelectionID1 {
					if (i == 0){
						noSongs = true
					}
				}
			case 2:
				for i in GlobalVars.musicSelectionID2 {
					if (i == 0){
						noSongs = true
					}
				}
			case 3:
				for i in GlobalVars.musicSelectionID3 {
					if (i == 0){
						noSongs = true
					}
				}
			case 4:
				for i in GlobalVars.musicSelectionID4 {
					if (i == 0){
						noSongs = true
					}
				}
			default:
				for i in GlobalVars.musicSelectionID0 {
					if (i == 0){
						noSongs = true
					}
				}
		}
		
		if noSongs {
			MPMusicPlayerController.applicationMusicPlayer.pause()
			//print("pausing")
		}*/
		
		musicHandler.updateMusic()
		//print("updating")
	}
	
	
	
	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view.
		
		// TODO REQUEST PERMISSION FIRST
		
		mediaPicker.delegate = self
		mediaPicker.allowsPickingMultipleItems = false
		
		//present(mediaPicker, animated: true, completion: nil)
		//selectedSong = ""
		
		//pickerView.selectRow(2, inComponent: 0, animated: true)
		//pickerView.dataSource = self
        //pickerView.delegate = self
		hoursTable.delegate = self
		hoursTable.dataSource = self
		
		selectListControl.selectedSegmentIndex = GlobalVars.selectedMusicList
		
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

		/*let gradientChangeAnimation = CABasicAnimation(keyPath: "colors")
		gradientChangeAnimation.duration = 5.0
		if((GlobalVars.hour >= 8) && (GlobalVars.hour <= 19)){ //Daytime
			//print("day")
			gradientChangeAnimation.toValue = [UIColor(red: 0.00, green: 0.31, blue: 0.59, alpha: 1).cgColor, UIColor(red: 0.07, green: 0.45, blue: 0.87, alpha: 1).cgColor]
		} else if((GlobalVars.hour >= 20) && (GlobalVars.hour <= 21)){//Sunset
			//print("sunset")
			gradientChangeAnimation.toValue = [UIColor(red: 0.00, green: 0.31, blue: 0.59, alpha: 1).cgColor, UIColor(red: 1.00, green: 0.61, blue: 0.43, alpha: 1).cgColor]
		} else if((GlobalVars.hour >= 22) || (GlobalVars.hour <= 5)){//Night
			//print("night")
			gradientChangeAnimation.toValue = [
				UIColor(red: 0.68, green: 0.67, blue: 1.0, alpha: 1).cgColor,
				UIColor(red: 1.00, green: 0.00, blue: 0.09, alpha: 1).cgColor
			]
		} else if((GlobalVars.hour >= 6) && (GlobalVars.hour <= 7)){//Sunrise
			//print("sunrise")
			gradientChangeAnimation.toValue = [UIColor(red: 0.02, green: 0.26, blue: 0.49, alpha: 1).cgColor, UIColor(red: 0.89, green: 0.68, blue: 0.60, alpha: 1).cgColor]
		}
		gradientChangeAnimation.autoreverses = true
		gradientChangeAnimation.fillMode = CAMediaTimingFillMode.forwards
		gradientChangeAnimation.isRemovedOnCompletion = false
		gradient.add(gradientChangeAnimation, forKey: "colorChange")
		*/
		// add the gradient to the view
		gradientView.layer.addSublayer(gradient)
		
		switch GlobalVars.selectedMusicList {
			case 0:
				//print(GlobalVars.musicSelectionID0)
				print(GlobalVars.musicSelection0)
			case 1:
				//print(GlobalVars.musicSelectionID1)
				print(GlobalVars.musicSelection1)
			case 2:
				//print(GlobalVars.musicSelectionID2)
				print(GlobalVars.musicSelection2)
			case 3:
				//print(GlobalVars.musicSelectionID3)
				print(GlobalVars.musicSelection3)
			case 4:
				//print(GlobalVars.musicSelectionID4)
				print(GlobalVars.musicSelection4)
			default:
				//print(GlobalVars.musicSelectionID0)
				print(GlobalVars.musicSelection0)
		}
	}
	
	override func viewWillDisappear(_ animated: Bool) {
		do {
			try defaults.setObject(GlobalVars.musicSelection0, forKey: "savedMusicSelection0")
		} catch {
			//print(error.localizedDescription)
		}
		do {
			try defaults.setObject(GlobalVars.musicSelectionID0, forKey: "savedMusicSelectionID0")
		} catch {
			//print(error.localizedDescription)
		}
		do {
			try defaults.setObject(GlobalVars.musicSelection1, forKey: "savedMusicSelection1")
		} catch {
			//print(error.localizedDescription)
		}
		do {
			try defaults.setObject(GlobalVars.musicSelectionID1, forKey: "savedMusicSelectionID1")
		} catch {
			//print(error.localizedDescription)
		}
		do {
			try defaults.setObject(GlobalVars.musicSelection2, forKey: "savedMusicSelection2")
		} catch {
			//print(error.localizedDescription)
		}
		do {
			try defaults.setObject(GlobalVars.musicSelectionID2, forKey: "savedMusicSelectionID2")
		} catch {
			//print(error.localizedDescription)
		}
		do {
			try defaults.setObject(GlobalVars.musicSelection3, forKey: "savedMusicSelection3")
		} catch {
			//print(error.localizedDescription)
		}
		do {
			try defaults.setObject(GlobalVars.musicSelectionID3, forKey: "savedMusicSelectionID3")
		} catch {
			//print(error.localizedDescription)
		}
		do {
			try defaults.setObject(GlobalVars.musicSelection4, forKey: "savedMusicSelection4")
		} catch {
			//print(error.localizedDescription)
		}
		do {
			try defaults.setObject(GlobalVars.musicSelectionID4, forKey: "savedMusicSelectionID4")
		} catch {
			//print(error.localizedDescription)
		}
		
		do {
			try defaults.setObject(GlobalVars.selectedMusicList, forKey: "savedSelectedMusicList")
		} catch {
			//print(error.localizedDescription)
		}
	}
	
	override func viewDidDisappear(_ animated: Bool) {
		gradientView.layer.sublayers?.forEach { $0.removeFromSuperlayer() }
	}

	@IBAction func visitWebsite(_ sender: Any) {
		
		let NotificationVC = self.storyboard?.instantiateViewController(withIdentifier: "ThirdViewController") as! UIViewController

		self.present(NotificationVC, animated: true, completion: nil)
		
	}
	
	
}

