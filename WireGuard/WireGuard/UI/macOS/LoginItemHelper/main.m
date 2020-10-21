// SPDX-License-Identifier: MIT
// Copyright © 2018-2019 WireGuard LLC. All Rights Reserved.

#import <Cocoa/Cocoa.h>

int main(int argc, char *argv[])
{
    NSString *appIdInfoDictionaryKey = @"com.wireguard.macos.app_id";
    NSString *appId = [NSBundle.mainBundle objectForInfoDictionaryKey:appIdInfoDictionaryKey];

    NSString *launchCode = @"LaunchedByWireGuardLoginItemHelper";
    NSAppleEventDescriptor *paramDescriptor = [NSAppleEventDescriptor descriptorWithString:launchCode];

    if (@available(macOS 10.15, *)) {
        NSURL *appURL = [NSWorkspace.sharedWorkspace URLForApplicationWithBundleIdentifier:appId];
        NSWorkspaceOpenConfiguration *openConfiguration = [[NSWorkspaceOpenConfiguration alloc] init];
        openConfiguration.activates = NO;
        openConfiguration.appleEvent = paramDescriptor;

        // Create condition to block the execution until `openApplicationAtURL:configuration:completionHandler:`
        // finishes its work.
        NSCondition *condition = [[NSCondition alloc] init];
        [NSWorkspace.sharedWorkspace openApplicationAtURL:appURL configuration:openConfiguration completionHandler:^(NSRunningApplication *app, NSError *error) {
            [condition signal];
        }];
        [condition wait];
    } else {
        [NSWorkspace.sharedWorkspace launchAppWithBundleIdentifier:appId options:NSWorkspaceLaunchWithoutActivation
                                    additionalEventParamDescriptor:paramDescriptor launchIdentifier:nil];
    }

    return 0;
}
