//
//  DateFormatter+Extensions.swift
//  ImageFeed
//
//  Created by big stepper on 10/09/2024.
//

import Foundation


extension DateFormatter {
    static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        return formatter
    }()
}
