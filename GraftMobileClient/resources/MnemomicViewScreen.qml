import QtQuick 2.9
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.2
import "components"

BaseScreen {
    id: root

    property bool screenState: true

    state: screenState ? "overviewWallet" : "createWallet"

    Item {
        anchors {
            fill: parent
            topMargin: 15
            leftMargin: 10
            rightMargin: 10
            bottomMargin: 15
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
            text: qsTr("Your wallet is created! Save and place in save this mnemonic password")
        }

        MnemonicPhraseView {
            id: mnemonicPhraseView
            anchors {
                verticalCenterOffset: screenState ? -30 : -20
                verticalCenter: parent.verticalCenter
                left: parent.left
                right: parent.right
            }
            mnemonicPhrase: GraftClient.getSeed()
        }

        WideActionButton {
            id: copyMnemonicButton
            anchors {
                left: parent.left
                right: parent.right
                bottom: saveButton.top
                bottomMargin: 15
            }
            text: qsTr("Copy to clipboard")
            onClicked: GraftClient.copyToClipboard(GraftClient.getSeed())
        }

        WideActionButton {
            id: saveButton
            anchors {
                left: parent.left
                right: parent.right
                bottom: parent.bottom
            }
            text: qsTr("I Save It!")
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
                target: root
                title: qsTr("Mnemonic phrase")
                action: save
                screenHeader {
                    navigationButtonState: Qt.platform.os !== "android"
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
