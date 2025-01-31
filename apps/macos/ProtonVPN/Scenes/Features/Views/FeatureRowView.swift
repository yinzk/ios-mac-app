//
//  FeatureRowView.swift
//  ProtonVPN - Created on 22.04.21.
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

import Cocoa
import vpncore

class FeatureRowView: NSView {
    
    @IBOutlet private weak var iconIV: NSImageView!
    @IBOutlet private weak var titleLbl: NSTextField!
    @IBOutlet private weak var descriptionLbl: NSTextField!
    @IBOutlet private weak var learnMoreBtn: NSButton!
    
    var viewModel: FeatureCellViewModel! {
        didSet {
            titleLbl.stringValue = viewModel.title
            iconIV.image = NSImage(named: viewModel.icon)
            descriptionLbl.stringValue = viewModel.description
            learnMoreBtn.title = LocalizedString.learnMore
        }
    }
    
    @IBAction private func didTapLearnMoreBtn(_ sender: Any) {
        SafariService.openLink(url: viewModel.urlContact)
    }
}
