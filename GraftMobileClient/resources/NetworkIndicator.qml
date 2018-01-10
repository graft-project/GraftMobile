import QtQuick 2.9

Rectangle {
    id: networkIndicator
    height: 40
    color: "#989FAB"

    Text {
        anchors {
            verticalCenter: networkIndicator.verticalCenter
            left: networkIndicator.left
            leftMargin: 18
        }
        text: GraftClient.networkName()
        color: "#FFFFFF"
    }
}
