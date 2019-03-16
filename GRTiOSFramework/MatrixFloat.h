//
//  MatrixFloat.h
//  GRT-iOS-HelloWorld
//
//  Created by Kirill Shteffen on 16/03/2019.
//  Copyright © 2019 Nicholas Arner. All rights reserved.
//



#ifndef MatrixFloat_h
#define MatrixFloat_h

#import <Foundation/Foundation.h>

@interface MatrixFloat : NSObject

- (instancetype)initWithSize:(NSInteger) size;

- (void)pushBack:(double)value;
- (void)clear;

#ifdef __cplusplus
- (GRT::MatrixFloat *)cppInstance;
#endif

@end

#endif /* MatrixFloat_h */
