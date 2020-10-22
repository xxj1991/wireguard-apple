// SPDX-License-Identifier: MIT
// Copyright © 2018-2019 WireGuard LLC. All Rights Reserved.

import Cocoa

class LaunchedAtLoginDetector {
    static let launchCode = "LaunchedByWireGuardLoginItemHelper"

    static func isReopenedByLoginItemHelper(reopenAppleEvent: NSAppleEventDescriptor) -> Bool {
        guard isReopenEvent(reopenAppleEvent) else { return false }
        guard let propData = reopenAppleEvent.paramDescriptor(forKeyword: keyAEPropData) else { return false }
        return propData.stringValue == launchCode
    }
}

private func isReopenEvent(_ event: NSAppleEventDescriptor) -> Bool {
    return event.eventClass == kCoreEventClass && event.eventID == kAEReopenApplication
}
