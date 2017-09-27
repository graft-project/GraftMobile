import QtQuick 2.9
import QtQuick.Layouts 1.3
import com.graft.design 1.0

Rectangle {
    property real amountMoneyCost: 0
    property alias amountGraftCost: amountGraftText.text

    height: 70
    color: "transparent"

    RowLayout {
        anchors {
            leftMargin: 12
            rightMargin: 12
            left: parent.left
            right: parent.right
            verticalCenter: parent.verticalCenter
        }

        Text {
            text: qsTr("Balance:")
            color: "#233146"
            font.pointSize: 20
            Layout.alignment: Qt.AlignLeft
        }

        RowLayout {
            Layout.alignment: Qt.AlignRight

            ColumnLayout {
                spacing: 0
                Layout.alignment: Qt.AlignRight

                Text {
                    id: amountGraftText
                    color: "#404040"
                    font {
                        bold: true
                        pointSize: 21
                    }
                }

                Text {
                    text: amountMoneyCost + " USD"
                    color: "#b39036"
                    font.pointSize: 12
                }
            }

            Image {
                Layout.preferredHeight: 30
                Layout.preferredWidth: 36
                fillMode: Image.PreserveAspectFit
                Layout.alignment: Qt.AlignRight
                source: "qrc:/imgs/g-max.png"
            }
        }
    }
}
