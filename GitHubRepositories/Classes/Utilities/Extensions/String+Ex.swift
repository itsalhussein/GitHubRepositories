//
//  String+Ex.swift
//  GitHubRepositories
//
//  Created by Hussein Anwar on 11/11/2023.
//

import Foundation

extension String {
    func formatDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        
        if let date = dateFormatter.date(from: self) {
            let calendar = Calendar.current
            let currentDate = Date()
            
            if let difference = calendar.dateComponents([.month], from: date, to: currentDate).month, difference < 6 {
                dateFormatter.dateFormat = "EEEE, MMM dd, yyyy"
                return dateFormatter.string(from: date)
            } else {
                let components = calendar.dateComponents([.year, .month], from: date, to: currentDate)
                let years = components.year ?? 0
                let months = components.month ?? 0
                
                if years > 0 {
                    return "\(years) year\(years > 1 ? "s" : "") ago"
                } else {
                    return "\(months) month\(months > 1 ? "s" : "") ago"
                }
            }
        } else {
            return "Invalid date format"
        }
    }
}
