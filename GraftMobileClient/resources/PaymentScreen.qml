import QtQuick 2.9
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.2
import QtQuick.Controls.Material 2.2
import com.graft.design 1.0
import "components"

BaseScreen {
    id: root

    property bool isSpacing: false
    property int screenState: 0

    Component.onCompleted: {
        if (screenState)
        {
            root.state = "successfulPaid"
        } else {
            root.state = "failPaid"
        }
    }

    screenHeader {
        navigationButtonState: Qt.platform.os === "android"
        actionButtonState: true
    }
    action: pushScreen

    Rectangle {
        anchors.fill: parent
        color: Qt.platform.os === "ios" ? "#FFFFFF" : "#E9E9E9"

        Item {
            anchors {
                top: parent.top
                bottom: completeLabel.top
                left: parent.left
                right: parent.right
            }

            Image {
                id: image
                anchors.centerIn: parent
                height: 200
                width: height
                fillMode: Image.PreserveAspectFit
                source: "qrc:/imgs/paid_icon.png"
            }
        }

        Pane {
            id: completeLabel

            height: 50
            anchors {
                right: parent.right
                left: parent.left
                bottom: button.top
                bottomMargin: addBottomMargin()
            }
            Material.elevation: Qt.platform.os === "android" ? 6 : 0
            padding: 0

            contentItem: Rectangle {
                id: completeLabelBackground
                color: ColorFactory.color(DesignFactory.CircleBackground)

                Text {
                    id: completeLabelText
                    anchors.centerIn: parent
                    color: "#FFFFFF"
                }
            }
        }

        WideActionButton {
            id: button
            anchors {
                left: parent.left
                right: parent.right
                bottom: parent.bottom
                leftMargin: 15
                rightMargin:15
                bottomMargin: 15
            }
            text: qsTr("DONE")
            onClicked: pushScreen()
        }
    }

    states: [
        State {
            name: "successfulPaid"

            PropertyChanges {
                target: image
                source: "qrc:/imgs/paid_icon.png"
            }
            PropertyChanges {
                target: completeLabelBackground
                color: "#FE4200"
            }
            PropertyChanges {
                target: completeLabelText
                text: Qt.platform.os === "ios" ? qsTr("Paid complete!") : qsTr("Checkout complete!")
            }
            PropertyChanges {
                target: button
                text: qsTr("DONE")
            }
        },
        State {
            name: "failPaid"

            PropertyChanges {
                target: root

                specialBackMode: pushScreen
                screenHeader {
                    navigationButtonState: Qt.platform.os !== "android"
                    actionButtonState: false
                }
            }
            PropertyChanges {
                target: image
                source: "qrc:/imgs/Error.png"
            }
            PropertyChanges {
                target: completeLabelBackground
                color: "#FE4200"
            }
            PropertyChanges {
                target: completeLabelText
                text: qsTr("Something getting wrong")
            }
            PropertyChanges {
                target: button
                text: qsTr("BACK")
            }
        }
    ]

    function addBottomMargin() {
        var addBottomMargin = 0;
        if (isSpacing === true) {
            return addBottomMargin = Qt.platform.os === "android" ? 15 : button.height + 15
        } else {
            return addBottomMargin = 15
        }
    }
}
