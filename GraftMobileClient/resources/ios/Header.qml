import QtQuick 2.9
import QtQuick.Layouts 1.3
import com.graft.design 1.0
import com.device.platform 1.0
import "../"

BaseHeader {
    id: rootItem
    height: Detector.detectDevice() === Platform.IPhoneX ? 88 :
                                        Detector.isDesktop() ? 49 : 64
    color: ColorFactory.color(DesignFactory.IosNavigationBar)

    property alias navigationText: navigationButton.text
    property alias actionText: actionButton.text

    RowLayout {
        height: parent.height
        anchors {
            leftMargin: 15
            rightMargin: 15
            topMargin: Detector.detectDevice() === Platform.IPhoneX ? 25 : Detector.isDesktop() ? 0 : 10
            left: parent.left
            right: parent.right
            top: parent.top
        }

        Item {
            Layout.preferredWidth: 30
            Layout.alignment: Qt.AlignLeft

            HeaderButton {
                id: navigationButton
                anchors.centerIn: parent
                visible: rootItem.isNavigationButtonVisible
                text: qsTr("Back")
                onClicked: navigationButtonClicked()
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
                    pixelSize: 17
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

            HeaderButton {
                id: actionButton
                anchors.centerIn: parent
                visible: rootItem.actionButtonState
                text: qsTr("Done")
                onClicked: actionButtonClicked()
            }
        }
    }
}
