//
//  ShopCarTableHeaderView.h
//  TestShopCar
//
//  Created by 卢会旭 on 2018/4/25.
//  Copyright © 2018年 卢会旭. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShopCarTableHeaderView : UITableViewHeaderFooterView

@property (nonatomic, strong) UIButton *selectStoreGoodsButton;

+ (CGFloat)getCartHeaderHeight;
@end
