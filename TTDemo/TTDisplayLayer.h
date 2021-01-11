//
//  TTDisplayLayer.h
//  TTDemoApp
//
//  Created by zing on 2020/11/2.
//

#import <QuartzCore/QuartzCore.h>

NS_ASSUME_NONNULL_BEGIN

@interface TTDisplayLayer : CAEAGLLayer
- (id)initWithFrame:(CGRect)frame;

-(void)displayPixelBuffer;

@end

NS_ASSUME_NONNULL_END
