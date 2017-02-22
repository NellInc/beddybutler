//
//  LogEntry.swift
//  Beddy Butler
//
//  Created by David Garces on 22/02/2017.
//  Copyright © 2017 David Garces. All rights reserved.
//

import Cocoa

class LogEntry: NSObject, NSCoding {
    
    let date: Date
    let message: String
    init(date: Date, message: String) {
        self.date = date
        self.message = message
    }
    required init(coder decoder: NSCoder) {
        self.date = (decoder.decodeObject(forKey: "date") as? Date) ?? Date()
        self.message = (decoder.decodeObject(forKey: "message") as? String) ?? ""
    }
    
    func encode(with coder: NSCoder) {
        coder.encode(date, forKey: "date")
        coder.encode(message, forKey: "message")
    }

}
