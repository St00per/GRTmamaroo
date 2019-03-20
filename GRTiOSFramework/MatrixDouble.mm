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

@interface MatrixDouble()
@property GRT::MatrixDouble *instance;
@end

@implementation MatrixDouble

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.instance = new GRT::MatrixDouble;
    }
    return self;
}

- (instancetype)initWithSize:(NSInteger) size
{
    self = [super init];
    if (self) {
        self.instance = new GRT::MatrixDouble(size);
    }
    return self;
}

- (void)dealloc
{
    delete self.instance;
}

- (void)pushBack:(VectorDouble) value
{
    GRT::VectorDouble *cppValue = new GRT::VectorDouble([value cppInstance]);
    self.instance->push_back(cppValue);
}

- (void)clear
{
    self.instance->clear();
}

- (GRT::MatrixDouble *)cppInstance
{
    return self.instance;
}

- (float) at: (int) i {
    return self.instance->at(index);
}


@end
