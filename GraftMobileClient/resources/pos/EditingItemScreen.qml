import QtQuick 2.9
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.2
import QtQuick.Controls.Material 2.2
import com.graft.design 1.0
import "../components"
import "../"

BaseScreen {
    id: additionItem
    title: qsTr("Add item")
    action: additionItem.confirmProductParameters
    Component.onCompleted: init()

    screenHeader {
        navigationButtonState: Qt.platform.os === "ios"
        actionButtonState: true
    }

    property alias currencyModel: productItem.currencyModel

    function init() {
        if (Qt.platform.os === "ios") {
            navigationText: qsTr("Cancel")
            actionText: qsTr("Done")
        }
    }

    function confirmProductParameters() {
        ProductModel.add(productItem.previewImage, productItem.titleText, productItem.price,
                         productItem.currencyModel, productItem.descriptionText)
        additionItem.pushScreen.openProductScreen()
        GraftClient.save()
    }

    ColumnLayout {
        spacing: 0
        anchors {
            fill: parent
            topMargin: 10
            bottomMargin: 20
        }

        ProductItemView {
            id: productItem
            Layout.leftMargin: 15
            Layout.rightMargin: 15
            Layout.fillWidth: true
            Layout.fillHeight: true
        }

        WideActionButton {
            id: multiTaskingButton
            text: qsTr("Confirm")
            onClicked: {
                confirmProductParameters()
            }
        }
    }
}
