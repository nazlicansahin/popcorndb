//
//  String+Localization.swift
//  popcorndb
//
//  Created by Nazlı on 4.08.2025.
//

import Foundation

extension String {
    
    // MARK: - Date Formatting
    var formattedDate: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        guard let date = dateFormatter.date(from: self) else {
            return self
        }
        
        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = "dd MMM yyyy"
        
        // Uygulama diline göre locale ayarla
        if let languageCode = Locale.current.language.languageCode?.identifier {
            switch languageCode {
            case "tr":
                outputFormatter.locale = Locale(identifier: "tr_TR")
            case "en":
                outputFormatter.locale = Locale(identifier: "en_US")
            default:
                outputFormatter.locale = Locale.current
            }
        } else {
            outputFormatter.locale = Locale.current
        }
        
        return outputFormatter.string(from: date)
    }
    
    // MARK: - Year Only
    var yearOnly: String {
        return String(self.prefix(4))
    }
}

// MARK: - Double Extensions for Rating
extension Double {
    
    // MARK: - Rating Format
    var formattedRating: String {
        return String(format: "%.1f", self)
    }
}

// MARK: - Int Extensions for Budget/Revenue
extension Int {
    
    // MARK: - Currency Format
    var formattedCurrency: String {
        if self == 0 {
            return "-"
        }
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        
        // Uygulama diline göre separator ayarla
        if let languageCode = Locale.current.language.languageCode?.identifier {
            switch languageCode {
            case "tr":
                formatter.groupingSeparator = "."
                formatter.decimalSeparator = ","
            case "en":
                formatter.groupingSeparator = ","
                formatter.decimalSeparator = "."
            default:
                formatter.groupingSeparator = Locale.current.groupingSeparator
                formatter.decimalSeparator = Locale.current.decimalSeparator
            }
        } else {
            formatter.groupingSeparator = Locale.current.groupingSeparator
            formatter.decimalSeparator = Locale.current.decimalSeparator
        }
        
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 0
        
        return "$\(formatter.string(from: NSNumber(value: self)) ?? "\(self)")"
    }
    
    
}
// MARK: - Localization
extension String {
    var localized: String {
        NSLocalizedString(self, comment: "")
    }
}
