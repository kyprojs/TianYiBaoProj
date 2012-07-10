//
//  GlobalVariableStore.m
//  TianYiBao
//
//  Created by lin xiaoyu on 12-6-9.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "GlobalVariableStore.h"




@implementation GlobalVariableStore
@synthesize provinceId,city,cityName,nickName;

/*
 全局变量写为一个单例类的成员变量，由这个类负责alloc和release，比如单例类为Global，全局变量为globalData
 ,写一个ShareInstance静态方法，在你需要拿到这个全局变量的地方：[Global shareInstance].globalData调用
 */

+(GlobalVariableStore *) sharedInstance{
    // the instance of this class is stored here
    static GlobalVariableStore *myInstance = nil;
    
    // check to see if an instance already exists
    if (nil == myInstance) {
        myInstance  = [[[self class] alloc] init];
        // initialize variables here
    }
    // return the instance of this class
    return myInstance;
}

@end
