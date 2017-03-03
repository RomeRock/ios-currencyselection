//
//  Country.swift
//  tipcalculator
//
//  Created by Rome Rock on 12/21/16.
//  Copyright © 2016 Rome Rock. All rights reserved.
//

import Foundation

class Country : NSObject, NSCoding {
    
    // MARK: - Types
    
    enum CoderKeys: String {
        case countryNameKey
        case countryCodeKey
        case currencyCodeKey
        case currencyNameKey
        case currencySymbolKey
        case emojiSymbolKey
    }
    
    // MARK: - Properties
    
    let countryName:String
    let countryCode:String
    let currencyCode:String
    let currencyName:String
    let currencySymbol:String
    let emojiSymbol:String
    
    // MARK: - Initializers
    
    init(countryName:String, countryCode:String, currencyCode:String, currencyName:String, currencySymbol:String, emojiSymbol:String ) {
        self.countryName = countryName
        self.countryCode = countryCode
        self.currencyCode = currencyCode
        self.currencyName = currencyName
        self.currencySymbol = currencySymbol
        self.emojiSymbol = emojiSymbol
    }
    
    // MARK: - NSCoding
    
    required init?(coder aDecoder: NSCoder) {
        countryName = aDecoder.decodeObject(forKey: CoderKeys.countryNameKey.rawValue) as! String
        countryCode = aDecoder.decodeObject(forKey: CoderKeys.countryCodeKey.rawValue) as! String
        currencyCode = aDecoder.decodeObject(forKey: CoderKeys.currencyCodeKey.rawValue) as! String
        currencyName = aDecoder.decodeObject(forKey: CoderKeys.currencyNameKey.rawValue) as! String
        currencySymbol = aDecoder.decodeObject(forKey: CoderKeys.currencySymbolKey.rawValue) as! String
        emojiSymbol = aDecoder.decodeObject(forKey: CoderKeys.emojiSymbolKey.rawValue) as! String
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(countryName, forKey: CoderKeys.countryNameKey.rawValue)
        aCoder.encode(countryCode, forKey: CoderKeys.countryCodeKey.rawValue)
        aCoder.encode(currencyCode, forKey: CoderKeys.currencyCodeKey.rawValue)
        aCoder.encode(currencyName, forKey: CoderKeys.currencyNameKey.rawValue)
        aCoder.encode(currencySymbol, forKey: CoderKeys.currencySymbolKey.rawValue)
        aCoder.encode(emojiSymbol, forKey: CoderKeys.emojiSymbolKey.rawValue)
    }

    // MARK: - Helper
    
    static func getCountries() -> [Country] {
        var countries:[Country] = []
        
        let mainLocale : NSLocale = NSLocale.current as NSLocale
        for mainCountryCode:String in NSLocale.isoCountryCodes {
            let localeId = NSLocale.localeIdentifier(fromComponents: [NSLocale.Key.countryCode.rawValue:mainCountryCode])
            let locale = NSLocale(localeIdentifier: localeId)
            let currencySymbol = locale.object(forKey: NSLocale.Key.currencySymbol)
            let currencyCode = locale.object(forKey: NSLocale.Key.currencyCode)
            let countryCode = locale.object(forKey: NSLocale.Key.countryCode)
            let currencyCodeMain = mainLocale.displayName(forKey: NSLocale.Key.currencyCode, value: currencyCode!)
            let countryCodeMain = mainLocale.displayName(forKey: NSLocale.Key.countryCode, value: countryCode!)
            let emoji:String = mainCountryCode.flag()
            let country:Country = Country(countryName: countryCodeMain!,countryCode: mainCountryCode,currencyCode: currencyCode as! String,currencyName: currencyCodeMain!,currencySymbol: currencySymbol as! String,emojiSymbol: emoji)
            countries.append(country)
        }
        countries.sort{ $0.countryName < $1.countryName }
        
        return countries
    }
    
    static func getCountry(code: String) -> Country {
        let mainLocale : NSLocale = NSLocale.current as NSLocale
        let localeId = NSLocale.localeIdentifier(fromComponents: [NSLocale.Key.countryCode.rawValue:code])
        let locale = NSLocale(localeIdentifier: localeId)
        let currencySymbol = locale.object(forKey: NSLocale.Key.currencySymbol)
        let currencyCode = locale.object(forKey: NSLocale.Key.currencyCode)
        let countryCode = locale.object(forKey: NSLocale.Key.countryCode)
        let currencyCodeMain = mainLocale.displayName(forKey: NSLocale.Key.currencyCode, value: currencyCode!)
        let countryCodeMain = mainLocale.displayName(forKey: NSLocale.Key.countryCode, value: countryCode!)
        let emoji:String = code.flag()
        let country:Country = Country(countryName: countryCodeMain!,countryCode: code,currencyCode: currencyCode as! String,currencyName: currencyCodeMain!,currencySymbol: currencySymbol as! String,emojiSymbol: emoji)
        
        return country
    }
}
