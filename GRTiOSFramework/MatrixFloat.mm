//
//  MatrixFloat.m
//  GRTiOS
//
//  Created by Вячеслав Казаков on 17.03.2019.
//  Copyright © 2019 Nicholas Arner. All rights reserved.
//

#import <Foundation/Foundation.h>

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

- (instancetype)initWithSize:(NSInteger) rows columns: (NSInteger) columns
{
    self = [super init];
    if (self) {
        self.instance = new GRT::MatrixFloat(rows, columns);
    }
    return self;
}

- (void)dealloc
{
    delete self.instance;
}

- (void)pushBack:(VectorFloat *) value
{
    GRT::VectorFloat *cppValue = [value cppInstance];
    self.instance->push_back(*cppValue);
}

- (void)clear
{
    self.instance->clear();
}

- (GRT::MatrixFloat *)cppInstance
{
    return self.instance;
}
//- (VectorFloat *) at: (size_t) i {
//    GRT::VectorFloat *vector = new GRT::VectorFloat(self.instance->getRow(i));
//    VectorFloat *wrapedVector = [VectorFloat new];
//    wrapedVector.cppInstance = vector;
//    return wrapedVector;
//}


@end
