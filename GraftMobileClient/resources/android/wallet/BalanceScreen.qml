import QtQuick 2.9
import QtQuick.Layouts 1.3
import org.graft 1.0
import "../"
import "../components"

BaseBalanceScreen {

    function isPayEnabled() {
        return GraftClient.networkType() === GraftClientTools.PublicExperimentalTestnet 
            || GraftClient.networkType() === GraftClientTools.PublicTestnet
    }

    Connections {
        target: GraftClient

        onNetworkTypeChanged: {
            payButton.enabled = isPayEnabled()
        }
    }

    // TODO: QTBUG-74076. The application is crash or will hang when request permission, after the
    // native Android keyboard. For more details see https://bugreports.qt.io/browse/QTBUG-74076
    Connections {
        target: GraftClientTools

        onCameraPermissionGranted: {
            if (result !== GraftClientTools.Unknown) {
                switch (button) {
                    case GraftClientTools.Send: pushSendCoinScreen(); break
                    case GraftClientTools.Pay: pushQRCodeScanner(); break
                }
            }
        }
    }

    ColumnLayout {
        spacing: 0
        anchors.fill: parent

        CoinListView {
            Layout.fillWidth: true
            Layout.fillHeight: true
        }

        AddNewButton {
            buttonTitle: qsTr("Add new account")
            Layout.fillWidth: true
            Layout.preferredHeight: 60
            Layout.bottomMargin: 15
            topLine: true
            bottomLine: true
            visible: false
            onClicked: pushScreen.openAddAccountScreen()
        }

        WideActionButton {
            id: sendCoinsButton
            Layout.fillWidth: true
            Layout.leftMargin: 15
            Layout.rightMargin: 15
            Layout.alignment: Qt.AlignCenter
            text: qsTr("Send")

            // TODO: QTBUG-74076. The application is crash or will hang when request permission, after the
            // native Android keyboard. For more details see https://bugreports.qt.io/browse/QTBUG-74076
            onClicked: GraftClientTools.requestCameraPermission(GraftClientTools.Send)
        }

        WideActionButton {
            id: payButton
            Layout.fillWidth: true
            Layout.leftMargin: 15
            Layout.rightMargin: 15
            Layout.bottomMargin: 15
            Layout.alignment: Qt.AlignCenter
            text: qsTr("Pay 11")
            enabled: isPayEnabled()

            // TODO: QTBUG-74076. The application is crash or will hang when request permission, after the
            // native Android keyboard. For more details see https://bugreports.qt.io/browse/QTBUG-74076
            onClicked: GraftClientTools.requestCameraPermission(GraftClientTools.Pay)
        }
    }

    function pushSendCoinScreen() {
        disableScreen()
        pushScreen.openSendCoinScreen()
    }

    function pushQRCodeScanner() {
        disableScreen()
        pushScreen.openQRCodeScanner()
    }
}
