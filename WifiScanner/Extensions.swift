//
//  Extensions.swift
//  WifiScanner
//
//  Copyright © 2020 Max Subbotin. All rights reserved.
//

import Foundation

public extension Date {
    
    public var serverSideFormat:String? {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSSSZ"
        let dateString = formatter.string(from: self)
        return dateString
    }
    
    /*public var timeFormat:String? {
        let formatter = DateFormatter()
        //formatter.dateStyle = .none
        //formatter.timeStyle = .short
        formatter.dateFormat = "HH:mm"
        let dateString = formatter.string(from: self)
        return dateString
    }*/
    
    public var dateTimeFormat:String? {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        formatter.locale = Locale.current
        let dateString = formatter.string(from: self)
        return dateString
    }
    
    /*public var dateFormat:String? {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .none
        let dateString = formatter.string(from: self)
        return dateString
    }*/
    
    public static func dateFromServerFormat(_ stringFormat:String) -> Date? {
        if stringFormat.count == 0 {
            return nil
        }
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS"
        var date = dateFormatter.date(from: stringFormat)
        if date == nil {
            dateFormatter.dateFormat = "yyyy-MM-dd' 'HH:mm:ss' '+Z" //2017-12-04 21:00:00 +0000
            date = dateFormatter.date(from: stringFormat)
        }
        if date == nil {
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSSSZ" //2017-12-04 21:00:00 +0000
            date = dateFormatter.date(from: stringFormat)
        }
        if date == nil {
            dateFormatter.dateFormat = "M/d/yy"
            date = dateFormatter.date(from: stringFormat)
        }
        return date
    }
    
    public static func from(year: Int, month: Int, day: Int) -> Date {
        let gregorianCalendar = NSCalendar(calendarIdentifier: .gregorian)!
        var dateComponents = DateComponents()
        dateComponents.year = year
        dateComponents.month = month
        dateComponents.day = day
        let date = gregorianCalendar.date(from: dateComponents)!
        return date
    }

    public func isSameDay(_ date:Date) -> Bool {
        return Calendar.current.isDate(self, inSameDayAs:date)
    }
    
    public var doubleValue:Double {
        return Double(self.timeIntervalSince1970)
    }
    
    public static func fromDouble(_ d:Double) -> Date {
        let seconds = Int(d)
        let date = Date(timeIntervalSince1970: TimeInterval(seconds))
        return date
    }
    
    func isBetween(_ date1: Date, and date2: Date) -> Bool {
        return (min(date1, date2) ... max(date1, date2)).contains(self)
    }
    
    func dateOnly() -> Date {
        let calendar = NSCalendar.current
        let components = calendar.dateComponents([.day, .month, .year], from: self)
        let year =  components.year
        let month = components.month
        let day = components.day
        var dateComponents = DateComponents()
        dateComponents.year = year
        dateComponents.month = month
        dateComponents.day = day
        let date = calendar.date(from: dateComponents)
        return date!
    }
    
    /*public var serverSideFormat:String? {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSSSZ"
        var dateString = formatter.string(from: self)
        if dateString.starts(with: "00\(self.year)-") { //  SD-670
            let strYear = "20\(self.year)-"
            dateString = dateString.replacingOccurrences(of: "00\(self.year)-", with: strYear)
        }
        if dateString.contains("+") {
            let plusSplits = dateString.split(separator: "+")
            if plusSplits.count == 2 {
                let strTimeZone = plusSplits[1]
                if strTimeZone.count > 4 {
                    let localTimeZoneFormatter = DateFormatter()
                    localTimeZoneFormatter.timeZone = TimeZone.current
                    localTimeZoneFormatter.dateFormat = "Z"
                    let tz = localTimeZoneFormatter.string(from: Date())
                    return plusSplits[0] + tz
                }
            }
        }
        return dateString
    }*/
    
    /*public var timeFormat:String? {
        let formatter = DateFormatter()
        //formatter.dateStyle = .none
        //formatter.timeStyle = .short
        formatter.dateFormat = "HH:mm"
        let dateString = formatter.string(from: self)
        return dateString
    }*/
    
    public var dateTimeFormatWithSeconds:String? {
        let formatter = DateFormatter()
        /*formatter.dateStyle = .short
         formatter.timeStyle = .short*/
        formatter.dateFormat = "MM/dd/yy', 'hh:mm:ss"
        formatter.locale = Locale.current
        let dateString = formatter.string(from: self)
        return dateString
    }
    
    public var fullFormat:String? {
        let formatter = DateFormatter()
        formatter.dateStyle = .full
        formatter.timeStyle = .medium
        let dateString = formatter.string(from: self)
        return dateString
    }
    
    /*public var dateTimeFormat:String? {
        let formatter = DateFormatter()
        /*formatter.dateStyle = .short
        formatter.timeStyle = .short*/
        formatter.dateFormat = "MM/dd/yy', 'hh:mm"
        formatter.locale = Locale.current
        let dateString = formatter.string(from: self)
        return dateString
    }
    
    public var dateFormat:String? {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .none
        let dateString = formatter.string(from: self)
        return dateString
    }*/
    
    public var serverDateFormat:String? {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/YYYY"
        let dateString = formatter.string(from: self)
        return dateString
    }
    
    public var dateFormatUS:String? {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US")
        formatter.dateStyle = .short
        formatter.timeStyle = .none
        let dateString = formatter.string(from: self)
        return dateString
    }
    
    /*public static func dateFromServerFormat(_ stringFormat:String) -> Date? {
        if stringFormat.count == 0 {
            return nil
        }
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS"
        var date = dateFormatter.date(from: stringFormat)
        if date == nil {
            dateFormatter.dateFormat = "yyyy-MM-dd' 'HH:mm:ss' '+Z" //2017-12-04 21:00:00 +0000
            date = dateFormatter.date(from: stringFormat)
        }
        if date == nil {
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSSSZ" //2017-12-04 21:00:00 +0000
            date = dateFormatter.date(from: stringFormat)
        }
        if date == nil {
            dateFormatter.dateFormat = "M/d/yy"
            date = dateFormatter.date(from: stringFormat)
        }
        if date == nil {
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
            date = dateFormatter.date(from: stringFormat)
        }
        if date == nil {
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
            date = dateFormatter.date(from: stringFormat)
        }
        return date
    }*/
    
    /*public static func from(year: Int, month: Int, day: Int) -> Date {
        let gregorianCalendar = NSCalendar(calendarIdentifier: .gregorian)!
        var dateComponents = DateComponents()
        dateComponents.year = year
        dateComponents.month = month
        dateComponents.day = day
        let date = gregorianCalendar.date(from: dateComponents)!
        return date
    }

    public func isSameDay(_ date:Date) -> Bool {
        return Calendar.current.isDate(self, inSameDayAs:date)
    }
    
    public var doubleValue:Double {
        return Double(self.timeIntervalSince1970)
    }
    
    public static func fromDouble(_ d:Double) -> Date {
        let seconds = Int(d)
        let date = Date(timeIntervalSince1970: TimeInterval(seconds))
        return date
    }
    
    func isBetween(_ date1: Date, and date2: Date) -> Bool {
        return (min(date1, date2) ... max(date1, date2)).contains(self)
    }
    
    public func dateOnly() -> Date {
        let calendar = NSCalendar.current
        let components = calendar.dateComponents([.day, .month, .year], from: self)
        let year =  components.year
        let month = components.month
        let day = components.day
        var dateComponents = DateComponents()
        dateComponents.year = year
        dateComponents.month = month
        dateComponents.day = day
        let date = calendar.date(from: dateComponents)
        return date!
    }*/
    
    public var monthName: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM"
        let strMonth = dateFormatter.string(from: self)
        return strMonth
    }
    
    public var year:Int {
        let calendar = Calendar.current
        let year = calendar.component(.year, from: self)
        return year
    }
    
    public var dayOfWeek:String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        return dateFormatter.string(from: self).capitalized
    }
    
    public var isWeekend:Bool {
        return Calendar.current.isDateInWeekend(self)
    }
    
    public var isAmericanHoliday:Bool {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd"
        let str = formatter.string(from: self)
        let holidays = ["01/01", "05/27", "04/07", "09/02", "11/28", "11/29", "12/25"]
        return holidays.contains(str)
    }
    
    public func daysWithWeekends(_ daysCount:Int) -> Int {
        var day = self
        var totalDays = 0
        for _ in 0...daysCount {
            day = Calendar.current.date(byAdding: .day, value: 1, to: day)!
            while day.isWeekend {
                day = Calendar.current.date(byAdding: .day, value: 1, to: day)!
                totalDays += 1
            }
            totalDays += 1
        }
        return totalDays
    }
    
    public var nextDay:Date? {
        return Calendar.current.date(byAdding: .day, value: 1, to: self)
    }
    
    public var prevDay:Date? {
        return Calendar.current.date(byAdding: .day, value: -1, to: self)
    }
}
