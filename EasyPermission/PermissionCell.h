//
//  PermissionCell.h
//  EasyPermission
//
//  Created by 陈晨晖 on 2019/6/13.
//  Copyright © 2019 sunner. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class PermissionCell;

@protocol PermissionCellDelegate <NSObject>
@optional
- (void)permissionCell:(PermissionCell *)cell requestClick:(UIButton *)requestButton;
- (void)permissionCell:(PermissionCell *)cell statusButton:(UIButton *)statusButton;
@end

@interface PermissionCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *requestButton;
@property (weak, nonatomic) IBOutlet UIButton *statusButton;
@property (weak, nonatomic) id<PermissionCellDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
