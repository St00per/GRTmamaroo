//
//  MatrixFloat.h
//  GRTiOS
//
//  Created by Вячеслав Казаков on 17.03.2019.
//  Copyright © 2019 Nicholas Arner. All rights reserved.
//

#ifndef MatrixFloat_h
#define MatrixFloat_h
#import "VectorFloat.h"

@interface MatrixFloat : NSObject

- (instancetype)initWithSize:(NSInteger) size;

- (void)pushBack:(VectorFloat *) value;
- (void)clear;
//- (VectorFloat *) at: (size_t) i;
#ifdef __cplusplus
- (GRT::MatrixFloat *)cppInstance;
#endif

@end

#endif /* MatrixFloat_h */
