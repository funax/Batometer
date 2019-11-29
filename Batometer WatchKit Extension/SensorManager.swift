//
//  SensorManager.swift
//  Batometer WatchKit Extension
//
//  Created by Funada Takumi on 2019/11/24.
//  Copyright © 2019 Musashinodenpa. All rights reserved.
//
import Combine
import CoreMotion
import WatchKit

class SensorManager: NSObject, ObservableObject {
    static let shared = SensorManager()     //singleton
    
    let willChange = PassthroughSubject<Void, Never>()
    let formatter = DateFormatter()
    var altimeter:CMAltimeter?

    @Published var pressureString:String = "----hPa"
    @Published var timestampString:String = "--:--:--"
    var counter = 0

    override private init() {
        super.init()
        altimeter = CMAltimeter()
        let server = CLKComplicationServer.sharedInstance()
        server.activeComplications?.forEach(server.reloadTimeline)
        print("Reload TL required ")
        startUpdate()
    }

    func restart(){
        stopUpdate()
        startUpdate()
    }
    
    func stopUpdate() {
        altimeter?.stopRelativeAltitudeUpdates()
    }

    func startUpdate() {
        formatter.dateFormat = "HH:mm:ss"

        if(CMAltimeter.isRelativeAltitudeAvailable()) {
            altimeter!.startRelativeAltitudeUpdates(to: OperationQueue.main, withHandler: { data, error in
                if error == nil {
                    let pressure:Double = data!.pressure.doubleValue
                    self.counter += 1
                    self.pressureString = String(format: "%.2f hPa", pressure * 10)
                    self.timestampString = self.formatter.string(from: Date()) + String(format: " (%d)", self.counter)
                    
                    let server = CLKComplicationServer.sharedInstance()
                    server.activeComplications?.forEach(server.extendTimeline)
                    print("Extend TL required " + self.timestampString)
                    self.willChange.send()
                }
            })
        } else {
            self.pressureString = "no sensor"
            self.timestampString = formatter.string(from: Date())
            self.willChange.send()
        }
        let fireDate = Date(timeIntervalSinceNow: 60.0)
        let userInfo = ["reason" : "background update"] as NSDictionary
        WKExtension.shared().scheduleBackgroundRefresh(withPreferredDate: fireDate, userInfo: userInfo, scheduledCompletion: { (error) in
                if (error == nil) {
                    print("BG task scheduled " + self.formatter.string(from: Date()) + String(format: " (%d)", self.counter))
                }
            }
        )
    }
}
