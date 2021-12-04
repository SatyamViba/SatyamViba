//
//  DashboardServices.swift
//  Viba
//
//  Created by Satyam Sutapalli on 01/12/21.
//

import Foundation

class DashboardServices {
    // MARK: - Clock In
    static func getCheckInOutDetailsByDate(date: Date, onCompletion handler: @escaping ((Result<CheckInOutListPerDayResponse, Error>) -> Void)) {
        NetworkManager.shared.fetchResponse(urlString: NetworkPath.clockInOutListByDate.rawValue + date.toApiFormat, params: EmptyRequest(), methodType: .get, completion: handler)
    }

    static func sendClockInClockOut(eventType: ClockInOutEvent, data: ClockInOut, onCompletion handler:  @escaping ((Result<ClockInOutResponse, Error>) -> Void)) {
        NetworkManager.shared.fetchResponse(urlString: eventType.url, params: data, methodType: .post, completion: handler)
    }

    // MARK: - Pre Invitations
}
