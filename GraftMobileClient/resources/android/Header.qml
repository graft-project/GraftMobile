import QtQuick 2.9
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.2
import com.graft.design 1.0
import "../"

BaseHeader {
    id: rootItem
    height: 60
    color: ColorFactory.color(DesignFactory.Foreground)

    onActionButtonStateChanged: {
        if (isSettings) {
            actionButton.image.source = "qrc:/imgs/whiteSettings.png"
            actionButton.image.height = 23
        } else if (isBlog) {
            actionButton.image.source = "qrc:/imgs/refresh.png"
            actionButton.image.height = 30
            actionButton.image.width = 30
        } else {
            actionButton.image.source = "qrc:/imgs/done.png"
        }
    }

    onNavigationButtonStateChanged: {
        if (navigationButtonState) {
            navigationButton.image.source = "qrc:/imgs/menu_icon.png"
            navigationButton.image.width = 20
        } else {
            navigationButton.image.source = "qrc:/imgs/back_icon.png"
            navigationButton.image.width = 20
        }
    }

    RowLayout {
        anchors {
            fill: parent
            leftMargin: 5
            rightMargin: 5
        }

        HeaderButton {
            id: navigationButton
            Layout.preferredHeight: parent.height - 10
            Layout.preferredWidth: height
            Layout.alignment: Qt.AlignLeft
            visible: isNavigationButtonVisible
            image.width: 20
            image.height: 18
            image.source: "qrc:/imgs/back_icon.png"
            onClicked: navigationButtonClicked()
        }

        Label {
            Layout.fillWidth: true
            Layout.leftMargin: isNavigationButtonVisible ? 25 : 15
            Layout.alignment: Qt.AlignLeft
            color: ColorFactory.color(DesignFactory.LightText)
            font {
                bold: true
                pixelSize: 17
            }
            text: rootItem.headerText
        }

        CartItem {
            visible: rootItem.cartEnable
            Layout.preferredHeight: 30
            Layout.preferredWidth: 30
            Layout.rightMargin: rootItem.actionButtonState ? 0 : 15
            Layout.alignment: Qt.AlignRight
            productCount: rootItem.selectedProductCount
        }

        HeaderButton {
            id: actionButton
            Layout.preferredHeight: parent.height - 10
            Layout.preferredWidth: height
            Layout.alignment: Qt.AlignRight
            visible: rootItem.actionButtonState
            image.width: 23
            image.height: 15
            image.source: "qrc:/imgs/done.png"
            onClicked: actionButtonClicked()
        }
    }
}
