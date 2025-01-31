//
//  LocalizationUtility.swift
//  vpncore - Created on 26.06.19.
//
//  Copyright (c) 2019 Proton Technologies AG
//
//  This file is part of vpncore.
//
//  vpncore is free software: you can redistribute it and/or modify
//  it under the terms of the GNU General Public License as published by
//  the Free Software Foundation, either version 3 of the License, or
//  (at your option) any later version.
//
//  vpncore is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//  GNU General Public License for more details.
//
//  You should have received a copy of the GNU General Public License
//  along with vpncore.  If not, see <https://www.gnu.org/licenses/>.

import Foundation

public class LocalizationUtility {
    
    public static let `default` = LocalizationUtility()
    
    public init() {
        loadShortNames()
    }
    
    public func shortenIfNeeded(_ name: String) -> String {
        return namesToShorten[name] ?? name
    }
    
    public func countryName(forCode countryCode: String) -> String? {
        let locale: Locale
        if let language = Locale.preferredLanguages[0].components(separatedBy: "-").first {
            locale = Locale(identifier: language)
        } else {
            locale = Locale.current
        }
        
        guard let name = locale.localizedString(forRegionCode: countryCode) else {
            return nil
        }
        return shortenIfNeeded(name)
    }
    
    // MARK: - Name shortening
    
    private var namesToShorten = [String: String]()
    
    private func loadShortNames() {
        do {
            let data = try Data(contentsOf: Bundle.main.url(forResource: "country-names", withExtension: "plist")!)
            let decoder = PropertyListDecoder()
            namesToShorten = try decoder.decode([String: String].self, from: data)
        } catch {
            namesToShorten = [String: String]()
        }
    }
    
}
