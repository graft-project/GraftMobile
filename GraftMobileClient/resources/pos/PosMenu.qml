import QtQuick 2.9
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.2

Rectangle {
    property double balanceInGraft: 1.15

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
                anchors {
                    centerIn: parent
                    bottom: parent.bottom
                    horizontalCenter: parent.horizontalCenter
                }
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
            Layout.preferredWidth: parent.width

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
                    }
                }
            }

            Text {
                text: qsTr("%1 g").arg(balanceInGraft)
                color: "#ffffff"
                Layout.alignment: Qt.AlignRight
                font {
                    bold: true
                    family: "Noto Sans CJK KR Medium"
                    pointSize: 10
                }
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

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    drawer.close()
                }
            }
        }
    }
}
