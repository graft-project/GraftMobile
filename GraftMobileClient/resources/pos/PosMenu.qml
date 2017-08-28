import QtQuick 2.9
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.2

Rectangle {
    property alias balanceInGraft: graftmoney.text

    color: "#484848"
    anchors.fill: parent

    ColumnLayout {
        spacing: 20
        anchors {
            left: parent.left
            leftMargin: 20
            right: parent.right
            rightMargin: 20
            top: parent.top
        }

        Item {
            Layout.topMargin: 20
            Layout.preferredHeight: 180
            Layout.preferredWidth: parent.width

            Image {
                width: parent.width / 2
                fillMode: Image.PreserveAspectFit
                anchors.centerIn: parent
                source: "qrc:/imgs/graft_pos_logo_small.png"
            }
        }

        Text {
            text: qsTr("STORE")
            color: "#ffffff"
            Layout.alignment: Qt.AlignLeft
            font {
                bold: true
                family: "Liberation Sans"
                pointSize: 10
            }
        }

        RowLayout {
            spacing: 0

            Text {
                text: qsTr("WALLET")
                color: "#ffffff"
                Layout.alignment: Qt.AlignLeft
                font {
                    family: "Liberation Sans"
                    pointSize: 10
                }

                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        drawer.close()
                        openInfoWalletScreen()
                    }
                }
            }

            Item {
                Layout.fillWidth: true
            }

            Text {
                id: graftmoney
                color: "#ffffff"
                Layout.alignment: Qt.AlignRight
                font {
                    bold: true
                    family: "Liberation Sans"
                    pointSize: 10
                }
            }

            Image {
                Layout.preferredHeight: 14
                fillMode: Image.PreserveAspectFit
                source: "qrc:/imgs/g_icon_small.png"
            }

        }

        Text {
            text: qsTr("SETTINGS")
            color: "#ffffff"
            Layout.alignment: Qt.AlignLeft
            font {
                family: "Liberation Sans"
                pointSize: 10
            }
        }
    }
}
