import QtQuick 2.9
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.2
import com.graft.design 1.0
import com.device.platform 1.0
import "../"

BaseHeader {
    id: rootItem
    height: Detector.detectDevice() === Platform.IPhoneX ? 88 :
                                        Detector.isDesktop() ? 49 : 64
    color: ColorFactory.color(DesignFactory.IosNavigationBar)

    property alias navigationText: navigationButton.name
    property alias actionText: actionButton.name

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
                name: qsTr("Back")
                onClicked: navigationButtonClicked()
            }
        }

        Item {
            Layout.fillWidth: true
            Layout.fillHeight: true

            Label {
                anchors.centerIn: parent
                color: ColorFactory.color(DesignFactory.LightText)
                font {
                    bold: true
                    pixelSize: 17
                }
                text: rootItem.headerText
            }
        }

        Item {
            Layout.preferredWidth: 30
            Layout.rightMargin: actionButton.name.length > 6 ? 10 : 0
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
                name: qsTr("Done")
                onClicked: actionButtonClicked()
                onPressed: actionButton.focus = true
                onReleased: actionButton.focus = false
            }
        }
    }
}
