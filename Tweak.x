#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

#define SPEED 1.5

%hook CAAnimation
- (void)setDuration:(CFTimeInterval)duration {
    %orig(duration / SPEED);
}
%end
