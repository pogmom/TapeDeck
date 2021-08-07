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

extension UIViewController {
	
	func addSnowflakes() {
		self.view.backgroundColor = UIColor.white
		let particleEmitter = CAEmitterLayer()
		particleEmitter.emitterPosition = CGPoint(x: view.center.x, y: -96)
		particleEmitter.emitterShape = .line
		particleEmitter.emitterSize = CGSize(width: view.frame.size.width, height: 1)
		let white = makeEmitterCell(color: UIColor.white)
		particleEmitter.emitterCells = [white]
		view.layer.addSublayer(particleEmitter)
	}
	
	private func makeEmitterCell(color: UIColor) -> CAEmitterCell {
		let cell = CAEmitterCell()
		cell.birthRate = 25
		cell.lifetime = 15.0
		cell.lifetimeRange = 0
		cell.color = color.cgColor
		cell.velocity = 100
		cell.velocityRange = 50
		cell.emissionLatitude = CGFloat.pi
		cell.emissionRange = CGFloat.pi / 4
		//cell.spin = 2
		//cell.spinRange = 3
		cell.scaleRange = 1
		cell.scale = 0.1
		cell.scaleSpeed = -0.05
		cell.contents = UIImage(named: "particle.png")?.cgImage
		return cell
	}
	
	func addRain() {
		self.view.backgroundColor = UIColor.white
		let particleEmitter = CAEmitterLayer()
		particleEmitter.emitterPosition = CGPoint(x: view.center.x, y: -96)
		particleEmitter.emitterShape = .line
		particleEmitter.emitterSize = CGSize(width: view.frame.size.width, height: 1)
		let white = makeEmitterCellRain(color: UIColor.white)
		particleEmitter.emitterCells = [white]
		view.layer.addSublayer(particleEmitter)
	}
	
	private func makeEmitterCellRain(color: UIColor) -> CAEmitterCell {
		let cell = CAEmitterCell()
		cell.birthRate = 100
		cell.lifetime = 7.0
		cell.lifetimeRange = 0
		cell.color = color.cgColor
		cell.velocity = 500
		cell.velocityRange = 250
		cell.emissionLatitude = CGFloat.pi
		//cell.emissionRange = CGFloat.pi / 4
		//cell.spin = 2
		//cell.spinRange = 3
		cell.scaleRange = 1
		cell.scale = 0.1
		cell.scaleSpeed = -0.05
		cell.contents = UIImage(named: "rain2.png")?.cgImage
		return cell
	}
	
	func removeEffects() {
		self.view.layer.sublayers?.forEach {
			if let item: CAEmitterLayer = $0 as? CAEmitterLayer {
				item.removeFromSuperlayer()
			}
		}
	}
	
}

var audioPlayer = AVAudioPlayer()
var musicPlayer = MPMusicPlayerController.applicationMusicPlayer

public class musicHandler{
	@objc class func updateMusic(){
		
		print("updating music")
		print(GlobalVars.musicStarted)
		
		timer.invalidate()
		//audioPlayer.stop()
		//musicPlayer.stop()
		
		
		//print("updating song")
		
		GlobalVars.hour = Calendar.current.component(.hour, from: Date())
		
		//song = GlobalVars.titleCode + hourPadding + String(GlobalVars.hour)
		//print(song)
		let documentsUrl:URL =  (FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!) as URL
		var mediaPredicate = MPMediaPredicate()
		
		do{
			
			print(GlobalVars.musicSelectionID[GlobalVars.selectedMusicList][GlobalVars.hour])
			print(GlobalVars.musicFileURL[GlobalVars.selectedMusicList][GlobalVars.hour])
			
			if(GlobalVars.musicSelectionID[GlobalVars.selectedMusicList][GlobalVars.hour] != 0){
				mediaPredicate = MPMediaPropertyPredicate(value: GlobalVars.musicSelectionID[GlobalVars.selectedMusicList][GlobalVars.hour], forProperty: "persistentID")
				GlobalVars.currentMusicFormat = true
				print("ID is not zero")
			} else if(GlobalVars.musicFileURL[GlobalVars.selectedMusicList][GlobalVars.hour] != ""){
				do {
					let destinationFileUrl = documentsUrl.appendingPathComponent(GlobalVars.musicFileURL[GlobalVars.selectedMusicList][GlobalVars.hour])
					audioPlayer = try AVAudioPlayer(contentsOf: URL.init(fileURLWithPath:destinationFileUrl.path))
					GlobalVars.currentMusicFormat = false
					print("URL is not blank")
				} catch {
					print(error.localizedDescription)
				}
			} else {
				print("ID is zero, URL is blank, scanning for previous songs")
				var searchID:UInt64 = 0
				var searchURL:String = ""
				GlobalVars.searchHour = GlobalVars.hour
				while (searchID == 0 && searchURL == "") {
					if(GlobalVars.searchHour > 0){
						GlobalVars.searchHour -= 1
					} else {
						GlobalVars.searchHour = 23
					}
					if(GlobalVars.searchHour == GlobalVars.hour){
						//print("no songs found!")
						break
					}
					//print("searching ", searchHour)
					searchID = GlobalVars.musicSelectionID[GlobalVars.selectedMusicList][GlobalVars.searchHour]
					searchURL = GlobalVars.musicFileURL[GlobalVars.selectedMusicList][GlobalVars.searchHour]
					
					print("searchID \(searchID)")
					print("searchURL \(searchURL)")
					
					if (searchID != 0){
						mediaPredicate = MPMediaPropertyPredicate(value: searchID, forProperty: "persistentID")
						GlobalVars.currentMusicFormat = true
						print("ID is not zero")
					} else if (searchURL != ""){
						do {
							let destinationFileUrl = documentsUrl.appendingPathComponent(searchURL)
							audioPlayer = try AVAudioPlayer(contentsOf: URL.init(fileURLWithPath:destinationFileUrl.path))
							GlobalVars.currentMusicFormat = false
							print("URL is not blank")
						} catch {
							print(error.localizedDescription)
						}
					}
				}
				print("Format: \(GlobalVars.currentMusicFormat)")
			}
			
			//print(mediaQuery)
			//musicPlayer.play()
			let mediaQuery = MPMediaQuery()
							
			mediaQuery.addFilterPredicate(mediaPredicate)
							
							
			//let mediaItemCollection: MPMediaItemCollection = MPMediaItemCollection()
							
			musicPlayer.setQueue(with: mediaQuery)
			musicPlayer.repeatMode = .one
		}
		
		if(GlobalVars.currentMusicFormat) {
			
			if(GlobalVars.musicStarted){
				
				musicPlayer.play()
			} else {
				musicPlayer.stop()
			}
		} else {
			audioPlayer.prepareToPlay()
			audioPlayer.numberOfLoops = -1
			
			let audioSession = AVAudioSession.sharedInstance()
			do{
				//try audioSession.setCategory(.playback, mode: .default)
				try audioSession.setActive(true)
				try audioSession.setCategory(.playback, mode: .default, options:
																			.init(rawValue: 0))
			} catch {
				print(error.localizedDescription)
			}
			if(GlobalVars.musicStarted){
				audioPlayer.play()
				let mpic = MPNowPlayingInfoCenter.default()
						mpic.nowPlayingInfo = [
							MPMediaItemPropertyTitle:"AC Tape Deck",
							MPMediaItemPropertyArtist:"Micah Gomez"
						]
			}
		}
		
		/*if(musicPlayer.playbackState == MPMusicPlaybackState.playing){
			musicPlayer.play()
		}*/
		
		print("making timer")
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
		
		print("done updating music")
	}
}

struct GlobalVars {
	static var musicSelectionID:[[UInt64]] = [[UInt64]](repeating: [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0], count: 15)
	static var musicSelection:[[String]] = [[String]](repeating: ["","","","","","","","","","","","","","","","","","","","","","","",""], count: 15)
	static var musicFileURL:[[String]] = [[String]](repeating: ["","","","","","","","","","","","","","","","","","","","","","","",""], count: 15)
	static var musicFormatType:[[Bool]] = [[Bool]](repeating: [false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false], count: 15)
	
	static var selectedCell:Int? = nil
	
	static var selectedMusicList:Int = UserDefaults.standard.integer(forKey: "savedSelectedMusicList")
	static var selectedList:Int = UserDefaults.standard.integer(forKey: "savedSelectedList")
	static var weatherList:Int = UserDefaults.standard.integer(forKey: "savedWeatherList")
	static var musicStarted = false
	static var currentMusicFormat:Bool = false
	static var titleName = UserDefaults.standard.string(forKey: "selectedTitle")
	static var hour = Calendar.current.component(.hour, from: Date())
	static var searchHour:Int = 0
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
	
	//@IBOutlet weak var dateLabel: UILabel!
	@IBOutlet weak var timeLabel: UILabel!
	@IBOutlet weak var songLabel: UILabel!
	
	var labelTimer = Timer()
	
	@objc func tick() {
		//dateLabel.text = DateFormatter.localizedString(from: Date(), dateStyle: .long, timeStyle: .none)
		timeLabel.text = DateFormatter.localizedString(from: Date(), dateStyle: .none, timeStyle: .short)
		var nowPlayingString:String = "Now Playing: "
		if (musicPlayer.playbackState == MPMusicPlaybackState.playing) {
			print("musicPlayer is playing")
			if GlobalVars.musicSelectionID[GlobalVars.selectedMusicList][GlobalVars.hour] != 0 {
				nowPlayingString.append(GlobalVars.musicSelection[GlobalVars.selectedMusicList][GlobalVars.hour])
			} else {
				var searchID:UInt64 = 0
				GlobalVars.searchHour = GlobalVars.hour
				while (searchID == 0) {
					if(GlobalVars.searchHour > 0){
						GlobalVars.searchHour -= 1
					} else {
						GlobalVars.searchHour = 23
					}
					if(GlobalVars.searchHour == GlobalVars.hour){
						//print("no songs found!")
						break
					}
					//print("searching ", searchHour)
					searchID = GlobalVars.musicSelectionID[GlobalVars.selectedMusicList][GlobalVars.searchHour]
					
					//print(searchID)
				}
				nowPlayingString.append(GlobalVars.musicSelection[GlobalVars.selectedMusicList][GlobalVars.searchHour])
			}
			
			songLabel.text = nowPlayingString
		}
		else if (audioPlayer.isPlaying) {
			print("audioplayer is playing")
			if GlobalVars.musicFileURL[GlobalVars.selectedMusicList][GlobalVars.hour] != "" {
				nowPlayingString.append(GlobalVars.musicSelection[GlobalVars.selectedMusicList][GlobalVars.hour])
			} else {
				var searchURL:String = ""
				GlobalVars.searchHour = GlobalVars.hour
				while (searchURL == "") {
					if(GlobalVars.searchHour > 0){
						GlobalVars.searchHour -= 1
					} else {
						GlobalVars.searchHour = 23
					}
					if(GlobalVars.searchHour == GlobalVars.hour){
						//print("no songs found!")
						break
					}
					//print("searching ", searchHour)
					searchURL = GlobalVars.musicFileURL[GlobalVars.selectedMusicList][GlobalVars.searchHour]
					
					//print(searchID)
				}
				nowPlayingString.append(GlobalVars.musicSelection[GlobalVars.selectedMusicList][GlobalVars.searchHour])
				print(nowPlayingString)
				songLabel.text = nowPlayingString
			}
		}
		else {
			print("neither is playing")
			songLabel.text = ""
		}
		
		if (GlobalVars.musicStarted) {
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
		print("list \(GlobalVars.selectedMusicList)")
		
		UIApplication.shared.beginReceivingRemoteControlEvents()
		let commandCenter = MPRemoteCommandCenter.shared()
		commandCenter.pauseCommand.isEnabled = true
		commandCenter.playCommand.isEnabled = true
		commandCenter.nextTrackCommand.isEnabled = false
		commandCenter.previousTrackCommand.isEnabled = false

		commandCenter.playCommand.addTarget { [unowned self] event in
				if !audioPlayer.isPlaying {
					//musicHandler.updateMusic()
					audioPlayer.play()
					GlobalVars.musicStarted = true
					print("music play")
					return .success
				}
				return .commandFailed
			}

			// Add handler for Pause Command
			commandCenter.pauseCommand.addTarget { [unowned self] event in
				if audioPlayer.isPlaying {
					audioPlayer.pause()
					GlobalVars.musicStarted = false
					print("music pause")
					return .success
				}
				return .commandFailed
			}
		
		musicPlayer.stop()
		audioPlayer.stop()
		GlobalVars.musicStarted = false
		
		
		if(!defaults.bool(forKey: "didRun")){
			defaults.set(0, forKey: "titleNo")
			//defaults.set(true, forKey: "didRun")
			for n in 0...14 {
				print(n)
				GlobalVars.musicSelectionID[n] = [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]
				GlobalVars.musicSelection[n] =  ["","","","","","","","","","","","","","","","","","","","","","","",""]
				GlobalVars.musicFormatType[n] = [false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false]
				GlobalVars.musicFileURL[n] =  ["","","","","","","","","","","","","","","","","","","","","","","",""]
			}
			do {try defaults.setObject(GlobalVars.musicSelection, forKey: "savedMusicSelection")} catch {/*print(error.localizedDescription)*/}
			do {try defaults.setObject(GlobalVars.musicSelectionID, forKey: "savedMusicSelectionID")} catch {/*print(error.localizedDescription)*/}
			do {try defaults.setObject(GlobalVars.musicFileURL, forKey: "savedMusicFileURL")} catch {/*print(error.localizedDescription)*/}
			do {try defaults.setObject(GlobalVars.musicFormatType, forKey: "savedMusicFileURL")} catch {/*print(error.localizedDescription)*/}
			//print("First App run")
			} else {
			
				if(!defaults.bool(forKey: "didUpdate")){
					for n in 0...14 {
						print(n)
						GlobalVars.musicFormatType[n] = [false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false]
						GlobalVars.musicFileURL[n] =  ["","","","","","","","","","","","","","","","","","","","","","","",""]
					}
					defaults.set(true, forKey: "didUpdate")
					print("appjustupdated")
				}
				if(!defaults.bool(forKey: "didUpdate2")){
					for n in 5...14 {
						print(n)
						GlobalVars.musicFormatType[n] = [false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false]
						GlobalVars.musicFileURL[n] =  ["","","","","","","","","","","","","","","","","","","","","","","",""]
						GlobalVars.musicSelection[n] = ["","","","","","","","","","","","","","","","","","","","","","","",""]
						GlobalVars.musicSelectionID[n] = [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]
					}
					do {try defaults.setObject(GlobalVars.musicSelection, forKey: "savedMusicSelection")} catch {/*print(error.localizedDescription)*/}
					do {try defaults.setObject(GlobalVars.musicSelectionID, forKey: "savedMusicSelectionID")} catch {/*print(error.localizedDescription)*/}
					do {try defaults.setObject(GlobalVars.musicFileURL, forKey: "savedMusicFileURL")} catch {/*print(error.localizedDescription)*/}
					do {try defaults.setObject(GlobalVars.musicFormatType, forKey: "savedMusicFileType")} catch {/*print(error.localizedDescription)*/}
					defaults.set(true, forKey: "didUpdate2")
					print("appjustupdated")
				}
				do {GlobalVars.musicSelection = try defaults.getObject(forKey: "savedMusicSelection", castTo: [[String]].self)} catch {/*print(error.localizedDescription)*/}
				do {GlobalVars.musicSelectionID = try defaults.getObject(forKey: "savedMusicSelectionID", castTo: [[UInt64]].self)} catch {/*print(error.localizedDescription)*/}
				do {GlobalVars.musicFileURL = try defaults.getObject(forKey: "savedMusicFileURL", castTo: [[String]].self)} catch {/*print(error.localizedDescription)*/}
				do {GlobalVars.musicFormatType = try defaults.getObject(forKey: "savedMusicFileType", castTo: [[Bool]].self)} catch {/*print(error.localizedDescription)*/}
				do {GlobalVars.selectedMusicList = try defaults.getObject(forKey: "savedSelectedMusicList", castTo: Int.self)} catch {/*print(error.localizedDescription)*/}
				do {GlobalVars.selectedList = try defaults.getObject(forKey: "savedSelectedList", castTo: Int.self)} catch {/*print(error.localizedDescription)*/}
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
		
		if (GlobalVars.musicStarted) {
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
		
		
		print("woah! \(GlobalVars.selectedMusicList)")
		for i in GlobalVars.musicSelectionID[GlobalVars.selectedMusicList] {
			if (i != 0){
				foundSong = true
			}
		}
		for i in GlobalVars.musicFileURL[GlobalVars.selectedMusicList] {
			if (i != ""){
				foundSong = true
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
		if (musicPlayer.playbackState == MPMusicPlaybackState.playing) {
			
			if GlobalVars.musicSelectionID[GlobalVars.selectedMusicList][GlobalVars.hour] != 0 {
				nowPlayingString.append(GlobalVars.musicSelection[GlobalVars.selectedMusicList][GlobalVars.hour])
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
					searchID = GlobalVars.musicSelectionID[GlobalVars.selectedMusicList][searchHour]
					
					//print(searchID)
				}
				nowPlayingString.append(GlobalVars.musicSelection[GlobalVars.selectedMusicList][searchHour])
			}
			songLabel.text = nowPlayingString
		} else {
			songLabel.text = ""
		}
	}
	
	override func viewWillAppear(_ animated: Bool) {
		
		print(AVAudioPlayer().isPlaying)
		// create the gradient layer
		let gradient = CAGradientLayer()
		gradient.frame = self.view.bounds
		//print("time: ", GlobalVars.hour)
		
		updateGradientAndView()
		
		
		
		/*if((GlobalVars.hour >= 8) && (GlobalVars.hour <= 19)){ //Daytime
			do{
				var gif = try UIImage(gifName: "day.gif")
				var gradColors:[CGColor] = [UIColor(red: 0.39, green: 0.69, blue: 1.00, alpha: 1).cgColor, UIColor(red: 0.07, green: 0.45, blue: 0.87, alpha: 1).cgColor]
				//63b0ff
				//1273de
				if GlobalVars.weatherList == 2 {
					gif = try UIImage(gifName: "day snow.gif")
					gradColors = [UIColor(red: 0.91, green: 0.98, blue: 1.00, alpha: 1.00).cgColor,UIColor(red: 0.36, green: 0.60, blue: 0.87, alpha: 1.00).cgColor]
					//e8faff
					//5b99de
				} else if GlobalVars.weatherList == 1 {
					//7da3ca
					//416594
					gradColors = [UIColor(red: 0.49, green: 0.64, blue: 0.79, alpha: 1.00).cgColor, UIColor(red: 0.25, green: 0.40, blue: 0.58, alpha: 1.00).cgColor]
				}
				sceneryImageView.setGifImage(gif, loopCount: -1)
				gradient.colors = gradColors
			}catch{print(error)}
		} else if((GlobalVars.hour >= 20) && (GlobalVars.hour <= 21)){//Sunset
			do{
				var gif = try UIImage(gifName: "day.gif")
				var gradColors:[CGColor] = [UIColor(red: 0.00, green: 0.31, blue: 0.59, alpha: 1).cgColor, UIColor(red: 1.00, green: 0.78, blue: 0.88, alpha: 1).cgColor]
				//004f96
				//ffc7e0
				if GlobalVars.weatherList == 2 {
					gif = try UIImage(gifName: "day snow.gif")
					gradColors = [UIColor(red: 0.46, green: 0.61, blue: 0.71, alpha: 1.00).cgColor,UIColor(red: 1.00, green: 0.89, blue: 0.94, alpha: 1.00).cgColor]
					//769cb6
					//ffe4f0
				} else if GlobalVars.weatherList == 1 {
					gradColors = [UIColor(red: 0.27, green: 0.44, blue: 0.59, alpha: 1.00).cgColor,UIColor(red: 0.64, green: 0.48, blue: 0.55, alpha: 1.00).cgColor]
					//446f96
					//a27b8c
				}
				sceneryImageView.setGifImage(gif, loopCount: -1)
				gradient.colors = gradColors
			}catch{print(error)}
		} else if((GlobalVars.hour >= 22) || (GlobalVars.hour <= 5)){//Night
			do{
				var gif = try UIImage(gifName: "night.gif")
				var gradColors:[CGColor] = [UIColor(red: 0.08, green: 0.27, blue: 0.59, alpha: 1).cgColor, UIColor(red: 0.00, green: 0.20, blue: 0.29, alpha: 1).cgColor]
				//144596
				//00334a
				if GlobalVars.weatherList == 2 {
					gif = try UIImage(gifName: "night snow.gif")
					gradColors = [UIColor(red: 0.55, green: 0.59, blue: 0.60, alpha: 1.00).cgColor,UIColor(red: 0.18, green: 0.30, blue: 0.44, alpha: 1.00).cgColor]
					//8B9699
					//2E4D70
				} else if GlobalVars.weatherList == 1 {
					gradColors = [UIColor(red: 0.00, green: 0.12, blue: 0.17, alpha: 1.00).cgColor,UIColor(red: 0.05, green: 0.18, blue: 0.39, alpha: 1.00).cgColor]
					//0D2E63
					//001E2B
				}
				sceneryImageView.setGifImage(gif, loopCount: -1)
				gradient.colors = gradColors
			}catch{print(error)}
		} else if((GlobalVars.hour >= 6) && (GlobalVars.hour <= 7)){//Sunrise
			do{
				var gif = try UIImage(gifName: "day.gif")
				var gradColors:[CGColor] = [UIColor(red: 0.02, green: 0.26, blue: 0.49, alpha: 1).cgColor, UIColor(red: 0.89, green: 0.68, blue: 0.60, alpha: 1).cgColor]
				//05427D
				//e3ad99
				if GlobalVars.weatherList == 2 {
					gif = try UIImage(gifName: "day snow.gif")
					gradColors = [UIColor(red: 0.50, green: 0.61, blue: 0.72, alpha: 1.00).cgColor,UIColor(red: 0.94, green: 0.87, blue: 0.84, alpha: 1.00).cgColor]
					//809CB7
					//EFDDD7
				} else if GlobalVars.weatherList == 1 {
					gradColors = [UIColor(red: 0.14, green: 0.25, blue: 0.36, alpha: 1.00).cgColor,UIColor(red: 0.54, green: 0.41, blue: 0.36, alpha: 1.00).cgColor]
					//23405C
					//8A685C
				}
				sceneryImageView.setGifImage(gif, loopCount: -1)
				gradient.colors = gradColors
			}catch{print(error)}
		}
		
		gradient.locations =  [0.00, 1.00]
		
		gradientView.layer.addSublayer(gradient)*/
		
		
		
		
		
		// MARK: CHANGE TAB BAR IMAGE
		//navigationController?.navigationBar.setBackgroundImage(UIImage(imageLiteralResourceName: "snowgrass"), for: UIBarMetrics.default)
		
		print("list is supposed to be \(GlobalVars.selectedList) in home screen")
		print("weather list is supposed to be \(GlobalVars.weatherList) in home screen")
		weatherControl.selectedSegmentIndex = GlobalVars.weatherList
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
		gradientView.layer.sublayers?.forEach { $0.removeFromSuperlayer() }
		do {try defaults.setObject(GlobalVars.musicSelection, forKey: "savedMusicSelection")} catch {/*print(error.localizedDescription)*/}
		do {try defaults.setObject(GlobalVars.musicSelectionID, forKey: "savedMusicSelectionID")} catch {/*print(error.localizedDescription)*/}
		do {try defaults.setObject(GlobalVars.musicFileURL, forKey: "savedMusicFileURL")} catch {/*print(error.localizedDescription)*/}
		do {try defaults.setObject(GlobalVars.musicFormatType, forKey: "savedMusicFileType")} catch {/*print(error.localizedDescription)*/}
	}
	
	@IBOutlet weak var controlButton: UIButton!
	
	@IBOutlet var PlayButtonSize: NSLayoutConstraint!
	
	
	@IBAction func play(_ sender: Any) {
		
		musicHandler.updateMusic()
		if(!GlobalVars.musicStarted){
			
			
			GlobalVars.musicStarted = true
			if GlobalVars.currentMusicFormat {
				musicPlayer.play()
			} else {
				audioPlayer.play()
			}
			
			controlButton.accessibilityLabel = "Pause Button"
			controlButton.setBackgroundImage(UIImage(systemName: "pause.circle"), for: UIControl.State.normal)
			UIView.animate(withDuration: 0.4,delay:0,usingSpringWithDamping: 0.5,initialSpringVelocity: 0,animations: {self.PlayButtonSize.constant = 130;self.view.layoutIfNeeded()}, completion: nil)
			print("Music started: \(GlobalVars.musicStarted)")
		} else{

			GlobalVars.musicStarted = false
			audioPlayer.stop()
			musicPlayer.stop()
			
			
			controlButton.accessibilityLabel = "Play Button"
			controlButton.setBackgroundImage(UIImage(systemName: "play.circle"), for: UIControl.State.normal)
			UIView.animate(withDuration: 0.4, delay: 0,usingSpringWithDamping: 0.5,initialSpringVelocity: 0,animations: {self.PlayButtonSize.constant = 90;self.view.layoutIfNeeded()}, completion: nil)
			print("Music started: \(GlobalVars.musicStarted)")
		}
		musicHandler.updateMusic()
		var nowPlayingString:String = "Now Playing: "
		if (musicPlayer.playbackState == MPMusicPlaybackState.playing) {
		
		if GlobalVars.musicSelectionID[GlobalVars.selectedMusicList][GlobalVars.hour] != 0 {
			nowPlayingString.append(GlobalVars.musicSelection[GlobalVars.selectedMusicList][GlobalVars.hour])
		} else {
			var searchID:UInt64 = 0
			GlobalVars.searchHour = GlobalVars.hour
			while (searchID == 0) {
				if(GlobalVars.searchHour > 0){
					GlobalVars.searchHour -= 1
				} else {
					GlobalVars.searchHour = 23
				}
				if(GlobalVars.searchHour == GlobalVars.hour){
					//print("no songs found!")
					break
				}
				//print("searching ", searchHour)
				searchID = GlobalVars.musicSelectionID[GlobalVars.selectedMusicList][GlobalVars.searchHour]
				
				//print(searchID)
			}
			nowPlayingString.append(GlobalVars.musicSelection[GlobalVars.selectedMusicList][GlobalVars.searchHour])
		}
		
		/*switch GlobalVars.selectedMusicList {
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
		}*/
		songLabel.text = nowPlayingString
		}
		else if (audioPlayer.isPlaying) {
			if GlobalVars.musicFileURL[GlobalVars.selectedMusicList][GlobalVars.hour] != "" {
				nowPlayingString.append(GlobalVars.musicSelection[GlobalVars.selectedMusicList][GlobalVars.hour])
			} else {
				var searchURL:String = ""
				GlobalVars.searchHour = GlobalVars.hour
				while (searchURL == "") {
					if(GlobalVars.searchHour > 0){
						GlobalVars.searchHour -= 1
					} else {
						GlobalVars.searchHour = 23
					}
					if(GlobalVars.searchHour == GlobalVars.hour){
						//print("no songs found!")
						break
					}
					//print("searching ", searchHour)
					searchURL = GlobalVars.musicFileURL[GlobalVars.selectedMusicList][GlobalVars.searchHour]
					
					//print(searchID)
				}
				nowPlayingString.append(GlobalVars.musicSelection[GlobalVars.selectedMusicList][GlobalVars.searchHour])
			}
		}
		else {
			songLabel.text = ""
		}
	}
	
	
	@IBOutlet var weatherControl: UISegmentedControl!
	
	@IBOutlet var barbutton: UITabBarItem!
	
	
	@IBAction func weatherControlChanged(_ sender: Any) {
		
		MPMusicPlayerController.applicationMusicPlayer.stop()
		audioPlayer.stop()
		musicPlayer.stop()
		var list = GlobalVars.selectedList
		if weatherControl.selectedSegmentIndex == 0 {
			let backImg: UIImage = UIImage(named: "grass")!
			self.tabBarController?.tabBar.backgroundImage = backImg
			self.tabBarController?.tabBar.tintColor = UIColor(red: 0.86, green: 0.69, blue: 0.24, alpha: 1.00)
			removeAllEffects()
		} else if weatherControl.selectedSegmentIndex == 1 {
			list = list + 5
			let backImg: UIImage = UIImage(named: "grass")!
			self.tabBarController?.tabBar.backgroundImage = backImg
			self.tabBarController?.tabBar.tintColor = UIColor(red: 0.86, green: 0.69, blue: 0.24, alpha: 1.00)
			showRain()
		} else if weatherControl.selectedSegmentIndex == 2 {
			list = list + 10
			let backImg: UIImage = UIImage(named: "grasssnow")!
			self.tabBarController?.tabBar.backgroundImage = backImg
			self.tabBarController?.tabBar.tintColor = UIColor(red: 0.12, green: 0.54, blue: 0.61, alpha: 1.00)
			showSnowflakes()
		}
		
		GlobalVars.selectedMusicList = list
		GlobalVars.weatherList = weatherControl.selectedSegmentIndex
		
		updateGradientAndView()
		
		
		
		/*
		if((GlobalVars.hour >= 8) && (GlobalVars.hour <= 19)){ //Daytime
			//print("day")
			do{
				var gif = try UIImage(gifName: "day.gif")
				if GlobalVars.weatherList == 2 {
					gif = try UIImage(gifName: "day snow.gif")
				}
				sceneryImageView.setGifImage(gif, loopCount: -1)
			}catch{print(error)}
		} else if((GlobalVars.hour >= 20) && (GlobalVars.hour <= 21)){//Sunset
			do{
				var gif = try UIImage(gifName: "day.gif")
				if GlobalVars.weatherList == 2 {
					gif = try UIImage(gifName: "day snow.gif")
				}
				sceneryImageView.setGifImage(gif, loopCount: -1)
			}catch{print(error)}
		} else if((GlobalVars.hour >= 22) || (GlobalVars.hour <= 5)){//Night
			//print("night")
			do{
				var gif = try UIImage(gifName: "night.gif")
				if GlobalVars.weatherList == 2 {
					gif = try UIImage(gifName: "night snow.gif")
				}
				sceneryImageView.setGifImage(gif, loopCount: -1)
			}catch{print(error)}
		} else if((GlobalVars.hour >= 6) && (GlobalVars.hour <= 7)){//Sunrise
			do{
				var gif = try UIImage(gifName: "day.gif")
				if GlobalVars.weatherList == 2 {
					gif = try UIImage(gifName: "day snow.gif")
				}
				sceneryImageView.setGifImage(gif, loopCount: -1)
			}catch{print(error)}
		}
		*/
		
		
		
		
		
		
		print("selected playlist is \(list)")
		
		//defaults.set(list, forKey: "savedSelectedList")
		defaults.set(weatherControl.selectedSegmentIndex, forKey: "savedWeatherList")
		//print(GlobalVars.selectedMusicList)
		musicHandler.updateMusic()
		//print("updating")
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
	
	func updateGradientAndView(){
	let gradient = CAGradientLayer()
	gradient.frame = self.view.bounds
	//print("time: ", GlobalVars.hour)
	if((GlobalVars.hour >= 8) && (GlobalVars.hour <= 19)){ //Daytime
		do{
			var gif = try UIImage(gifName: "day.gif")
			var gradColors:[CGColor] = [UIColor(red: 0.39, green: 0.69, blue: 1.00, alpha: 1).cgColor, UIColor(red: 0.07, green: 0.45, blue: 0.87, alpha: 1).cgColor]
			//63b0ff
			//1273de
			if GlobalVars.weatherList == 2 {
				gif = try UIImage(gifName: "day snow.gif")
				gradColors = [UIColor(red: 0.91, green: 0.98, blue: 1.00, alpha: 1.00).cgColor,UIColor(red: 0.36, green: 0.60, blue: 0.87, alpha: 1.00).cgColor]
				//e8faff
				//5b99de
			} else if GlobalVars.weatherList == 1 {
				//7da3ca
				//416594
				gradColors = [UIColor(red: 0.49, green: 0.64, blue: 0.79, alpha: 1.00).cgColor, UIColor(red: 0.25, green: 0.40, blue: 0.58, alpha: 1.00).cgColor]
			}
			sceneryImageView.setGifImage(gif, loopCount: -1)
			gradient.colors = gradColors
		}catch{print(error)}
	} else if((GlobalVars.hour >= 20) && (GlobalVars.hour <= 21)){//Sunset
		do{
			var gif = try UIImage(gifName: "day.gif")
			var gradColors:[CGColor] = [UIColor(red: 0.00, green: 0.31, blue: 0.59, alpha: 1).cgColor, UIColor(red: 1.00, green: 0.78, blue: 0.88, alpha: 1).cgColor]
			//004f96
			//ffc7e0
			if GlobalVars.weatherList == 2 {
				gif = try UIImage(gifName: "day snow.gif")
				gradColors = [UIColor(red: 0.46, green: 0.61, blue: 0.71, alpha: 1.00).cgColor,UIColor(red: 1.00, green: 0.89, blue: 0.94, alpha: 1.00).cgColor]
				//769cb6
				//ffe4f0
			} else if GlobalVars.weatherList == 1 {
				gradColors = [UIColor(red: 0.27, green: 0.44, blue: 0.59, alpha: 1.00).cgColor,UIColor(red: 0.64, green: 0.48, blue: 0.55, alpha: 1.00).cgColor]
				//446f96
				//a27b8c
			}
			sceneryImageView.setGifImage(gif, loopCount: -1)
			gradient.colors = gradColors
		}catch{print(error)}
	} else if((GlobalVars.hour >= 22) || (GlobalVars.hour <= 5)){//Night
		do{
			var gif = try UIImage(gifName: "night.gif")
			var gradColors:[CGColor] = [UIColor(red: 0.08, green: 0.27, blue: 0.59, alpha: 1).cgColor, UIColor(red: 0.00, green: 0.20, blue: 0.29, alpha: 1).cgColor]
			//144596
			//00334a
			if GlobalVars.weatherList == 2 {
				gif = try UIImage(gifName: "night snow.gif")
				gradColors = [UIColor(red: 0.55, green: 0.59, blue: 0.60, alpha: 1.00).cgColor,UIColor(red: 0.18, green: 0.30, blue: 0.44, alpha: 1.00).cgColor]
				//8B9699
				//2E4D70
			} else if GlobalVars.weatherList == 1 {
				gradColors = [UIColor(red: 0.00, green: 0.12, blue: 0.17, alpha: 1.00).cgColor,UIColor(red: 0.05, green: 0.18, blue: 0.39, alpha: 1.00).cgColor]
				//0D2E63
				//001E2B
			}
			sceneryImageView.setGifImage(gif, loopCount: -1)
			gradient.colors = gradColors
		}catch{print(error)}
	} else if((GlobalVars.hour >= 6) && (GlobalVars.hour <= 7)){//Sunrise
		do{
			var gif = try UIImage(gifName: "day.gif")
			var gradColors:[CGColor] = [UIColor(red: 0.02, green: 0.26, blue: 0.49, alpha: 1).cgColor, UIColor(red: 0.89, green: 0.68, blue: 0.60, alpha: 1).cgColor]
			//05427D
			//e3ad99
			if GlobalVars.weatherList == 2 {
				gif = try UIImage(gifName: "day snow.gif")
				gradColors = [UIColor(red: 0.50, green: 0.61, blue: 0.72, alpha: 1.00).cgColor,UIColor(red: 0.94, green: 0.87, blue: 0.84, alpha: 1.00).cgColor]
				//809CB7
				//EFDDD7
			} else if GlobalVars.weatherList == 1 {
				gradColors = [UIColor(red: 0.14, green: 0.25, blue: 0.36, alpha: 1.00).cgColor,UIColor(red: 0.54, green: 0.41, blue: 0.36, alpha: 1.00).cgColor]
				//23405C
				//8A685C
			}
			sceneryImageView.setGifImage(gif, loopCount: -1)
			gradient.colors = gradColors
		}catch{print(error)}
	}
	
	gradient.locations =  [0.00, 1.00]
	
	gradientView.layer.sublayers?.forEach { $0.removeFromSuperlayer() }
	gradientView.layer.addSublayer(gradient)
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
