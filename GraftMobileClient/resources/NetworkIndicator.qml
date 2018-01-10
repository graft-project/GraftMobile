import QtQuick 2.9

Rectangle {
    id: networkIndicator
    height: 40
    color: "#989FAB"

    Connections {
        target: GraftClient
        onNetworkTypeChanged: nameTypeNetwork.text = GraftClient.networkName()
    }

    Text {
        id: nameTypeNetwork
        anchors {
            verticalCenter: networkIndicator.verticalCenter
            left: networkIndicator.left
            leftMargin: 18
        }
        text: GraftClient.networkName()
        color: "#FFFFFF"
    }
}
