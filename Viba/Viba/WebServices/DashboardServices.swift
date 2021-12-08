//
//  DashboardServices.swift
//  Viba
//
//  Created by Satyam Sutapalli on 01/12/21.
//

import Foundation

class DashboardServices {
    // MARK: - Clock In
    static func checkOutsideOrg(data: ClockInOut, onCompletion handler: @escaping((Result<CheckInOrgResponse, Error>) -> Void)) {
        NetworkManager.shared.fetchResponse(urlString: NetworkPath.isOutsideOrg.rawValue, params: data, methodType: .post, completion: handler)
    }

    static func getCheckInOutDetailsByDate(date: Date, onCompletion handler: @escaping ((Result<CheckInOutListPerDayResponse, Error>) -> Void)) {
        NetworkManager.shared.fetchResponse(urlString: NetworkPath.clockInOutListByDate.rawValue + date.toApiFormat, params: EmptyRequest(), methodType: .get, completion: handler)
    }

    static func sendClockInClockOut(eventType: ClockInOutEvent, data: ClockInOut, onCompletion handler:  @escaping ((Result<ClockInOutResponse, Error>) -> Void)) {
        NetworkManager.shared.fetchResponse(urlString: eventType.url, params: data, methodType: .post, completion: handler)
    }

    // MARK: - Pre Invitations
    static func createInvitation(event: CreateInvitation, onCompletion handler: @escaping((Result<CreateInvitationResponse, Error>) -> Void)) {
        NetworkManager.shared.fetchResponse(urlString: NetworkPath.createInvitation.rawValue, params: event, methodType: .post, completion: handler)
    }

    static func getInvitationsList(date: Date, completion handler: @escaping ((Result<InvitationListResponse, Error>) -> Void)) {
        NetworkManager.shared.fetchResponse(urlString: NetworkPath.invitationsByDate.rawValue + date.toApiFormat, params: EmptyRequest(), methodType: .get, completion: handler)
    }
}
