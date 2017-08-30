import QtQuick 2.9
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.2
import QtQuick.Controls.Material 2.2
import "../"

BaseScreen {
    property alias model: graftCBox.model
    property var pushScreen

    header.visible: false

    ListModel {
        id: cardModel

        ListElement {
            cardName: "Graft"
            cardNumber: "XXX344F355"
        }

        ListElement {
            cardName: "Bitcoins"
            cardNumber: "XXX5Kb8kLf9"
        }

        ListElement {
            cardName: "VISA"
            cardNumber: "XXX3224"
        }

        ListElement {
            cardName: "MasterCard"
            cardNumber: "XXX2345"
        }
    }

    Rectangle {
        anchors.fill: parent
        color: "#484848"

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
                    model: CardModel//cardModel
                    clip: true
                    spacing: 10
                    delegate: cardDelegate

                    Component {
                        id: cardDelegate

                        Wallet {
                            width: cardList.width
                            name: cardName
                            number: cardNumber
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
