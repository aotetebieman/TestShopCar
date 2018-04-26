//
//  ShopCarBar.h
//  TestShopCar
//
//  Created by 卢会旭 on 2018/4/25.
//  Copyright © 2018年 卢会旭. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShopCarBar : UIView
//结算
@property (nonatomic, strong) UIButton *balanceButton;
//全选
@property (nonatomic, strong) UIButton *selectAllButton;
//价格
@property (nonatomic, retain) UILabel *allMoneyLabel;
//删除
@property (nonatomic, strong) UIButton *deleteButton;

@property (nonatomic, assign) BOOL     isNormalState;

@property (nonatomic, assign) float    money;
@end
