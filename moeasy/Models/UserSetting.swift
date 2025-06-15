//
//  UserSetting.swift
//  SwiftProject2
//
//  Created by georgeHsu on 2025/5/4.
//

import Foundation

struct UserSeting {
    var title : String
    var url : String
    var userKey : String
    var uuid : String
    var isAuth : Bool
    
    init (title : String, url : String, userKey : String, uuid : String, isAuth : Bool) {
        self.title = title
        self.url = url
        self.userKey = userKey
        self.uuid = uuid
        self.isAuth = isAuth
    }
    
    init () {
        self.init(title : "", url: "", userKey: "", uuid : "", isAuth: false)
    }
}
