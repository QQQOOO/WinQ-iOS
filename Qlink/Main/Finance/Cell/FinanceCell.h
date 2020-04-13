//
//  FinanceCell.h
//  Qlink
//
//  Created by Jelly Foo on 2019/4/11.
//  Copyright © 2019 pan. All rights reserved.
//

#import "QBaseTableCell.h"

@class FinanceProductModel;

static NSString *FinanceCellReuse = @"FinanceCell";
#define FinanceCell_Height 112

@interface FinanceCell : QBaseTableCell

@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UILabel *rateValLab;
@property (weak, nonatomic) IBOutlet UILabel *dayLab;
@property (weak, nonatomic) IBOutlet UILabel *fromQLCLab;
@property (weak, nonatomic) IBOutlet UIImageView *arrow;
@property (weak, nonatomic) IBOutlet UILabel *statusLab;

- (void)configCell:(FinanceProductModel *)model;

@end
