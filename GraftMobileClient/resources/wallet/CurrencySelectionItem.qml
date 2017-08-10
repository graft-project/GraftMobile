import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Controls.Material 2.2
import QtQuick.Layouts 1.3


ColumnLayout {
    property alias currencyModel: graftCBox.model
    property int balanceInGraft: 0
    property int balanceInUSD: 0

    spacing: 10

    Text {
        text: qsTr("PAY WITH:")
        Layout.alignment: Qt.AlignLeft
        font {
            pointSize: 12
            bold: true
        }
        color: "#707070"
    }

    ColumnLayout {

        ComboBox {
            id: graftCBox
            Layout.fillWidth: true
            Material.background: "transparent"
            Layout.leftMargin: -12
            Layout.rightMargin: -12
            font.pointSize: 11
            Material.foreground: "#707070"
        }

        Rectangle {
            height: 2
            Layout.topMargin: -20
            Layout.fillWidth: true
            color: "#707070"
        }

        RowLayout {
            Layout.topMargin: -10
            Text {
                color: "#707070"
                text: qsTr("Balance:\t")
                font {
                    pointSize: 12
                    family: "Liberation Sans"
                }
            }
            Text {
                color: "#707070"
                text: qsTr("%1g / %2USD").arg(balanceInGraft).arg(balanceInUSD)
                font {
                    pointSize: 12
                    family: "Liberation Sans"
                    bold: true
                }
            }
        }
    }
}
