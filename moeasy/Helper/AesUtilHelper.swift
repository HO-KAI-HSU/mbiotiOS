//
//  AesUtilHelper.swift
//  SwiftProject2
//
//  Created by georgeHsu on 2025/5/14.
//

import Foundation
import CryptoKit

struct AesUtilHelper {
    private let key: SymmetricKey
    private let nonce: String
    
    init(keyString: String) {
        // 使用 SHA256 將字串轉為固定長度金鑰（256-bit）
        let keyData = Data(keyString.utf8)
        let hash = SHA256.hash(data: keyData)
        self.key = SymmetricKey(data: hash)
        self.nonce = keyString
    }

    func encrypt(_ text: String) throws -> Data {
        let data = Data(text.utf8)
        let nonceUtf8 = Data(nonce.utf8)
        let nonce = try AES.GCM.Nonce(data: nonceUtf8)
        let sealedBox = try AES.GCM.seal(data, using: key, nonce: nonce)
        return sealedBox.combined!
    }

    func decrypt(_ encryptedData: Data) throws -> String {
        let sealedBox = try AES.GCM.SealedBox(combined: encryptedData)
        let decryptedData = try AES.GCM.open(sealedBox, using: key)
        return String(data: decryptedData, encoding: .utf8)!
    }
}
