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
    property alias closeLabelVisible: label.opacity
    property alias animationTimer: label.timer

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

    TemporaryLabel {
        id: label
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
}
