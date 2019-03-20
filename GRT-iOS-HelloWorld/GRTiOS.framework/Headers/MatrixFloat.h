//
//  MatrixFloat.h
//  GRTiOS
//
//  Created by Вячеслав Казаков on 17.03.2019.
//  Copyright © 2019 Nicholas Arner. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VectorFloat.h"

@interface MatrixFloat : NSObject

- (instancetype)initWithSize:(uint) rows columns: (uint) columns;
- (void)pushBack:(VectorFloat *) value;
- (void)clear;
//- (VectorFloat *) at: (size_t) i;
#ifdef __cplusplus
- (GRT::MatrixFloat *)cppInstance;
-(void) setCppInstance: (GRT::MatrixFloat *) cppInstance;
#endif

@end
