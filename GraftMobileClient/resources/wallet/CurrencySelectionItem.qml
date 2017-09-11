import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Controls.Material 2.2
import QtQuick.Layouts 1.3
import com.graft.design 1.0

ColumnLayout {
    property alias currencyModel: graftCBox.model
    property real balanceInGraft: 0
    property real balanceInUSD: 0

    spacing: 10

    Text {
        text: qsTr("PAY WITH:")
        Layout.alignment: Qt.AlignLeft
        font {
            pointSize: 12
            bold: true
        }
        color: ColorFactory.color(DesignFactory.MainText)
    }

    ColumnLayout {
        ComboBox {
            id: graftCBox
            Layout.fillWidth: true
            editable: true
            contentItem.enabled: false
            font.pointSize: 11
            Material.background: "transparent"
            Material.foreground: ColorFactory.color(DesignFactory.MainText)
        }

        RowLayout {
            Text {
                color: ColorFactory.color(DesignFactory.MainText)
                text: qsTr("Balance:\t")
                font {
                    pointSize: 12
                    family: "Liberation Sans"
                }
            }

            Text {
                color: ColorFactory.color(DesignFactory.MainText)
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
