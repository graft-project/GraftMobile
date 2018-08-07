import QtQuick 2.9
import QtQuick.Controls 2.2

MenuItem {
    property alias menuIcon: menuLabel.labelIcon
    property alias menuTitle: menuLabel.labelName

    padding: 0
    topPadding: 0
    bottomPadding: 0
    contentItem: MenuLabel {
        id: menuLabel
    }
}
