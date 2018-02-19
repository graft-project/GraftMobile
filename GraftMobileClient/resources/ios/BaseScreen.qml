import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Dialogs 1.2
import com.device.platform 1.0
import "../"

Page {
    id: basePage

    property var pushScreen: null
    property var action: null
    property var specialBackMode: null
    property alias screenHeader: appHeader
    property alias isMenuVisible: appHeader.isNavigationButtonVisible
    property var screenDialog: Detector.isDesktop() ? desktopDialog : mobileDialog

    signal attentionAccepted()
    signal errorMessage()

    onVisibleChanged: enableScreen()

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
        topMargin: (parent.height - desktopDialog.height) / 2
        leftMargin: (parent.width - desktopDialog.width) / 2
        title: qsTr("Attention")
        confirmButton.onClicked: desktopDialog.close()
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
}
