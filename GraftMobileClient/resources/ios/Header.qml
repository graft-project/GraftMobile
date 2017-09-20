import QtQuick 2.9
import QtQuick.Layouts 1.3
import QtGraphicalEffects 1.0
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

            Text {
                id: navigationButton
                text: qsTr("Back")
                visible: rootItem.navigationButtonState
                horizontalAlignment: Text.AlignHCenter
                anchors.centerIn: parent
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
                horizontalAlignment: Text.AlignHCenter
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
                visible: rootItem.cartEnable
                productCount: rootItem.selectedProductCount
                anchors.centerIn: parent
                height: 25
                width: 25
            }

            Text {
                id: actionButton
                text: qsTr("Done")
                visible: rootItem.actionButtonState
                horizontalAlignment: Text.AlignHCenter
                anchors.centerIn: parent
                font.pointSize: 12
                color: ColorFactory.color(DesignFactory.LightText)

                MouseArea {
                    anchors.fill: parent
                    onClicked: actionButtonClicked()
                }
            }
        }
    }
}
