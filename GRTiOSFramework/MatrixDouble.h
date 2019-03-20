//
//  MatrixFloat.h
//  GRTiOS
//
//  Created by Вячеслав Казаков on 17.03.2019.
//  Copyright © 2019 Nicholas Arner. All rights reserved.
//

#ifndef MatrixFloat_h
#define MatrixFloat_h

@interface MatrixDouble : NSObject
- (instancetype)initWithSize:(NSInteger) size;
- (void)pushBack:(VectorDouble) value;
- (void)clear;
- (VectorDouble) at: (int) i;
#ifdef __cplusplus
- (GRT::MatrixDouble *)cppInstance;
#endif

@end

#endif /* MatrixFloat_h */
