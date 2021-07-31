//
//  SecondViewController.swift
//  grandfatherrock
//
//  Created by Micah Gomez on 4/15/20.
//  Copyright © 2020 Micah Gomez. All rights reserved.
//

import UIKit
import Zip
import SwiftyJSON
import MediaPlayer

class fileDataCell : UITableViewCell {
	
	@IBOutlet weak var filetypeLabel: UILabel!
	@IBOutlet weak var filenameLabel : UILabel!
	
}

extension FileManager {
	func urls(for directory: FileManager.SearchPathDirectory, skipsHiddenFiles: Bool = true ) -> [URL]? {
		let documentsURL = urls(for: directory, in: .userDomainMask)[0]
		let fileURLs = try? contentsOfDirectory(at: documentsURL, includingPropertiesForKeys: nil, options: skipsHiddenFiles ? .skipsHiddenFiles : [] )
		
		return fileURLs
	}
}

class FourthViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, MPMediaPickerControllerDelegate {
	var refreshControl = UIRefreshControl()
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		var resourcesContent = FileManager.default.urls(for: .documentDirectory) ?? []
		resourcesContent.sort {
			$0.lastPathComponent < $1.lastPathComponent
		}
		
		print(FileManager.default.urls(for: .documentDirectory) ?? "none")
		
		return resourcesContent.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "filecell", for: indexPath) as! fileDataCell
		
		var resourcesContent = FileManager.default.urls(for: .documentDirectory) ?? []
		resourcesContent.sort {
			$0.lastPathComponent < $1.lastPathComponent
		}
		
		cell.filenameLabel?.text = resourcesContent[indexPath.row].lastPathComponent
		cell.filetypeLabel?.text = resourcesContent[indexPath.row].pathExtension
		cell.selectionStyle = .none
		return cell
	}
	
	func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool
	{
		return true
	}
	
	func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath){
		var resourcesContent = FileManager.default.urls(for: .documentDirectory) ?? []
		resourcesContent.sort {
			$0.lastPathComponent < $1.lastPathComponent
		}
		
		let dirs : [String] = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.allDomainsMask, true)
		let filePathToDelete = dirs[0].appendingFormat("/" + resourcesContent[indexPath.row].lastPathComponent)
		let fileManager = FileManager.default
		
		if editingStyle == .delete
		{
			do {
				
				//Check if file exists
				if fileManager.fileExists(atPath: filePathToDelete) {
					//Delete file
					try fileManager.removeItem(atPath: filePathToDelete)
				} else {
					print("File does not exist: \(resourcesContent[indexPath.row].absoluteString)")
				}
				
			}
			catch let error as NSError {
				print("An error took place: \(error)")
			}
			filesTable.reloadData()
		}
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
		var resourcesContent = FileManager.default.urls(for: .documentDirectory) ?? []
		resourcesContent.sort {
			$0.lastPathComponent < $1.lastPathComponent
		}
		print(resourcesContent[indexPath.row].lastPathComponent)
		print(resourcesContent[indexPath.row])
		GlobalVars.musicSelection[GlobalVars.selectedMusicList][GlobalVars.selectedCell!] = resourcesContent[indexPath.row].lastPathComponent
		GlobalVars.musicSelectionID[GlobalVars.selectedMusicList][GlobalVars.selectedCell!] = 0
		GlobalVars.musicFileURL[GlobalVars.selectedMusicList][GlobalVars.selectedCell!] = resourcesContent[indexPath.row].lastPathComponent
		//print("PATH FROM IS \(resourcesContent[indexPath.row].absoluteString)")
		print("PATH SAVED IS \(GlobalVars.musicFileURL[GlobalVars.selectedMusicList][GlobalVars.selectedCell!])")
		GlobalVars.musicFormatType[GlobalVars.selectedMusicList][GlobalVars.selectedCell!] = false
		GlobalVars.selectedCell = nil
		self.dismiss(animated: true, completion: nil)
	}
	
	let defaults = UserDefaults.standard
	
	@IBOutlet var filesTable: UITableView!
	
	@IBOutlet var gradientView: UIView!
	
	@IBOutlet var selectListControl: UISegmentedControl!
	
	@IBAction func selectListControlChanged(_ sender: Any) {
		
		MPMusicPlayerController.applicationMusicPlayer.stop()
		
		GlobalVars.selectedMusicList = selectListControl.selectedSegmentIndex
		//print(GlobalVars.selectedMusicList)
		filesTable.reloadData()
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
		
		filesTable.delegate = self
		filesTable.dataSource = self
		
		filesTable.alwaysBounceVertical = true
		let refresher = UIRefreshControl()
		refresher.addTarget(self, action: #selector(refreshStream), for: .valueChanged)

		refreshControl = refresher
		filesTable.addSubview(refreshControl)
	}
	
	@objc func refreshStream() {

		print("refresh")
		filesTable?.reloadData()

		refreshControl.endRefreshing()

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
		
		/*switch GlobalVars.selectedMusicList {
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
		}*/
	}
	
	override func viewDidDisappear(_ animated: Bool) {
		gradientView.layer.sublayers?.forEach { $0.removeFromSuperlayer() }
	}

	@IBAction func importPopup(_ sender: Any) {
		
		//1. Create the alert controller.
		let alert = UIAlertController(title: "Download Music", message: "Enter a link to an MP3, ZIP, or properly formatted JSON file \n If your files aren't visible after entering the link, try pulling down to refresh", preferredStyle: .alert)

		//2. Add the text field. You can configure it however you need.
		alert.addTextField { (textField) in
			textField.text = "https://downloads.khinsider.com"
		}

		// 3. Grab the value from the text field, and print it when the user clicks OK.
		alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {_ in
			let textField = alert.textFields![0] // Force unwrapping because we know it exists.
			print("Text field: \(textField.text)")
			
			if (!textField.text!.isEmpty) {
				let fileURL = URL(string: textField.text!)
				let sessionConfig = URLSessionConfiguration.default
				let session = URLSession(configuration: sessionConfig)
				
				let request = URLRequest(url:fileURL!)
				
				
				if ((fileURL?.pathExtension == "mp3") || (fileURL?.pathExtension == "zip")) {
					let documentsUrl:URL =  (FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!) as URL
					let destinationFileUrl = documentsUrl.appendingPathComponent(fileURL?.lastPathComponent ?? "fileerr")
					
					self.downloadSong(request: request, destination: destinationFileUrl, runFrom: "Default")
					
				} else if (fileURL?.pathExtension == "json") {
					
					print("file is json")
					
					let documentsUrl:URL =  (FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!) as URL
					
					let task = session.dataTask(with: request) { (data, response, error) in
						if error == nil {
							do{
								let jsonData = try JSON(data: data!)
								print(jsonData)
								//print(jsonURL)
								for (index,subJson):(String, JSON) in jsonData {
									let hour:Int = subJson["hour"].intValue
									print(hour)
									let url:URL = subJson["url"].url!
									//let url:URL = URL(fileURLWithPath: urlAsString)
									let urlRequest = URLRequest(url:url)
									print(url)
									
									var DLHourPadding:String = ""
									
									if(hour < 10){
										DLHourPadding = "0"
									}
									
									let destinationFileUrl = documentsUrl.appendingPathComponent((fileURL!.deletingPathExtension().lastPathComponent) + " - " + DLHourPadding + String(hour) + " - " + url.lastPathComponent)
									print(destinationFileUrl)
									self.downloadSong(request: urlRequest, destination: destinationFileUrl, runFrom: "JSON")
									
									GlobalVars.musicFormatType[GlobalVars.selectedMusicList][hour] = false
									GlobalVars.musicSelectionID[GlobalVars.selectedMusicList][hour] = 0
									GlobalVars.musicSelection[GlobalVars.selectedMusicList][hour] = destinationFileUrl.lastPathComponent
									GlobalVars.musicFileURL[GlobalVars.selectedMusicList][hour] = destinationFileUrl.lastPathComponent
								}
								
							}
							catch {
								print(error)
							}
						}
					}
					task.resume()
					
					
				} else {
					let unsupportedAlert = UIAlertController(title: "", message: "Please make sure your url links to an mp3, zip, or json file", preferredStyle: UIAlertController.Style.alert)
					unsupportedAlert.addAction(UIAlertAction(title: "Okay", style: UIAlertAction.Style.default, handler: nil))
					self.present(unsupportedAlert, animated: true, completion: nil)
				}
				
			}
			
		}))

		// 4. Present the alert.
		self.present(alert, animated: true, completion: nil)
		
	}
	
	@IBAction func close(_ sender: Any) {
		dismiss(animated: true)
	}
	
	func downloadSong(request:URLRequest,destination:URL,runFrom:String) -> Void {
		let sessionConfig = URLSessionConfiguration.default
		let session = URLSession(configuration: sessionConfig)
		let task = session.downloadTask(with: request) { (tempLocalUrl, response, error) in
			if let tempLocalUrl = tempLocalUrl, error == nil {
				
				do {
					try FileManager.default.copyItem(at: tempLocalUrl, to: destination)
				} catch (let writeError) {
					print("Error creating a file \(destination) : \(writeError)")
					DispatchQueue.main.async {
						let writeErrAlert = UIAlertController(title: "Error Saving File '\(destination.lastPathComponent)'", message: "Check to make sure another file with the same name doesn't already exist", preferredStyle: UIAlertController.Style.alert)
						writeErrAlert.addAction(UIAlertAction(title: "Okay", style: UIAlertAction.Style.default, handler: nil))
						self.present(writeErrAlert, animated: true, completion: nil)
						self.filesTable.reloadData()
					}
				}
				// Success
				if (runFrom == "Default") {
				if let statusCode = (response as? HTTPURLResponse)?.statusCode {
					print("Successfully downloaded. Status code: \(statusCode)")
					DispatchQueue.main.async {
						let dlAlert = UIAlertController(title: "Successfully Downloaded", message: "\(destination.lastPathComponent)", preferredStyle: UIAlertController.Style.alert)
						dlAlert.addAction(UIAlertAction(title: "Okay", style: UIAlertAction.Style.default, handler: nil))
						self.present(dlAlert, animated: true, completion: nil)
						self.filesTable.reloadData()
					}
				}
				}
			} else {
				print("Error took place while downloading a file. Error description: %@", error?.localizedDescription as Any);
				DispatchQueue.main.async {
					let networkErrAlert = UIAlertController(title: "Error Downloading File '\(destination.lastPathComponent)'", message: "Check to make sure your internet connection is stable and that the URL is correct", preferredStyle: UIAlertController.Style.alert)
					networkErrAlert.addAction(UIAlertAction(title: "Okay", style: UIAlertAction.Style.default, handler: nil))
					self.present(networkErrAlert, animated: true, completion: nil)
					self.filesTable.reloadData()
				}
			}
			
			if destination.pathExtension == "zip" {
				print("it's a zip!")
				
				if runFrom == "Default" {
					let dirs : [String] = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.allDomainsMask, true)
					let filePathToDelete = dirs[0].appendingFormat("/" + destination.lastPathComponent)
					
					do {
						//let unzipDirectory = try Zip.quickUnzipFile(destination) // Unzip
						let unzipDirectory = try Zip.unzipFile(destination, destination: URL(fileURLWithPath: dirs[0]), overwrite: false, password: nil)
					}
					catch {
						print("Something went wrong: \(error)")
					}
					
					do {
						let fileManager = FileManager.default
						
						// Check if file exists
						if fileManager.fileExists(atPath: filePathToDelete) {
							// Delete file
							try fileManager.removeItem(atPath: filePathToDelete)
						} else {
							print("File does not exist")
						}
					}
					catch let error as NSError {
						print("An error took place: \(error)")
					}
				} else if runFrom == "JSON" {
					print("Cannot download zip in json!")
				}
				
			}
		}
		task.resume()
	}
	
}

