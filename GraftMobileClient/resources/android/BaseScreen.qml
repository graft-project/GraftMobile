import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Dialogs 1.2
import "../"

Page {
    id: basePage

    property var pushScreen: null
    property var action: null
    property var specialBackMode: null
    property alias screenHeader: appHeader
    property alias isMenuActive: appHeader.navigationButtonState
    property alias isMenuVisible: appHeader.isNavigationButtonVisible
    property alias screenDialog: attentionDialog

    signal attentionAccepted()
    signal errorMessage()

    onVisibleChanged: enableScreen()

    header: Header {
        id: appHeader
        headerText: basePage.title

        onNavigationButtonClicked: {
            if (navigationButtonState) {
                basePage.pushScreen.showMenu()
            } else {
                if (specialBackMode) {
                    specialBackMode()
                } else {
                    basePage.pushScreen.goBack()
                }
            }
        }

        onActionButtonClicked: {
            action()
        }
    }

    MessageDialog {
        id: attentionDialog
        title: qsTr("Attention")
        icon: StandardIcon.Warning
        onAccepted: attentionAccepted()
    }

    function backButtonHandler() {
        return isMenuActive
    }

    function disableScreen() {
        basePage.enabled = false
    }

    function enableScreen() {
        basePage.enabled = true
        errorMessage()
    }

    function priceRegExp() {
        return /(([1-9]\d{0,5}\.\d{1,10})|([1-9]\d{0,5}))|([0]\.\d{1,10})|(.){0}/
    }

    function openScreenDialog(title, price) {
        if (title === "" && price === "") {
            screenDialog.text = qsTr("Please, enter the item title and price.")
        } else if (title === "") {
            screenDialog.text = qsTr("Please, enter the item title.")
        } else if (price === "") {
            screenDialog.text = qsTr("Please, enter the item price.")
        } else if ((0.0001 > price) || (price > 100000.0)) {
            screenDialog.text = qsTr("The amount must be more than 0 and less than 100 000! Please input correct value.")
        } else {
            return false
        }
        screenDialog.title = qsTr("Input error")
        screenDialog.open()
        return true
    }
}
