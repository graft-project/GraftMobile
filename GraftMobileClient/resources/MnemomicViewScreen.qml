import QtQuick 2.9
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.2
import com.device.platform 1.0
import org.graft 1.0
import "components"

BaseScreen {
    id: root

    property bool screenState: true

    state: screenState ? "overviewWallet" : "createWallet"

    Item {
        id: mnemonicScreen
        anchors {
            fill: parent
            topMargin: 15
            leftMargin: 5
            rightMargin: 5
            bottomMargin: Detector.isSpecialTypeDevice() && !screenState ? Detector.bottomNavigationBarHeight() : 15
        }

        Label {
            id: label
            anchors {
                top: parent.top
                left: parent.left
                right: parent.right
                leftMargin: 10
                rightMargin: 10
            }
            horizontalAlignment: Label.AlignHCenter
            color: "#ce2121"
            wrapMode: Label.WordWrap
            text: qsTr("Your wallet is created! Your mnemonic phrase is the only way to restore " +
                       "your wallet!\nCopy and store in the safe place this mnemonic password.")
        }

        Label {
            id: mnemonicPhraseView
            font {
                wordSpacing: 25
                pixelSize: 16
            }
            anchors {
                verticalCenterOffset: Detector.isMobile() ? -11 : -20
                verticalCenter: parent.verticalCenter
                left: parent.left
                right: parent.right
                leftMargin: 25
                rightMargin: 25
            }
            lineHeight: mnemonicScreen.width < 340 ? 23 : 40
            lineHeightMode: Label.FixedHeight
            horizontalAlignment: Label.AlignHCenter
            wrapMode: Label.WordWrap
            text: GraftClient.getSeed()
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
                leftMargin: 10
                rightMargin: 10
            }
            text: qsTr("Copy to clipboard")
            onClicked: {
                GraftClientTools.copyToClipboard(GraftClient.getSeed())
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
                leftMargin: 10
                rightMargin: 10
            }
            text: qsTr("I saved it!")
            onClicked: {
                disableScreen()
                save()
            }
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
                    isNavigationButtonVisible: false
                    navigationButtonState: true
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
