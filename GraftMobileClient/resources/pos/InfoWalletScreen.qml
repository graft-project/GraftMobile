import QtQuick 2.9
import QtQuick.Layouts 1.3
import "../"
import "../components"

BaseBalanceScreen {
    splitterVisible: false
    screenHeader {
        navigationButtonState: true
    }

    ColumnLayout {
        anchors.fill: parent
        spacing: 0

        Rectangle {
            Layout.fillHeight: true
            Layout.fillWidth: true
            color: "red"
        }

        WideActionButton {
            text: qsTr("Transfer to Paypal")
            onClicked: {}
        }

        WideActionButton {
            text: qsTr("Chase XXX929")
            onClicked: {}
        }
    }
}
