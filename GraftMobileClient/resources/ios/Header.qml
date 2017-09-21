import QtQuick 2.9
import QtQuick.Layouts 1.3
import com.graft.design 1.0
import "../"

BaseHeader {
    id: rootItem
    height: 44
    color: ColorFactory.color(DesignFactory.ForegroundIos)

    property alias navigationText: navigationButton.text
    property alias actionText: actionButton.text

    RowLayout {
        height: parent.height
        anchors {
            leftMargin: 15
            rightMargin: 15
            left: parent.left
            right: parent.right
        }

        Item {
            Layout.preferredWidth: 30
            Layout.alignment: Qt.AlignLeft

            Text {
                id: navigationButton
                anchors.centerIn: parent
                visible: rootItem.navigationButtonState
                text: qsTr("Back")
                font.pointSize: 12
                color: ColorFactory.color(DesignFactory.LightText)

                MouseArea {
                    anchors.fill: parent
                    onClicked: navigationButtonClicked()
                }
            }
        }

        Item {
            Layout.fillWidth: true
            Layout.fillHeight: true

            Text {
                text: rootItem.headerText
                anchors.centerIn: parent
                font {
                    bold: true
                    pointSize: 13
                }
                color: ColorFactory.color(DesignFactory.LightText)
            }
        }

        Item {
            Layout.preferredWidth: 30
            Layout.alignment: Qt.AlignRight

            CartItem {
                width: 25
                height: 25
                visible: rootItem.cartEnable
                productCount: rootItem.selectedProductCount
                anchors.centerIn: parent
            }

            Text {
                id: actionButton
                anchors.centerIn: parent
                visible: rootItem.actionButtonState
                text: qsTr("Done")
                font.pointSize: 11
                color: ColorFactory.color(DesignFactory.LightText)

                MouseArea {
                    anchors.fill: parent
                    onClicked: actionButtonClicked()
                }
            }
        }
    }
}
