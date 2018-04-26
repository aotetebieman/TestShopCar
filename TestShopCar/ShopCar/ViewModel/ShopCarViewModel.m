//
//  ShopCarViewModel.m
//  TestShopCar
//
//  Created by 卢会旭 on 2018/4/25.
//  Copyright © 2018年 卢会旭. All rights reserved.
//

#import "ShopCarViewModel.h"
#import "ShopCarTableViewCell.h"
#import "ShopCarTableHeaderView.h"
@interface ShopCarViewModel (){
    NSArray *_priceArr;//价格数据
    NSArray *_picArr;//图片数据
    NSArray *_shopGoodsCount;//商品数量数据
    NSArray *_shopGoodsAmount;//商品总数数据
}
@property (nonatomic,assign)NSInteger random;
@end
@implementation ShopCarViewModel
-(instancetype)init {
    self = [super init];
    if (self) {
        //价格数据
        _priceArr = @[@(12),@(5.45),@(123.41),@(677.12),@(93.1)];
        //图片数据
        _picArr = @[@"http://pic.5tu.cn/uploads/allimg/1606/pic_5tu_big_2016052901023305535.jpg",
                            @"http://pic.5tu.cn/uploads/allimg/1605/pic_5tu_big_2016052901023303745.jpg",
                            @"http://pic.5tu.cn/uploads/allimg/1605/pic_5tu_big_201605291711245481.jpg",
                            @"http://pic.5tu.cn/uploads/allimg/1605/pic_5tu_big_2016052901023285762.jpg",
                            @"http://pic.5tu.cn/uploads/allimg/1506/091630516760.jpg",
                            @"http://pic.5tu.cn/uploads/allimg/1506/091630516760.jpg"];
        //商品数量
        _shopGoodsCount = @[@(4),@(3),@(9),@(1),@(2)];
        //总数
        _shopGoodsAmount = @[@(13),@(4),@(8),@(2),@(20)];
    }
    return self;
}
//获取数据
- (void)getData {
    //数据个数
    NSInteger allCount = 20;
    NSInteger allGoodCount = 0;
    NSMutableArray *shopCarArr = [NSMutableArray arrayWithCapacity:allCount];
    //选中的数据
    NSMutableArray *shopSelectedArr = [NSMutableArray arrayWithCapacity:allCount];
    for (int i = 0; i < allCount; i++) {
        NSInteger index = [_shopGoodsCount[self.random] intValue];
        NSMutableArray *goodsArr = [NSMutableArray arrayWithCapacity:index];
        for (int j = 0; j < index; j++) {
            ShopCarModel *model = [[ShopCarModel alloc] init];
            model.p_id = @"837827483748";
            model.p_stock = 22;
            model.imageUrl = _picArr[self.random];
            model.price      = [_priceArr[self.random] floatValue];
            model.name = [NSString stringWithFormat:@"%d测试名字的啊啊啊啊啊啊",j];
            model.amount = [_shopGoodsAmount[self.random] integerValue];
            [goodsArr addObject:model];
            allGoodCount++;
        }
        [shopCarArr addObject:goodsArr];
        //默认不选中
        [shopSelectedArr addObject:@(NO)];
    }
    //赋值
    self.shopData = shopCarArr;
    self.shopSelectArray = shopSelectedArr;
    self.shopCarGoods = allGoodCount;
}
- (NSInteger)random {
    NSInteger integer = (NSInteger)(arc4random() % 5);
    return integer;
}
- (void)configCell:(ShopCarTableViewCell *)cell forIndexPath:(NSIndexPath *) indexPath{
    ShopCarModel *model = self.shopData[indexPath.section][indexPath.row];
    
    [[[cell.shopSelectBtn rac_signalForControlEvents:UIControlEventTouchUpInside] takeUntil:cell.rac_prepareForReuseSignal] subscribeNext:^(__kindof UIControl * _Nullable x) {
        x.selected = !x.selected;
        [self rowSelected:x.selected forIndexPath:indexPath];
    }];
    
    cell.numberCount.countChangeBlock = ^(NSInteger count) {
        [self rowChangeAmount:count indexPath:indexPath];
    };
    
    cell.model = model;
}
#pragma mark---单元格数量改变
- (void)rowChangeAmount:(NSInteger)count indexPath:(NSIndexPath *)indexPath {
    ShopCarModel *model = self.shopData[indexPath.section][indexPath.row];
    
    [model setValue:@(count) forKey:@"amount"];
    
    //刷新数据
    [self.shopCarTableV reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    
    //重新计算价格
    self.allPrices = [self getAllPrices];
}
#pragma mark---单元格选中
- (void)rowSelected:(BOOL)selected forIndexPath:(NSIndexPath *)indexPath {
    //改变当前model的选中状态
    ShopCarModel *model = self.shopData[indexPath.section][indexPath.row];
    [model setValue:@(selected) forKey:@"isSelect"];
    NSInteger isAllSelect = 0;
    //判断当前对应的组的所有数据是否选中
    for (ShopCarModel *model in self.shopData[indexPath.section]) {
        if (model.isSelect) {
            isAllSelect ++;
        }
    }
    //是否全部选中
    [self.shopSelectArray replaceObjectAtIndex:indexPath.section withObject:(isAllSelect == [self.shopData[indexPath.section] count])?@(YES):@(NO)];
    //刷新数据
//    [self.shopCarTableV reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    [self.shopCarTableV reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationNone];
    /*重新计算价格*/
    self.allPrices = [self getAllPrices];
}
#pragma mark---重新结算价格
//计算价格
- (float)getAllPrices {
    float allPrice = 0;
    //商品数量
    NSInteger shopCount = self.shopData.count;
    //选中商品数量
    NSInteger selectedShopCount = self.shopSelectArray.count;
    if (selectedShopCount == shopCount && shopCount != 0) {
        //全选
        self.isSelectAll = YES;
    }
    
    for (NSArray *arr in self.shopData) {
        for (ShopCarModel *model in arr) {
            if (!model.isSelect) {
                self.isSelectAll = NO;
            }else {
                allPrice += model.amount * model.price;
//                allPrice += model.price;
            }
        }
    }
    return allPrice;
}

#pragma mark---全选
//全选
- (void)allSelectedData:(BOOL)selected {
    float allPrice = 0;
    for (NSArray *arr in self.shopData) {
        for (ShopCarModel *model in arr) {
            [model setValue:@(selected) forKey:@"isSelect"];
            if (model.isSelect) {
                allPrice += model.amount * model.price;
//                allPrice += model.price;
            }
        }
    }
    self.shopSelectArray = [[[[self.shopSelectArray rac_sequence] map:^id(NSNumber *value) {
        return @(selected);
    }] array] mutableCopy];
    self.allPrices = allPrice;
    [self.shopCarTableV reloadData];
}
#pragma mark---删除
//删除
- (void)deleteData {
    NSInteger index1 = -1;
    NSMutableIndexSet *selectIndex1 = [NSMutableIndexSet indexSet];
    for (NSMutableArray *arr in self.shopData) {
        index1 ++;
        NSInteger index2 = -1;
        NSMutableIndexSet *selectIndex2 = [NSMutableIndexSet indexSet];
        for (ShopCarModel *model in arr) {
            index2 ++;
            if (model.isSelect) {
                [selectIndex2 addIndex:index2];
            }
        }
        NSInteger shopCount = arr.count;
        NSInteger selectCount = selectIndex2.count;
        if (selectCount == shopCount) {
            [selectIndex1 addIndex:index1];
            self.shopCarGoods -= selectCount;
        }
        [arr removeObjectsAtIndexes:selectIndex2];
    }
    [self.shopData removeObjectsAtIndexes:selectIndex1];
    
    [self.shopSelectArray removeObjectsAtIndexes:selectIndex1];
    
    [self.shopCarTableV reloadData];
    
    //重新获取价格
    self.allPrices = 0;
    self.allPrices = [self getAllPrices];
}
#pragma mark---侧滑删除
- (void)deleteGoodsBySingleSlide:(NSIndexPath *)indexPath {
    //对应的组
    NSMutableArray *arr =  self.shopData[indexPath.section];
    
    [arr removeObjectAtIndex:indexPath.row];
    if (arr.count == 0) {
        [self.shopData removeObjectAtIndex:indexPath.section];
        [self.shopSelectArray removeObjectAtIndex:indexPath.section];
        [self.shopCarTableV reloadData];
    }else {
        
        NSInteger selectCount = 0;
        
        NSInteger shopCount = arr.count;
        for (ShopCarModel *model in arr) {
            if (model.isSelect) {
                selectCount ++;
            }
        }
        //判断剩下的数据是否是全选，如果全选，选中组的头视图按钮
        [self.shopSelectArray replaceObjectAtIndex:indexPath.section withObject:selectCount == shopCount ? @(YES) : @(NO)];
        
        [self.shopCarTableV reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationNone];
    }
    //购物车商品数量减一
    self.shopCarGoods -= 1;
    //删除数据后刷新价格
    self.allPrices = [self getAllPrices];
}
#pragma mark---UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.shopData.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *arr = self.shopData[section];
    return arr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ShopCarTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ShopCarCell" forIndexPath:indexPath];

    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [self configCell:cell forIndexPath:indexPath];

    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    //当前组的数据
    NSMutableArray *arr = self.shopData[section];
    ShopCarTableHeaderView *headerV = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"shopCarHeaderV"];
    [[[headerV.selectStoreGoodsButton rac_signalForControlEvents:UIControlEventTouchUpInside] takeUntil:headerV.rac_prepareForReuseSignal] subscribeNext:^(__kindof UIControl * _Nullable x) {
        x.selected = !x.selected;
        //更换当前选中数据的对应数据的选中状态
        [self.shopSelectArray replaceObjectAtIndex:section withObject:@(x.selected)];
        for (ShopCarModel *model in arr) {
            [model setValue:@(x.selected) forKey:@"isSelect"];
        }
        //刷新数据
        [self.shopCarTableV reloadSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:UITableViewRowAnimationNone];
        //重新计算价格
        self.allPrices = [self getAllPrices];
    }];
    
    //当前店铺的选中状态
    headerV.selectStoreGoodsButton.selected = [self.shopSelectArray[section] boolValue];
    return headerV;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return [ShopCarTableHeaderView getCartHeaderHeight];
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.00001f;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return nil;
}
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}
- (nullable NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"删除";
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        [self deleteGoodsBySingleSlide:indexPath];
    }
}
@end
