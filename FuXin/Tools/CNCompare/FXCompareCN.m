//
//  FXCompareCN.m
//  FuXin
//
//  Created by 徐宝桥 on 14-5-22.
//  Copyright (c) 2014年 ___MyCompanyName___. All rights reserved.
//

#import "FXCompareCN.h"
#import "FXChineseName.h"
#import "pinyin.h"

@implementation FXCompareCN

//返回数组为tableview右侧索引框
+ (NSMutableArray *)tableViewIndexArray:(NSArray *)nameArray {
    NSArray *sortArry = [self getPinYinListFromChinaeseList:nameArray];
    NSMutableArray *resultArray = [NSMutableArray array];
    NSString *indexString = @"";
    //#栏
    BOOL otherIndex = NO;
    for (FXChineseName *object in sortArry) {
        NSString *firstCharacter = [object.nameEnglish substringToIndex:1];
        //若第一个字符为非A-Z
        char firstChar = [firstCharacter characterAtIndex:0];
        if (!(firstChar >= 'A' && firstChar <= 'Z')) {
            otherIndex = YES;
        }
        else {
            if (![indexString isEqualToString:firstCharacter]) {
                [resultArray addObject:firstCharacter];
                indexString = firstCharacter;
            }
        }
    }
    if (otherIndex) {
        [resultArray addObject:@"#"];
    }
    return resultArray;
}

//返回tableview每个section的数据源
+ (NSMutableArray *)dataForSectionWithArray:(NSArray *)nameArray {
    NSArray *sortArray = [self getPinYinListFromChinaeseList:nameArray];
    NSMutableArray *resultArray = [NSMutableArray array];
    NSMutableArray *sectionArray;
    NSString *indexString = @"";
    //#栏
    NSMutableArray *otherArray = [NSMutableArray array];
    for (FXChineseName *object in sortArray) {
        NSString *firstCharacter = [object.nameEnglish substringToIndex:1];
//        NSString *name = object.nameChinese;
        NSDictionary *nameInfo = [NSDictionary dictionaryWithObjectsAndKeys:
                                  object.nameChinese, kName,
                                  object.nameIndex, kIndex,
                                  nil];
        //若第一个字符为非A-Z
        char firstChar = [firstCharacter characterAtIndex:0];
        if (!(firstChar >= 'A' && firstChar <= 'Z')) {
            [otherArray addObject:nameInfo];
        }
        else {
            //A-Z
            if (![indexString isEqualToString:firstCharacter]) {
                sectionArray = [NSMutableArray array];
                [sectionArray addObject:nameInfo];
                [resultArray addObject:sectionArray];
                indexString = firstCharacter;
            }
            else {
                [sectionArray addObject:nameInfo];
            }
        }
    }
    [resultArray addObject:otherArray];
    return resultArray;
}

//返回数组为已排序数组
+ (NSArray *)getPinYinListFromChinaeseList:(NSArray *)nameList {
    NSMutableArray *nameLists = [NSMutableArray array];
    for (int i = 0; i < [nameList count]; i++) {
        FXChineseName *name = [[FXChineseName alloc] init];
        name.nameChinese = [NSString stringWithString:[nameList objectAtIndex:i]];
        name.nameIndex = [NSNumber numberWithInt:i];
        if (name.nameChinese == nil) {
            name.nameChinese = @"";
        }
        //去空格
        name.nameChinese = [name.nameChinese stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        
        //过滤字符
        name.nameChinese = [self removeSpecialCharacter:name.nameChinese];
        //判断首字符是否是字母
        NSString *regex = @"[A-Za-z]+";
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
        if ([predicate evaluateWithObject:name.nameChinese]) {
            //首字母大写
            name.nameEnglish = [name.nameChinese capitalizedString];
        }
        else {
            if (![name.nameChinese isEqualToString:@""]) {
                NSString *pinyin = @"";
                for (int j = 0; j < name.nameChinese.length; j++) {
                    NSString *singlePinyinLetter = [[NSString stringWithFormat:@"%c",pinyinFirstLetter([name.nameChinese characterAtIndex:j])] uppercaseString];
                    pinyin = [pinyin stringByAppendingString:singlePinyinLetter];
                }
                name.nameEnglish = pinyin;
            }
            else {
                name.nameEnglish = @"";
            }
        }
        [nameLists addObject:name];
    }
    //按首字母排序
    NSArray *sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"nameEnglish" ascending:YES]];
    return [nameLists sortedArrayUsingDescriptors:sortDescriptors];
}

//过滤字符
+ (NSString *)removeSpecialCharacter:(NSString *)string {
    NSRange urgentRange = [string rangeOfCharacterFromSet:
                           [NSCharacterSet characterSetWithCharactersInString:
                        @",.？、 ~￥#&<>《》()[]{}【】^@/￡&curren;|&sect;&uml;「」『』￠￢￣~@#&*（）——+|《》$_€"]];
    if (urgentRange.location != NSNotFound)
    {
        return [self removeSpecialCharacter:
                [string stringByReplacingCharactersInRange:urgentRange withString:@""]];
    }
    return string;
}

@end
