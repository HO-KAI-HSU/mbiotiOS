//
//  SettingsBundleHelper.swift
//  SwiftProject2
//
//  Created by georgeHsu on 2024/5/19.
//

import Foundation
class SettingsBundleHelper {
    
    static var mainBundleDict: [String: Any]?
    static let userDefaults = UserDefaults.standard
    
    // Bundle Key Structure
    struct SettingsBundleKeys {
        static let title = "title"
        static let urlKey = "url_preference"
        static let userKey = "key_preference"
    }
    
    // Setting main bundle
    @objc static func setMainBundle() {
        if mainBundleDict == nil {
            if let dict = Bundle.main.infoDictionary {
                mainBundleDict = dict
            }
        }
    }
    
    static func setBuildInfo() {
            let appUrl = userDefaults.value(forKey: SettingsBundleKeys.urlKey)
            userDefaults.set(appUrl, forKey: SettingsBundleKeys.urlKey)
        }
    
    static func configureSettingsBundle() {
            
        guard let settingsBundle = Bundle.main.url(forResource: "Settings", withExtension:"bundle") else {
        print("Settings.bundle not found")
        return;
        }
        
        guard let settings = NSDictionary(contentsOf: settingsBundle.appendingPathComponent("Root.plist")) else {
            print("Root.plist not found in settings bundle")
            return
        }
        
        guard let preferences = settings.object(forKey: "PreferenceSpecifiers") as? [[String: AnyObject]] else {
            print("Root.plist has invalid format")
            return
        }
        
        var defaultsToRegister = [String: AnyObject]()
        for pref in preferences {
            if let key = pref["Key"] as? String, let val = pref["DefaultValue"] {
                print("\(key)==> \(val)")
                defaultsToRegister[key] = val
                userDefaults.set(val, forKey: key)
            }
        }
    }
}



