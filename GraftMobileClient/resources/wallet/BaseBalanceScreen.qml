import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Controls.Material 2.2
import QtQuick.Layouts 1.3
import com.graft.design 1.0
import "../"
import "../components"

BaseScreen {
    id: root

    property real amountGraft: 0
    property real amountMoney: 0
    property alias splitterVisible: splitter.visible
    default property alias content: placeholder.data

    title: qsTr("Wallet")
    screenHeader {
        navigationButtonState: true
    }

    ColumnLayout {
        anchors.fill: parent
        spacing: 20

        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 200
            Layout.alignment: Qt.AlignTop
            color: "#EDEEF0"

            Image {
                id: graftWalletLogo
                anchors.centerIn: parent
                height: parent.height / 2
                width: parent.width / 2
                fillMode: Image.PreserveAspectFit
                source: "qrc:/imgs/graft-wallet-logo.png"
            }
        }

        RowLayout {
            Layout.alignment: Qt.AlignTop
            Layout.leftMargin: 20
            Layout.rightMargin: 20
            spacing: 10

            Text {
                Layout.fillWidth: true
                Layout.alignment: Qt.AlignLeft
                font.pointSize: 20
                text: qsTr("Balance:")
            }

            ColumnLayout {
                Layout.alignment: Qt.AlignRight
                spacing: 0

                Text {
                    font.pointSize: 22
                    text: amountGraft
                }

                Text {
                    color: "#B79746"
                    font.pointSize: 15
                    text: amountMoney + " USD"
                }
            }

            Image {
                Layout.preferredHeight: 50
                Layout.preferredWidth: 50
                Layout.alignment: Image.AlignRight
                fillMode: Image.PreserveAspectFit
                source: "qrc:/imgs/g-max.png"
            }
        }

        Rectangle {
            id: splitter
            Layout.fillWidth: true
            Layout.preferredHeight: 2
            color: "#EDEEF0"
        }

        Item {
            id: placeholder
            Layout.fillWidth: true
            Layout.fillHeight: true
        }
    }
}
