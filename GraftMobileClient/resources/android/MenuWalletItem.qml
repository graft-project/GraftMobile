import QtQuick 2.9
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.2
import com.graft.design 1.0

MenuItem {
    property alias balanceInGraft: graftMoney.text
    property alias icon: menuLabel.icon
    property alias name: menuLabel.name

    padding: 0
    topPadding: 0
    bottomPadding: 0
    contentItem: Item {

        RowLayout {
            anchors {
                fill: parent
                rightMargin: 10
                verticalCenter: parent.verticalCenter
            }

            MenuLabel {
                id: menuLabel
                Layout.fillWidth: true
                Layout.alignment: Qt.AlignCenter
                name: qsTr("Wallet")
                icon: "qrc:/imgs/waller.png"
            }

            Text {
                id: graftMoney
                color: ColorFactory.color(DesignFactory.MainText)
                Layout.alignment: Qt.AlignRight
                font {
                    bold: true
                    family: "Liberation Sans"
                    pointSize: 15
                }
            }

            Image {
                Layout.preferredHeight: 23
                Layout.preferredWidth: 23
                Layout.alignment: Qt.AlignRight
                source: "qrc:/imgs/g-min.png"
            }
        }
    }
}
