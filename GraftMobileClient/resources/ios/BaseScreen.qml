import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Dialogs 1.2
import com.device.platform 1.0
import org.navigation.attached.properties 1.0
import "../"

Page {
    id: basePage

    property var pushScreen: null
    property var action: null
    property var specialBackMode: null
    property alias screenHeader: appHeader
    property alias isMenuActive: appHeader.navigationButtonState
    property alias isMenuVisible: appHeader.isNavigationButtonVisible
    property var screenDialog: Detector.isDesktop() ? desktopDialog : mobileDialog

    signal networkReplyError()
    signal attentionAccepted()
    signal errorMessage()

    Navigation.implicitFirstComponent: screenHeader.Navigation.implicitFirstComponent
    onFocusChanged: {
        if (basePage.focus) {
            forceActiveFocus()
        }
    }
    onVisibleChanged: {
        enableScreen()
    }

    header: Header {
        id: appHeader
        headerText: basePage.title

        onNavigationButtonClicked: {
            if (specialBackMode) {
                specialBackMode()
            } else {
                basePage.pushScreen.goBack()
            }
        }

        onActionButtonClicked: {
            action()
        }
    }

    DesktopDialog {
        id: desktopDialog
        width: parent.width / 1.2
        leftMargin: (parent.width - desktopDialog.width) / 2
        topMargin: (parent.height - desktopDialog.height) / 2
        title: qsTr("Attention")
        onConfirmed: {
            nextItemInFocusChain(true).forceActiveFocus(Qt.TabFocusReason)
            attentionAccepted()
            desktopDialog.close()
        }
    }

    MessageDialog {
        id: mobileDialog
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
        return /^(180{1,8}|1[0-7]\d{8}|[1-9]\d{0,8}|0)(\.\d{0,10}){0,1}$/
    }

    function openScreenDialog(title, price) {
        if (title === "" && price === "") {
            screenDialog.text = qsTr("Please, enter the item title and price.")
        } else if (title === "") {
            screenDialog.text = qsTr("Please, enter the item title.")
        } else if (price === "") {
            screenDialog.text = qsTr("Please, enter the item price.")
        } else {
            return false
        }
        screenDialog.title = qsTr("Input error")
        screenDialog.open()
        return true
    }
}
