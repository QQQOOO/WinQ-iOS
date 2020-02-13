//
//  TopupProductSubCell.h
//  Qlink
//
//  Created by Jelly Foo on 2020/2/11.
//  Copyright © 2020 pan. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class TopupProductModel,TopupDeductionTokenModel;

static NSString *TopupProductSubCell_Reuse = @"TopupProductSubCell";
#define TopupProductSubCell_Height 140

@interface TopupProductSubCell : UITableViewCell

- (void)config:(TopupProductModel *)productM token:(TopupDeductionTokenModel *)tokenM;

@end

NS_ASSUME_NONNULL_END
