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
            editable: true
            contentItem.enabled: false
            font.pointSize: 11
            Material.background: "transparent"
            Material.foreground: "#707070"
        }

        RowLayout {
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
