//
//  BPPointerShapeHelper.h
//  ButtonPointerShapeCrash
//
//  Created by Bruno Philipe on 12.05.20.
//  Copyright © 2020 Bruno Philipe. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

API_AVAILABLE(ios(13.4))
@interface BPPointerShapeHelper: NSObject<UIPointerInteractionDelegate>

@property (nonatomic, copy, nullable) UITargetedPreview * _Nonnull (^liftPointerEffectProvider)(void);

+ (void)setRoundedRectPointerShapeProviderForView:(UIView * _Nonnull)view
                                    usingProvider:(void (^)(CGRect * _Nonnull, CGFloat * _Nonnull))provider;

+ (void)setBezierPathPointerShapeProviderForView:(UIView * _Nonnull)view
                                   usingProvider:(void (^)(UIBezierPath * _Nullable * _Nullable))provider;

- (id)initWithView:(UIView * _Nonnull)view bezierPathProvider:(void (^)(UIBezierPath * _Nullable * _Nullable))provider;

- (id)initWithView:(UIView * _Nonnull)view roundedRectProvider:(void (^)(CGRect * _Nonnull, CGFloat * _Nonnull))provider;

@end

NS_ASSUME_NONNULL_END
