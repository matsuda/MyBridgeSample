//
//  RealmManager.swift
//  MyBridgeSample
//
//  Created by Kosuke Matsuda on 2020/05/23.
//  Copyright © 2020 Kosuke Matsuda. All rights reserved.
//

import Foundation
import RealmSwift

final class RealmManager {
    class func migrate() {
        print("<<<<<<<<<<<<<<<<<<<< Realm migration start >>>>>>>>>>>>>>>>")
        do {
            try _ = userRealm()
        } catch {
            fatalError("Not complete Realm migration because \(error)")
        }
        print("<<<<<<<<<<<<<<<<<<<< Realm migration end   >>>>>>>>>>>>>>>>")
    }

    class func cleanUserRealm() {
        guard let url = UserRealm.configuration.fileURL else {
            return
        }
        cleanRealm(url: url)
    }

    /// Realm関連ファイルを削除します。
    class func cleanRealm(fileName: String) {
        guard let dir = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first else {
            return
        }
        let realmURL = URL(fileURLWithPath: "\(dir)/\(fileName)")
        cleanRealm(url: realmURL)
    }

    class func cleanRealm(url realmURL: URL) {
        print("Realm url : \(realmURL)")
        let realmURLs: [URL] = [
            realmURL,
            realmURL.appendingPathExtension("lock"),
            realmURL.appendingPathExtension("note"),
            realmURL.appendingPathExtension("management"),
        ]
        let fm = FileManager.default
        for url in realmURLs {
            do {
                try fm.removeItem(at: url)
                #if DEBUG
                print("Realm remove \(url)")
                #endif
            } catch {}
        }
    }

    class func installRealm(url realmURL: URL) throws {
        print("Install realm to url : \(realmURL)")
        let realmPath = realmURL.path

        let fm = FileManager.default
        if fm.fileExists(atPath: realmPath) { return }
        guard let resourcePath = Bundle.main.resourcePath else { return }

        let path = (resourcePath as NSString).appendingPathComponent(realmURL.lastPathComponent)
        do {
            try fm.copyItem(atPath: path, toPath: realmPath)
            print("Copy from \(path) to \(realmPath)")
        } catch let error {
            print("Can't copy from \(path) to \(realmPath).")
            throw error
        }
    }
}
