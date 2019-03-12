import QtQuick 2.9
import QtQuick.Dialogs 1.2
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.2
import com.device.platform 1.0
import org.navigation.attached.properties 1.0
import "components"

BaseScreen {
    id: sendCoinScreen

    property alias address: receiversAddress.text
    property string amount: ""
    property string fee: ""

    title: qsTr("Send")
    onErrorMessage: busyIndicator.running = false

    Connections {
        target: GraftClient

        onTransferReceived: {
            busyIndicator.running = false
            enableScreen()
            pushScreen.openPaymentScreen(result, true)
        }
    }

    Component.onCompleted: {
        QuickExchangeModel.clear()
        QuickExchangeModel.add("Fee", "GRFT", parseFloat(fee) + parseFloat(amount), true)
    }

    ColumnLayout {
        anchors.fill: parent
        spacing: 0

        ColumnLayout {
            Layout.alignment: Qt.AlignTop
            Layout.fillWidth: true
            Layout.margins: 15
            spacing: 20

            Label {
                Layout.fillWidth: true
                font {
                    pixelSize: 16
                    bold: true
                }
                text: Detector.isPlatform(Platform.IOS | Platform.Desktop) ?
                                              qsTr("Receiver's address:") : qsTr("Receiver's address")
            }

            Label {
                id: receiversAddress
                Layout.fillWidth: true
                wrapMode: Label.WrapAnywhere
                font.pixelSize: 16
                horizontalAlignment: Qt.AlignHCenter
            }

            RowLayout {
                Layout.fillWidth: true

                Label {
                    Layout.fillWidth: true
                    font {
                        pixelSize: 16
                        bold: true
                    }
                    text: Detector.isPlatform(Platform.IOS | Platform.Desktop) ? qsTr("Amount:") :
                                                                                 qsTr("Amount")
                }

                Label {
                    font.pixelSize: 16
                    text: qsTr("%1\t<b>%2</b>").arg(amount).arg("GRFT")
                }
            }

            RowLayout {
                Layout.fillWidth: true

                Label {
                    Layout.fillWidth: true
                    font {
                        pixelSize: 16
                        bold: true
                    }
                    text: Detector.isPlatform(Platform.IOS | Platform.Desktop) ? qsTr("Fee:") :
                                                                                 qsTr("Fee")
                }

                Label {
                    font.pixelSize: 16
                    text: qsTr("%1\t<b>%2</b>").arg(fee).arg("GRFT")
                }
            }
        }

        Item {
            Layout.fillHeight: true
        }

        QuickExchangeView {
            id: quickExchangeView
            Layout.preferredHeight: 50
            Layout.fillWidth: true
            Layout.bottomMargin: 15
        }

        WideActionButton {
            id: sendCoinsButton
            Layout.fillWidth: true
            Layout.leftMargin: 15
            Layout.rightMargin: 15
            Layout.bottomMargin: 15
            Layout.alignment: Qt.AlignBottom | Qt.AlignCenter
            text: qsTr("Confirm")
            KeyNavigation.tab: sendCoinScreen.Navigation.implicitFirstComponent
            onClicked: passwordDialog.open()
        }
    }

    BusyIndicator {
        id: busyIndicator
        anchors.centerIn: parent
        running: false
    }

    ChooserDialog {
        id: passwordDialog
        title: qsTr("Enter password:")
        topMargin: (parent.height - passwordDialog.height) / 2
        leftMargin: (parent.width - passwordDialog.width) / 2
        confirmButtonText: qsTr("OK")
        denyButtonText: qsTr("Close")
        onConfirmed: passwordDialog.accept()
        onDenied: {
            passwordTextField.clear()
            passwordDialog.close()
        }
        onAccepted: checkingPassword(passwordTextField.text)
    }

    function checkingPassword(password) {
        if (GraftClient.checkPassword(password)) {
            disableScreen()
            busyIndicator.running = true
            GraftClient.transfer(receiversAddress.text, amount)
        } else {
            screenDialog.title = qsTr("Error")
            screenDialog.text = qsTr("You enter incorrect password!\nPlease try again...")
            screenDialog.open()
            busyIndicator.running = false
            enableScreen()
        }
        passwordDialog.passwordTextField.clear()
    }
}

