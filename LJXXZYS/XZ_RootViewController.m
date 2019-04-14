//
//  XZ_RootViewController.m
//  LJXXZYS
//
//  Created by 栾金鑫 on 2019/4/13.
//  Copyright © 2019年 栾金鑫. All rights reserved.
//

#import "XZ_RootViewController.h"
#import "XZ_CollectionCell.h"
#import "XZ_ChooseYSViewController.h"

@interface XZ_RootViewController () <UICollectionViewDelegate , UICollectionViewDataSource>

@property (nonatomic , strong) UIImageView * bgImage;

@property (nonatomic , strong) UILabel * titleLabel;

@property (nonatomic , strong) UICollectionView * xzCollection;

@property (nonatomic , strong) NSMutableArray * dataArray;

@property (nonatomic , strong) NSMutableArray * imgArr;

@property (nonatomic , strong) NSMutableArray * btnArr;

@end

@implementation XZ_RootViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    if (@available(iOS 11.0, *)) {
        self.xzCollection.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.navigationController.navigationBarHidden = YES;
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    self.navigationController.navigationBarHidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self configUI];
}

- (void) configUI {
    __weak typeof (self) weakSelf = self;
    [self.view addSubview:self.bgImage];
    [self.view addSubview:self.titleLabel];

    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    //设置布局方向为垂直流布局
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    // 行间距
    layout.minimumLineSpacing = INMFit(10);
    layout.minimumInteritemSpacing = INMFit(10);
    //设置每个item的大小
    layout.itemSize = CGSizeMake((INMScreenW - INMFit(40))/3, INMFit(120));
    layout.sectionInset = UIEdgeInsetsMake( 0, INMFit(10), 0, INMFit(10)); //设置距离上 左 下 右
    UICollectionView * collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    collectionView.delegate = self;
    collectionView.dataSource = self;
    collectionView.showsVerticalScrollIndicator = NO;
    collectionView.showsHorizontalScrollIndicator = NO;
    
    [collectionView registerClass:[XZ_CollectionCell class] forCellWithReuseIdentifier:@"detailCollectCell"];
    collectionView.backgroundColor = [UIColor clearColor];//INMUIColorWithRGB(0xffffff, 1.0);
    [self.view addSubview:collectionView];
    self.xzCollection = collectionView;

    [collectionView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(weakSelf.view);
        make.height.mas_equalTo(INMFit(520));
        make.top.mas_equalTo(INMFit(100));
    }];
    /*
    for (int i = 0; i < 5; i++) {
        UIButton * btn = [[UIButton alloc]init];
        btn.backgroundColor = [UIColor whiteColor];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn setTitle:self.btnArr[i] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont boldSystemFontOfSize:18];
        btn.layer.borderColor = [UIColor redColor].CGColor;
        btn.layer.borderWidth = 2.0f;
        [self.view addSubview:btn];
        
        [btn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(weakSelf.xzCollection.mas_bottom).offset(INMFit(30)+(i*INMFit(70)));
            make.centerX.mas_equalTo(weakSelf.view.mas_centerX);
            make.height.mas_equalTo(INMFit(50));
            make.width.mas_equalTo(INMFit(150));
        }];
    }
     */
    
    [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(INMFit(44));
        make.height.mas_equalTo(INMFit(50));
        make.left.right.mas_equalTo(0);
    }];
}

#pragma mark - <UICollectionViewDataSource>
- (NSInteger) numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArray != 0 ? self.dataArray.count : 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    XZ_CollectionCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"detailCollectCell" forIndexPath:indexPath];
    
    cell.title.text = self.dataArray[indexPath.item];
    
    cell.bgImg.image = [UIImage imageNamed:self.imgArr[indexPath.item]];

    return cell;
}

/* 点击item */
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    XZ_ChooseYSViewController * chooseYSVC = [XZ_ChooseYSViewController new];
    chooseYSVC.xingzuoStr = self.dataArray[indexPath.item];
    NSLog(@"%ld",indexPath.item);
    
    XZ_CollectionCell * selectCell = (XZ_CollectionCell *)[collectionView cellForItemAtIndexPath:indexPath];
    
    selectCell.layer.borderColor = [UIColor yellowColor].CGColor;
    selectCell.title.textColor = [UIColor redColor];
    
    [self.navigationController pushViewController:chooseYSVC animated:YES];
}

-(void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    XZ_CollectionCell *cell = (XZ_CollectionCell *)[collectionView cellForItemAtIndexPath:indexPath];
    // 边框颜色复原
    cell.layer.borderColor = [UIColor whiteColor].CGColor;
    cell.title.textColor = [UIColor whiteColor];
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.font = [UIFont boldSystemFontOfSize:35];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.text = @"请选择属于你de星座";
    }
    return _titleLabel;
}

- (UIImageView *)bgImage {
    if (!_bgImage) {
        _bgImage = [[UIImageView alloc]initWithFrame:[UIScreen mainScreen].bounds];
        _bgImage.image = [UIImage imageNamed:@"xingzuo.jpg"];
    }
    return _bgImage;
}

-(NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray arrayWithObjects:@"白羊座",@"金牛座",@"双子座",@"巨蟹座",@"狮子座",@"处女座",@"天秤座",@"天蝎座",@"射手座",@"摩羯座",@"水瓶座",@"双鱼座", nil];
    }
    return _dataArray;
}

- (NSMutableArray *)imgArr {
    if (!_imgArr) {
        _imgArr = [NSMutableArray arrayWithObjects:@"by.png",@"jn.jpg",@"shuangzi.jpg",@"jx.jpg",@"sz.jpg",@"cn.jpg",@"tc.jpg",@"tx.jpg",@"ss.jpg",@"mj.jpg",@"sp.jpg",@"sy.jpg", nil];
    }
    return _imgArr;
}

- (NSMutableArray *)btnArr {
    if(!_btnArr) {
        _btnArr = [NSMutableArray arrayWithObjects:@"今日运势",@"明日运势",@"本周运势",@"本月运势",@"全年运势", nil];
    }
    return _btnArr;
}

@end
