//
//  GoodsNumberCount.m
//  TestShopCar
//
//  Created by 卢会旭 on 2018/4/25.
//  Copyright © 2018年 卢会旭. All rights reserved.
//

#import "GoodsNumberCount.h"
static CGFloat const Wd = 28;
@interface GoodsNumberCount()
//加号按钮
@property (nonatomic,strong)UIButton *addBtn;
//减号按钮
@property (nonatomic,strong)UIButton *subBtn;
//显示数量的输入框
@property (nonatomic,strong)UITextField *numTextF;
@end
@implementation GoodsNumberCount
#pragma mark--lazy load
//加号
-(UIButton *)addBtn {
    if (!_addBtn) {
        _addBtn = [ZCControl createButtonWithFrame:CGRectMake(CGRectGetMaxX(self.numTextF.frame), 0, Wd, Wd) ImageName:@"product_detail_add_normal" Target:nil Action:nil Title:nil];
        [_addBtn setBackgroundImage:[UIImage imageNamed:@"product_detail_add_no"]
                              forState:UIControlStateDisabled];
        _addBtn.tag = 1;
        [self addSubview:_addBtn];
    }
    return _addBtn;
}
//减号
-(UIButton *)subBtn {
    if (!_subBtn) {
        _subBtn = [ZCControl createButtonWithFrame:CGRectMake(0, 0, Wd, Wd) ImageName:@"product_detail_sub_normal" Target:nil Action:nil Title:nil];
        [_subBtn setBackgroundImage:[UIImage imageNamed:@"product_detail_sub_no"]
                           forState:UIControlStateDisabled];
        _subBtn.tag = 0;
        [self addSubview:_subBtn];
    }
    return _subBtn;
}
//数量输入框
-(UITextField *)numTextF {
    if (!_numTextF) {
        _numTextF = [ZCControl createTextFieldWithFrame:CGRectMake(CGRectGetMaxX(self.subBtn.frame), 0, Wd*1.5, self.subBtn.frame.size.height) placeholder:nil passWord:NO leftImageView:nil rightImageView:nil Font:17 backgRoundImageName:nil];
        _numTextF.keyboardType = UIKeyboardTypeNumberPad;
        _numTextF.layer.borderWidth = 1.3;
        _numTextF.layer.borderColor = RGBColor(201, 201, 201, 1).CGColor;
        _numTextF.textColor = [UIColor blackColor];
        _numTextF.adjustsFontSizeToFitWidth = YES;
        _numTextF.textAlignment = NSTextAlignmentCenter;
        _numTextF.text = [NSString stringWithFormat:@"%@",@(0)];
        _numTextF.backgroundColor = [UIColor whiteColor];
        [self addSubview:_numTextF];
    }
    return _numTextF;
}
-(instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        //创建视图
        [self createUI];
    }
    return self;
}
-(void)awakeFromNib {
    [super awakeFromNib];
    //创建视图
    [self createUI];
}
- (void)createUI {
    self.backgroundColor = [UIColor clearColor];
    self.currentNumber = 0;
    self.totalNumber = 0;
    //减号按钮
    [[self.subBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        self.currentNumber --;
        if (self.countChangeBlock) {
            self.countChangeBlock(self.currentNumber);
        }
    }];
    
    
    //内容改变
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:@"UITextFieldTextDidEndEditingNotification" object:self.numTextF] subscribeNext:^(NSNotification * _Nullable x) {
        UITextField *tf = x.object;
        NSString *text = tf.text;
        NSInteger changeNum = 0;
        if (text.integerValue > self.totalNumber && self.totalNumber != 0) {
            self.currentNumber = self.totalNumber;
            self.numTextF.text = [NSString stringWithFormat:@"%@",@(self.totalNumber)];
            changeNum = self.totalNumber;
        }else if (text.integerValue<1){
            
            self.numTextF.text = @"1";
            changeNum = 1;
            
        } else {
            
            self.currentNumber = text.integerValue;
            changeNum = self.currentNumber;
            
        }
        if (self.countChangeBlock) {
            self.countChangeBlock(changeNum);
        }
    }];
    //加号按钮
    [[self.addBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        self.currentNumber ++;
        if (self.countChangeBlock) {
            self.countChangeBlock(self.currentNumber);
        }
    }];
    
    RACSignal *subSignal = [RACObserve(self, currentNumber) map:^id _Nullable(NSNumber  *subValue) {
        return @(subValue.integerValue > 1);
    }];
    RACSignal *addSignal = [RACObserve(self, currentNumber) map:^id _Nullable(NSNumber * addValue) {
        return @(addValue.integerValue < self.totalNumber);
    }];
    
    RAC(self.subBtn,enabled) = subSignal;
    RAC(self.addBtn,enabled) = addSignal;
    
    //内容显示
    RACSignal *numberColorSingal = [RACObserve(self, totalNumber) map:^id _Nullable(NSNumber *  _Nullable totalValue) {
        return totalValue.integerValue == 0 ? [UIColor redColor] : [UIColor blackColor];
    }];
    RAC(self.numTextF,textColor) = numberColorSingal;
    
    //内容改变
    RACSignal *textSignal = [RACObserve(self, currentNumber) map:^id _Nullable(NSNumber  *_Nullable value) {
        return [NSString stringWithFormat:@"%@",value];
    }];
    RAC(self.numTextF,text) = textSignal;
}
@end
