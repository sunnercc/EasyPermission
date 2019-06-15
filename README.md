an easy way to request authorization for iOS platform.

![demo](https://github.com/sunnercc/EasyPermission/blob/master/easyPermission.gif)

## supported permission privacy type
``` objc 
typedef NS_ENUM(NSUInteger, EasyPermissionPrivacyType) {
    EasyPermissionPrivacyTypeCamera,
    EasyPermissionPrivacyTypePhotoLibrary,
    EasyPermissionPrivacyTypeMicrophone,
    EasyPermissionPrivacyTypeLocationAlways,
    EasyPermissionPrivacyTypeLocationWhenInUse,
    EasyPermissionPrivacyTypeLocationAlwaysAndWhenInUse,
    EasyPermissionPrivacyTypeContacts NS_ENUM_AVAILABLE_IOS(9_0),
    EasyPermissionPrivacyTypeReminders,
    EasyPermissionPrivacyTypeCalendars,
    EasyPermissionPrivacyTypeSiri NS_ENUM_AVAILABLE_IOS(10_0),
    EasyPermissionPrivacyTypeSpeechRecognition NS_ENUM_AVAILABLE_IOS(10_0),
    EasyPermissionPrivacyTypeMusic NS_ENUM_AVAILABLE_IOS(9_3),
    EasyPermissionPrivacyTypeMotion NS_ENUM_AVAILABLE_IOS(11_0),
    EasyPermissionPrivacyTypeBluetooth
};
```

## supported authorization status
``` objc 
typedef NS_ENUM(NSUInteger, EasyPermissionAuthorizationStatus) {
    EasyPermissionAuthorizationStatusNotDetermined,
    EasyPermissionAuthorizationStatusRestricted,
    EasyPermissionAuthorizationStatusDenied,
    EasyPermissionAuthorizationStatusAuthorized
};
```

## use methods
``` objc 
+ (void)authorizationRequestWithPrivacyType:(EasyPermissionPrivacyType)privacyType
                          completionHandler:(void (^)(EasyPermissionAuthorizationStatus status))handler;

+ (EasyPermissionAuthorizationStatus)getAuthorizationStatusWithPrivacyType:(EasyPermissionPrivacyType)type;

```
