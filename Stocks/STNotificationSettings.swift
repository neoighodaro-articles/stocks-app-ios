//
//  Settings.swift
//  Stocks
//
//  Created by Neo Ighodaro on 03/09/2018.
//  Copyright © 2018 TapSharp. All rights reserved.
//

import Foundation

class STNotificationSettings: NSObject {
    
    static let KEY = "ST_NOTIFICATIONS"
    static let shared = STNotificationSettings()
    
    private override init() {}
    
    private var settings: [String: Bool] {
        get {
            let key = STNotificationSettings.KEY
            
            if let settings = UserDefaults.standard.object(forKey: key) as? [String: Bool] {
                return settings
            }
            
            return [:]
        }
        set(newValue) {
            var settings: [String: Bool] = [:]
            
            for (k, v) in newValue {
                settings[k.uppercased()] = v
            }
            
            UserDefaults.standard.set(settings, forKey: STNotificationSettings.KEY)
        }
    }
    
    /// Checks if push notification is enabled for stock
    func enabled(for stock: String) -> Bool {
        if let stock = settings.first(where: { $0.key == stock.uppercased() }) {
            return stock.value
        }
        
        return false
    }
    
    /// Save new settings
    func save(stock: String, enabled: Bool) {
        settings[stock.uppercased()] = enabled
    }
}
