//
//  ViewController.m
//  EasyPermission
//
//  Created by 陈晨晖 on 2019/6/13.
//  Copyright © 2019 sunner. All rights reserved.
//

#import "ViewController.h"
#import "PermissionCell.h"
#import "EasyPermission/EasyPermission.h"
#define permissionReuseID @"permissionReuseID"
@interface ViewController () <UITableViewDelegate, UITableViewDataSource, PermissionCellDelegate>
@property (weak, nonatomic) IBOutlet UITableView *permissionTableView;
@property (copy, nonatomic) NSArray <NSString *> *datas;
@property (copy, nonatomic) NSArray <NSNumber *> *privacyTypes;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _datas = @[@"camera", @"photoLibrary", @"microphone", @"locationAlways", @"locationWhenInUse", @"locationAlwaysAndWhenInUse", @"contacts", @"reminders", @"calendars", @"siri", @"speechRecognition", @"music", @"motion", @"bluetooth"];
    _privacyTypes = @[@(EasyPermissionPrivacyTypeCamera), @(EasyPermissionPrivacyTypePhotoLibrary), @(EasyPermissionPrivacyTypeMicrophone), @(EasyPermissionPrivacyTypeLocationAlways), @(EasyPermissionPrivacyTypeLocationWhenInUse), @(EasyPermissionPrivacyTypeLocationAlwaysAndWhenInUse), @(EasyPermissionPrivacyTypeContacts), @(EasyPermissionPrivacyTypeReminders), @(EasyPermissionPrivacyTypeCalendars), @(EasyPermissionPrivacyTypeSiri), @(EasyPermissionPrivacyTypeSpeechRecognition), @(EasyPermissionPrivacyTypeMusic), @(EasyPermissionPrivacyTypeMotion), @(EasyPermissionPrivacyTypeBluetooth)];
    
    [_permissionTableView registerNib:[UINib nibWithNibName:NSStringFromClass([PermissionCell class]) bundle:nil] forCellReuseIdentifier:permissionReuseID];
}

- (void)_alertWithTitle:(NSString *)title authorizationStatus:(EasyPermissionAuthorizationStatus)status {
    NSString *message = @"no status";
    switch (status) {
        case EasyPermissionAuthorizationStatusNotDetermined:
            message = @"not determined";
            break;
        case EasyPermissionAuthorizationStatusRestricted:
            message = @"restricted";
            break;
        case EasyPermissionAuthorizationStatusDenied:
            message = @"denied";
            break;
        case EasyPermissionAuthorizationStatusAuthorized:
            message = @"authorized";
            break;
        default:
            break;
    }
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:(UIAlertControllerStyleAlert)];
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"ok" style:(UIAlertActionStyleDefault) handler:nil];
    [alert addAction:ok];
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - UITableViewDataSource & UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _datas.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PermissionCell *cell = [tableView dequeueReusableCellWithIdentifier:permissionReuseID forIndexPath:indexPath];
    cell.titleLabel.text = _datas[indexPath.row];
    cell.delegate = self;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50.f;
}

#pragma mark - PermissionCellDelegate
- (void)permissionCell:(PermissionCell *)cell requestClick:(UIButton *)requestButton {
    NSUInteger row = [self.permissionTableView indexPathForCell:cell].row;
    [EasyPermission authorizationRequestWithPrivacyType:_privacyTypes[row].integerValue completionHandler:^(EasyPermissionAuthorizationStatus status) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self _alertWithTitle:cell.titleLabel.text authorizationStatus:status];
        });
    }];
}

- (void)permissionCell:(PermissionCell *)cell statusButton:(UIButton *)statusButton {
    NSUInteger row = [self.permissionTableView indexPathForCell:cell].row;
    EasyPermissionAuthorizationStatus status = [EasyPermission getAuthorizationStatusWithPrivacyType:_privacyTypes[row].integerValue];
    [self _alertWithTitle:cell.titleLabel.text authorizationStatus:status];
}

@end
