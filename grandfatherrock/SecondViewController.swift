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
		
		var weather = ""
		if GlobalVars.weatherList == 0 {
			weather = "☀️ "
		} else if GlobalVars.weatherList == 1 {
			weather = "🌧 "
		} else if GlobalVars.weatherList == 2 {
			weather = "❄️ "
		}
		
		hourString = "\(weather)\(hourString)"

		cell.hourLabel?.text = hourString
		cell.accessibilityLabel = cell.hourLabel.text
		cell.accessibilityLabel?.append(". ")
		
		cell.songLabel?.text = GlobalVars.musicSelection[GlobalVars.selectedMusicList][indexPath.row]
		if ((GlobalVars.musicSelectionID[GlobalVars.selectedMusicList][indexPath.row] == 0) && (GlobalVars.musicFileURL[GlobalVars.selectedMusicList][indexPath.row] == "")){
			cell.accessoryType = .detailButton
			cell.accessibilityLabel?.append("No song set")
		} else {
			cell.accessoryType = .none
			cell.accessibilityLabel?.append(cell.songLabel.text!)
		}
		
		/*switch GlobalVars.selectedMusicList {
			case 0:
				cell.songLabel?.text = GlobalVars.musicSelection0[indexPath.row]
				if (GlobalVars.musicSelectionID0[indexPath.row] == 0){
					cell.accessoryType = .detailButton
					cell.accessibilityLabel?.append("No song set")
				} else {
					cell.accessoryType = .none
					cell.accessibilityLabel?.append(cell.songLabel.text!)
				}
			case 1:
				cell.songLabel?.text = GlobalVars.musicSelection1[indexPath.row]
				if (GlobalVars.musicSelectionID1[indexPath.row] == 0){
					cell.accessoryType = .detailButton
					cell.accessibilityLabel?.append("No song set")
				} else {
					cell.accessoryType = .none
					cell.accessibilityLabel?.append(cell.songLabel.text!)
				}
			case 2:
				cell.songLabel?.text = GlobalVars.musicSelection2[indexPath.row]
				if (GlobalVars.musicSelectionID2[indexPath.row] == 0){
					cell.accessoryType = .detailButton
					cell.accessibilityLabel?.append("No song set")
				} else {
					cell.accessoryType = .none
					cell.accessibilityLabel?.append(cell.songLabel.text!)
				}
			case 3:
				cell.songLabel?.text = GlobalVars.musicSelection3[indexPath.row]
				if (GlobalVars.musicSelectionID3[indexPath.row] == 0){
					cell.accessoryType = .detailButton
					cell.accessibilityLabel?.append("No song set")
				} else {
					cell.accessoryType = .none
					cell.accessibilityLabel?.append(cell.songLabel.text!)
				}
			case 4:
				cell.songLabel?.text = GlobalVars.musicSelection4[indexPath.row]
				if (GlobalVars.musicSelectionID4[indexPath.row] == 0){
					cell.accessoryType = .detailButton
					cell.accessibilityLabel?.append("No song set")
				} else {
					cell.accessoryType = .none
					cell.accessibilityLabel?.append(cell.songLabel.text!)
				}
			default:
				cell.songLabel?.text = "uh oh!"
				cell.accessoryType = .detailButton
				cell.accessibilityLabel?.append("No song set")
		}*/
		
		cell.accessibilityHint?.append("Press to set a song for this hour")
		
		return cell
	}
	
	func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool
	{
		return true
	}
	
	func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath){
		if editingStyle == .delete
		 {
			
			GlobalVars.musicSelection[GlobalVars.selectedMusicList][indexPath.row] = ""
			GlobalVars.musicSelectionID[GlobalVars.selectedMusicList][indexPath.row] = 0
			GlobalVars.musicFileURL[GlobalVars.selectedMusicList][indexPath.row] = ""
			GlobalVars.musicFormatType[GlobalVars.selectedMusicList][indexPath.row] = true
			
			/*switch GlobalVars.selectedMusicList {
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
			}*/
			
			hoursTable.reloadData()
			
			if ((MPMusicPlayerController.applicationMusicPlayer.playbackState == MPMusicPlaybackState.playing) && (tableHour == GlobalVars.hour)){
				musicHandler.updateMusic()
			}
		 }
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
		
		let alert = UIAlertController(title: "Where do you want to select music from?", message: "", preferredStyle: .actionSheet)
		alert.popoverPresentationController?.sourceView = self.view
		alert.popoverPresentationController?.sourceRect = CGRect(x: self.view.bounds.size.width / 2.0, y: self.view.bounds.size.height / 2.0, width: 1.0, height: 1.0)
		if (UIDevice.current.userInterfaceIdiom == .pad){
			alert.popoverPresentationController!.permittedArrowDirections = []
		}
		//shareMenu.popoverPresentationController.sourceView = self.view
		//shareMenu.popoverPresentationController.sourceRect = CGRectMake(self.view.bounds.size.width / 2.0, self.view.bounds.size.height / 2.0, 1.0, 1.0)

		alert.addAction(UIAlertAction(title: "From Music App", style: .default, handler: {_ in
			self.tableHour = indexPath.row
			self.present(self.mediaPicker, animated: true, completion: nil)
		}))
		alert.addAction(UIAlertAction(title: "From File", style: .default, handler: {_ in
			let NotificationVC = self.storyboard?.instantiateViewController(withIdentifier: "FourthViewController") as! UIViewController
			GlobalVars.selectedCell = indexPath.row
			NotificationVC.modalPresentationStyle = .fullScreen
			self.present(NotificationVC, animated: true, completion: nil)
			
		}))
		alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: {_ in
			
		}))

		self.present(alert, animated: true)
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
		/*
		GlobalVars.musicSelectionID[GlobalVars.selectedMusicList][tableHour] = mediaItemCollection.items[0].persistentID
		GlobalVars.musicSelection[GlobalVars.selectedMusicList][tableHour] = selectedSong
		*/
		GlobalVars.musicSelection[GlobalVars.selectedMusicList][tableHour] = selectedSong
		GlobalVars.musicSelectionID[GlobalVars.selectedMusicList][tableHour] = mediaItemCollection.items[0].persistentID
		GlobalVars.musicFileURL[GlobalVars.selectedMusicList][tableHour] = ""
		GlobalVars.musicFormatType[GlobalVars.selectedMusicList][tableHour] = true
		
		
		//print(GlobalVars.selectedMusicList)
		/*switch GlobalVars.selectedMusicList {
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
		}*/
		
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
	
	@IBOutlet var selectListWeatherControl: UISegmentedControl!
	
	@IBAction func selectListControlChanged(_ sender: Any) {
		
		MPMusicPlayerController.applicationMusicPlayer.stop()
		audioPlayer.stop()
		musicPlayer.stop()
		var list = selectListControl.selectedSegmentIndex
		if selectListWeatherControl.selectedSegmentIndex == 0 {
			let backImg: UIImage = UIImage(named: "grass")!
			self.tabBarController?.tabBar.backgroundImage = backImg
			self.tabBarController?.tabBar.tintColor = UIColor(red: 0.86, green: 0.69, blue: 0.24, alpha: 1.00)
			removeAllEffects()
		} else if selectListWeatherControl.selectedSegmentIndex == 1 {
			list = list + 5
			let backImg: UIImage = UIImage(named: "grass")!
			self.tabBarController?.tabBar.backgroundImage = backImg
			self.tabBarController?.tabBar.tintColor = UIColor(red: 0.86, green: 0.69, blue: 0.24, alpha: 1.00)
			showRain()
		} else if selectListWeatherControl.selectedSegmentIndex == 2 {
			list = list + 10
			let backImg: UIImage = UIImage(named: "grasssnow")!
			self.tabBarController?.tabBar.backgroundImage = backImg
			self.tabBarController?.tabBar.tintColor = UIColor(red: 0.12, green: 0.54, blue: 0.61, alpha: 1.00)
			showSnowflakes()
		}
		
		GlobalVars.selectedMusicList = list
		GlobalVars.weatherList = selectListWeatherControl.selectedSegmentIndex
		
		print("selected playlist is \(list)")
		
		print("saving savedSelectedList to \(selectListControl.selectedSegmentIndex)")
		defaults.set(selectListControl.selectedSegmentIndex, forKey: "savedSelectedList")
		print("saving savedSelectedMusicList to \(selectListControl.selectedSegmentIndex)")
		defaults.set(selectListControl.selectedSegmentIndex, forKey: "savedSelectedMusicList")
		print("saving savedWeatherList to \(selectListWeatherControl.selectedSegmentIndex)")
		defaults.set(selectListWeatherControl.selectedSegmentIndex, forKey: "savedWeatherList")
		//print(GlobalVars.selectedMusicList)
		hoursTable.reloadData()
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
		
		hoursTable.reloadData()
		
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
		
		print("list is supposed to be \(GlobalVars.selectedList) in home screen")
		print("weather list is supposed to be \(GlobalVars.weatherList) in music screen")
		selectListWeatherControl.selectedSegmentIndex = GlobalVars.weatherList
		if GlobalVars.weatherList == 0 {
			let backImg: UIImage = UIImage(named: "grass")!
			self.tabBarController?.tabBar.backgroundImage = backImg
			self.tabBarController?.tabBar.tintColor = UIColor(red: 0.86, green: 0.69, blue: 0.24, alpha: 1.00)
			removeAllEffects()
		} else if GlobalVars.weatherList == 1 {
			let backImg: UIImage = UIImage(named: "grass")!
			self.tabBarController?.tabBar.backgroundImage = backImg
			self.tabBarController?.tabBar.tintColor = UIColor(red: 0.86, green: 0.69, blue: 0.24, alpha: 1.00)
			showRain()
		} else if GlobalVars.weatherList == 2 {
			let backImg: UIImage = UIImage(named: "grasssnow")!
			self.tabBarController?.tabBar.backgroundImage = backImg
			self.tabBarController?.tabBar.tintColor = UIColor(red: 0.12, green: 0.54, blue: 0.61, alpha: 1.00)
			showSnowflakes()
		}
	}
	
	override func viewWillDisappear(_ animated: Bool) {
		do {try defaults.setObject(GlobalVars.musicSelection, forKey: "savedMusicSelection")} catch {/*print(error.localizedDescription)*/}
		do {try defaults.setObject(GlobalVars.musicSelectionID, forKey: "savedMusicSelectionID")} catch {/*print(error.localizedDescription)*/}
		do {try defaults.setObject(GlobalVars.musicFileURL, forKey: "savedMusicFileURL")} catch {/*print(error.localizedDescription)*/}
		do {try defaults.setObject(GlobalVars.musicFormatType, forKey: "savedMusicFileType")} catch {/*print(error.localizedDescription)*/}
		do {try defaults.setObject(GlobalVars.weatherList, forKey: "savedWeatherList")} catch {/*print(error.localizedDescription)*/}
	}
	
	override func viewDidDisappear(_ animated: Bool) {
		gradientView.layer.sublayers?.forEach { $0.removeFromSuperlayer() }
	}

	@IBAction func visitWebsite(_ sender: Any) {
		
		let NotificationVC = self.storyboard?.instantiateViewController(withIdentifier: "ThirdViewController") as! UIViewController

		self.present(NotificationVC, animated: true, completion: nil)
		
	}
	
	@objc func showSnowflakes() {
		self.removeEffects()
		self.addSnowflakes()
	}
	
	@objc func showRain() {
		self.removeEffects()
		self.addRain()
	}
	
	@objc func removeAllEffects() {
		self.removeEffects()
	}
	
}

