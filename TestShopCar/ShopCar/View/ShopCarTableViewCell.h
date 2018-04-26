//
//  ShopCarTableViewCell.h
//  TestShopCar
//
//  Created by 卢会旭 on 2018/4/25.
//  Copyright © 2018年 卢会旭. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShopCarModel.h"
#import "GoodsNumberCount.h"
@interface ShopCarTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *shopSelectBtn;
@property (weak, nonatomic) IBOutlet UIImageView *goodImageV;
@property (weak, nonatomic) IBOutlet UILabel *goodName;
@property (weak, nonatomic) IBOutlet UILabel *goodsPrice;
@property (weak, nonatomic) IBOutlet GoodsNumberCount *numberCount;

@property (nonatomic,strong)ShopCarModel *model;

@end
