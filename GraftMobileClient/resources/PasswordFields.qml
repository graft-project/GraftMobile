import QtQuick 2.9
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.2
import QtQuick.Controls.Material 2.2
import "components"

ColumnLayout {
    property bool visibilityPass: true

    spacing: 0

    LinearEditItem {
        id: passwordTextField
        Layout.alignment: Qt.AlignLeft
        Layout.topMargin: 10
        maximumLength: 50
        title: Qt.platform.os === "android" ? qsTr("Password") : qsTr("Password:")
        echoMode: visibilityPass ? TextInput.Normal : TextInput.Password
        passwordCharacter: '•'

        //        RoundButton {
        //            id: visibilityButton
        //            radius: 100
        //            highlighted: true
        //            Material.elevation: 0
        //            Material.accent: visibilityPass ? "#2034435b" : "transparent"
        //            anchors {
        //                right: parent.right
        //                top: parent.top
        //                topMargin:  -5
        //            }
        //            background {
        //                x: 0
        //                y: 0
        //                width: background.parent.width
        //                height: background.parent.height
        //            }

        //            Image {
        //                anchors.centerIn: parent
        //                fillMode: Image.PreserveAspectFit
        //                height: parent.height / 2
        //                width: parent.width / 2
        //                source: visibilityPass ? "qrc:/imgs/visibility_on.png" : "qrc:/imgs/visibility_off.png"
        //            }

        //            onClicked: {
        //                ddd.start()
        //                visibilityPass =!visibilityPass
        //            }

        //            SequentialAnimation on Material.accent {
        //                id: ddd
        //                running: false

        //                ColorAnimation {
        //                    from: "transparent"
        //                    to: "#2034435b"
        //                    duration: 1000
        //                }

        //                ColorAnimation {
        //                    to: "transparent"
        //                    duration: 0
        //                }
        //            }
        //        }
    }
    CheckBox {
        id: control
        anchors {
            right: parent.right
            top: parent.top
        }
        checked: true
        indicator.width: 1
        indicator.height: 1

        Image {
//            height: 30
//            width: 30
            anchors {
                fill: parent
                bottomMargin: 2
                leftMargin: 2
            }
            fillMode: Image.PreserveAspectFit
            source: control.checked ? "qrc:/imgs/visibility_off.png" : "qrc:/imgs/visibility_on.png"
        }
    }

//    RadioButton {
//        id: control
//        anchors {
//            right: parent.right
//            top: parent.top
//            margins: 15
//        }
////        checked: true
//        indicator.width: 0.5
//        indicator.height: 0.5

//        Image {
//            anchors {
//                fill: parent
//                margins: -2
//            }
//            fillMode: Image.PreserveAspectFit
//            source: control.checked ? "qrc:/imgs/visibility_off.png" : "qrc:/imgs/visibility_on.png"
//        }
//    }
}
