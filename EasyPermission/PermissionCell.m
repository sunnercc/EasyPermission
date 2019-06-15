//
//  PermissionCell.m
//  EasyPermission
//
//  Created by 陈晨晖 on 2019/6/13.
//  Copyright © 2019 sunner. All rights reserved.
//

#import "PermissionCell.h"

@implementation PermissionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)request:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(permissionCell:requestClick:)]) {
        [self.delegate permissionCell:self requestClick:sender];
    }
}

- (IBAction)status:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(permissionCell:statusButton:)]) {
        [self.delegate permissionCell:self statusButton:sender];
    }
}


@end
