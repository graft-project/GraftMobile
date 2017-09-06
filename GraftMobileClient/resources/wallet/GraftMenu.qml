import QtQuick 2.9
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.2
import QtQuick.Controls.Material 2.2
import "../"

BaseScreen {
    property alias cBoxModel: graftCBox.model
    property alias lViewModel: cardList.model
    property var pushScreen

    header.visible: false

    Rectangle {
        anchors.fill: parent
        color: "#283c4a"

        ColumnLayout {
            spacing: 30
            anchors {
                top: parent.top
                right: parent.right
                left: parent.left
                margins: 25
            }

            Item {
                Layout.fillWidth: true
                Layout.preferredHeight: 150

                Image {
                    width: parent.width / 2
                    anchors {
                        bottom: parent.bottom
                        horizontalCenter: parent.horizontalCenter
                    }
                    fillMode: Image.PreserveAspectFit
                    source: "qrc:/imgs/graft_wallet_logo_small.png"
                }
            }

            ColumnLayout {
                spacing: 20

                Text {
                    text: qsTr("HOME")
                    color: "white"
                    font {
                        family: "Liberation Sans"
                        pointSize: 14
                    }

                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            pushScreen.hideMenu()
                            pushScreen.openBalanceScreen()
                        }
                    }
                }

                ComboBox {
                    id: graftCBox
                    Layout.fillWidth: true
                    editable: true
                    contentItem.enabled: false
                    font.pointSize: 14
                    Material.background: "transparent"
                    Material.foreground: "#707070"
                }

                ListView {
                    id: cardList
                    Layout.fillWidth: true
                    Layout.minimumHeight: 106
                    model: CardModel
                    clip: true
                    spacing: 10
                    delegate: cardDelegate

                    Component {
                        id: cardDelegate

                        Wallet {
                            width: cardList.width
                            name: cardName
                            number: cardHideNumber
                        }
                    }
                }

                Text {
                    Layout.alignment: Qt.AlignLeft
                    text: qsTr("+  Add Card")
                    color: "white"
                    font {
                        family: "Liberation Sans"
                        pointSize: 14
                    }

                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            pushScreen.hideMenu()
                            pushScreen.addCardScreen()
                        }
                    }
                }
            }

            ColumnLayout {
                spacing: 20

                Text {
                    text: qsTr("TRANSACTION")
                    color: "white"
                    font {
                        family: "Liberation Sans"
                        pointSize: 14
                    }

                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            pushScreen.hideMenu()
                        }
                    }
                }

                Text {
                    text: qsTr("TRANSFER")
                    color: "white"
                    font {
                        family: "Liberation Sans"
                        pointSize: 14
                    }

                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            pushScreen.hideMenu()
                        }
                    }
                }
            }
        }
    }
}
