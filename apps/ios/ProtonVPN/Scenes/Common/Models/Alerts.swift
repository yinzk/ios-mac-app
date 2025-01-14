//
//  Alerts.swift
//  ProtonVPN - Created on 01.07.19.
//
//  Copyright (c) 2019 Proton Technologies AG
//
//  This file is part of ProtonVPN.
//
//  ProtonVPN is free software: you can redistribute it and/or modify
//  it under the terms of the GNU General Public License as published by
//  the Free Software Foundation, either version 3 of the License, or
//  (at your option) any later version.
//
//  ProtonVPN is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//  GNU General Public License for more details.
//
//  You should have received a copy of the GNU General Public License
//  along with ProtonVPN.  If not, see <https://www.gnu.org/licenses/>.
//
import Foundation
import vpncore

public class TrialExpiredAlert: SystemAlert {
    public var title: String? = LocalizedString.trialExpiredAlertTitleIOS
    public var message: String? = LocalizedString.trialExpiredAlertBodyIOS
    public var actions = [AlertAction]()
    public let isError: Bool = false
    public var dismiss: (() -> Void)?
    
    public init(confirmHandler: @escaping () -> Void, cancelHandler: @escaping () -> Void, planChecker: PlanUpgradeCheckerProtocol) {
        var cancelButtonTitle = LocalizedString.gotIt
        if planChecker.canUpgrade() {
            actions.append(AlertAction(title: LocalizedString.upgrade, style: .confirmative, handler: confirmHandler))
            cancelButtonTitle = LocalizedString.cancel
        }
        
        actions.append(AlertAction(title: cancelButtonTitle, style: .cancel, handler: cancelHandler))
    }
}
