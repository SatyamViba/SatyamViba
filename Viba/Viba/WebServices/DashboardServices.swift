//
//  DashboardServices.swift
//  Viba
//
//  Created by Satyam Sutapalli on 01/12/21.
//

import Foundation

class DashboardServices {
    static func getCheckInOutDetailsByDate(date: Date, onCompletion handler: @escaping ((Result<CheckInOutListPerDayResponse, Error>) -> Void)) {
        let dtFormatter = DateFormatter()
        dtFormatter.dateFormat = "yyyy-MM-dd"
        let dtToSend = "2021-11-26" // dtFormatter.string(from: date)
        NetworkManager.shared.fetchResponse(urlString: NetworkPath.clockInOutListByDate.rawValue + dtToSend, params: EmptyRequest(), methodType: .get, completion: handler)
    }

    static func sendClockInClockOut(eventType: ClockInOutEvent, data: ClockInOut, onCompletion handler:  @escaping ((Result<ClockInOutResponse, Error>) -> Void)) {
        NetworkManager.shared.fetchResponse(urlString: eventType.url, params: data, methodType: .post, completion: handler)
    }
}
