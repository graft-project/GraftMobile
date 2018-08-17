#include "permissiondelegate.h"

#include <AVFoundation/AVFoundation.h>
#include <UIKit/UIKit.h>

PermissionDelegate::PermissionDelegate()
{
}

bool PermissionDelegate::isCameraAuthorised()
{
    NSString *mediaType = AVMediaTypeVideo;
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];
    if (authStatus == AVAuthorizationStatusAuthorized)
    {
        return true;
    }
    return false;
}
