//
//  GoodsNumberCount.h
//  TestShopCar
//
//  Created by 卢会旭 on 2018/4/25.
//  Copyright © 2018年 卢会旭. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^numberChangeBlock)(NSInteger count);
@interface GoodsNumberCount : UIView

//当前数量
@property (nonatomic,assign)NSInteger currentNumber;

//总数
@property (nonatomic,assign)NSInteger totalNumber;

//数量改变的block
@property (nonatomic,copy)numberChangeBlock countChangeBlock;

@end
