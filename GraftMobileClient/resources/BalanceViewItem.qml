import QtQuick 2.9
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.5
import org.graft 1.0
import org.navigation.attached.properties 1.0

// "Balance" button view

Rectangle {
    id: balance

    property real unlockedBalance: 0.0
    property real totalBalance: 0.0
    property bool balanceVisible: true
    property int dotsCount: 0
    property bool checked: unlockedMainBalance.checked

    Navigation.implicitFirstComponent: unlockedMainBalance
    // Navigation.implicitLastComponent: lockedMainBalance

    height: 80
    color: "#FCF9F1"
    state: GraftClient.isBalanceUpdated() ? "afterUpdate" : "beforeUpdate"


    Connections {
        target: GraftClient
        onBalanceUpdated: {
            balance.state = GraftClient.isBalanceUpdated() ? "afterUpdate" : "beforeUpdate"
            unlockedBalance = GraftClient.balance(GraftClientTools.UnlockedBalance)
            totalBalance = GraftClient.balance(GraftClientTools.LockedBalance)
        }
    }

    ColumnLayout {
        spacing: 0
        anchors {
            fill: parent
            verticalCenter: parent.verticalCenter
        }

        // balance button
        Button {
            id: unlockedMainBalance

            flat: true
            topInset: 0
            bottomInset: 0
            // enabled: balanceVisible
            Layout.fillWidth: true
            Layout.preferredHeight: 80
            KeyNavigation.backtab: balance.Navigation.explicitLastComponent
            checkable: !balanceVisible
            onClicked: {
                console.log("currentItem: " + currentItem)

                if (balanceVisible) {
                    pushScreen.openMainAddressScreen()
                }
            }

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

                    RowLayout {
                        Layout.fillWidth: true
                        spacing: 10

                        Label {
                            color: "#233146"
                            font.pixelSize: 20
                            text: qsTr("Balance")
                        }

                        Label {
                            Layout.fillWidth: true
                            Layout.rightMargin: 12
                            Layout.alignment: Qt.AlignRight
                            horizontalAlignment: Text.AlignRight
                            color: "#404040"
                            font.pixelSize: 20
                            text: unlockedBalance + " / " + totalBalance
                        }
                    }

                    RowLayout {
                        Layout.fillWidth: true
                        spacing: 10

                        Label {
                            id: updateLabel
                            color: "#3d4757"
                            font.pixelSize: 12

                            Timer {
                                id: timer
                                repeat: true
                                onTriggered: dots()
                            }
                        }
                    }
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

       // delimiter
        Rectangle {
            Layout.fillWidth: true
            Layout.leftMargin: 15
            Layout.rightMargin: 15
            Layout.preferredHeight: 1
            color: "#e6e6e8"
        }
    }

    states: [
        State {
            name: "beforeUpdate"

            PropertyChanges {
                target: updateLabel
                text: qsTr("Waiting for update")
            }
            PropertyChanges {
                target: timer
                running: true
            }
        },
        State {
            name: "afterUpdate"

            PropertyChanges {
                target: updateLabel
                text: qsTr("Updated!")
            }
            PropertyChanges {
                target: timer
                running: false
            }
        }
    ]

    function dots() {
        if (dotsCount >= 3) {
            updateLabel.text = GraftClientTools.dotsRemove(updateLabel.text)
            dotsCount = 0
        } else {
            updateLabel.text += '.'
            dotsCount++
        }
    }
}
