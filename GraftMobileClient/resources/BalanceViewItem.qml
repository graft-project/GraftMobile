import QtQuick 2.9
import QtQuick.Layouts 1.3
import org.graft 1.0

Rectangle {
    id: balance

    property real amountUnlockGraftCost: 0
    property real amountLockGraftCost: 0

    height: 120
    color: "#FCF9F1"

    Connections {
        target: GraftClient
        onBalanceUpdated: {
            amountUnlockGraftCost = GraftClient.balance(GraftClientTools.UnlockedBalance)
            amountLockGraftCost = GraftClient.balance(GraftClientTools.LockedBalance)
        }
    }

    ColumnLayout {
        spacing: 0
        anchors {
            fill: parent
            leftMargin: 15
            rightMargin: 15
            verticalCenter: parent.verticalCenter
        }

        RowLayout {
            spacing: 0
            Layout.fillWidth: true
            Layout.preferredHeight: 60

            Image {
                Layout.preferredHeight: 42
                Layout.preferredWidth: 48
                Layout.alignment: Qt.AlignLeft
                fillMode: Image.PreserveAspectFit
                source: "qrc:/imgs/g-max.png"
            }

            ColumnLayout {
                spacing: 0
                Layout.leftMargin: 14

                Text {
                    text: qsTr("Main Balance")
                    color: "#233146"
                    font.pointSize: 20
                    Layout.alignment: Qt.AlignLeft
                }

                Text {
                    text: qsTr("Unlocked")
                    color: "#3d4757"
                    font.pointSize: 12
                    Layout.alignment: Qt.AlignLeft
                }
            }

            Text {
                text: amountUnlockGraftCost
                Layout.fillWidth: true
                Layout.alignment: Qt.AlignRight
                horizontalAlignment: Text.AlignRight
                color: "#404040"
                font.pointSize: 20
                Layout.rightMargin: 8
            }
        }

        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 1
            color: "#e6e6e8"
        }

        RowLayout {
            spacing: 0
            Layout.fillWidth: true
            Layout.preferredHeight: 60

            Image {
                Layout.preferredHeight: 42
                Layout.preferredWidth: 48
                Layout.maximumWidth: 100
                Layout.alignment: Qt.AlignLeft
                fillMode: Image.PreserveAspectFit
                source: "qrc:/imgs/lock.png"
            }

            ColumnLayout {
                spacing: 0
                Layout.leftMargin: 14

                Text {
                    text: qsTr("Main Balance")
                    color: "#233146"
                    font.pointSize: 20
                    Layout.alignment: Qt.AlignLeft
                }

                Text {
                    text: qsTr("Locked")
                    color: "#3d4757"
                    font.pointSize: 12
                    Layout.alignment: Qt.AlignLeft
                }
            }

            Text {
                text: amountLockGraftCost
                Layout.fillWidth: true
                Layout.alignment: Qt.AlignRight
                horizontalAlignment: Text.AlignRight
                color: "#d1cfc8"
                font.pointSize: 20
                Layout.rightMargin: 8
            }
        }
    }
}
