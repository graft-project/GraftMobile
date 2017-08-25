import QtQuick 2.9
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.2
import QtQuick.Controls.Material 2.2

Rectangle {
    property alias model: graftCBox.model

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
                        drawer.close()
                        openBalanceScreen()
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

            ColumnLayout {
                Layout.preferredWidth: parent.width
                spacing: 10

                Wallet {
                    name: "Graft"
                    number: "XXX344F355"
                }

                Wallet {
                    name: "Bitcoins"
                    number: "XXX5Kb8kLf9"
                }

                Wallet {
                    name: "VISA"
                    number: "XXX3224"
                }

                Wallet {
                    name: "MasterCard"
                    number: "XXX2345"
                }
            }

            RowLayout {
                spacing: 12

                Text {
                    Layout.alignment: Qt.AlignLeft
                    text: qsTr("+")
                    color: "white"
                    font {
                        family: "Liberation Sans"
                        pointSize: 14
                    }

                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            drawer.close()
                        }
                    }
                }

                Text {
                    Layout.alignment: Qt.AlignRight
                    text: qsTr("Add Card")
                    color: "white"
                    font {
                        family: "Liberation Sans"
                        pointSize: 13
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
                        drawer.close()
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
                        drawer.close()
                    }
                }
            }
        }
    }
}
