//
//  DBManager.m
//  DBManager
//
//  Created by Cain on 3/2/16.
//  Copyright (c) 2016 Cain. All rights reserved.
//

#import "DBManager.h"
#import "FMDB.h"

// Collection表
#import "DBCollectionModel.h"

@implementation DBManager
{
    FMDatabase * _database; // FMDB的数据库管理对象
}

// 创建单例对象
+ (instancetype)sharedManager
{
    
    static dispatch_once_t token;
    static DBManager * gDBManager = nil;
    
    dispatch_once(&token, ^{
        if (!gDBManager) {
            gDBManager = [[DBManager alloc] init];
        }
    });
    return gDBManager;
}

- (instancetype)init
{
    if (self = [super init]) {
        // 创建数据库，使用FMDB第三方框架
        // 创建数据库文件保存路径..../Documents/music.sqlite
        // sqlite数据库（轻量级的数据库），它就是一个普通的文件，txt是一样的，只不过其中的文件内容不一样。
        // 注：sqlite文件中定义了你的数据库表、数据内容
        // MySql、Oracle这些大型的数据库，它需要一个管理服务，是一整套的。
        NSString * dbPath = [NSString stringWithFormat:@"%@/Documents/music.sqlite", NSHomeDirectory()];
        // 创建FMDatabase
        // 如果在目录下没有这个数据库文件，将创建该文件。
        _database = [[FMDatabase alloc] initWithPath:dbPath];
        
        // 打开数据库
        [_database open];
        
        // 创建数据库表，表中的字段
        NSString * createSql = @"create table if not exists collection(musicUrl varchar(255), songName varchar(255), musicImage varchar(255), art varchar(255))";
        // FMDatabase执行sql语句
        // 当数据库文件创建完成时，首先创建数据表，如果没有这个表，就去创建，有了就不创建
        [_database executeUpdate:createSql];
        
    }
    return self;
}

#pragma mark - 增删改查

// 检查是否存在数据
- (BOOL)isExsitsWithAppId:(NSString *) musicUrl
{
    NSString * querySql = [NSString stringWithFormat:@"select * from Collection where musicUrl='%@'", musicUrl];
    FMResultSet * set = [_database executeQuery:querySql];
    // 判断是否已存在数据
    if ([set next]) {
        return YES;
    }
    else
        return NO;
}

// 添加一条数据到数据库中
- (BOOL)addCollectionModel:(DBCollectionModel *) model
{
    BOOL isExsits = [self isExsitsWithAppId:model.musicUrl];
    
    // 如果已存在数据，先删除已有的数据，再添加新数据
    if (isExsits) {
        NSString * deleteSql = [NSString stringWithFormat:@"delete from Collection where musicUrl=%@", model.musicUrl];
        [_database executeUpdate:deleteSql];
    }
    // 添加新数据
    NSString * insertSql = @"insert into collection values (?,?,?,?)";
    
    BOOL success = [_database executeUpdate:insertSql, model.musicUrl, model.songName, model.musicImage,model.art];
    
    return success;
}

// 删除数据
- (BOOL)deleteCollectionModel:(DBCollectionModel *) model
{
    // 判断将要删除的应用记录是否存在
    BOOL isExists = [self isExsitsWithAppId:model.musicUrl];
    if (isExists) {
        // 删除对应的记录
        BOOL success = [_database executeUpdate:@"delete from collection where musicUrl=?", model.musicUrl];
        return success;
    }
    else
    {
        NSLog(@"该记录不存在");
        return NO;
    }
}

// 获取所有的记录
- (NSArray *)fetchAllData
{
    // 找出Collection表中所有的数据
    NSString * fetchSql = @"select * from collection";
    
    // 执行sql
    FMResultSet * set = [_database executeQuery:fetchSql];
    
    // 循环遍历取出数据
    NSMutableArray * array = [[NSMutableArray alloc] init];
    while ([set next]) {
        DBCollectionModel * model = [[DBCollectionModel alloc] init];
        // 从结果集中获取数据
        // 注：sqlite数据库不区别分大小写
        model.musicUrl = [set stringForColumn:@"musicUrl"];
        model.songName = [set stringForColumn:@"songName"];
        model.musicImage = [set stringForColumn:@"musicImage"];
        model.art = [set stringForColumn:@"art"];
        
        [array addObject:model];
    }
    return array;
}

@end
