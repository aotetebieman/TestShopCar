//
//  ShopCarModel.h
//  TestShopCar
//
//  Created by 卢会旭 on 2018/4/25.
//  Copyright © 2018年 卢会旭. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ShopCarModel : NSObject
//商品id 
@property (nonatomic, strong) NSString  *p_id;

@property (nonatomic, assign) float     price;

@property (nonatomic, strong) NSString  *name;

@property (nonatomic, strong) NSString  *imageUrl;

@property (nonatomic, assign) NSInteger amount;
//最大数量
@property (nonatomic, assign) NSInteger p_stock;
//商品是否被选中
@property (nonatomic, assign) BOOL      isSelect;
@end
