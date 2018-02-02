import QtQuick 2.9
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.2
import com.device.platform 1.0
import "components"

BaseScreen {
    id: root

    property bool screenState: true

    state: screenState ? "overviewWallet" : "createWallet"

    Item {
        anchors {
            fill: parent
            topMargin: 15
            leftMargin: 15
            rightMargin: 15
            bottomMargin: Detector.detectDevice() === Platform.IPhoneX ? screenState ? 15 : 30 : 15
        }

        Label {
            id: label
            anchors {
                top: parent.top
                left: parent.left
                right: parent.right
            }
            horizontalAlignment: Label.AlignHCenter
            color: "#BBBBBB"
            wrapMode: Label.WordWrap
            text: qsTr("Your wallet is created! Copy and store in the safe place this " +
                       "mnemonic password")
        }

        MnemonicPhraseView {
            id: mnemonicPhraseView
            anchors {
                verticalCenterOffset: -30
                verticalCenter: parent.verticalCenter
                left: parent.left
                right: parent.right
            }
            mnemonicPhrase: GraftClient.getSeed()
        }

        PopupMessageLabel {
            id: mnemonicPhraseLabel
            anchors.centerIn: parent
            labelText: qsTr("Mnemonic phrase is copied!")
        }

        WideActionButton {
            id: copyMnemonicButton
            anchors {
                left: parent.left
                right: parent.right
                bottom: screenState ? parent.bottom : saveButton.top
            }
            text: qsTr("Copy to clipboard")
            onClicked: {
                GraftClient.copyToClipboard(GraftClient.getSeed())
                mnemonicPhraseLabel.opacity = 1.0
                mnemonicPhraseLabel.timer.start()
            }
        }

        WideActionButton {
            id: saveButton
            anchors {
                left: parent.left
                right: parent.right
                bottom: parent.bottom
            }
            text: qsTr("I saved it!")
            onClicked: save()
        }
    }

    states: [
        State {
            name: "createWallet"

            PropertyChanges {
                target: label
                visible: true
            }
            PropertyChanges {
                target: root
                title: qsTr("Create wallet")
                action: save
                screenHeader {
                    navigationButtonState: Detector.isPlatform(Platform.Android)
                    isNavigationButtonVisible: false
                    actionButtonState: true
                }
            }
        },
        State {
            name: "overviewWallet"

            PropertyChanges {
                target: label
                visible: false
            }
            PropertyChanges {
                target: saveButton
                visible: false
            }
            PropertyChanges {
                target: root
                title: qsTr("Mnemonic phrase")
                action: save
                screenHeader {
                    navigationButtonState: Detector.isPlatform(Platform.IOS) || Detector.isDesktop()
                }
            }
        }
    ]

    function save() {
        if (screenState) {
            pushScreen.goBack()
        } else {
            pushScreen.openBaseScreen()
        }
    }
}
