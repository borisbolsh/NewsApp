//
//  DateFormatter+Ext.swift
//  NewsApp
//
//  Created by Boris Bolshakov on 10.12.21.
//

import Foundation

extension DateFormatter {
    static let newsDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm, dd-MM-yyyy"
        return formatter
    }()
    
    static func changeDateFormat(from string: String) -> String {

        let responseDateFormatter = DateFormatter()
        responseDateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        
        guard let convertedDate = responseDateFormatter.date(from: string) else {
            return "no date"
        }
   
        return newsDateFormatter.string(from: convertedDate)
    }

}
