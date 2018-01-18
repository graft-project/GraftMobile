import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Dialogs 1.2
import "../"

Page {
    id: basePage
    property var pushScreen
    property var action
    property alias screenHeader: appHeader
    property var specialBackMode: null
    property alias isMenuActive: appHeader.navigationButtonState
    property alias screenDialog: attentionDialog

    signal attentionAccepted()
    signal animationCompleted()

    header: Header {
        id: appHeader
        headerText: basePage.title

        onNavigationButtonClicked: {
            if(navigationButtonState) {
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

    PopupMessageLabel {
        id: closeLabel
        anchors {
            left: parent.left
            right: parent.right
            bottom: parent.bottom
            margins: 33
        }
        labelText: qsTr("Are you sure to close the application? \n Please, click again.")
        opacityAnimator.onStopped: animationCompleted()
    }

    MessageDialog {
        id: attentionDialog
        title: qsTr("Attention")
        icon: StandardIcon.Warning
        onAccepted: attentionAccepted()
    }

    function showCloseLabel() {
        closeLabel.opacity = 1.0
        closeLabel.timer.start()
    }
}
