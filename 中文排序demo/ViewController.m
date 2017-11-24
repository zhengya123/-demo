//
//  ViewController.m
//  中文排序demo
//
//  Created by 中商国际 on 2017/11/23.
//  Copyright © 2017年 中商国际. All rights reserved.
//

#import "ViewController.h"
#import "ChineseString.h"
#import "pinyin.h"
@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) NSArray        * stringsToSort;
@property (nonatomic, strong) NSMutableArray * dataArr;
@property (nonatomic, strong) UITableView    * tableView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableView];
    [self beginPaixu];
    
}
-(NSArray*)stringsToSort{
    
    if(!_stringsToSort){
        
        _stringsToSort=@[
                         @{@"title":@"北京",@"id":@"110000"},
                         @{@"title":@"天津",@"id":@"120000"},
                         @{@"title":@"河北省",@"id":@"130000"},
                         @{@"title":@"山西省",@"id":@"140000"},
                         @{@"title":@"内蒙古自治区",@"id":@"150000"},
                         @{@"title":@"辽宁省",@"id":@"210000"},
                         @{@"title":@"吉林省",@"id":@"220000"},
                         @{@"title":@"黑龙江省",@"id":@"230000"},
                         @{@"title":@"上海",@"id":@"310000"},
                         @{@"title":@"江苏省",@"id":@"320000"},
                         @{@"title":@"浙江省",@"id":@"330000"},
                         @{@"title":@"安徽省",@"id":@"340000"},
                         @{@"title":@"福建省",@"id":@"350000"},
                         @{@"title":@"江西省",@"id":@"360000"},
                         @{@"title":@"山东省",@"id":@"370000"},
                         @{@"title":@"河南省",@"id":@"410000"},
                         @{@"title":@"湖北省",@"id":@"420000"},
                         @{@"title":@"湖南省",@"id":@"430000"},
                         @{@"title":@"广东省",@"id":@"440000"}
                         ];
    }
    
    return _stringsToSort;
    
}
- (void)beginPaixu{
    
    // 将中文字符串赋值给类中得字符串,一个中文就是一个ChineseString对象,这里得创建一个可变数组,用来存储ChineseString对象
    NSMutableArray *letterResult = [NSMutableArray array];
    
    for(int i =0; i<self.stringsToSort.count; i++){
        ChineseString*chineseString = [ [ChineseString alloc] init];
        chineseString.string=[self.stringsToSort[i] objectForKey:@"title"];
        chineseString.ID = [self.stringsToSort[i] objectForKey:@"id"];
        if(chineseString.string==nil){
            chineseString.string=@"";
            chineseString.ID = @"";
        }
        NSString *pinYinResult = [NSString string]; //一个中文对应一个      pinYinResult(中文的拼音)
        if( ! [chineseString.string isEqualToString: @""]){
            //获取中文每个字的首字母 . letter:字母
            for(int j =0; j<chineseString.string.length; j++){
                //得到中文中每个字的首字母
                NSString*singlePinYinLetter = [[NSString stringWithFormat:@"%c",pinyinFirstLetter([chineseString.string characterAtIndex:j])] uppercaseString];
                //中文转拼音首字母的函数: pinyinFirstLetter    uppercaseString:  表示大写字母
                //拼接中文每个字的首字母,最终得到此中文的拼音
                pinYinResult = [pinYinResult stringByAppendingString: singlePinYinLetter];
            }
            chineseString.pinYin = [pinYinResult substringToIndex:1] ;
            
        }else{
            chineseString.pinYin=@"";
            
        }
        
        [letterResult addObject:chineseString];
        
    }
    
    //  NSLog(@"\r\r获取了中文每个字的首字母列表:");
//    for(int i =0; i < letterResult.count ; i++){
//        
//        ChineseString *appendingLetter = letterResult[i];
//        
//        NSLog(@"中文__%@首字母__%@",appendingLetter.string,appendingLetter.pinYin);
//        
//    }

    
    //接下来就是对字母进行排序
    // 1> 创建排序描述器
    NSSortDescriptor * descriptor = [NSSortDescriptor sortDescriptorWithKey:@"pinYin" ascending:YES];
    //yes:升序,反之. pinYin:表示要进行排序的key(kvc),之前我们把中文转为拼音的时候,chineseString.pinYin =  pinYinResult ;  我们要排序的就是pinYin
    //2> 存放排序器
    NSArray *descriptorArray = [NSArray arrayWithObjects: descriptor,nil];
    NSArray *descriptorResult = [letterResult sortedArrayUsingDescriptors : descriptorArray];
    for(int i =0; i<descriptorResult.count; i++){
        NSMutableDictionary * dic = [NSMutableDictionary new];
        ChineseString *result = descriptorResult[i];
        [dic setValue:result.string forKey:@"title"];
        [dic setValue:result.ID forKey:@"id"];
        [dic setValue:result.pinYin forKey:@"First"];
        [self.dataArr addObject:dic];
        
    }
    
    
    NSMutableDictionary *sortDic = [NSMutableDictionary dictionaryWithCapacity:0];
    for (NSDictionary *dic in self.dataArr) {
        NSString *imageTime = dic[@"First"];
        NSMutableArray *groupArr = sortDic[imageTime];
        if (!groupArr) {
            groupArr = [NSMutableArray arrayWithCapacity:0];
            [sortDic setObject:groupArr forKey:imageTime];
        }
        [groupArr addObject:dic];
    }
    
    NSMutableArray * mut = [NSMutableArray new];
    for (NSString *key in sortDic) {
        NSArray * sortarr = sortDic[key];
        NSDictionary * setDic = @{
                                  @"firstname":key,
                                  @"titleArr":sortarr
                                  };
        [mut addObject:setDic];
    }
    
    
    for (int i = 0; i<mut.count; i++) {
        for (int j = i+1; j<mut.count; j++) {
            NSString * firstName = [mut[i] objectForKey:@"firstname"];
            NSString * secondName = [mut[j] objectForKey:@"firstname"];
            if ([firstName localizedCompare:secondName] == 1) {
                [mut exchangeObjectAtIndex:i withObjectAtIndex:j];
            }
        }
    }
    [self.dataArr removeAllObjects];
    [self.dataArr addObjectsFromArray:mut];
    [self.tableView reloadData];
    NSLog(@"最后输出==%@",self.dataArr);
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataArr.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray * arr = [self.dataArr[section] objectForKey:@"titleArr"];
    return arr.count;

}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UILabel * label = [UILabel new];
    label.frame = CGRectMake(10, 0, [UIScreen mainScreen].bounds.size.width - 20, 44);
    label.text = [NSString stringWithFormat:@"    %@",[self.dataArr[section] objectForKey:@"firstname"]];
    return label;

}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    cell.textLabel.text = [NSString stringWithFormat:@"%@",[[self.dataArr[indexPath.section] objectForKey:@"titleArr"][indexPath.row] objectForKey:@"title"]];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

}
#pragma mark - lan
- (NSMutableArray *)dataArr{
    if (_dataArr == nil) {
        _dataArr = [NSMutableArray new];
    }
    return _dataArr;
}
- (UITableView *)tableView{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
    }
    return _tableView;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
