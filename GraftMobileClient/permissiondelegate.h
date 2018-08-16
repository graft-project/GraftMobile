#ifndef PERMISSIONDELEGATE_H
#define PERMISSIONDELEGATE_H

class PermissionDelegate
{
public:
    explicit PermissionDelegate();

    static bool isCameraAuthorised();
};
#endif // PERMISSIONDELEGATE_H
