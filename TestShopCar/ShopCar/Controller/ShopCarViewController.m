//
//  ShopCarViewController.m
//  TestShopCar
//
//  Created by 卢会旭 on 2018/4/25.
//  Copyright © 2018年 卢会旭. All rights reserved.
//

#import "ShopCarViewController.h"
#import "ShopCarBar.h"
@interface ShopCarViewController ()
@property (nonatomic,strong)ShopCarViewModel *viewModel;
//表视图
@property (nonatomic,strong)UITableView *shopCarTableV;
//底部按钮视图
@property (nonatomic,strong)ShopCarBar *shopCarBar;

//编辑按钮
@property (nonatomic,strong)UIBarButtonItem *editBtn;
@property (nonatomic,assign)BOOL isEdit;
@end

@implementation ShopCarViewController
- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    [self loadData];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = YES;
    self.title = @"购物车";
    self.view.backgroundColor = [UIColor whiteColor];
    self.isEdit = NO;
    self.navigationItem.rightBarButtonItem = self.editBtn;
    [self.view addSubview:self.shopCarTableV];
    [self.view addSubview:self.shopCarBar];
    //全选
    [[self.shopCarBar.selectAllButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        x.selected = !x.selected;
        //全选
        [self.viewModel allSelectedData:x.selected];
    }];
    //删除
    [[self.shopCarBar.deleteButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        //选中删除
        [self.viewModel deleteData];
    }];
    //结算
    [[self.shopCarBar.balanceButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        //结算
        NSLog(@"结算");
    }];
    
    //监听价格
    [RACObserve(self.viewModel, allPrices) subscribeNext:^(NSNumber *x) {
        self.shopCarBar.money = x.floatValue;
    }];
    /* 全选 状态 */
    RAC(self.shopCarBar.selectAllButton,selected) = RACObserve(self.viewModel, isSelectAll);
    /* 购物车数量 */
    [RACObserve(self.viewModel, shopCarGoods) subscribeNext:^(NSNumber *x) {

        if(x.integerValue == 0){
            self.title = [NSString stringWithFormat:@"购物车"];
        } else {
            self.title = [NSString stringWithFormat:@"购物车(%@)",x];
        }
        
    }];
}
- (void)loadData {
    [self.viewModel getData];
    [self.shopCarTableV reloadData];
}
- (void)editClick:(UIBarButtonItem *)sender {
    self.isEdit = !self.isEdit;
    NSString *itemTitle = self.isEdit == YES?@"完成":@"编辑";
    sender.title = itemTitle;
    self.shopCarBar.isNormalState = !self.isEdit;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark --- lazy load
-(ShopCarViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[ShopCarViewModel alloc] init];
        _viewModel.shopCarTableV = self.shopCarTableV;
        _viewModel.shopCarVC = self;
    }
    return _viewModel;
}
- (UITableView *)shopCarTableV {
    if (!_shopCarTableV) {
        _shopCarTableV = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT - 50) style:UITableViewStyleGrouped];
        [_shopCarTableV registerNib:[UINib nibWithNibName:@"ShopCarTableViewCell" bundle:nil]
             forCellReuseIdentifier:@"ShopCarCell"];
        [_shopCarTableV registerClass:NSClassFromString(@"ShopCarTableHeaderView") forHeaderFooterViewReuseIdentifier:@"shopCarHeaderV"];
        _shopCarTableV.delegate = self.viewModel;
        _shopCarTableV.dataSource = self.viewModel;
    }
    return _shopCarTableV;
}
-(ShopCarBar *)shopCarBar {
    if (!_shopCarBar) {
        _shopCarBar = [[ShopCarBar alloc] initWithFrame:CGRectMake(0, HEIGHT - 50, WIDTH, 50)];
        _shopCarBar.isNormalState = YES;
    }
    return _shopCarBar;
}
-(UIBarButtonItem *)editBtn {
    if (!_editBtn) {
        _editBtn = [[UIBarButtonItem alloc] initWithTitle:@"编辑" style:UIBarButtonItemStyleDone target:self action:@selector(editClick:)];
        _editBtn.tintColor = RGBColor(170, 170, 170, 1);
    }
    return _editBtn;
}
@end
