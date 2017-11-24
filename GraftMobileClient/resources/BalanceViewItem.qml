import QtQuick 2.9
import QtQuick.Layouts 1.3
import org.graft 1.0

Rectangle {
    id: balance

    property real amountGraftCost: 0

    height: 70
    color: "#ffffff"

    Connections {
        target: GraftClient
        onBalanceUpdated: {
            amountGraftCost = GraftClient.balance(GraftClientTools.UnlockedBalance)
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

        Text {
            text: qsTr("Main Balance:")
            color: "#233146"
            font.pointSize: 20
            Layout.fillWidth: true
            Layout.leftMargin: 14
            Layout.alignment: Qt.AlignLeft
        }

        Text {
            id:graftCost
            text: amountGraftCost
            color: "#404040"
            font.pointSize: 20
            Layout.rightMargin: 8
            Layout.alignment: Qt.AlignRight
        }
    }

    Rectangle {
        height: 1
        anchors {
            left: parent.left
            right: parent.right
            bottom: parent.bottom
            leftMargin: 15
            rightMargin: 15
        }
        color: "#e6e6e8"
    }
}
