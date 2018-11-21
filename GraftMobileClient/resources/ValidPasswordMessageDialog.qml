import QtQuick 2.9
import QtQuick.Dialogs 1.2

Item {
    property alias mobileMessageDialog: mobileMessageDialog
    property alias desktopMessageDialog: desktopMessageDialog
    property string messageText: qsTr("Are you sure you don't want to create a password for your " +
                                      "wallet? You will not be able to create a password later!")

    signal desktopDialogApproved()
    signal desktopDialogRefused()

    anchors.fill: parent

    MessageDialog {
        id: mobileMessageDialog
        title: qsTr("Attention")
        icon: StandardIcon.Warning
        text: messageText
        standardButtons: StandardButton.Yes | StandardButton.No
    }

    ChooserDialog {
        id: desktopMessageDialog
        topMargin: (parent.height - desktopMessageDialog.height) / 2
        leftMargin: (parent.width - desktopMessageDialog.width) / 2
        dialogMode: true
        title: qsTr("Attention")
        dialogMessage: messageText
        confirmButtonText: qsTr("Yes")
        denyButtonText: qsTr("No")
        onConfirmed: {
            desktopDialogApproved()
            desktopMessageDialog.close()
        }
        onDenied: {
            desktopDialogRefused()
            desktopMessageDialog.close()
        }
    }
}
