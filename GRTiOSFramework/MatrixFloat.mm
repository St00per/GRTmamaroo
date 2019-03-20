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

@implementation MatrixFloat {
    double *dataPtr;
    double **rowPtr;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.instance = new GRT::MatrixFloat;
    }
    return self;
}

- (instancetype)initWithSize:(uint) rows columns: (uint) columns
{
    self = [super init];
    if (self) {
        self.instance = new GRT::MatrixFloat(rows, columns);
        dataPtr = self.instance->getData();

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

-(void) setCppInstance: (GRT::MatrixFloat *) cppInstance {
    self.cppInstance = cppInstance;
}



//- (VectorFloat *) at: (size_t) i {
//    GRT::VectorFloat *vector = new GRT::VectorFloat(self.instance->getRow(i));
//    VectorFloat *wrapedVector = [VectorFloat new];
//    wrapedVector.cppInstance = vector;
//    return wrapedVector;
//}


@end
