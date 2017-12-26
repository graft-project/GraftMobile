import QtQuick 2.9
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.2
import org.graft 1.0

Rectangle {
    property real amountUnlockGraftCost: 0
    property real amountLockGraftCost: 0
    property alias lockedArrowVisible: lockedArrow.visible
    property alias lockedBalanceButton: lockedMainBalance
    property alias unlockedArrowVisible: unlockedArrow.visible
    property alias unlockedBalanceButton: unlockedMainBalance

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
            verticalCenter: parent.verticalCenter
        }

        Button {
            id: unlockedMainBalance
            flat: true
            Layout.fillWidth: true
            Layout.preferredHeight: 60
            background {
                x: 0
                y: 0
                width: background.parent.width
                height: background.parent.height
            }
            onClicked: pushScreen.openMainAddressScreen("mainAddress")

            RowLayout {
                spacing: 0
                anchors {
                    fill: parent
                    leftMargin: 15
                    rightMargin: 15
                    verticalCenter: parent.verticalCenter
                }

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
                        font.pointSize: 20
                        color: "#233146"
                        Layout.alignment: Qt.AlignLeft
                    }

                    Text {
                        text: qsTr("Unlocked")
                        font.pointSize: 12
                        color: "#3d4757"
                        Layout.alignment: Qt.AlignLeft
                    }
                }

                Text {
                    text: amountUnlockGraftCost
                    font.pointSize: 20
                    color: "#404040"
                    Layout.fillWidth: true
                    Layout.rightMargin: 12
                    Layout.alignment: Qt.AlignRight
                    horizontalAlignment: Text.AlignRight
                }

                Image {
                    id: unlockedArrow
                    source: "qrc:/imgs/arrow.png"
                    Layout.preferredHeight: 20
                    Layout.preferredWidth: 15
                    Layout.alignment: Qt.AlignRight
                }
            }
        }

        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 1
            Layout.leftMargin: 15
            Layout.rightMargin: 15
            color: "#e6e6e8"
        }

        Button {
            id: lockedMainBalance
            flat: true
            Layout.preferredHeight: 60
            Layout.fillWidth: true
            background {
                x: 0
                y: 0
                width: background.parent.width
                height: background.parent.height
            }
            onClicked: pushScreen.openMainAddressScreen("mainAddress")

            RowLayout {
                spacing: 0
                anchors {
                    fill: parent
                    leftMargin: 15
                    rightMargin: 15
                    verticalCenter: parent.verticalCenter
                }

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
                        font.pointSize: 20
                        color: "#233146"
                        Layout.alignment: Qt.AlignLeft
                    }

                    Text {
                        text: qsTr("Locked")
                        font.pointSize: 12
                        color: "#3d4757"
                        Layout.alignment: Qt.AlignLeft
                    }
                }

                Text {
                    text: amountLockGraftCost
                    font.pointSize: 20
                    color: "#d1cfc8"
                    Layout.fillWidth: true
                    Layout.rightMargin: 12
                    Layout.alignment: Qt.AlignRight
                    horizontalAlignment: Text.AlignRight
                }

                Image {
                    id: lockedArrow
                    source: "qrc:/imgs/arrow.png"
                    Layout.preferredHeight: 20
                    Layout.preferredWidth: 15
                    Layout.alignment: Qt.AlignRight
                }
            }
        }
    }
}
