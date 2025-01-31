//
//  TrialAboutToExpireViewController.swift
//  ProtonVPN - Created on 27.06.19.
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

class TrialAboutToExpireViewController: NSViewController {

    @IBOutlet weak var titleLabel: NSTextField!
    @IBOutlet weak var descriptionLabel: NSTextField!
    
    @IBOutlet weak var connectionsTitle: NSTextField!
    @IBOutlet weak var connectionsDescription: NSTextField!
    @IBOutlet weak var secureCoreTitle: NSTextField!
    @IBOutlet weak var secureCoreDescription: NSTextField!
    @IBOutlet weak var serversTitle: NSTextField!
    @IBOutlet weak var serversDescription: NSTextField!
    @IBOutlet weak var streamingTitle: NSTextField!
    @IBOutlet weak var streamingDescription: NSTextField!
    
    @IBOutlet weak var laterButton: ClearCancellationButton!
    @IBOutlet weak var upgradeButton: UpsellPrimaryActionButton!
    @IBOutlet weak var moneyBackGuaranteeLabel: NSTextField!
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init() {
        super.init(nibName: NSNib.Name("TrialAboutToExpire"), bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleLabel.attributedStringValue = LocalizedString.freeTrialAboutToExpireTitle.attributed(withColor: .protonWhite(), fontSize: 32, bold: true)
        
        let description = NSMutableAttributedString(attributedString: LocalizedString.freeTrialAboutToExpireDescription(LocalizedString.protonvpnPlus).attributed(withColor: .protonWhite(), fontSize: 18))
        let descriptionFullRange = (description.string as NSString).range(of: description.string)
        let descriptionPlusRange = (description.string as NSString).range(of: LocalizedString.protonvpnPlus)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        paragraphStyle.lineSpacing = 6
        description.addAttribute(.paragraphStyle, value: paragraphStyle, range: descriptionFullRange)
        description.addAttribute(.font, value: NSFont.boldSystemFont(ofSize: 18), range: descriptionPlusRange)
        descriptionLabel.attributedStringValue = description
        
        connectionsTitle.attributedStringValue = LocalizedString._5Connections.attributed(withColor: .protonWhite(), fontSize: 18)
        connectionsDescription.attributedStringValue = LocalizedString._5ConnectionsDescription.attributed(withColor: .protonWhite(), fontSize: 12)
        secureCoreTitle.attributedStringValue = LocalizedString.secureCore.attributed(withColor: .protonWhite(), fontSize: 18)
        secureCoreDescription.attributedStringValue = LocalizedString.secureCoreDescription.attributed(withColor: .protonWhite(), fontSize: 12)
        serversTitle.attributedStringValue = LocalizedString.multipleServersTitle.attributed(withColor: .protonWhite(), fontSize: 18)
        serversDescription.attributedStringValue = LocalizedString.multipleServersDescription.attributed(withColor: .protonWhite(), fontSize: 12)
        streamingTitle.attributedStringValue = LocalizedString.secureStreamingTitle.attributed(withColor: .protonWhite(), fontSize: 18)
        streamingDescription.attributedStringValue = LocalizedString.secureStreamingDescription.attributed(withColor: .protonWhite(), fontSize: 12)
        
        laterButton.title = LocalizedString.maybeLater
        upgradeButton.title = LocalizedString.upgradeNow
        
        moneyBackGuaranteeLabel.attributedStringValue = LocalizedString.moneyBackGuarantee.attributed(withColor: .protonWhite(), fontSize: 12)
    }
    
    override func viewWillAppear() {
        super.viewWillAppear()
        view.window?.applyInfoAppearance()
    }
    
    @IBAction func maybeLater(_ sender: Any) {
        dismiss(nil)
    }
    
    @IBAction func upgrade(_ sender: Any) {
        SafariService.openLink(url: CoreAppConstants.ProtonVpnLinks.accountDashboard)
        dismiss(nil)
    }
}
