import QtQuick 2.9
import QtQuick.Layouts 1.3
import "components"

BaseScreen {
    title: qsTr("Main Balance")
    screenHeader {
        navigationButtonState: Qt.platform.os === "android"
    }

    ColumnLayout {
        spacing: 0
        anchors.fill: parent

        BalanceViewItem {
            id: balanceItem
            Layout.fillWidth: true
        }

        Rectangle {
            Layout.fillHeight: true
            Layout.fillWidth: true
            color: "#e9e9e9"

            Image {
                cache: false
                source: GraftClient.addressQRCodeImage()
                height: 160
                width: height
                anchors.centerIn: parent
            }
        }

        Rectangle {
            color: "#ffffff"
            Layout.fillWidth: true
            Layout.fillHeight: true

            ColumnLayout {
                anchors {
                    fill: parent
                    margins: 15
                }

                Text {
                    text: GraftClient.address()
//                    text: qsTr("0xe6fba3f8b13662029a062bbe5995cd3a083b6ab")
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignHCenter
                    color: "black"
                    font.pointSize: 14
                }

                WideActionButton {
                    text: qsTr("Copy to clipboard")
                    Layout.alignment: Qt.AlignBottom
                    onClicked: {}
                }
            }
        }
    }
}
