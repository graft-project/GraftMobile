import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Dialogs 1.2

Page {
    id: basePage
    property var pushScreen
    property var action
    property alias screenHeader: appHeader
    property var specialBackMode: null
    property alias screenDialog: attentionDialog

    signal attentionException()

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

    MessageDialog {
        id: attentionDialog
        title: qsTr("Attention")
        icon: StandardIcon.Warning
        onAccepted: attentionException()
    }
}
