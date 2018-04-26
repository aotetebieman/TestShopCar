//
//  ShopCarTableHeaderView.m
//  TestShopCar
//
//  Created by 卢会旭 on 2018/4/25.
//  Copyright © 2018年 卢会旭. All rights reserved.
//

#import "ShopCarTableHeaderView.h"
@interface ShopCarTableHeaderView()

@property (nonatomic, strong) UIButton *storeNameButton;

@end
@implementation ShopCarTableHeaderView
- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        
        [self setHeaderUI];
    }
    return self;
}

- (void)setHeaderUI{
    
    self.contentView.backgroundColor = [UIColor whiteColor];
    
    self.selectStoreGoodsButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.selectStoreGoodsButton.frame = CGRectZero;
    [self.selectStoreGoodsButton setImage:[UIImage imageNamed:@"xn_circle_normal"]
                                 forState:UIControlStateNormal];
    [self.selectStoreGoodsButton setImage:[UIImage imageNamed:@"xn_circle_select"]
                                 forState:UIControlStateSelected];
    self.selectStoreGoodsButton.backgroundColor=[UIColor clearColor];
    [self addSubview:self.selectStoreGoodsButton];
    
    self.storeNameButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.storeNameButton.frame = CGRectZero;
    [self.storeNameButton setTitle:@"店铺名字_____"
                          forState:UIControlStateNormal];
    [self.storeNameButton setTitleColor:[UIColor blackColor]
                               forState:UIControlStateNormal];
    self.storeNameButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    self.storeNameButton.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    self.storeNameButton.titleLabel.font = [UIFont systemFontOfSize:13];
    [self addSubview:self.storeNameButton];
    
}

- (void)layoutSubviews{
    
    [super layoutSubviews];
    
    self.selectStoreGoodsButton.frame = CGRectMake(0, 0, 36, 30);
    
    self.storeNameButton.frame = CGRectMake(40, 0, WIDTH - 40, 30);
    
}

+ (CGFloat)getCartHeaderHeight{
    
    return 30;
}
@end
