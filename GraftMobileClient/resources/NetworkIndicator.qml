import QtQuick 2.9
import QtQuick.Controls 2.2

Rectangle {
    id: networkIndicator
    height: 40
    color: "#989FAB"

    Connections {
        target: GraftClient
        onNetworkTypeChanged: nameTypeNetwork.text = GraftClient.networkName()
    }

    Label {
        id: nameTypeNetwork
        anchors {
            verticalCenter: networkIndicator.verticalCenter
            left: networkIndicator.left
            leftMargin: 18
        }
        color: "#FFFFFF"
        font.pixelSize: 16
        text: GraftClient.networkName()
    }
}
