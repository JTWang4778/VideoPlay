//
//  JTPLayerView.h
//  MediaPlayer
//
//  Created by 王锦涛 on 2017/6/3.
//  Copyright © 2017年 JTWang. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol  JTPLayerViewDelegate <NSObject>

- (void)big;
- (void)small;
@end
@interface JTPLayerView : UIView

@property (nonatomic,weak) id <JTPLayerViewDelegate> delegate;

@end
