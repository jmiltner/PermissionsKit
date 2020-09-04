//
//  MPPhotosAuthorizer.m
//  PermissionsKit
//
//  Created by Sergii Kryvoblotskyi on 9/12/18.
//  Copyright © 2018 MacPaw. All rights reserved.
//

@import Photos;

#import "MPPhotosAuthorizer.h"

@implementation MPPhotosAuthorizer

- (MPAuthorizationStatus)authorizationStatus
{
    if (@available(macOS 10.13, *))
    {
        PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
        return [self _authorizationStatusFromPhotosAuthorizationStatus:status];
    }
    else
    {
        return MPAuthorizationStatusAuthorized;
    }
}

- (void)requestAuthorizationWithCompletion:(nonnull void (^)(MPAuthorizationStatus))completionHandler
{
    if (@available(macOS 10.13, *))
    {
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
            completionHandler([self _authorizationStatusFromPhotosAuthorizationStatus:status]);
        }];
    }
    else
    {
        completionHandler(MPAuthorizationStatusAuthorized);
    }
}

#pragma mark - Private

- (MPAuthorizationStatus)_authorizationStatusFromPhotosAuthorizationStatus:(PHAuthorizationStatus)status
{
    switch (status) {
        case PHAuthorizationStatusDenied:
        case PHAuthorizationStatusRestricted:
            return MPAuthorizationStatusDenied;
        case PHAuthorizationStatusAuthorized:
            return MPAuthorizationStatusAuthorized;
        case PHAuthorizationStatusNotDetermined:
            return MPAuthorizationStatusNotDetermined;
// JUM 2020-09-04: PHAuthorizationStatusLimited is defined as AVAILABLE(ios(14)), yet when building with Xcode 12, compiler claims this exists... resorting to having a default: statement for now...
//        case PHAuthorizationStatusLimited:
//            return MPAuthorizationStatusAuthorized;
        default:
            return MPAuthorizationStatusNotDetermined;
    }
}

@end
