//
//  hswidget.swift
//  hswidget
//
//  Created by Micah Gomez on 9/17/20.
//  Copyright © 2020 Micah Gomez. All rights reserved.
//

import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
	func placeholder(in context: Context) -> SimpleEntry {
		return SimpleEntry(date: Date(), hour: hourString(), c1: getC1(), c2: getC2(), sceneAsset: getSceneAsset())
	}

	func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
		let entry = SimpleEntry(date: Date(), hour: hourString(), c1: getC1(), c2: getC2(), sceneAsset: getSceneAsset())
		completion(entry)
	}

	func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
		var entries: [SimpleEntry] = []

		// Generate a timeline consisting of five entries an hour apart, starting from the current date.
		let currentDate = Date()
		for hourOffset in 0 ..< 5 {
			let entryDate = Calendar.current.date(byAdding: .minute, value: hourOffset*5, to: currentDate)!
			let entry = SimpleEntry(date: entryDate, hour: hourString(), c1: getC1(), c2: getC2(), sceneAsset: getSceneAsset())
			entries.append(entry)
		}

		let timeline = Timeline(entries: entries, policy: .atEnd)
		completion(timeline)
	}
	
	func hourString() -> String {
		let currentHour = Calendar.current.component(.hour, from: Date())
		var rowHour:Int = 12
		var hourString = String(rowHour)
		hourString.append(" AM")

		if (currentHour < 12) && (currentHour > 0) {
			rowHour = currentHour
			hourString = String(rowHour)
			hourString.append(" AM")
		} else if (currentHour > 11) {
			rowHour = currentHour
			if (currentHour > 12){
				rowHour = rowHour - 12
			}
			hourString = String(rowHour)
			hourString.append(" PM")
		}
		return hourString
	}
	
	func getC1() -> Color {
		var c1:Color = Color.white
		if((Calendar.current.component(.hour, from: Date()) >= 8) && (Calendar.current.component(.hour, from: Date()) <= 19)){ //Daytime
			print("day")
			c1 = Color(red: 0.39, green: 0.69, blue: 1.00)
		} else if((Calendar.current.component(.hour, from: Date()) >= 20) && (Calendar.current.component(.hour, from: Date()) <= 21)){//Sunset
			print("sunset")
			c1 = Color(red: 0.00, green: 0.31, blue: 0.59)
		} else if((Calendar.current.component(.hour, from: Date()) >= 22) || (Calendar.current.component(.hour, from: Date()) <= 5)){//Night
			print("night")
			c1 = Color(red: 0.08, green: 0.27, blue: 0.59)
		} else if((Calendar.current.component(.hour, from: Date()) >= 6) && (Calendar.current.component(.hour, from: Date()) <= 7)){//Sunrise
			print("sunrise")
			c1 = Color(red: 0.02, green: 0.26, blue: 0.49)
		}
		return c1
	}
	
	func getC2() -> Color {
		var c2:Color = Color.white
		if((Calendar.current.component(.hour, from: Date()) >= 8) && (Calendar.current.component(.hour, from: Date()) <= 19)){ //Daytime
			print("day")
			c2 = Color(red: 0.07, green: 0.45, blue: 0.87)
		} else if((Calendar.current.component(.hour, from: Date()) >= 20) && (Calendar.current.component(.hour, from: Date()) <= 21)){//Sunset
			print("sunset")
			c2 = Color(red: 1.00, green: 0.78, blue: 0.88)
		} else if((Calendar.current.component(.hour, from: Date()) >= 22) || (Calendar.current.component(.hour, from: Date()) <= 5)){//Night
			print("night")
			c2 = Color(red: 0.00, green: 0.20, blue: 0.29)
		} else if((Calendar.current.component(.hour, from: Date()) >= 6) && (Calendar.current.component(.hour, from: Date()) <= 7)){//Sunrise
			print("sunrise")
			c2 = Color(red: 0.89, green: 0.68, blue: 0.60)
		}
		return c2
	}
	
	func getSceneAsset() -> String {
		var sceneAsset:String = "ACBackgroundDay"
		if((Calendar.current.component(.hour, from: Date()) >= 8) && (Calendar.current.component(.hour, from: Date()) <= 19)){ //Daytime
			print("day")
			sceneAsset = "ACBackgroundDay"
		} else if((Calendar.current.component(.hour, from: Date()) >= 20) && (Calendar.current.component(.hour, from: Date()) <= 21)){//Sunset
			print("sunset")
			sceneAsset = "ACBackgroundDay"
		} else if((Calendar.current.component(.hour, from: Date()) >= 22) || (Calendar.current.component(.hour, from: Date()) <= 5)){//Night
			print("night")
			sceneAsset = "ACBackgroundNight"
		} else if((Calendar.current.component(.hour, from: Date()) >= 6) && (Calendar.current.component(.hour, from: Date()) <= 7)){//Sunrise
			print("sunrise")
			sceneAsset = "ACBackgroundDay"
		}
		return sceneAsset
	}
}

struct SimpleEntry: TimelineEntry {
	let date: Date
	let hour: String
	//let hourInt: Int
	let c1:Color
	let c2:Color
	let sceneAsset:String
}

struct cardSmallView : View {
	var entry: Provider.Entry
	
	var body: some View {
		GeometryReader { geometry in
			VStack(alignment:.center){
				Spacer()
				Text(String(entry.hour))
					.font(Font.custom("FinkHeavy", size: 32))
					.foregroundColor(Color(red: 0.84, green: 0.69, blue: 0.33))
				Spacer()
				Image(entry.sceneAsset)
					.resizable()
					.scaledToFit()
				Spacer()
					.frame(height: 0)
				Image("grass")
					.resizable()
					.scaledToFit()
			}
			.background(LinearGradient(gradient: Gradient(colors: [entry.c1, entry.c2]), startPoint: .top, endPoint: .bottom))
			//.frame(width: geometry.size.width, height: geometry.size.height)
			.padding(.leading, -20)
			.padding(.trailing, -20)
		}
	}
}

struct cardMediumView : View {
	var entry: Provider.Entry
	
	var body: some View {
		GeometryReader { geometry in
			VStack(alignment:.center){
				HStack(){
					Spacer()
					VStack(){
						
						Spacer()
						Text(String(entry.hour))
							.font(Font.custom("FinkHeavy", size: 32))
							.foregroundColor(Color(red: 0.84, green: 0.69, blue: 0.33))
						Spacer()
					}
					Spacer()
					VStack(){
						Spacer()
						Image(entry.sceneAsset)
							.resizable()
							.scaledToFit()
							.frame(maxWidth: geometry.size.width/2)
					}
					Spacer()
				}
				Spacer()
					.frame(height: 0)
				Image("grass")
					.resizable()
					.scaledToFit()
			}
			.background(LinearGradient(gradient: Gradient(colors: [entry.c1, entry.c2]), startPoint: .top, endPoint: .bottom))
			//.frame(width: geometry.size.width, height: geometry.size.height)
			.padding(.leading, -20)
			.padding(.trailing, -20)
		}
	}
}

struct cardLargeView : View {
	var entry: Provider.Entry
	
	var body: some View {
		GeometryReader { geometry in
			VStack(alignment:.center){
				Spacer()
				Text(String(entry.hour))
					.font(Font.custom("FinkHeavy", size: 72))
					.foregroundColor(Color(red: 0.84, green: 0.69, blue: 0.33))
				Spacer()
				Image(entry.sceneAsset)
					.resizable()
					.scaledToFit()
				Spacer()
					.frame(height: 0)
				Image("grass")
					.resizable()
					.scaledToFit()
			}
			.background(LinearGradient(gradient: Gradient(colors: [entry.c1, entry.c2]), startPoint: .top, endPoint: .bottom))
			//.frame(width: geometry.size.width, height: geometry.size.height)
			.padding(.leading, -20)
			.padding(.trailing, -20)
		}
	}
}

struct detailsNotAvailable : View {
	var entry: Provider.Entry
	
	var body: some View{
		VStack{
			Text("Nothing Available")
		}
	}
}



struct hswidgetEntryView : View {
	var entry: Provider.Entry
	@Environment(\.widgetFamily) var family: WidgetFamily
	
	let dateFormatter = DateFormatter()
	
	var body: some View {
			ZStack
			{
				Group{
					switch family {
					case .systemSmall: cardSmallView(entry: entry)
					case .systemMedium: cardMediumView(entry: entry)
					case .systemLarge: cardLargeView(entry: entry)
					default: detailsNotAvailable(entry: entry)
							}
				}.padding(.horizontal)
			}
		}
}

@main
struct hswidget: Widget {
	let kind: String = "hswidget"

	var body: some WidgetConfiguration {
		StaticConfiguration(kind: kind, provider: Provider()) { entry in
			hswidgetEntryView(entry: entry)
		}
		.configurationDisplayName("AC Clock Widget")
		.description("Takes the hour and main screen view from AC Tape Deck and condences it to fit on your home screen.")
	}
}

struct hswidget_Previews: PreviewProvider {
	static var previews: some View {
		hswidgetEntryView(entry: SimpleEntry(date: Date(), hour: "3 PM", c1: Color(red: 0.39, green: 0.69, blue: 1.00), c2: Color(red: 0.07, green: 0.45, blue: 0.87), sceneAsset: "ACBackgroundDay"))
			.previewContext(WidgetPreviewContext(family: .systemSmall))
	}
}
