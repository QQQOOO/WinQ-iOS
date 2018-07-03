//
//  UserDefaultsManager.swift
//  O3
//
//  Created by Andrei Terentiev on 10/9/17.
//  Copyright © 2017 drei. All rights reserved.
//

import Foundation


class UserDefaultsManager {

    private static let networkKey = "networkKey"

    static var network: Network {
        get {
           if let stringValue = UserDefaults.standard.string(forKey: networkKey)
           {
                return Network(rawValue: stringValue)!
            }
            return Network(rawValue: "main")!
        }
        set {
            WalletManage.shareInstance3.account?.neoClient = NeoClient(network: network, seedURL: UserDefaultsManager.seed)
            UserDefaults.standard.set(newValue.rawValue, forKey: networkKey)
           // NotificationCenter.default.post(name: Notification.Name("ChangedNetwork"), object: nil)
        }
    }

    private static let useDefaultSeedKey = "usedDefaultSeedKey"
    static var useDefaultSeed: Bool {
        get {
           
           let seedValue = UserDefaults.standard.bool(forKey: useDefaultSeedKey)
            if seedValue {
                return UserDefaults.standard.bool(forKey: useDefaultSeedKey)
            }
            return false
        }
        set {
            if newValue {
                if let bestNode = NEONetworkMonitor.autoSelectBestNode() {
                    UserDefaults.standard.set(newValue, forKey: useDefaultSeedKey)
                    UserDefaultsManager.seed = bestNode
                }
            } else {
                UserDefaults.standard.set(newValue, forKey: useDefaultSeedKey)
                UserDefaults.standard.synchronize()
            }
        }
    }

    private static let seedKey = "seedKey"
    static var seed: String {
        get {
            if UserDefaults.standard.string(forKey: seedKey) != nil
            {
                 return UserDefaults.standard.string(forKey: seedKey)!
            }
            return "http://seed2.neo.org:20332"
        }
        set {
            Neo.client.seed = newValue
            WalletManage.shareInstance3.account?.neoClient = NeoClient(network: UserDefaultsManager.network, seedURL: newValue)
            UserDefaults.standard.set(newValue, forKey: seedKey)
            UserDefaults.standard.synchronize()
           // NotificationCenter.default.post(name: Notification.Name("ChangedNetwork"), object: nil)
        }
    }

    private static let selectedThemeIndexKey = "selectedThemeIndex"
    static var themeIndex: Int {
        get {
            let intValue = UserDefaults.standard.integer(forKey: selectedThemeIndexKey)
            if intValue != 0 && intValue != 1 {
                return 0
            }
            return intValue
        }
        set {
            UserDefaults.standard.set(newValue, forKey: selectedThemeIndexKey)
            UserDefaults.standard.synchronize()
        }
    }

    private static let launchedBeforeKey = "launchedBeforeKey"
    static var launchedBefore: Bool {
        get {
            let value = UserDefaults.standard.bool(forKey: launchedBeforeKey)
            return value
        }
        set {
            UserDefaults.standard.set(newValue, forKey: launchedBeforeKey)
            UserDefaults.standard.synchronize()
        }
    }

    private static let o3WalletAddressKey = "o3WalletAddressKey"
    static var o3WalletAddress: String? {
        get {
            let stringValue = UserDefaults.standard.string(forKey: o3WalletAddressKey)
            return stringValue
        }
        set {
            UserDefaults.standard.set(newValue, forKey: o3WalletAddressKey)
            UserDefaults.standard.synchronize()
        }
    }

    private static let referenceFiatCurrencyKey = "referenceCurrencyKey"
    static var referenceFiatCurrency: Currency {
        get {
            let stringValue = UserDefaults.standard.string(forKey: referenceFiatCurrencyKey)
            return Currency(rawValue: stringValue!)!
        }
        set {
            UserDefaults.standard.set(newValue.rawValue, forKey: referenceFiatCurrencyKey)
            UserDefaults.standard.synchronize()
            NotificationCenter.default.post(name: Notification.Name("ChangedReferenceCurrency"), object: nil)
        }
    }

    private static let selectedNEP5TokensKey = "selectedNEP5TokensKey"
    static var selectedNEP5Token: [String: NEP5Token]? {
        get {

            if let data = UserDefaults.standard.value(forKey: selectedNEP5TokensKey) as? Data {
                do {
                    let tokens = try PropertyListDecoder().decode([String: NEP5Token].self, from: data)
                    return tokens
                } catch {
                    return [:]
                }
            }
            return [:]
        }
        set {
            do {
                let data = try PropertyListEncoder().encode(newValue)
                UserDefaults.standard.set(data, forKey: selectedNEP5TokensKey)
                UserDefaults.standard.synchronize()
            } catch {
                print("Save Failed")
            }
        }
    }
}
