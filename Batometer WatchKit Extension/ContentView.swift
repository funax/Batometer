//  ContentView.swift
//  Batometer WatchKit Extension
//  Created by Funada Takumi on 2019/11/23.
//  Copyright © 2019 Musashinodenpa. All rights reserved.

import SwiftUI
import Combine
import CoreMotion

struct ContentView: View {
    @ObservedObject var sensor = SensorManager.shared
    let availabe = CMAltimeter.isRelativeAltitudeAvailable()

    var body: some View {
        VStack {
            Text(availabe ? sensor.pressureString : "reading...")
            Text(availabe ? sensor.timestampString : "reading...")
            Button(action: { self.sensor.restart() }) {
                Text("Restart")
            }.frame(width: CGFloat(80.0), height: CGFloat(28.0))
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
