import QtQuick 2.9
import QtQuick.Layouts 1.3

Rectangle {
    property real amountMoneyCost: 0
    property real amountGraftCost: 0

    height: 70
    color: "#ffffff"

    RowLayout {
        spacing: 10
        anchors {
            left: parent.left
            right: parent.right
            leftMargin: 15
            rightMargin: 15
            verticalCenter: parent.verticalCenter
        }

        Image {
            Layout.preferredHeight: 42
            Layout.preferredWidth: 48
            fillMode: Image.PreserveAspectFit
            Layout.alignment: Qt.AlignLeft
            source: "qrc:/imgs/g-max.png"
        }

        Text {
            text: qsTr("Main Balance:")
            color: "#233146"
            font.pointSize: 20
            Layout.alignment: Qt.AlignLeft
        }

        Rectangle {
            Layout.fillWidth: true
        }

        ColumnLayout {
            spacing: 0
            Layout.alignment: Qt.AlignRight

            Text {
                id:a
                text: amountGraftCost
                color: "#404040"
                font.pointSize: 20
            }

            Text {
                text: "$" + amountMoneyCost
                color: "#b39036"
                font.pointSize: 12
                anchors.right: a.right
            }
        }
    }

    Rectangle {
        height: 1
        anchors {
            bottom: parent.bottom
            left: parent.left
            right: parent.right
            leftMargin: 15
            rightMargin: 15
        }
        color: "#e6e6e8"
    }
}
