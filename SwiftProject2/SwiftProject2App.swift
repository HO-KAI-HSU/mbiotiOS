//
//  SwiftProject2App.swift
//  SwiftProject2
//
//  Created by georgeHsu on 2023/8/14.
//

import SwiftUI

@main
struct SwiftProject2App: App {
    
    var body: some Scene {
        
        let userDefault = UserDefaults.standard
        let aes = AesUtilHelper(keyString: "1qaz2wsx1234")
        let url = userDefault.string(forKey: "url_preference") ?? ""
        let key = userDefault.string(forKey: "key_preference") ?? ""
        
        WindowGroup {
            IndexView(userSetting: .constant(UserSeting(url: url, userKey:key, uuid:"", isAuth: false)),
                      aes: .constant(aes))
                .onReceive(NotificationCenter.default.publisher(for: UIApplication.didBecomeActiveNotification)) { (_) in
                    SettingsBundleHelper.configureSettingsBundle()
                    print("UIApplication: active")
                }
            
        }
    }
}
