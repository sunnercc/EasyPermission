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
    EasyPermissionPrivacyTypeContacts,
    EasyPermissionPrivacyTypeReminders,
    EasyPermissionPrivacyTypeCalendars,
    EasyPermissionPrivacyTypeSiri,
    EasyPermissionPrivacyTypeSpeechRecognition,
    EasyPermissionPrivacyTypeMusic,
    EasyPermissionPrivacyTypeMotion,
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
+ (void)authorizationRequestWithPrivacyType:(EasyPermissionPrivacyType)privacyType handler:(void (^)(EasyPermissionAuthorizationStatus status))handler;

+ (EasyPermissionAuthorizationStatus)getAuthorizationStatusWithPrivacyType:(EasyPermissionPrivacyType)privacyType;

```
