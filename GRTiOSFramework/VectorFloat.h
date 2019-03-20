//
//  VectorFloat.h
//  GRTiOS
//
//  Created by Nicholas Arner on 8/22/17.
//  Copyright © 2017 Nicholas Arner. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VectorFloat : NSObject

- (instancetype)initWithSize:(NSInteger) size;

- (void)pushBack:(double)value;
- (void)clear;
- (float) at: (int) i;
#ifdef __cplusplus
- (GRT::VectorFloat *)cppInstance;
- (void) setCppInstance:(GRT::VectorFloat *) instance;
#endif

@end
