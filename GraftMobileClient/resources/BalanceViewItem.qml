import QtQuick 2.9
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.2
import org.graft 1.0

Rectangle {
    property real amountUnlockGraftCost: 0
    property real amountLockGraftCost: 0
    property bool balanceVisible: true

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

        BorderlessButton {
            id: unlockedMainBalance
            enabled: balanceVisible
            Layout.fillWidth: true
            Layout.preferredHeight: 60
            onClicked: pushScreen.openMainAddressScreen()

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
                    Layout.alignment: Qt.AlignLeft

                    Text {
                        text: qsTr("Main Balance")
                        font.pointSize: 20
                        color: "#233146"
                    }

                    Text {
                        text: qsTr("Unlocked")
                        font.pointSize: 12
                        color: "#3d4757"
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
                    visible: balanceVisible
                    source: "qrc:/imgs/arrow.png"
                    Layout.preferredHeight: 20
                    Layout.preferredWidth: 15
                    Layout.alignment: Qt.AlignRight
                }
            }
        }

        Rectangle {
            Layout.fillWidth: true
            Layout.leftMargin: 15
            Layout.rightMargin: 15
            Layout.preferredHeight: 1
            color: "#e6e6e8"
        }

        BorderlessButton {
            id: lockedMainBalance
            enabled: balanceVisible
            Layout.fillWidth: true
            Layout.preferredHeight: 60
            onClicked: pushScreen.openMainAddressScreen()

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
                    source: "qrc:/imgs/lock.png"
                }

                ColumnLayout {
                    spacing: 0
                    Layout.leftMargin: 14
                    Layout.alignment: Qt.AlignLeft

                    Text {
                        text: qsTr("Main Balance")
                        font.pointSize: 20
                        color: "#233146"
                    }

                    Text {
                        text: qsTr("Locked")
                        font.pointSize: 12
                        color: "#3d4757"
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
                    visible: balanceVisible
                    source: "qrc:/imgs/arrow.png"
                    Layout.preferredHeight: 20
                    Layout.preferredWidth: 15
                    Layout.alignment: Qt.AlignRight
                }
            }
        }
    }
}
