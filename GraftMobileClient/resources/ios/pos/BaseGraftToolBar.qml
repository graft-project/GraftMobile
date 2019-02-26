import QtQuick 2.9
import com.graft.design 1.0
import com.device.platform 1.0

Rectangle {
    property var pushScreen
    property string highlight: "#25FFFFFF"

    signal seclectedButtonChanged(string buttonName)

    height: Detector.bottomNavigationBarHeight() + 49
    color: ColorFactory.color(DesignFactory.IosNavigationBar)
}
