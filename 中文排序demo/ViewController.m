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
@interface ViewController ()

@property(nonatomic,strong)NSArray * stringsToSort;
@property (nonatomic, strong) NSMutableArray * dataArr;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
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
                         @{@"title":@"广东省",@"id":@"440000"},
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
    
    NSMutableArray *letterResult = [NSMutableArray array];
    
    for(int i =0; i<self.stringsToSort.count; i++){
        ChineseString*chineseString = [ [ChineseString alloc] init];
        chineseString.string=[self.stringsToSort[i] objectForKey:@"title"];
        chineseString.ID = [self.stringsToSort[i] objectForKey:@"id"];
        if(chineseString.string==nil){
            chineseString.string=@"";
            chineseString.ID = @"";
        }
        NSString *pinYinResult = [NSString string];
        if( ! [chineseString.string isEqualToString: @""]){
            for(int j =0; j<chineseString.string.length; j++){
                NSString*singlePinYinLetter = [[NSString stringWithFormat:@"%c",pinyinFirstLetter([chineseString.string characterAtIndex:j])] uppercaseString];
                pinYinResult = [pinYinResult stringByAppendingString: singlePinYinLetter];
            }
            chineseString.pinYin = [pinYinResult substringToIndex:1] ;
            
        }else{
            chineseString.pinYin=@"";
            
        }
        
        [letterResult addObject:chineseString];
        
    }
    
    NSSortDescriptor * descriptor = [NSSortDescriptor sortDescriptorWithKey:@"pinYin" ascending:YES];
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
    NSLog(@"最后输出==%@",self.dataArr);
}


#pragma mark - lan
- (NSMutableArray *)dataArr{
    if (_dataArr == nil) {
        _dataArr = [NSMutableArray new];
    }
    return _dataArr;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
