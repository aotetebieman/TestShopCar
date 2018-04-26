//
//  ShopCarTableViewCell.m
//  TestShopCar
//
//  Created by 卢会旭 on 2018/4/25.
//  Copyright © 2018年 卢会旭. All rights reserved.
//

#import "ShopCarTableViewCell.h"

@implementation ShopCarTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)setModel:(ShopCarModel *)model {
    self.shopSelectBtn.selected = model.isSelect;
    self.goodName.text = model.name;
    self.goodsPrice.text = [NSString stringWithFormat:@"￥%.2f",model.price];
    self.numberCount.totalNumber = model.p_stock;
    self.numberCount.currentNumber = model.amount;
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
