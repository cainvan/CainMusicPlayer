//
//  DBManager.h
//  DBManager
//
//  Created by Cain on 3/2/16.
//  Copyright (c) 2016 Cain. All rights reserved.
//
/**
 *  数据库管理类，用于App的收藏，将数据保存到数据库中
 *  单例类
 */
#import <Foundation/Foundation.h>
#import "DBCollectionModel.h"

// #import 和 @class 的 区别
// #import 是导入头文件并且也将方法和属性接口导入。
// @class类的前置声明：只是一个类的名称，无法获取到类中具体的属性和方法。

@interface DBManager : NSObject

// 单例
+ (instancetype)sharedManager;

// 检查是否存在数据
- (BOOL)isExsitsWithAppId:(NSString *) musicUrl;

// 添加一条数据到数据库中
- (BOOL)addCollectionModel:(DBCollectionModel *) model;

// 删除数据
- (BOOL)deleteCollectionModel:(DBCollectionModel *) model;

// 获取所有的记录
- (NSArray *)fetchAllData;

@end
