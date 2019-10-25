//
//  MnemonicTipView.m
//  Qlink
//
//  Created by Jelly Foo on 2018/10/23.
//  Copyright © 2018 pan. All rights reserved.
//

#import "TopupPayLoadView.h"
#import "UIView+Visuals.h"
#import "WalletCommonModel.h"
#import "GlobalConstants.h"

@interface TopupPayLoadView ()

@property (weak, nonatomic) IBOutlet UIView *tipBack;
@property (weak, nonatomic) IBOutlet UIImageView *walletIcon;
@property (weak, nonatomic) IBOutlet UILabel *walletNameLab;
@property (weak, nonatomic) IBOutlet UILabel *walletAddressLab;
@property (weak, nonatomic) IBOutlet UIImageView *img1;
@property (weak, nonatomic) IBOutlet UIImageView *img2;
@property (weak, nonatomic) IBOutlet UILabel *tipLab1;
@property (weak, nonatomic) IBOutlet UILabel *tipLab2;
@property (nonatomic, copy) TopupPayCompleteBlock completeB;
@property (nonatomic, strong) NSString *currentSymbol;

@end

@implementation TopupPayLoadView

+ (instancetype)getInstance {
    TopupPayLoadView *view = [[[NSBundle mainBundle] loadNibNamed:@"TopupPayLoadView" owner:self options:nil] lastObject];
    [view.tipBack cornerRadius:8];
    return view;
}

- (void)config:(WalletCommonModel *)model symbol:(NSString *)symbol completeB:(TopupPayCompleteBlock)completeB {
    _completeB = completeB;
    _currentSymbol = symbol;
    
    _img1.image = [UIImage imageNamed:@"icon_background_load"];
    _img2.image = [UIImage imageNamed:@"icon_background_no"];
    _tipLab1.text = [NSString stringWithFormat:kLang(@"_is_being_paid"),_currentSymbol];
    _tipLab2.text = kLang(@"generate_recharge_vouchers_on_the_chain");
    
    _walletIcon.image = [WalletCommonModel walletIcon:model.walletType];
    _walletNameLab.text = model.name;
    _walletAddressLab.text = [NSString stringWithFormat:@"%@...%@",[model.address substringToIndex:8],[model.address substringWithRange:NSMakeRange(model.address.length - 8, 8)]];
}

- (void)startPayAnimate {
    kWeakSelf(self);
    _img1.image = [UIImage imageNamed:@"icon_background_success"];
    _img2.image = [UIImage imageNamed:@"icon_background_load"];
    _tipLab1.text = [NSString stringWithFormat:kLang(@"successfully_paid_"),_currentSymbol];
    _tipLab2.text = kLang(@"generating_recharge_vouchers_on_the_chain");
    [UIView animateWithDuration:0.2 animations:^{
        weakself.img1.transform = CGAffineTransformMakeScale(1.2, 1.2);
        weakself.img2.transform = CGAffineTransformMakeScale(1.2, 1.2);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.2 animations:^{
            weakself.img1.transform = CGAffineTransformIdentity;
            weakself.img2.transform = CGAffineTransformIdentity;
        }];
    }];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{ // 延时
        weakself.img2.image = [UIImage imageNamed:@"icon_background_success"];
        weakself.tipLab1.text = [NSString stringWithFormat:kLang(@"successfully_paid_"),_currentSymbol];
        _tipLab2.text = kLang(@"the_recharge_voucher_on_the_chain_was_successfully_generated");
        [UIView animateWithDuration:0.2 animations:^{
            weakself.img2.transform = CGAffineTransformMakeScale(1.2, 1.2);
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.2 animations:^{
                weakself.img2.transform = CGAffineTransformIdentity;
            }];
        }];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{ // 延时
            if (weakself.completeB) {
                weakself.completeB();
            }
            
            [weakself hide];
        });
    });
}

- (void)show {
    self.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    [kAppD.window addSubview:self];
}

- (void)hide {
    [self removeFromSuperview];
}


@end
