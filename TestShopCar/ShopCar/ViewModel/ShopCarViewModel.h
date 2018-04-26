//
//  ShopCarViewModel.h
//  TestShopCar
//
//  Created by 卢会旭 on 2018/4/25.
//  Copyright © 2018年 卢会旭. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ShopCarModel.h"
@class ShopCarViewController;
@interface ShopCarViewModel : NSObject <UITableViewDelegate,UITableViewDataSource>

//店铺数据
@property (nonatomic,strong)NSMutableArray *shopData;
//是否选中的数据
@property (nonatomic,strong)NSMutableArray *shopSelectArray;
/**
 *  carbar 观察的属性变化
 */
@property (nonatomic, assign) float allPrices;
/**
 *  carbar 全选的状态
 */
@property (nonatomic, assign) BOOL isSelectAll;
//购物车商品数量
@property (nonatomic,assign)NSInteger shopCarGoods;

@property (nonatomic,strong)UITableView *shopCarTableV;

@property (nonatomic, weak) ShopCarViewController *shopCarVC;
//获取数据
- (void)getData;
//全选
- (void)allSelectedData:(BOOL)selected;
//删除
- (void)deleteData;
@end
