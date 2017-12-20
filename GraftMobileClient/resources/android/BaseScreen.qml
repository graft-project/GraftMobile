import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Dialogs 1.2

Page {
    id: basePage
    property var pushScreen
    property var action
    property alias screenHeader: appHeader
    property var specialBackMode: null
    property alias isMenuActive: appHeader.navigationButtonState
    property alias screenDialog: attentionDialog

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

    MessageDialog {
        id: attentionDialog
        title: qsTr("Attention")
        icon: StandardIcon.Warning
    }
}
