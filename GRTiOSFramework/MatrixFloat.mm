//
//  MatrixFloat.m
//  GRT-iOS-HelloWorld
//
//  Created by Kirill Shteffen on 16/03/2019.
//  Copyright © 2019 Nicholas Arner. All rights reserved.
//

#ifdef __cplusplus
#include "grt.h"
#endif

#import "MatrixFloat.h"

@interface MatrixFloat()
@property GRT::MatrixFloat *instance;
@end

@implementation MatrixFloat

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.instance = new GRT::MatrixFloat;
    }
    return self;
}

- (instancetype)initWithSize:(NSInteger) size
{
    self = [super init];
    if (self) {
        self.instance = new GRT::MatrixFloat(size);
    }
    return self;
}

- (void)dealloc
{
    delete self.instance;
}

- (void)pushBack:(double) value
{
    self.instance->push_back(value);
}

- (void)clear
{
    self.instance->clear();
}

- (GRT::VectorDouble *)cppInstance
{
    return self.instance;
}

@end
