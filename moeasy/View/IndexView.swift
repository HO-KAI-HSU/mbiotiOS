//
//  IndexView.swift
//  SwiftProject2
//
//  Created by georgeHsu on 2024/5/19.
//

import SwiftUI

struct IndexView: View {
    
    @Binding var userSetting : UserSeting
    @Binding var aes : AesUtilHelper
    @State private var checkUrlAndUserKeyOption = true
    @State private var enableSignIn = false
    @State private var showCopied = false
    
    var body: some View {
        NavigationStack {
            VStack {
                
                let title  = RefreshName()
                Text(title)
                    .fontWeight(.medium)
                    .font(.system(size: 32))
                    .foregroundStyle(.indigo)
                    .padding()
                
                Gap(height: 30)
                
                let uid = GetUuid()
                Text("請點擊複製以下代號，傳給合作廠商申請金鑰")
                    .fontWeight(.medium)
                    .font(.system(size: 16))
                    .multilineTextAlignment(.center)
                    .foregroundStyle(.white)
                    .disabled(/*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/)
                
                Button(action: {
                    let textToCopy = uid
                    UIPasteboard.general.string = textToCopy

                    // 顯示提示訊息
                    showCopied = true
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                        showCopied = false
                    }
                }) {
                    Text(uid)
                        .padding()
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(8)
                }

                if showCopied {
                    Text("✅ 已複製到剪貼簿")
                        .foregroundColor(.green)
                        .transition(.opacity)
                }
                
                Gap(height: 30)
                
                Button("登入系統") {
                    Refresh()
                }
                .frame(width: 300)
                .padding()
                .foregroundColor(.white)
                .background(Color.indigo)
                .cornerRadius(10)
                
                NavigationLink (
                    destination: SystemWebView(),
                    isActive: $enableSignIn) {
                    let _ = print("click!!")
                    let _ = print("isAuth: \(userSetting.isAuth)")
                    let _ = print("enableSignIn : \(enableSignIn)")
                }
            }
            .confirmationDialog("請確認您的網址與金鑰是否已設定完成", isPresented: $checkUrlAndUserKeyOption, titleVisibility: .visible) {
                Button("檢查") {
                    Refresh()
                    print("enableSignIn : \(enableSignIn)")
                    if !enableSignIn {
                        let _ = print("IndexView url : \(userSetting.url)")
                        let _ = print("IndexView uId : \(userSetting.uuid)")
                        OpenAppSettings()
                    }
                }
            }
//            .alert(isPresented: $enableSignIn) {
//                Alert(
//                    title: Text("驗證結果"),
//                    message: Text("金鑰已驗證. 可登入"),
//                    dismissButton: .default(Text("OK"))
//                )
//            }
            .padding(10)
        }
    }
    
    
    func GetUuid() -> String {
        if let uuid = UIDevice.current.identifierForVendor?.uuidString {
            print("Device UUID: \(uuid)")
            return uuid;
        }
        else {
            return ""
        }
    }
    
    func CheckIsAuth(uid: String, url : String, key : String) -> Bool {
        var isAuth = false
        do {
            let url = url
            let key = key
            
            if (url.isEmpty) {
                print("URL尚未設定")
                return false;
            }
            
            if (key.isEmpty) {
                print("金鑰尚未設定")
                return false;
            }
            
            // 先加密
            let encrypted = try aes.encrypt(uid)
            print(encrypted.base64EncodedString())
            if let restoredData = Data(base64Encoded: key) {
                let decrypted = try aes.decrypt(restoredData)
                print("解密結果: \(decrypted)")
                isAuth = decrypted == uid ? true : false
                
                if (isAuth) {
                    print("金鑰已驗證")
                } else {
                    print("金鑰輸入錯誤")
                }
            
                userSetting.isAuth = isAuth
            } else {
                print("Base64 解密失敗")
            }
        } catch {
            let _ = print("解密失敗: \(error.localizedDescription)")
        }
        self.enableSignIn = isAuth
        return isAuth
    }
    
    func OpenAppSettings() {
        if let url = URL(string: UIApplication.openSettingsURLString) {
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url)
            }
        }
    }
    
    func RefreshName() -> String {
        let userDefault = UserDefaults.standard
        let title = userDefault.string(forKey: "title") ?? ""
        return title
    }
    
    func Refresh() {
        let userDefault = UserDefaults.standard
        let title = userDefault.string(forKey: "title") ?? ""
        let url = userDefault.string(forKey: "url_preference") ?? ""
        let key = userDefault.string(forKey: "key_preference") ?? ""
        self.userSetting = UserSeting(title : title, url: url, userKey:key, uuid : "", isAuth: false)
        let uid = GetUuid()
        let isAuth = CheckIsAuth(uid: uid, url : url, key : key)
        self.userSetting = UserSeting(title : title, url: url, userKey:key, uuid : uid, isAuth: isAuth)
    }
    
    func SetAppAppearance(to style: UIUserInterfaceStyle) {
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = windowScene.windows.first {
            window.overrideUserInterfaceStyle = style
        }
    }
}

struct Gap: View {
    let height: CGFloat
    var body: some View {
        Color.clear.frame(height: height)
    }
}

#Preview {
    let userDefault = UserDefaults.standard
    let title = userDefault.string(forKey: "title") ?? ""
    let url = userDefault.string(forKey: "url_preference") ?? ""
    let key = userDefault.string(forKey: "key_preference") ?? ""
    return IndexView(userSetting: .constant(UserSeting(title : title, url: url, userKey:key, uuid : "", isAuth: false)),
                     aes: .constant(AesUtilHelper(keyString: "1qaz2wsx1234")))
}
