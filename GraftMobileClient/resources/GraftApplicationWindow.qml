import QtQuick 2.9
import QtQuick.Controls 2.2

ApplicationWindow {
    id: root
    visible: true
    width: 420
    height: 580
//    width: 320
//    height: 480

    function init() {
        if (Qt.platform.os === "ios") {
            root.visibility = ApplicationWindow.FullScreen
        }
    }

    Component.onCompleted: init()
}
