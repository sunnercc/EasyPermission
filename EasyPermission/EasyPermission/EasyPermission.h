//
//  EasyPermission.h
//  EasyPermission
//
//  Created by 陈晨晖 on 2019/6/13.
//  Copyright © 2019 sunner. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, EasyPermissionPrivacyType) {
    EasyPermissionPrivacyTypeCamera,
    EasyPermissionPrivacyTypePhotoLibrary,
    EasyPermissionPrivacyTypeMicrophone,
    EasyPermissionPrivacyTypeLocationAlways,
    EasyPermissionPrivacyTypeLocationWhenInUse,
    EasyPermissionPrivacyTypeLocationAlwaysAndWhenInUse,
    EasyPermissionPrivacyTypeContacts,
    EasyPermissionPrivacyTypeReminders,
    EasyPermissionPrivacyTypeCalendars,
    EasyPermissionPrivacyTypeSiri,
    EasyPermissionPrivacyTypeSpeechRecognition,
    EasyPermissionPrivacyTypeMusic,
    EasyPermissionPrivacyTypeMotion,
    EasyPermissionPrivacyTypeBluetooth
};

typedef NS_ENUM(NSUInteger, EasyPermissionAuthorizationStatus) {
    EasyPermissionAuthorizationStatusNotDetermined,
    EasyPermissionAuthorizationStatusRestricted,
    EasyPermissionAuthorizationStatusDenied,
    EasyPermissionAuthorizationStatusAuthorized
};

@interface EasyPermission : NSObject

+ (void)authorizationRequestWithPrivacyType:(EasyPermissionPrivacyType)privacyType completionHandler:(void (^)(EasyPermissionAuthorizationStatus status))handler;

+ (EasyPermissionAuthorizationStatus)getAuthorizationStatusWithPrivacyType:(EasyPermissionPrivacyType)type;

@end

NS_ASSUME_NONNULL_END
