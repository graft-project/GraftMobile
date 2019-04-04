#include "iostools.h"

#include <UIKit/UIKit.h>
#include <sys/utsname.h>

@interface QIOSApplicationDelegate
@end

@interface QIOSApplicationDelegate (ApplicationDelegate)
@end

@implementation QIOSApplicationDelegate (ApplicationDelegate)
@end

IOSTools::IOSTools(QObject *parent)
    : AbstractDeviceTools(parent)
{
}

IOSTools::~IOSTools()
{
}

bool IOSTools::isSpecialTypeDevice() const
{
    static dispatch_once_t onceToken;

    dispatch_once(&onceToken, ^{
#if TARGET_IPHONE_SIMULATOR
        NSString *model = NSProcessInfo.processInfo.environment[@"SIMULATOR_MODEL_IDENTIFIER"];
#else

        struct utsname systemInfo;
        uname(&systemInfo);

        NSString *model = [NSString stringWithCString:systemInfo.machine
                                            encoding:NSUTF8StringEncoding];
#endif
        mIsIphoneXTypeDevice = [model isEqualToString:@"iPhone10,3"] || [model isEqualToString:@"iPhone10,6"] || //iPhone X
                               [model isEqualToString:@"iPhone11,8"] || //iPhone XR
                               [model isEqualToString:@"iPhone11,2"] || //iPhone XS
                               [model isEqualToString:@"iPhone11,4"] || [model isEqualToString:@"iPhone11,6"]; //iPhone XS Max
    });
    if (mIsIphoneXTypeDevice)
    {
        mBottomNavigationBarHeight = 34;
        mStatusBarHeight = 44;
    }
    return mIsIphoneXTypeDevice;
}

double IOSTools::bottomNavigationBarHeight() const
{
    isSpecialTypeDevice();
    return mBottomNavigationBarHeight;
}

double IOSTools::statusBarHeight() const
{
    isSpecialTypeDevice();
    return mStatusBarHeight;
}
