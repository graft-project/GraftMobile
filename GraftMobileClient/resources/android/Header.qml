import QtQuick 2.9
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.2
import com.graft.design 1.0
import "../"

BaseHeader {
    id: rootItem
    height: 60
    color: ColorFactory.color(DesignFactory.Foreground)

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
            onButtonClicked: navigationButtonClicked()
        }

//        RoundButton {
//            id: navigationButton
//            Layout.preferredHeight: parent.height - 10
//            Layout.preferredWidth: height
//            Layout.alignment: Qt.AlignLeft
//            visible: isNavigationButtonVisible
//            flat: true

//            Image {
//                id: menuIcon
//                width: 20
//                height: 18
//                anchors.centerIn: parent
//                source: "qrc:/imgs/back_icon.png"
//            }

//            onClicked: navigationButtonClicked()
//        }

        Text {
            Layout.fillWidth: true
            Layout.leftMargin: isNavigationButtonVisible ? 25 : 5
            Layout.alignment: Qt.AlignLeft
            text: rootItem.headerText
            font {
                bold: true
                pointSize: 17
            }
            color: ColorFactory.color(DesignFactory.LightText)
        }

        CartItem {
            visible: rootItem.cartEnable
            Layout.preferredHeight: 30
            Layout.preferredWidth: 30
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
            onButtonClicked: actionButtonClicked()
        }

//        RoundButton {
//            Layout.preferredHeight: parent.height - 10
//            Layout.preferredWidth: height
//            Layout.alignment: Qt.AlignRight
//            visible: rootItem.actionButtonState
//            flat: true

//            Image {
//                height: 15
//                width: 23
//                anchors.centerIn: parent
//                source: "qrc:/imgs/done.png"
//            }

//            onClicked: actionButtonClicked()
//        }
    }
}
