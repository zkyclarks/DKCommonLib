//
//  DKSecretTool.swift
//  PDDMall
//
//  Created by keyu zhang on 2018/8/29.
//  Copyright © 2018年 pdd. All rights reserved.
//

import UIKit
import CryptoSwift

class DKSecretEncode: NSObject {
    
    //AES-ECB128加密
    public static func encode(key:String, sourceData data:Data) -> Data
    {
        var decrypted: [UInt8] = []
        let ka = Array(key.utf8)
        do {
            let aes = try AES(key: ka, blockMode:ECB(), padding:.zeroPadding) // aes128
            let bytes = data.bytes
            decrypted = try aes.encrypt(bytes)
        } catch {
        }
        
        let decoded = Data(decrypted)
        return decoded
    }
    
    //  MARK:  AES-ECB128解密
    public static func decode(key:String, sourceData data:Data) -> Data
    {
        // byte 数组
        var encrypted: [UInt8] = []
        let count = data.count
        
        // 把data 转成byte数组
        for i in 0..<count {
            var temp:UInt8 = 0
            data.copyBytes(to: &temp, from:i..<(i+1))
            encrypted.append(temp)
        }
        
        // decode AES
        var decrypted: [UInt8] = []
        let ka = Array(key.utf8)
        do {
            let aes = try AES(key: ka, blockMode:ECB(), padding:.zeroPadding) // aes128
            decrypted = try aes.decrypt(encrypted)
        } catch {
        }
        
        // byte 转换成NSData
        let encoded = Data(decrypted)
        return encoded
    }

    
    //AES-ECB128加密
    public static func encode(key:String, sourceString string:String)->String
    {
        // 从String 转成data
        guard let data = string.data(using: String.Encoding.utf8) else {
            fatalError("source string is invalid")
        }
        let encoded = encode(key: key, sourceData: data)
        //加密结果要用Base64转码
        return encoded.base64EncodedString()
    }
    
    //  MARK:  AES-ECB128解密
    public static func decode(key:String, sourceString string:String)->String {
        //decode base64
        guard let data = Data(base64Encoded: string) else {
            fatalError("source string is invalid")
        }
        let encoded = decode(key: key, sourceData: data)
        //解密结果从data转成string
        let str = String(bytes: encoded.bytes, encoding: .utf8)!
        return str
    }
}

