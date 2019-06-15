//
//  EasyPermission.m
//  EasyPermission
//
//  Created by 陈晨晖 on 2019/6/13.
//  Copyright © 2019 sunner. All rights reserved.
//

#import "EasyPermission.h"
#import <AVFoundation/AVFoundation.h>
#import <Photos/Photos.h>
#import <CoreLocation/CoreLocation.h>
#import <Contacts/Contacts.h>
#import <EventKit/EventKit.h>
#import <Intents/Intents.h>
#import <Speech/Speech.h>
#import <MediaPlayer/MediaPlayer.h>
#import <CoreMotion/CoreMotion.h>
#import <CoreBluetooth/CoreBluetooth.h>

typedef NS_ENUM(NSUInteger, EPLocationType) {
    EPLocationTypeAlways,
    EPLocationTypeWhenInUse,
    EPLocationTypeAlwaysAndWhenInUse
};

@interface EPLocationManager : NSObject <CLLocationManagerDelegate> {
    CLLocationManager *_mgr;
}
@property (nonatomic, copy) void (^completionHandler)(CLAuthorizationStatus status);

+ (instancetype)sharedInstance;

- (void)requestAccessForLocationType:(EPLocationType)locationType completionHandler:(void (^)(CLAuthorizationStatus status))handler;

+ (CLAuthorizationStatus)authorizationStatusForLocationType:(EPLocationType)type;

@end

@implementation EPLocationManager

- (instancetype)init {
    self = [super init];
    if (self) {
        _mgr = [[CLLocationManager alloc] init];
        _mgr.delegate = self;
    }
    return self;
}

+ (instancetype)sharedInstance {
    static id instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

- (void)requestAccessForLocationType:(EPLocationType)locationType completionHandler:(void (^)(CLAuthorizationStatus status))handler {
    _completionHandler = [handler copy];
    switch (locationType) {
        case EPLocationTypeAlways:
            [_mgr requestAlwaysAuthorization];
            break;
        case EPLocationTypeWhenInUse:
            [_mgr requestWhenInUseAuthorization];
            break;
        case EPLocationTypeAlwaysAndWhenInUse:
            if (@available(iOS 9.0, *)) {
                _mgr.allowsBackgroundLocationUpdates = true;
            } else {
                // Fallback on earlier versions
            }
            [_mgr requestAlwaysAuthorization];
            break;
    }
}

+ (CLAuthorizationStatus)authorizationStatusForLocationType:(EPLocationType)type {
    return [CLLocationManager authorizationStatus];
}

#pragma mark - CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    if (_completionHandler) {
        _completionHandler(status);
    }
}

@end

@interface EasyPermission ()
@end

@implementation EasyPermission

+ (void)authorizationRequestWithPrivacyType:(EasyPermissionPrivacyType)type completionHandler:(void (^)(EasyPermissionAuthorizationStatus))handler {
    switch (type) {
        case EasyPermissionPrivacyTypeCamera:
            [self authorizationRequestCameraWithHandler:handler];
            break;
        case EasyPermissionPrivacyTypePhotoLibrary:
            [self authorizationPhotoLibraryWithHandler:handler];
            break;
        case EasyPermissionPrivacyTypeMicrophone:
            [self authorizationRequestMicrophoneWithHandler:handler];
            break;
        case EasyPermissionPrivacyTypeLocationAlways:
            [self authorizationRequestLocationAlwaysWithHandler:handler];
            break;
        case EasyPermissionPrivacyTypeLocationWhenInUse:
            [self authorizationRequestLocationWhenInUseWithHandler:handler];
            break;
        case EasyPermissionPrivacyTypeLocationAlwaysAndWhenInUse:
            [self authorizationRequestLocationAlwaysAndWhenInUseWithHandler:handler];
            break;
        case EasyPermissionPrivacyTypeContacts:
            [self authorizationRequestContactsWithHandler:handler];
            break;
        case EasyPermissionPrivacyTypeReminders:
            [self authorizationRequestRemindersWithHandler:handler];
            break;
        case EasyPermissionPrivacyTypeCalendars:
            [self authorizationRequestCalendarsWithHandler:handler];
            break;
        case EasyPermissionPrivacyTypeSiri:
            [self authorizationRequestSiriWithHandler:handler];
            break;
        case EasyPermissionPrivacyTypeSpeechRecognition:
            [self authorizationRequestSpeechRecognitionWithHandler:handler];
            break;
        case EasyPermissionPrivacyTypeMusic:
            [self authorizationRequestMusicWithHandler:handler];
            break;
        case EasyPermissionPrivacyTypeMotion:
            [self authorizationRequestMotionWithHandler:handler];
            break;
        case EasyPermissionPrivacyTypeBluetooth:
            [self authorizationRequestBluetoothWithHandler:handler];
            break;
        default:
            break;
    }
}

+ (void)authorizationRequestCameraWithHandler:(void (^)(EasyPermissionAuthorizationStatus))handler {
    [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
        handler(granted ? EasyPermissionAuthorizationStatusAuthorized : EasyPermissionAuthorizationStatusDenied);
    }];
}

+ (void)authorizationPhotoLibraryWithHandler:(void (^)(EasyPermissionAuthorizationStatus))handler {
    [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
        switch (status) {
            case PHAuthorizationStatusNotDetermined:
                handler(EasyPermissionAuthorizationStatusNotDetermined);
                break;
            case PHAuthorizationStatusRestricted:
                handler(EasyPermissionAuthorizationStatusRestricted);
                break;
            case PHAuthorizationStatusDenied:
                handler(EasyPermissionAuthorizationStatusDenied);
                break;
            case PHAuthorizationStatusAuthorized:
                handler(EasyPermissionAuthorizationStatusAuthorized);
                break;
            default:
                break;
        }
    }];
}

+ (void)authorizationRequestMicrophoneWithHandler:(void (^)(EasyPermissionAuthorizationStatus))handler {
    [[AVAudioSession sharedInstance] requestRecordPermission:^(BOOL granted) {
        handler(granted ? EasyPermissionAuthorizationStatusAuthorized : EasyPermissionAuthorizationStatusDenied);
    }];
}

+ (void)authorizationRequestLocationAlwaysWithHandler:(void (^)(EasyPermissionAuthorizationStatus))handler {
    [[EPLocationManager sharedInstance] requestAccessForLocationType:(EPLocationTypeAlways) completionHandler:^(CLAuthorizationStatus status) {
        switch (status) {
            case kCLAuthorizationStatusNotDetermined:
                handler(EasyPermissionAuthorizationStatusNotDetermined);
                break;
            case kCLAuthorizationStatusRestricted:
                handler(EasyPermissionAuthorizationStatusRestricted);
                break;
            case kCLAuthorizationStatusDenied:
                handler(EasyPermissionAuthorizationStatusDenied);
                break;
            case kCLAuthorizationStatusAuthorizedAlways:
                handler(EasyPermissionAuthorizationStatusAuthorized);
                break;
            default:
                break;
        }
    }];
}

+ (void)authorizationRequestLocationWhenInUseWithHandler:(void (^)(EasyPermissionAuthorizationStatus))handler {
    [[EPLocationManager sharedInstance] requestAccessForLocationType:(EPLocationTypeWhenInUse) completionHandler:^(CLAuthorizationStatus status) {
        switch (status) {
            case kCLAuthorizationStatusNotDetermined:
                handler(EasyPermissionAuthorizationStatusNotDetermined);
                break;
            case kCLAuthorizationStatusRestricted:
                handler(EasyPermissionAuthorizationStatusRestricted);
                break;
            case kCLAuthorizationStatusDenied:
                handler(EasyPermissionAuthorizationStatusDenied);
                break;
            case kCLAuthorizationStatusAuthorizedWhenInUse:
                handler(EasyPermissionAuthorizationStatusAuthorized);
                break;
            default:
                break;
        }
    }];
}

+ (void)authorizationRequestLocationAlwaysAndWhenInUseWithHandler:(void (^)(EasyPermissionAuthorizationStatus))handler {
    [[EPLocationManager sharedInstance] requestAccessForLocationType:(EPLocationTypeAlwaysAndWhenInUse) completionHandler:^(CLAuthorizationStatus status) {
        switch (status) {
            case kCLAuthorizationStatusNotDetermined:
                handler(EasyPermissionAuthorizationStatusNotDetermined);
                break;
            case kCLAuthorizationStatusRestricted:
                handler(EasyPermissionAuthorizationStatusRestricted);
                break;
            case kCLAuthorizationStatusDenied:
                handler(EasyPermissionAuthorizationStatusDenied);
                break;
            case kCLAuthorizationStatusAuthorizedAlways:
                handler(EasyPermissionAuthorizationStatusAuthorized);
                break;
            default:
                break;
        }
    }];
}

+ (void)authorizationRequestContactsWithHandler:(void (^)(EasyPermissionAuthorizationStatus))handler {
    if (@available(iOS 9.0, *)) {
        [[[CNContactStore alloc] init] requestAccessForEntityType:(CNEntityTypeContacts) completionHandler:^(BOOL granted, NSError * _Nullable error) {
            handler(granted ? EasyPermissionAuthorizationStatusAuthorized : EasyPermissionAuthorizationStatusDenied);
        }];
    }
}

+ (void)authorizationRequestRemindersWithHandler:(void (^)(EasyPermissionAuthorizationStatus))handler {
    [[[EKEventStore alloc] init] requestAccessToEntityType:(EKEntityTypeReminder) completion:^(BOOL granted, NSError * _Nullable error) {
        handler(granted ? EasyPermissionAuthorizationStatusAuthorized : EasyPermissionAuthorizationStatusDenied);
    }];
}

+ (void)authorizationRequestCalendarsWithHandler:(void (^)(EasyPermissionAuthorizationStatus))handler {
    [[[EKEventStore alloc] init] requestAccessToEntityType:(EKEntityTypeEvent) completion:^(BOOL granted, NSError * _Nullable error) {
        handler(granted ? EasyPermissionAuthorizationStatusAuthorized : EasyPermissionAuthorizationStatusDenied);
    }];
}

+ (void)authorizationRequestSiriWithHandler:(void (^)(EasyPermissionAuthorizationStatus))handler {
    if (@available(iOS 10.0, *)) {
        [INPreferences requestSiriAuthorization:^(INSiriAuthorizationStatus status) {
            switch (status) {
                case INSiriAuthorizationStatusNotDetermined:
                    handler(EasyPermissionAuthorizationStatusNotDetermined);
                    break;
                case INSiriAuthorizationStatusRestricted:
                    handler(EasyPermissionAuthorizationStatusRestricted);
                    break;
                case INSiriAuthorizationStatusDenied:
                    handler(EasyPermissionAuthorizationStatusDenied);
                    break;
                case INSiriAuthorizationStatusAuthorized:
                    handler(EasyPermissionAuthorizationStatusAuthorized);
                    break;
                default:
                    break;
            }
        }];
    } else {
        // Fallback on earlier versions
    }
}

+ (void)authorizationRequestSpeechRecognitionWithHandler:(void (^)(EasyPermissionAuthorizationStatus))handler {
    if (@available(iOS 10.0, *)) {
        [SFSpeechRecognizer requestAuthorization:^(SFSpeechRecognizerAuthorizationStatus status) {
            switch (status) {
                case SFSpeechRecognizerAuthorizationStatusNotDetermined:
                    handler(EasyPermissionAuthorizationStatusNotDetermined);
                    break;
                case SFSpeechRecognizerAuthorizationStatusRestricted:
                    handler(EasyPermissionAuthorizationStatusRestricted);
                    break;
                case SFSpeechRecognizerAuthorizationStatusDenied:
                    handler(EasyPermissionAuthorizationStatusDenied);
                    break;
                case SFSpeechRecognizerAuthorizationStatusAuthorized:
                    handler(EasyPermissionAuthorizationStatusAuthorized);
                    break;
                default:
                    break;
            }
        }];
    } else {
        // Fallback on earlier versions
    }
}

+ (void)authorizationRequestMusicWithHandler:(void (^)(EasyPermissionAuthorizationStatus))handler {
    if (@available(iOS 9.3, *)) {
        [MPMediaLibrary requestAuthorization:^(MPMediaLibraryAuthorizationStatus status) {
            switch (status) {
                case MPMediaLibraryAuthorizationStatusNotDetermined:
                    handler(EasyPermissionAuthorizationStatusNotDetermined);
                    break;
                case MPMediaLibraryAuthorizationStatusRestricted:
                    handler(EasyPermissionAuthorizationStatusRestricted);
                    break;
                case MPMediaLibraryAuthorizationStatusDenied:
                    handler(EasyPermissionAuthorizationStatusDenied);
                    break;
                case MPMediaLibraryAuthorizationStatusAuthorized:
                    handler(EasyPermissionAuthorizationStatusAuthorized);
                    break;
                default:
                    break;
            }
        }];
    } else {
        // Fallback on earlier versions
    }
}

+ (void)authorizationRequestMotionWithHandler:(void (^)(EasyPermissionAuthorizationStatus))handler {
    NSAssert(NO, @"motion request not supports");
}

+ (void)authorizationRequestBluetoothWithHandler:(void (^)(EasyPermissionAuthorizationStatus))handler {
    NSAssert(NO, @"motion bluetooth not supports");
}

+ (EasyPermissionAuthorizationStatus)getAuthorizationStatusWithPrivacyType:(EasyPermissionPrivacyType)type {
    EasyPermissionAuthorizationStatus status = EasyPermissionAuthorizationStatusNotDetermined;
    switch (type) {
        case EasyPermissionPrivacyTypeCamera:
            status = [self getCameraAuthorizationStatus];
            break;
        case EasyPermissionPrivacyTypePhotoLibrary:
            status = [self getPhotoLibraryAuthorizationStatus];
            break;
        case EasyPermissionPrivacyTypeMicrophone:
            status = [self getMicrophoneAuthorizationStatus];
            break;
        case EasyPermissionPrivacyTypeLocationAlways:
            status = [self getLocationAlwaysAuthorizationStatus];
            break;
        case EasyPermissionPrivacyTypeLocationWhenInUse:
            status = [self getLocationWhenInUseAuthorizationStatus];
            break;
        case EasyPermissionPrivacyTypeLocationAlwaysAndWhenInUse:
            status = [self getLocationAlwaysAndWhenInUseAuthorizationStatus];
            break;
        case EasyPermissionPrivacyTypeContacts:
            status = [self getContactsAuthorizationStatus];
            break;
        case EasyPermissionPrivacyTypeReminders:
            status = [self getRemindersAuthorizationStatus];
            break;
        case EasyPermissionPrivacyTypeCalendars:
            status = [self getCalendarsAuthorizationStatus];
            break;
        case EasyPermissionPrivacyTypeSiri:
            status = [self getSiriAuthorizationStatus];
            break;
        case EasyPermissionPrivacyTypeSpeechRecognition:
            status = [self getSpeechRecognitionAuthorizationStatus];
            break;
        case EasyPermissionPrivacyTypeMusic:
            status = [self getMusicAuthorizationStatus];
            break;
        case EasyPermissionPrivacyTypeMotion:
            status = [self getMotionAuthorizationStatus];
            break;
        case EasyPermissionPrivacyTypeBluetooth:
            status = [self getBluetoothAuthorizationStatus];
        default:
            break;
    }
    return status;
}

+ (EasyPermissionAuthorizationStatus)getCameraAuthorizationStatus {
    AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    switch (status) {
        case AVAuthorizationStatusNotDetermined:
            return EasyPermissionAuthorizationStatusNotDetermined;
        case AVAuthorizationStatusRestricted:
            return EasyPermissionAuthorizationStatusRestricted;
        case AVAuthorizationStatusDenied:
            return EasyPermissionAuthorizationStatusDenied;
        case AVAuthorizationStatusAuthorized:
            return EasyPermissionAuthorizationStatusAuthorized;
    }
}

+ (EasyPermissionAuthorizationStatus)getPhotoLibraryAuthorizationStatus {
    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
    switch (status) {
        case PHAuthorizationStatusNotDetermined:
            return EasyPermissionAuthorizationStatusNotDetermined;
        case PHAuthorizationStatusRestricted:
            return EasyPermissionAuthorizationStatusRestricted;
        case PHAuthorizationStatusDenied:
            return EasyPermissionAuthorizationStatusDenied;
        case PHAuthorizationStatusAuthorized:
            return EasyPermissionAuthorizationStatusAuthorized;
    }
}

+ (EasyPermissionAuthorizationStatus)getMicrophoneAuthorizationStatus {
    AVAudioSessionRecordPermission status = [AVAudioSession sharedInstance].recordPermission;
    switch (status) {
        case AVAudioSessionRecordPermissionUndetermined:
            return EasyPermissionAuthorizationStatusNotDetermined;
        case AVAudioSessionRecordPermissionDenied:
            return EasyPermissionAuthorizationStatusDenied;
        case AVAudioSessionRecordPermissionGranted:
            return EasyPermissionAuthorizationStatusAuthorized;
    }
}

+ (EasyPermissionAuthorizationStatus)getLocationAlwaysAuthorizationStatus {
    CLAuthorizationStatus status = [EPLocationManager authorizationStatusForLocationType:(EPLocationTypeAlways)];
    switch (status) {
        case kCLAuthorizationStatusNotDetermined:
            return EasyPermissionAuthorizationStatusNotDetermined;
        case kCLAuthorizationStatusRestricted:
            return EasyPermissionAuthorizationStatusRestricted;
        case kCLAuthorizationStatusDenied:
            return EasyPermissionAuthorizationStatusDenied;
        case kCLAuthorizationStatusAuthorizedAlways:
            return EasyPermissionAuthorizationStatusAuthorized;
        default:
            return EasyPermissionAuthorizationStatusNotDetermined;
    }
}

+ (EasyPermissionAuthorizationStatus)getLocationWhenInUseAuthorizationStatus {
    CLAuthorizationStatus status = [EPLocationManager authorizationStatusForLocationType:(EPLocationTypeWhenInUse)];
    switch (status) {
        case kCLAuthorizationStatusNotDetermined:
            return EasyPermissionAuthorizationStatusNotDetermined;
        case kCLAuthorizationStatusRestricted:
            return EasyPermissionAuthorizationStatusRestricted;
        case kCLAuthorizationStatusDenied:
            return EasyPermissionAuthorizationStatusDenied;
        case kCLAuthorizationStatusAuthorizedWhenInUse:
            return EasyPermissionAuthorizationStatusAuthorized;
        default:
            return EasyPermissionAuthorizationStatusNotDetermined;
    }
}

+ (EasyPermissionAuthorizationStatus)getLocationAlwaysAndWhenInUseAuthorizationStatus {
    CLAuthorizationStatus status = [EPLocationManager authorizationStatusForLocationType:(EPLocationTypeAlwaysAndWhenInUse)];
    switch (status) {
        case kCLAuthorizationStatusNotDetermined:
            return EasyPermissionAuthorizationStatusNotDetermined;
        case kCLAuthorizationStatusRestricted:
            return EasyPermissionAuthorizationStatusRestricted;
        case kCLAuthorizationStatusDenied:
            return EasyPermissionAuthorizationStatusDenied;
        case kCLAuthorizationStatusAuthorizedAlways:
            return EasyPermissionAuthorizationStatusAuthorized;
        default:
            return EasyPermissionAuthorizationStatusNotDetermined;
    }
}

+ (EasyPermissionAuthorizationStatus)getContactsAuthorizationStatus {
    if (@available(iOS 9.0, *)) {
        CNAuthorizationStatus status = [CNContactStore authorizationStatusForEntityType:(CNEntityTypeContacts)];
        switch (status) {
            case CNAuthorizationStatusNotDetermined:
                return EasyPermissionAuthorizationStatusNotDetermined;
            case CNAuthorizationStatusRestricted:
                return EasyPermissionAuthorizationStatusRestricted;
            case CNAuthorizationStatusDenied:
                return EasyPermissionAuthorizationStatusDenied;
            case CNAuthorizationStatusAuthorized:
                return EasyPermissionAuthorizationStatusAuthorized;
        }
    } else {
        NSAssert(NO, @"available (iOS 9.0, *)");
        return EasyPermissionAuthorizationStatusNotDetermined;
    }
}

+ (EasyPermissionAuthorizationStatus)getRemindersAuthorizationStatus {
    EKAuthorizationStatus status = [EKEventStore authorizationStatusForEntityType:(EKEntityTypeReminder)];
    switch (status) {
        case EKAuthorizationStatusNotDetermined:
            return EasyPermissionAuthorizationStatusNotDetermined;
        case EKAuthorizationStatusRestricted:
            return EasyPermissionAuthorizationStatusRestricted;
        case EKAuthorizationStatusDenied:
            return EasyPermissionAuthorizationStatusDenied;
        case EKAuthorizationStatusAuthorized:
            return EasyPermissionAuthorizationStatusAuthorized;
    }
}

+ (EasyPermissionAuthorizationStatus)getCalendarsAuthorizationStatus {
    EKAuthorizationStatus status = [EKEventStore authorizationStatusForEntityType:EKEntityTypeEvent];
    switch (status) {
        case EKAuthorizationStatusNotDetermined:
            return EasyPermissionAuthorizationStatusNotDetermined;
        case EKAuthorizationStatusRestricted:
            return EasyPermissionAuthorizationStatusRestricted;
        case EKAuthorizationStatusDenied:
            return EasyPermissionAuthorizationStatusDenied;
        case EKAuthorizationStatusAuthorized:
            return EasyPermissionAuthorizationStatusAuthorized;
    }
}

+ (EasyPermissionAuthorizationStatus)getSiriAuthorizationStatus {
    if (@available(iOS 10.0, *)) {
        INSiriAuthorizationStatus status = [INPreferences siriAuthorizationStatus];
        switch (status) {
            case INSiriAuthorizationStatusNotDetermined:
                return EasyPermissionAuthorizationStatusNotDetermined;
            case INSiriAuthorizationStatusRestricted:
                return EasyPermissionAuthorizationStatusRestricted;
            case INSiriAuthorizationStatusDenied:
                return EasyPermissionAuthorizationStatusDenied;
            case INSiriAuthorizationStatusAuthorized:
                return EasyPermissionAuthorizationStatusAuthorized;
        }
    } else {
        NSAssert(NO, @"available (iOS 10.0, *)");
        return EasyPermissionAuthorizationStatusNotDetermined;
    }
}

+ (EasyPermissionAuthorizationStatus)getSpeechRecognitionAuthorizationStatus {
    if (@available(iOS 10.0, *)) {
        SFSpeechRecognizerAuthorizationStatus status = [SFSpeechRecognizer authorizationStatus];
        switch (status) {
            case SFSpeechRecognizerAuthorizationStatusNotDetermined:
                return EasyPermissionAuthorizationStatusNotDetermined;
            case SFSpeechRecognizerAuthorizationStatusRestricted:
                return EasyPermissionAuthorizationStatusRestricted;
            case SFSpeechRecognizerAuthorizationStatusDenied:
                return EasyPermissionAuthorizationStatusDenied;
            case SFSpeechRecognizerAuthorizationStatusAuthorized:
                return EasyPermissionAuthorizationStatusAuthorized;
        }
    } else {
        NSAssert(NO, @"available (iOS 10.0, *)");
        return EasyPermissionAuthorizationStatusNotDetermined;
    }
}

+ (EasyPermissionAuthorizationStatus)getMusicAuthorizationStatus {
    if (@available(iOS 9.3, *)) {
        MPMediaLibraryAuthorizationStatus status = [MPMediaLibrary authorizationStatus];
        switch (status) {
            case MPMediaLibraryAuthorizationStatusNotDetermined:
                return EasyPermissionAuthorizationStatusNotDetermined;
            case MPMediaLibraryAuthorizationStatusRestricted:
                return EasyPermissionAuthorizationStatusRestricted;
            case MPMediaLibraryAuthorizationStatusDenied:
                return EasyPermissionAuthorizationStatusDenied;
            case MPMediaLibraryAuthorizationStatusAuthorized:
                return EasyPermissionAuthorizationStatusAuthorized;
        }
    } else {
        NSAssert(NO, @"available (iOS 9.3, *)");
        return EasyPermissionAuthorizationStatusNotDetermined;
    }
}

+ (EasyPermissionAuthorizationStatus)getMotionAuthorizationStatus {
    if (@available(iOS 11.0, *)) {
        CMAuthorizationStatus status = [CMAltimeter authorizationStatus];
        switch (status) {
            case CMAuthorizationStatusNotDetermined:
                return EasyPermissionAuthorizationStatusNotDetermined;
            case CMAuthorizationStatusRestricted:
                return EasyPermissionAuthorizationStatusRestricted;
            case CMAuthorizationStatusDenied:
                return EasyPermissionAuthorizationStatusDenied;
            case CMAuthorizationStatusAuthorized:
                return EasyPermissionAuthorizationStatusAuthorized;
        }
    } else {
        NSAssert(NO, @"available (iOS 11.0, *)");
        return EasyPermissionAuthorizationStatusNotDetermined;
    }
}

+ (EasyPermissionAuthorizationStatus)getBluetoothAuthorizationStatus {
    CBPeripheralManagerAuthorizationStatus status = [CBPeripheralManager authorizationStatus];
    switch (status) {
        case CBPeripheralManagerAuthorizationStatusNotDetermined:
            return EasyPermissionAuthorizationStatusNotDetermined;
        case CBPeripheralManagerAuthorizationStatusRestricted:
            return EasyPermissionAuthorizationStatusRestricted;
        case CBPeripheralManagerAuthorizationStatusDenied:
            return EasyPermissionAuthorizationStatusDenied;
        case CBPeripheralManagerAuthorizationStatusAuthorized:
            return EasyPermissionAuthorizationStatusAuthorized;
    }
}

@end
