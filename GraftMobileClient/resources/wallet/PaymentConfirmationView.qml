import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Controls.Material 2.2
import QtQuick.Layouts 1.3
import QtQuick.Controls.Styles 1.4
import "../"

Item {
    property alias currencyModel: graftCBox.model
    property alias mtotalAmount: totalViewScreen.totalAmount
    property int balanceInGraft: 0
    property int balanceInUSD: 0

    ColumnLayout {
        id: column
        spacing: 100
        anchors {
            left: parent.left
            right: parent.right
            top: parent.top
            topMargin: 50
            leftMargin: 30
            rightMargin: 30
        }

        TotalView {
            id: totalViewScreen
            Layout.preferredWidth: parent.width
        }

        ColumnLayout {
            Layout.fillWidth: true
            spacing: 0

            ComboBox {
                id: graftCBox
                Layout.fillWidth: true
                Material.background: "#00707070"
            }

            Rectangle {
                height: 2
                Layout.fillWidth: true
                color: "#707070"
            }

            Text {
                Layout.topMargin: 12
                color: "#707070"
                text: qsTr("Balance:\t" + balanceInGraft + "g / " + balanceInUSD + "USD")
                font{
                    pointSize: 12
                    family: "Liberation Sans"
                    bold: true
                }
            }
        }

        RoundButton {
            id: confirmButton
            topPadding: 15
            bottomPadding: 15
            highlighted: true
            Material.elevation: 0
            Material.accent: "#707070"
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignCenter
            Layout.leftMargin: 70
            Layout.rightMargin: 70
            text: qsTr("Confirm")
            font {
                family: "Liberation Sans"
                pointSize: 18
                capitalization: Font.MixedCase
            }
        }
    }
}
