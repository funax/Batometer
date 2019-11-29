//
//  ComplicationController.swift
//  Batometer WatchKit Extension
//
//  Created by Funada Takumi on 2019/11/23.
//  Copyright © 2019 Musashinodenpa. All rights reserved.
//

import ClockKit
import Combine
import SwiftUI

class ComplicationController: NSObject, CLKComplicationDataSource {
    
    @ObservedObject var sensor = SensorManager()
    
    func getSupportedTimeTravelDirections(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationTimeTravelDirections) -> Void) {
        handler([.forward, .backward])
    }
    
    func getTimelineStartDate(for complication: CLKComplication, withHandler handler: @escaping (Date?) -> Void) {
        handler(nil)
    }
    
    func getTimelineEndDate(for complication: CLKComplication, withHandler handler: @escaping (Date?) -> Void) {
        handler(nil)
    }
    
    func getPrivacyBehavior(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationPrivacyBehavior) -> Void) {
        handler(.showOnLockScreen)
    }
    
    // MARK: - Timeline Population
    
    func getCurrentTimelineEntry(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationTimelineEntry?) -> Void) {

        // https://qiita.com/MilanistaDev/items/6a09bb787d9eee509c0d
        switch complication.family {
        case .modularLarge:
            let t = CLKComplicationTemplateModularLargeStandardBody()
            let text1 = CLKSimpleTextProvider(text: "気圧")
            let text2 = CLKSimpleTextProvider(text: sensor.pressureString)
            let text3 = CLKSimpleTextProvider(text: sensor.timestampString)
            t.headerTextProvider = text1
            t.body1TextProvider = text2
            t.body2TextProvider = text3
            let entry = CLKComplicationTimelineEntry(date: Date(), complicationTemplate: t)
            handler(entry)
            
        case .graphicRectangular:
            // headerImageProvider(nil可), headerTextProvider, body1TextProvider,  gaugeProviderが必要
            let rectangularTemplate = CLKComplicationTemplateGraphicRectangularTextGauge()

            let headerText = CLKSimpleTextProvider(text: "テスト")
            headerText.tintColor = UIColor(red: 116.0/255.0, green: 192.0/255.0, blue: 58.0/255.0, alpha: 1.0)
            rectangularTemplate.headerTextProvider = headerText

            let bodyText = CLKSimpleTextProvider(text: "残タスク：1")
            bodyText.tintColor = .white
            rectangularTemplate.body1TextProvider = bodyText

            let gaugeColor = UIColor(red: 116.0/255.0, green: 192.0/255.0, blue: 58.0/255.0, alpha: 1.0)
            let gaugeProvider =
                CLKSimpleGaugeProvider(style: .fill, gaugeColor: gaugeColor, fillFraction: 0.5)
            rectangularTemplate.gaugeProvider = gaugeProvider
            // 用意したTemplateをセット
            let entry = CLKComplicationTimelineEntry(date: Date(), complicationTemplate: rectangularTemplate)
            handler(entry)
        default:
            handler(nil)
        }
    }
    
    func getTimelineEntries(for complication: CLKComplication, before date: Date, limit: Int, withHandler handler: @escaping ([CLKComplicationTimelineEntry]?) -> Void) {
        // Call the handler with the timeline entries prior to the given date
        handler(nil)
    }
    
    func getTimelineEntries(for complication: CLKComplication, after date: Date, limit: Int, withHandler handler: @escaping ([CLKComplicationTimelineEntry]?) -> Void) {
        // Call the handler with the timeline entries after to the given date
        handler(nil)
    }
    
    // MARK: - Placeholder Templates
    
    func getLocalizableSampleTemplate(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationTemplate?) -> Void) {
        // This method will be called once per supported complication, and the results will be cached
        handler(nil)
    }
}
