//
//  FirstViewController.swift
//  grandfatherrock
//
//  Created by Micah Gomez on 4/15/20.
//  Copyright © 2020 Micah Gomez. All rights reserved.
//

import UIKit
import AVFoundation
import MediaPlayer
import StoreKit
import SwiftyGif

protocol ObjectSavable {
	func setObject<Object>(_ object: Object, forKey: String) throws where Object: Encodable
	func getObject<Object>(forKey: String, castTo type: Object.Type) throws -> Object where Object: Decodable
}
enum ObjectSavableError: String, LocalizedError {
	case unableToEncode = "Unable to encode object into data"
	case noValue = "No data object found for the given key"
	case unableToDecode = "Unable to decode object into given type"
	
	var errorDescription: String? {
		rawValue
	}
}

extension UserDefaults: ObjectSavable {
	func setObject<Object>(_ object: Object, forKey: String) throws where Object: Encodable {
		let encoder = JSONEncoder()
		do {
			let data = try encoder.encode(object)
			set(data, forKey: forKey)
		} catch {
			throw ObjectSavableError.unableToEncode
		}
	}
	
	func getObject<Object>(forKey: String, castTo type: Object.Type) throws -> Object where Object: Decodable {
		guard let data = data(forKey: forKey) else { throw ObjectSavableError.noValue }
		let decoder = JSONDecoder()
		do {
			let object = try decoder.decode(type, from: data)
			return object
		} catch {
			throw ObjectSavableError.unableToDecode
		}
	}
}

public class musicHandler{
	@objc class func updateMusic(){
		
		timer.invalidate()
		
		//print("updating song")
		
		GlobalVars.hour = Calendar.current.component(.hour, from: Date())
		
		//song = GlobalVars.titleCode + hourPadding + String(GlobalVars.hour)
		////print(song)
		let musicPlayer = MPMusicPlayerController.applicationMusicPlayer
		
		do{
			
			var mediaPredicate = MPMediaPredicate()
			switch GlobalVars.selectedMusicList {
			case 0:
				if(GlobalVars.musicSelectionID0[GlobalVars.hour] != 0){
					mediaPredicate = MPMediaPropertyPredicate(value: GlobalVars.musicSelectionID0[GlobalVars.hour], forProperty: "persistentID")
				} else {
					var searchID:UInt64 = 0
					var searchHour:Int = GlobalVars.hour
					while (searchID == 0) {
						if(searchHour > 0){
							searchHour -= 1
						} else {
							searchHour = 23
						}
						if(searchHour == GlobalVars.hour){
							//print("no songs found!")
							break
						}
						//print("searching ", searchHour)
						searchID = GlobalVars.musicSelectionID0[searchHour]
						
						//print(searchID)
					}
					//print("Song Found!")
					mediaPredicate = MPMediaPropertyPredicate(value: GlobalVars.musicSelectionID0[searchHour], forProperty: "persistentID")
				}
			case 1:
				if(GlobalVars.musicSelectionID1[GlobalVars.hour] != 0){
					mediaPredicate = MPMediaPropertyPredicate(value: GlobalVars.musicSelectionID1[GlobalVars.hour], forProperty: "persistentID")
				} else {
					var searchID:UInt64 = 0
					var searchHour:Int = GlobalVars.hour
					while (searchID == 0) {
						if(searchHour > 0){
							searchHour -= 1
						} else {
							searchHour = 23
						}
						if(searchHour == GlobalVars.hour){
							//print("no songs found!")
							break
						}
						//print("searching ", searchHour)
						searchID = GlobalVars.musicSelectionID1[searchHour]
						
						//print(searchID)
					}
					//print("Song Found!")
					mediaPredicate = MPMediaPropertyPredicate(value: GlobalVars.musicSelectionID1[searchHour], forProperty: "persistentID")
				}
			case 2:
				if(GlobalVars.musicSelectionID2[GlobalVars.hour] != 0){
					mediaPredicate = MPMediaPropertyPredicate(value: GlobalVars.musicSelectionID2[GlobalVars.hour], forProperty: "persistentID")
				} else {
					var searchID:UInt64 = 0
					var searchHour:Int = GlobalVars.hour
					while (searchID == 0) {
						if(searchHour > 0){
							searchHour -= 1
						} else {
							searchHour = 23
						}
						if(searchHour == GlobalVars.hour){
							//print("no songs found!")
							break
						}
						//print("searching ", searchHour)
						searchID = GlobalVars.musicSelectionID2[searchHour]
						
						//print(searchID)
					}
					//print("Song Found!")
					mediaPredicate = MPMediaPropertyPredicate(value: GlobalVars.musicSelectionID2[searchHour], forProperty: "persistentID")
				}
			case 3:
				if(GlobalVars.musicSelectionID3[GlobalVars.hour] != 0){
					mediaPredicate = MPMediaPropertyPredicate(value: GlobalVars.musicSelectionID3[GlobalVars.hour], forProperty: "persistentID")
				} else {
					var searchID:UInt64 = 0
					var searchHour:Int = GlobalVars.hour
					while (searchID == 0) {
						if(searchHour > 0){
							searchHour -= 1
						} else {
							searchHour = 23
						}
						if(searchHour == GlobalVars.hour){
							//print("no songs found!")
							break
						}
						//print("searching ", searchHour)
						searchID = GlobalVars.musicSelectionID3[searchHour]
						
						//print(searchID)
					}
					//print("Song Found!")
					mediaPredicate = MPMediaPropertyPredicate(value: GlobalVars.musicSelectionID3[searchHour], forProperty: "persistentID")
				}
			case 4:
				if(GlobalVars.musicSelectionID4[GlobalVars.hour] != 0){
					mediaPredicate = MPMediaPropertyPredicate(value: GlobalVars.musicSelectionID4[GlobalVars.hour], forProperty: "persistentID")
				} else {
					var searchID:UInt64 = 0
					var searchHour:Int = GlobalVars.hour
					while (searchID == 0) {
						if(searchHour > 0){
							searchHour -= 1
						} else {
							searchHour = 23
						}
						if(searchHour == GlobalVars.hour){
							//print("no songs found!")
							break
						}
						//print("searching ", searchHour)
						searchID = GlobalVars.musicSelectionID4[searchHour]
						
						//print(searchID)
					}
					//print("Song Found!")
					mediaPredicate = MPMediaPropertyPredicate(value: GlobalVars.musicSelectionID4[searchHour], forProperty: "persistentID")
				}
			default:
				if(GlobalVars.musicSelectionID0[GlobalVars.hour] != 0){
					mediaPredicate = MPMediaPropertyPredicate(value: GlobalVars.musicSelectionID0[GlobalVars.hour], forProperty: "persistentID")
				} else {
					var searchID:UInt64 = 0
					var searchHour:Int = GlobalVars.hour
					while (searchID == 0) {
						if(searchHour > 0){
							searchHour -= 1
						} else {
							searchHour = 23
						}
						if(searchHour == GlobalVars.hour){
							//print("no songs found!")
							break
						}
						//print("searching ", searchHour)
						searchID = GlobalVars.musicSelectionID0[searchHour]
						
						//print(searchID)
					}
					//print("Song Found!")
					mediaPredicate = MPMediaPropertyPredicate(value: GlobalVars.musicSelectionID0[searchHour], forProperty: "persistentID")
				}
			}
			
			//let mediaPredicate = MPMediaPropertyPredicate(value: GlobalVars.musicSelectionID1[GlobalVars.hour], forProperty: "persistentID")
			
			let mediaQuery = MPMediaQuery()
			
			mediaQuery.addFilterPredicate(mediaPredicate)
			
			
			//let mediaItemCollection: MPMediaItemCollection = MPMediaItemCollection()
			
			musicPlayer.setQueue(with: mediaQuery)
			musicPlayer.repeatMode = .one
			//print(mediaQuery)
			//musicPlayer.play()
		}
		
		
		
		if(MPMusicPlayerController.applicationMusicPlayer.playbackState == MPMusicPlaybackState.playing){
			musicPlayer.play()
		}
		
		if(Calendar.current.component(.minute, from: Date()) == 0){
			date = Date().addingTimeInterval(3600)
		} else{
			let currentMinute = Calendar.current.component(.minute, from: Date())
			let currentSeconds = Calendar.current.component(.second, from: Date())
			let timeTillTopOfTheHour = 3600 - currentSeconds - (currentMinute * 60)
			date = Date().addingTimeInterval(TimeInterval(timeTillTopOfTheHour))
		}
		
		//print(date)
		
		timer = Timer(fireAt: date, interval: 0, target: self, selector: #selector(updateMusic), userInfo: nil, repeats: false)
		RunLoop.main.add(timer, forMode: RunLoop.Mode.common)
		
	}
}

struct GlobalVars {
	static var musicSelectionID0:[UInt64] = [UInt64]()
	static var musicSelection0:[String] = [String]()
	static var musicSelectionID1:[UInt64] = [UInt64]()
	static var musicSelection1:[String] = [String]()
	static var musicSelectionID2:[UInt64] = [UInt64]()
	static var musicSelection2:[String] = [String]()
	static var musicSelectionID3:[UInt64] = [UInt64]()
	static var musicSelection3:[String] = [String]()
	static var musicSelectionID4:[UInt64] = [UInt64]()
	static var musicSelection4:[String] = [String]()
	static var selectedMusicList:Int = 0
	static var musicStarted = false
	static var titleName = UserDefaults.standard.string(forKey: "selectedTitle")
	static var hour = Calendar.current.component(.hour, from: Date())
}

var i = 0

var date = Date()
var timer = Timer()
let currentSeconds = Calendar.current.component(.second, from: Date())
let currentMinute = Calendar.current.component(.minute, from: Date())
let timeTillTopOfTheHour = 3600 - currentSeconds - (currentMinute * 60)
var hourPadding = ""
var prevVol = 0.0

class FirstViewController: UIViewController{
	
	let defaults = UserDefaults.standard
	let musicPlayer = MPMusicPlayerController.applicationMusicPlayer
	
	//@IBOutlet weak var dateLabel: UILabel!
	@IBOutlet weak var timeLabel: UILabel!
	@IBOutlet weak var songLabel: UILabel!
	
	var labelTimer = Timer()
	
	@objc func tick() {
		//dateLabel.text = DateFormatter.localizedString(from: Date(), dateStyle: .long, timeStyle: .none)
		timeLabel.text = DateFormatter.localizedString(from: Date(), dateStyle: .none, timeStyle: .short)
		var nowPlayingString:String = "Now Playing: "
		if (MPMusicPlayerController.applicationMusicPlayer.playbackState == MPMusicPlaybackState.playing) {
			switch GlobalVars.selectedMusicList {
			case 0:
				if GlobalVars.musicSelectionID0[GlobalVars.hour] != 0 {
					nowPlayingString.append(GlobalVars.musicSelection0[GlobalVars.hour])
				} else {
					var searchID:UInt64 = 0
					var searchHour:Int = GlobalVars.hour
					while (searchID == 0) {
						if(searchHour > 0){
							searchHour -= 1
						} else {
							searchHour = 23
						}
						if(searchHour == GlobalVars.hour){
							//print("no songs found!")
							break
						}
						//print("searching ", searchHour)
						searchID = GlobalVars.musicSelectionID0[searchHour]
						
						//print(searchID)
					}
					nowPlayingString.append(GlobalVars.musicSelection0[searchHour])
				}
			case 1:
				if GlobalVars.musicSelectionID1[GlobalVars.hour] != 0 {
					nowPlayingString.append(GlobalVars.musicSelection1[GlobalVars.hour])
				} else {
					var searchID:UInt64 = 0
					var searchHour:Int = GlobalVars.hour
					while (searchID == 0) {
						if(searchHour > 0){
							searchHour -= 1
						} else {
							searchHour = 23
						}
						if(searchHour == GlobalVars.hour){
							//print("no songs found!")
							break
						}
						//print("searching ", searchHour)
						searchID = GlobalVars.musicSelectionID1[searchHour]
						
						//print(searchID)
					}
					nowPlayingString.append(GlobalVars.musicSelection1[searchHour])
				}
			case 2:
				if GlobalVars.musicSelectionID2[GlobalVars.hour] != 0 {
					nowPlayingString.append(GlobalVars.musicSelection2[GlobalVars.hour])
				} else {
					var searchID:UInt64 = 0
					var searchHour:Int = GlobalVars.hour
					while (searchID == 0) {
						if(searchHour > 0){
							searchHour -= 1
						} else {
							searchHour = 23
						}
						if(searchHour == GlobalVars.hour){
							//print("no songs found!")
							break
						}
						//print("searching ", searchHour)
						searchID = GlobalVars.musicSelectionID2[searchHour]
						
						//print(searchID)
					}
					nowPlayingString.append(GlobalVars.musicSelection2[searchHour])
				}
			case 3:
				if GlobalVars.musicSelectionID3[GlobalVars.hour] != 0 {
					nowPlayingString.append(GlobalVars.musicSelection3[GlobalVars.hour])
				} else {
					var searchID:UInt64 = 0
					var searchHour:Int = GlobalVars.hour
					while (searchID == 0) {
						if(searchHour > 0){
							searchHour -= 1
						} else {
							searchHour = 23
						}
						if(searchHour == GlobalVars.hour){
							//print("no songs found!")
							break
						}
						//print("searching ", searchHour)
						searchID = GlobalVars.musicSelectionID3[searchHour]
						
						//print(searchID)
					}
					nowPlayingString.append(GlobalVars.musicSelection3[searchHour])
				}
			case 4:
				if GlobalVars.musicSelectionID4[GlobalVars.hour] != 0 {
					nowPlayingString.append(GlobalVars.musicSelection4[GlobalVars.hour])
				} else {
					var searchID:UInt64 = 0
					var searchHour:Int = GlobalVars.hour
					while (searchID == 0) {
						if(searchHour > 0){
							searchHour -= 1
						} else {
							searchHour = 23
						}
						if(searchHour == GlobalVars.hour){
							//print("no songs found!")
							break
						}
						//print("searching ", searchHour)
						searchID = GlobalVars.musicSelectionID4[searchHour]
						
						//print(searchID)
					}
					nowPlayingString.append(GlobalVars.musicSelection4[searchHour])
				}
			default:
				if GlobalVars.musicSelectionID0[GlobalVars.hour] != 0 {
					nowPlayingString.append(GlobalVars.musicSelection0[GlobalVars.hour])
				} else {
					var searchID:UInt64 = 0
					var searchHour:Int = GlobalVars.hour
					while (searchID == 0) {
						if(searchHour > 0){
							searchHour -= 1
						} else {
							searchHour = 23
						}
						if(searchHour == GlobalVars.hour){
							//print("no songs found!")
							break
						}
						//print("searching ", searchHour)
						searchID = GlobalVars.musicSelectionID0[searchHour]
						
						//print(searchID)
					}
					nowPlayingString.append(GlobalVars.musicSelection0[searchHour])
				}
			}
			songLabel.text = nowPlayingString
		} else {
			songLabel.text = ""
		}
		
		if (MPMusicPlayerController.applicationMusicPlayer.playbackState == MPMusicPlaybackState.playing) {
			GlobalVars.musicStarted = true
			controlButton.accessibilityLabel = "Pause Button"
			controlButton.setBackgroundImage(UIImage(systemName: "pause.circle"), for: UIControl.State.normal)
			UIView.animate(withDuration: 0.4, delay: 0,usingSpringWithDamping: 0.5,initialSpringVelocity: 0,animations: {self.PlayButtonSize.constant = 130;self.view.layoutIfNeeded()}, completion: nil)
		} else {
			GlobalVars.musicStarted = false
			controlButton.accessibilityLabel = "Play Button"
			controlButton.setBackgroundImage(UIImage(systemName: "play.circle"), for: UIControl.State.normal)
			UIView.animate(withDuration: 0.4, delay: 0,usingSpringWithDamping: 0.5,initialSpringVelocity: 0, animations: {self.PlayButtonSize.constant = 90;self.view.layoutIfNeeded()}, completion: nil)
		}
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view.
		
		musicPlayer.stop()
		GlobalVars.musicStarted = false
		
		
		if(!defaults.bool(forKey: "didRun")){
			defaults.set("New Horizons", forKey: "selectedTitle")
			defaults.set(0, forKey: "titleNo")
			//defaults.set(true, forKey: "didRun")
			GlobalVars.musicSelectionID0 = [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]
			GlobalVars.musicSelection0 =  ["","","","","","","","","","","","","","","","","","","","","","","",""]
			GlobalVars.musicSelectionID1 = [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]
			GlobalVars.musicSelection1 =  ["","","","","","","","","","","","","","","","","","","","","","","",""]
			GlobalVars.musicSelectionID2 = [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]
			GlobalVars.musicSelection2 =  ["","","","","","","","","","","","","","","","","","","","","","","",""]
			GlobalVars.musicSelectionID3 = [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]
			GlobalVars.musicSelection3 =  ["","","","","","","","","","","","","","","","","","","","","","","",""]
			GlobalVars.musicSelectionID4 = [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]
			GlobalVars.musicSelection4 =  ["","","","","","","","","","","","","","","","","","","","","","","",""]
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
			//print("First App run")
		} else {
			do {
				GlobalVars.musicSelection0 = try defaults.getObject(forKey: "savedMusicSelection0", castTo: [String].self)
				//print(GlobalVars.musicSelection0)
			} catch {
				//print(error.localizedDescription)
			}
			do {
				GlobalVars.musicSelectionID0 = try defaults.getObject(forKey: "savedMusicSelectionID0", castTo: [UInt64].self)
				//print(GlobalVars.musicSelectionID0)
			} catch {
				//print(error.localizedDescription)
			}
			do {
				GlobalVars.musicSelection1 = try defaults.getObject(forKey: "savedMusicSelection1", castTo: [String].self)
				//print(GlobalVars.musicSelection1)
			} catch {
				//print(error.localizedDescription)
			}
			do {
				GlobalVars.musicSelectionID1 = try defaults.getObject(forKey: "savedMusicSelectionID1", castTo: [UInt64].self)
				//print(GlobalVars.musicSelectionID1)
			} catch {
				//print(error.localizedDescription)
			}
			do {
				GlobalVars.musicSelection2 = try defaults.getObject(forKey: "savedMusicSelection2", castTo: [String].self)
				//print(GlobalVars.musicSelection2)
			} catch {
				//print(error.localizedDescription)
			}
			do {
				GlobalVars.musicSelectionID2 = try defaults.getObject(forKey: "savedMusicSelectionID2", castTo: [UInt64].self)
				//print(GlobalVars.musicSelectionID2)
			} catch {
				//print(error.localizedDescription)
			}
			do {
				GlobalVars.musicSelection3 = try defaults.getObject(forKey: "savedMusicSelection3", castTo: [String].self)
				//print(GlobalVars.musicSelection3)
			} catch {
				//print(error.localizedDescription)
			}
			do {
				GlobalVars.musicSelectionID3 = try defaults.getObject(forKey: "savedMusicSelectionID3", castTo: [UInt64].self)
				//print(GlobalVars.musicSelectionID3)
			} catch {
				//print(error.localizedDescription)
			}
			do {
				GlobalVars.musicSelection4 = try defaults.getObject(forKey: "savedMusicSelection4", castTo: [String].self)
				//print(GlobalVars.musicSelection4)
			} catch {
				//print(error.localizedDescription)
			}
			do {
				GlobalVars.musicSelectionID4 = try defaults.getObject(forKey: "savedMusicSelectionID4", castTo: [UInt64].self)
				//print(GlobalVars.musicSelectionID4)
			} catch {
				//print(error.localizedDescription)
			}
			
			do {
				GlobalVars.selectedMusicList = try defaults.getObject(forKey: "savedSelectedMusicList", castTo: Int.self)
				//print(GlobalVars.selectedMusicList)
			} catch {
				//print(error.localizedDescription)
			}
			//print("App Ran Before")
		}
		
		//print(currentSeconds)
		//print(currentMinute)
		
		//print(timeTillTopOfTheHour)
		
		////print(GlobalVars.selectedSong)
		
		GlobalVars.hour = Calendar.current.component(.hour, from: Date())
		date = Date().addingTimeInterval(TimeInterval(timeTillTopOfTheHour))
		//print(date)
		timer = Timer(fireAt: date, interval: 0, target: musicHandler.self, selector: #selector(musicHandler.updateMusic), userInfo: nil, repeats: false)
		RunLoop.main.add(timer, forMode: .common)
		
		//dateLabel.text = DateFormatter.localizedString(from: Date(), dateStyle: .long, timeStyle: .none)
		timeLabel.text = DateFormatter.localizedString(from: Date(), dateStyle: .none, timeStyle: .short)
		labelTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector:#selector(self.tick) , userInfo: nil, repeats: true)
		
		if((GlobalVars.hour >= 8) && (GlobalVars.hour <= 19)){ //Daytime
			do{
				let gif = try UIImage(gifName: "day.gif")
				sceneryImageView.setGifImage(gif, loopCount: -1)
			}catch{print(error)}
		} else if((GlobalVars.hour >= 20) && (GlobalVars.hour <= 21)){//Sunset
			//print("sunset")
			do{
				let gif = try UIImage(gifName: "day.gif")
				sceneryImageView.setGifImage(gif, loopCount: -1)
			}catch{print(error)}
		} else if((GlobalVars.hour >= 22) || (GlobalVars.hour <= 5)){//Night
			//print("night")
			do{
				let gif = try UIImage(gifName: "night.gif")
				sceneryImageView.setGifImage(gif, loopCount: -1)
			}catch{print(error)}
		} else if((GlobalVars.hour >= 6) && (GlobalVars.hour <= 7)){//Sunrise
			//print("sunrise")
			do{
				let gif = try UIImage(gifName: "day.gif")
				sceneryImageView.setGifImage(gif, loopCount: -1)
			}catch{print(error)}
		}
		
		/*do{
		
		audioPlayer = try AVAudioPlayer(contentsOf: URL.init(fileURLWithPath: Bundle.main.path(forResource: song, ofType: "mp3")!))
		audioPlayer.prepareToPlay()
		audioPlayer.numberOfLoops = -1
		
		let audioSession = AVAudioSession.sharedInstance()
		do{
		try audioSession.setCategory(.playback, mode: .default)
		try audioSession.setActive(true)
		}
		
		
		}
		catch{
		//print(error)
		}*/
		
	}
	
	@IBOutlet var sceneryImageView: UIImageView!
	
	@IBOutlet var gradientView: UIView!
	
	override func viewDidAppear(_ animated: Bool) {
		
		//print("fuck!")
		let prevHour = GlobalVars.hour
		GlobalVars.hour = Calendar.current.component(.hour, from: Date())
		if GlobalVars.hour != prevHour {
			musicHandler.updateMusic()
		}
		
		if (!defaults.bool(forKey: "didRun")){
			let fuckAlert = UIAlertController(title: "Welcome!", message: "Please visit the 'Select Music' tab to set your hourly playlist, and come back here and hit play once it's ready!", preferredStyle: .alert)
			
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
			fuckAlert.addAction(OKAction)
			
			// Present Dialog message
			self.present(fuckAlert, animated: true, completion:nil)
			
			defaults.set(true, forKey: "didRun")
			
		}
		
		if (MPMusicPlayerController.applicationMusicPlayer.playbackState == MPMusicPlaybackState.playing) {
			GlobalVars.musicStarted = true
			controlButton.accessibilityLabel = "Pause Button"
			controlButton.setBackgroundImage(UIImage(systemName: "pause.circle"), for: UIControl.State.normal)
			UIView.animate(withDuration: 0.4, delay: 0,usingSpringWithDamping: 0.5,initialSpringVelocity: 0,animations: {self.PlayButtonSize.constant = 130;self.view.layoutIfNeeded()}, completion: nil)
		} else {
			GlobalVars.musicStarted = false
			controlButton.accessibilityLabel = "Play Button"
			controlButton.setBackgroundImage(UIImage(systemName: "play.circle"), for: UIControl.State.normal)
			UIView.animate(withDuration: 0.4, delay: 0,usingSpringWithDamping: 0.5,initialSpringVelocity: 0, animations: {self.PlayButtonSize.constant = 90;self.view.layoutIfNeeded()}, completion: nil)
		}
		
		var foundSong = false
		switch GlobalVars.selectedMusicList {
		case 0:
			for i in GlobalVars.musicSelectionID0 {
				if (i != 0){
					foundSong = true
				}
			}
		case 1:
			for i in GlobalVars.musicSelectionID1 {
				if (i != 0){
					foundSong = true
				}
			}
		case 2:
			for i in GlobalVars.musicSelectionID2 {
				if (i != 0){
					foundSong = true
				}
			}
		case 3:
			for i in GlobalVars.musicSelectionID3 {
				if (i != 0){
					foundSong = true
				}
			}
		case 4:
			for i in GlobalVars.musicSelectionID4 {
				if (i != 0){
					foundSong = true
				}
			}
		default:
			for i in GlobalVars.musicSelectionID0 {
				if (i != 0){
					foundSong = true
				}
			}
		}
		
		if !foundSong && defaults.bool(forKey: "didRun") {
			let errorAlert = UIAlertController(title: "Song Error", message: "No songs found in this track. Please visit the 'Select Music' tab to set a song and get started!", preferredStyle: .alert)
			
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
			//print("Song is missing for at one hour")
			
			controlButton.isEnabled = false
			controlButton.accessibilityLabel = "Play Button. Music Cannot be played."
		} else {
			controlButton.isEnabled = true
		}
		self.view.layoutIfNeeded()
		
		var nowPlayingString:String = "Now Playing: "
		if (MPMusicPlayerController.applicationMusicPlayer.playbackState == MPMusicPlaybackState.playing) {
			switch GlobalVars.selectedMusicList {
			case 0:
				if GlobalVars.musicSelectionID0[GlobalVars.hour] != 0 {
					nowPlayingString.append(GlobalVars.musicSelection0[GlobalVars.hour])
				} else {
					var searchID:UInt64 = 0
					var searchHour:Int = GlobalVars.hour
					while (searchID == 0) {
						if(searchHour > 0){
							searchHour -= 1
						} else {
							searchHour = 23
						}
						if(searchHour == GlobalVars.hour){
							//print("no songs found!")
							break
						}
						//print("searching ", searchHour)
						searchID = GlobalVars.musicSelectionID0[searchHour]
						
						//print(searchID)
					}
					nowPlayingString.append(GlobalVars.musicSelection0[searchHour])
				}
			case 1:
				if GlobalVars.musicSelectionID1[GlobalVars.hour] != 0 {
					nowPlayingString.append(GlobalVars.musicSelection1[GlobalVars.hour])
				} else {
					var searchID:UInt64 = 0
					var searchHour:Int = GlobalVars.hour
					while (searchID == 0) {
						if(searchHour > 0){
							searchHour -= 1
						} else {
							searchHour = 23
						}
						if(searchHour == GlobalVars.hour){
							//print("no songs found!")
							break
						}
						//print("searching ", searchHour)
						searchID = GlobalVars.musicSelectionID1[searchHour]
						
						//print(searchID)
					}
					nowPlayingString.append(GlobalVars.musicSelection1[searchHour])
				}
			case 2:
				if GlobalVars.musicSelectionID2[GlobalVars.hour] != 0 {
					nowPlayingString.append(GlobalVars.musicSelection2[GlobalVars.hour])
				} else {
					var searchID:UInt64 = 0
					var searchHour:Int = GlobalVars.hour
					while (searchID == 0) {
						if(searchHour > 0){
							searchHour -= 1
						} else {
							searchHour = 23
						}
						if(searchHour == GlobalVars.hour){
							//print("no songs found!")
							break
						}
						//print("searching ", searchHour)
						searchID = GlobalVars.musicSelectionID2[searchHour]
						
						//print(searchID)
					}
					nowPlayingString.append(GlobalVars.musicSelection2[searchHour])
				}
			case 3:
				if GlobalVars.musicSelectionID3[GlobalVars.hour] != 0 {
					nowPlayingString.append(GlobalVars.musicSelection3[GlobalVars.hour])
				} else {
					var searchID:UInt64 = 0
					var searchHour:Int = GlobalVars.hour
					while (searchID == 0) {
						if(searchHour > 0){
							searchHour -= 1
						} else {
							searchHour = 23
						}
						if(searchHour == GlobalVars.hour){
							//print("no songs found!")
							break
						}
						//print("searching ", searchHour)
						searchID = GlobalVars.musicSelectionID3[searchHour]
						
						//print(searchID)
					}
					nowPlayingString.append(GlobalVars.musicSelection3[searchHour])
				}
			case 4:
				if GlobalVars.musicSelectionID4[GlobalVars.hour] != 0 {
					nowPlayingString.append(GlobalVars.musicSelection4[GlobalVars.hour])
				} else {
					var searchID:UInt64 = 0
					var searchHour:Int = GlobalVars.hour
					while (searchID == 0) {
						if(searchHour > 0){
							searchHour -= 1
						} else {
							searchHour = 23
						}
						if(searchHour == GlobalVars.hour){
							//print("no songs found!")
							break
						}
						//print("searching ", searchHour)
						searchID = GlobalVars.musicSelectionID4[searchHour]
						
						//print(searchID)
					}
					nowPlayingString.append(GlobalVars.musicSelection4[searchHour])
				}
			default:
				if GlobalVars.musicSelectionID0[GlobalVars.hour] != 0 {
					nowPlayingString.append(GlobalVars.musicSelection0[GlobalVars.hour])
				} else {
					var searchID:UInt64 = 0
					var searchHour:Int = GlobalVars.hour
					while (searchID == 0) {
						if(searchHour > 0){
							searchHour -= 1
						} else {
							searchHour = 23
						}
						if(searchHour == GlobalVars.hour){
							//print("no songs found!")
							break
						}
						//print("searching ", searchHour)
						searchID = GlobalVars.musicSelectionID0[searchHour]
						
						//print(searchID)
					}
					nowPlayingString.append(GlobalVars.musicSelection0[searchHour])
				}
			}
			songLabel.text = nowPlayingString
		} else {
			songLabel.text = ""
		}
	}
	
	override func viewWillAppear(_ animated: Bool) {
		
		// create the gradient layer
		let gradient = CAGradientLayer()
		gradient.frame = self.view.bounds
		//print("time: ", GlobalVars.hour)
		if((GlobalVars.hour >= 8) && (GlobalVars.hour <= 19)){ //Daytime
			//print("day")
			do{
				let gif = try UIImage(gifName: "day.gif")
				sceneryImageView.setGifImage(gif, loopCount: -1)
			}catch{print(error)}
			//sceneryImageView.image = UIImage(named: "ACBackgroundDay", in: Bundle(for: type(of: self)), compatibleWith: nil)
			gradient.colors = [UIColor(red: 0.39, green: 0.69, blue: 1.00, alpha: 1).cgColor, UIColor(red: 0.07, green: 0.45, blue: 0.87, alpha: 1).cgColor]
		} else if((GlobalVars.hour >= 20) && (GlobalVars.hour <= 21)){//Sunset
			//print("sunset")
			do{
				let gif = try UIImage(gifName: "day.gif")
				sceneryImageView.setGifImage(gif, loopCount: -1)
			}catch{print(error)}
			//sceneryImageView.image = UIImage(named: "ACBackgroundDay", in: Bundle(for: type(of: self)), compatibleWith: nil)
			gradient.colors = [UIColor(red: 0.00, green: 0.31, blue: 0.59, alpha: 1).cgColor, UIColor(red: 1.00, green: 0.78, blue: 0.88, alpha: 1).cgColor]
		} else if((GlobalVars.hour >= 22) || (GlobalVars.hour <= 5)){//Night
			//print("night")
			do{
				let gif = try UIImage(gifName: "night.gif")
				sceneryImageView.setGifImage(gif, loopCount: -1)
			}catch{print(error)}
			//sceneryImageView.image = UIImage(named: "ACBackgroundNight", in: Bundle(for: type(of: self)), compatibleWith: nil)
			gradient.colors = [UIColor(red: 0.08, green: 0.27, blue: 0.59, alpha: 1).cgColor, UIColor(red: 0.00, green: 0.20, blue: 0.29, alpha: 1).cgColor]
		} else if((GlobalVars.hour >= 6) && (GlobalVars.hour <= 7)){//Sunrise
			//print("sunrise")
			do{
				let gif = try UIImage(gifName: "day.gif")
				sceneryImageView.setGifImage(gif, loopCount: -1)
			}catch{print(error)}
			//sceneryImageView.image = UIImage(named: "ACBackgroundDay", in: Bundle(for: type(of: self)), compatibleWith: nil)
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
		
		
	}
	
	override func viewWillDisappear(_ animated: Bool) {
		gradientView.layer.sublayers?.forEach { $0.removeFromSuperlayer() }
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
	}
	
	@IBOutlet weak var controlButton: UIButton!
	
	@IBOutlet var PlayButtonSize: NSLayoutConstraint!
	
	
	@IBAction func play(_ sender: Any) {
		if(!GlobalVars.musicStarted){
			
			
			GlobalVars.musicStarted = true
			musicHandler.updateMusic()
			let musicPlayer = MPMusicPlayerController.applicationMusicPlayer
			musicPlayer.play()
			GlobalVars.musicStarted = true
			controlButton.accessibilityLabel = "Pause Button"
			controlButton.setBackgroundImage(UIImage(systemName: "pause.circle"), for: UIControl.State.normal)
			UIView.animate(withDuration: 0.4,delay:0,usingSpringWithDamping: 0.5,initialSpringVelocity: 0,animations: {self.PlayButtonSize.constant = 130;self.view.layoutIfNeeded()}, completion: nil)
		}
		else{
			let musicPlayer = MPMusicPlayerController.applicationMusicPlayer
			musicPlayer.pause()
			GlobalVars.musicStarted = false
			controlButton.accessibilityLabel = "Play Button"
			controlButton.setBackgroundImage(UIImage(systemName: "play.circle"), for: UIControl.State.normal)
			UIView.animate(withDuration: 0.4, delay: 0,usingSpringWithDamping: 0.5,initialSpringVelocity: 0,animations: {self.PlayButtonSize.constant = 90;self.view.layoutIfNeeded()}, completion: nil)
				
		}
		var nowPlayingString:String = "Now Playing: "
		if (MPMusicPlayerController.applicationMusicPlayer.playbackState == MPMusicPlaybackState.playing) {
			switch GlobalVars.selectedMusicList {
			case 0:
				if GlobalVars.musicSelectionID0[GlobalVars.hour] != 0 {
					nowPlayingString.append(GlobalVars.musicSelection0[GlobalVars.hour])
				} else {
					var searchID:UInt64 = 0
					var searchHour:Int = GlobalVars.hour
					while (searchID == 0) {
						if(searchHour > 0){
							searchHour -= 1
						} else {
							searchHour = 23
						}
						if(searchHour == GlobalVars.hour){
							//print("no songs found!")
							break
						}
						//print("searching ", searchHour)
						searchID = GlobalVars.musicSelectionID0[searchHour]
						
						//print(searchID)
					}
					nowPlayingString.append(GlobalVars.musicSelection0[searchHour])
				}
			case 1:
				if GlobalVars.musicSelectionID1[GlobalVars.hour] != 0 {
					nowPlayingString.append(GlobalVars.musicSelection1[GlobalVars.hour])
				} else {
					var searchID:UInt64 = 0
					var searchHour:Int = GlobalVars.hour
					while (searchID == 0) {
						if(searchHour > 0){
							searchHour -= 1
						} else {
							searchHour = 23
						}
						if(searchHour == GlobalVars.hour){
							//print("no songs found!")
							break
						}
						//print("searching ", searchHour)
						searchID = GlobalVars.musicSelectionID1[searchHour]
						
						//print(searchID)
					}
					nowPlayingString.append(GlobalVars.musicSelection1[searchHour])
				}
			case 2:
				if GlobalVars.musicSelectionID2[GlobalVars.hour] != 0 {
					nowPlayingString.append(GlobalVars.musicSelection2[GlobalVars.hour])
				} else {
					var searchID:UInt64 = 0
					var searchHour:Int = GlobalVars.hour
					while (searchID == 0) {
						if(searchHour > 0){
							searchHour -= 1
						} else {
							searchHour = 23
						}
						if(searchHour == GlobalVars.hour){
							//print("no songs found!")
							break
						}
						//print("searching ", searchHour)
						searchID = GlobalVars.musicSelectionID2[searchHour]
						
						//print(searchID)
					}
					nowPlayingString.append(GlobalVars.musicSelection2[searchHour])
				}
			case 3:
				if GlobalVars.musicSelectionID3[GlobalVars.hour] != 0 {
					nowPlayingString.append(GlobalVars.musicSelection3[GlobalVars.hour])
				} else {
					var searchID:UInt64 = 0
					var searchHour:Int = GlobalVars.hour
					while (searchID == 0) {
						if(searchHour > 0){
							searchHour -= 1
						} else {
							searchHour = 23
						}
						if(searchHour == GlobalVars.hour){
							//print("no songs found!")
							break
						}
						//print("searching ", searchHour)
						searchID = GlobalVars.musicSelectionID3[searchHour]
						
						//print(searchID)
					}
					nowPlayingString.append(GlobalVars.musicSelection3[searchHour])
				}
			case 4:
				if GlobalVars.musicSelectionID4[GlobalVars.hour] != 0 {
					nowPlayingString.append(GlobalVars.musicSelection4[GlobalVars.hour])
				} else {
					var searchID:UInt64 = 0
					var searchHour:Int = GlobalVars.hour
					while (searchID == 0) {
						if(searchHour > 0){
							searchHour -= 1
						} else {
							searchHour = 23
						}
						if(searchHour == GlobalVars.hour){
							//print("no songs found!")
							break
						}
						//print("searching ", searchHour)
						searchID = GlobalVars.musicSelectionID4[searchHour]
						
						//print(searchID)
					}
					nowPlayingString.append(GlobalVars.musicSelection4[searchHour])
				}
			default:
				if GlobalVars.musicSelectionID0[GlobalVars.hour] != 0 {
					nowPlayingString.append(GlobalVars.musicSelection0[GlobalVars.hour])
				} else {
					var searchID:UInt64 = 0
					var searchHour:Int = GlobalVars.hour
					while (searchID == 0) {
						if(searchHour > 0){
							searchHour -= 1
						} else {
							searchHour = 23
						}
						if(searchHour == GlobalVars.hour){
							//print("no songs found!")
							break
						}
						//print("searching ", searchHour)
						searchID = GlobalVars.musicSelectionID0[searchHour]
						
						//print(searchID)
					}
					nowPlayingString.append(GlobalVars.musicSelection0[searchHour])
				}
			}
			songLabel.text = nowPlayingString
		} else {
			songLabel.text = ""
		}
	}
	
	/*@objc func updateMusic(){
	
	//timer.invalidate()
	
	prevVol = Double(audioPlayer.volume)
	audioPlayer.setVolume(0, fadeDuration: 3)
	//print("updating song")
	
	hour = Calendar.current.component(.hour, from: date)
	if(hour<10){
	hourPadding = "0"
	}
	else{
	hourPadding = ""
	}
	
	song = "acnh" + hourPadding + String(hour)
	//print(song)
	
	do{
	
	audioPlayer = try AVAudioPlayer(contentsOf: URL.init(fileURLWithPath: Bundle.main.path(forResource: song, ofType: "mp3")!))
	audioPlayer.prepareToPlay()
	audioPlayer.numberOfLoops = -1
	
	let audioSession = AVAudioSession.sharedInstance()
	do{
	try audioSession.setCategory(.playback, mode: .default)
	try audioSession.setActive(true)
	}
	
	
	}
	catch{
	//print(error)
	}
	if(GlobalVars.musicStarted){
	audioPlayer.play()
	}
	audioPlayer.setVolume(Float(prevVol), fadeDuration: 1)
	date = date.addingTimeInterval(3600)
	//print(date)
	timer = Timer(fireAt: date, interval: 0, target: self, selector: #selector(updateMusic), userInfo: nil, repeats: false)
	RunLoop.main.add(timer, forMode: RunLoop.Mode.common)
	
	}*/
	
	
	
}

enum IAPHandlerAlertType{
	case disabled
	case restored
	case purchased
	
	func message() -> String{
		switch self {
		case .disabled: return "Purchases are disabled on your device!"
		case .restored: return "You've successfully restored your purchase!"
		case .purchased: return "Your support means so much to me, thank you for enjoying AC Tape Deck!"
		}
	}
	func title() -> String{
		switch self {
		case .disabled: return ""
		case .restored: return ""
		case .purchased: return "Thank you!"
		}
	}
}

class IAPHandler: NSObject {
	static let shared = IAPHandler()
	
	let SMALL_TIP_PRODUCT_ID = "smalltip"
	let MEDIUM_TIP_PRODUCT_ID = "mediumtip"
	let LARGE_TIP_PRODUCT_ID = "largetip"
	
	fileprivate var productID = ""
	fileprivate var productsRequest = SKProductsRequest()
	fileprivate var iapProducts = [SKProduct]()
	
	var purchaseStatusBlock: ((IAPHandlerAlertType) -> Void)?
	
	// MARK: - MAKE PURCHASE OF A PRODUCT
	func canMakePurchases() -> Bool {  return SKPaymentQueue.canMakePayments()  }
	
	func purchaseMyProduct(index: Int){
		if iapProducts.count == 0 { return }
		
		if self.canMakePurchases() {
			let product = iapProducts[index]
			let payment = SKPayment(product: product)
			SKPaymentQueue.default().add(self)
			SKPaymentQueue.default().add(payment)
			
			//print("PRODUCT TO PURCHASE: \(product.productIdentifier)")
			productID = product.productIdentifier
		} else {
			purchaseStatusBlock?(.disabled)
		}
	}
	
	// MARK: - RESTORE PURCHASE
	func restorePurchase(){
		SKPaymentQueue.default().add(self)
		SKPaymentQueue.default().restoreCompletedTransactions()
	}
	
	
	// MARK: - FETCH AVAILABLE IAP PRODUCTS
	func fetchAvailableProducts(){
		
		// Put here your IAP Products ID's
		let productIdentifiers = NSSet(objects: SMALL_TIP_PRODUCT_ID,MEDIUM_TIP_PRODUCT_ID,LARGE_TIP_PRODUCT_ID
		)
		
		productsRequest = SKProductsRequest(productIdentifiers: productIdentifiers as! Set<String>)
		productsRequest.delegate = self
		productsRequest.start()
	}
}

extension IAPHandler: SKProductsRequestDelegate, SKPaymentTransactionObserver{
	// MARK: - REQUEST IAP PRODUCTS
	func productsRequest (_ request:SKProductsRequest, didReceive response:SKProductsResponse) {
		
		if (response.products.count > 0) {
			iapProducts = response.products
			for product in iapProducts{
				let numberFormatter = NumberFormatter()
				numberFormatter.formatterBehavior = .behavior10_4
				numberFormatter.numberStyle = .currency
				numberFormatter.locale = product.priceLocale
				let price1Str = numberFormatter.string(from: product.price)
				//print(product.localizedDescription + "\nfor just \(price1Str!)")
			}
		}
	}
	
	func paymentQueueRestoreCompletedTransactionsFinished(_ queue: SKPaymentQueue) {
		purchaseStatusBlock?(.restored)
	}
	
	// MARK:- IAP PAYMENT QUEUE
	func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
		for transaction:AnyObject in transactions {
			if let trans = transaction as? SKPaymentTransaction {
				switch trans.transactionState {
				case .purchased:
					//print("purchased")
					SKPaymentQueue.default().finishTransaction(transaction as! SKPaymentTransaction)
					purchaseStatusBlock?(.purchased)
					break
					
				case .failed:
					//print("failed")
					SKPaymentQueue.default().finishTransaction(transaction as! SKPaymentTransaction)
					break
				case .restored:
					//print("restored")
					SKPaymentQueue.default().finishTransaction(transaction as! SKPaymentTransaction)
					break
					
				default: break
				}}}
	}
}
