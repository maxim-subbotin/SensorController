//
//  BDHost.h
//  WifiScanner
//
//  Created by Snappii on 9/19/19.
//  Copyright © 2019 Max Subbotin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BDHost : NSObject

+ (NSString *)hostnameForAddress:(NSString *)address;
+ (NSArray *)hostnamesForAddress:(NSString *)address;
+ (NSArray *)ipAddresses;
+ (NSArray *)ethernetAddresses;

@end

NS_ASSUME_NONNULL_END
