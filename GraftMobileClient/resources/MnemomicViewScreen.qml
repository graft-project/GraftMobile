import QtQuick 2.9
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.2
import "components"

BaseScreen {
    id: root

    property bool screenState: true

    Component.onCompleted: {
        if (screenState)
        {
            root.state = "overviewWallet"
        } else {
            root.state = "createWallet"
        }
    }

    ColumnLayout {
        anchors {
            fill: parent
            leftMargin: 10
            rightMargin: 10
        }

        ColumnLayout {
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignTop
            Layout.topMargin: 10
            spacing: 100

            Label {
                id: label
                Layout.fillWidth: true
                Layout.alignment: Qt.AlignTop
                horizontalAlignment: Label.AlignHCenter
                color: "#BBBBBB"
                wrapMode: Label.WordWrap
                text: qsTr("You wallet created! Save and place in save this mnemonic password")
            }

            MnemonicPhraseView {
                id: mnemonicPhraseView
                Layout.fillWidth: true
            }
        }

        WideActionButton {
            id: saveButton
            Layout.alignment: Qt.AlignBottom
            Layout.bottomMargin: 15
            text: qsTr("I Save It!")
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
                action: pushScreen
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
                action: pushScreen
                screenHeader {
                    navigationButtonState: Qt.platform.os !== "android"
                    actionButtonState: true
                }
            }
        }
    ]
}
