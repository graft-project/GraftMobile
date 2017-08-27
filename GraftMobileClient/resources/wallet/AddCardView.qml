import QtQuick 2.9
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.2
import QtQuick.Controls.Material 2.2
import "../"
import "../components"

BaseScreen {
    id: root
    title: qsTr("Add Card")

    ColumnLayout {
        anchors {
            top: parent.top
            right: parent.right
            left: parent.left
            margins: 25
        }
        spacing: 20

        Item {
            Layout.fillWidth: true
            Layout.preferredHeight: 100

            Image {
                id: graftWalletLogo
                anchors {
                    bottom: parent.bottom
                    horizontalCenter: parent.horizontalCenter
                }
                width: parent.width / 2
                fillMode: Image.PreserveAspectFit
                source: "qrc:/imgs/card_icon.png"
            }
        }

        ColumnLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true
            spacing: 20

            TextField {
                id: cardNumber
                Layout.fillWidth: true
                placeholderText: qsTr("Card Number:")
                inputMethodHints: Qt.ImhDigitsOnly
                validator: RegExpValidator {
                    regExp: /(5\d{15}|4\d{15}|30\d{14})/
                }
            }

            ColumnLayout {
                Layout.fillWidth: true
                Layout.fillHeight: true
                spacing: 0

                Text {
                    Layout.fillWidth: true
                    text: qsTr("Expiration Date:")
                    color: "#707070"
                    font {
                        family: "Liberation Sans"
                        pointSize: 14
                    }
                }

                RowLayout {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 30
                    ComboBox {
                        id: month
                        Layout.fillWidth: true
                        contentItem.enabled: false
                        font.pointSize: 14
                        Material.background: "transparent"
                        Material.foreground: "#707070"
                        model: setMonth()

                        function setMonth() {
                            var lMonth = new Array
                            for (var i = 0; i < 12; i++) {
                                if (i < 9) {
                                    var zero = "0"
                                    zero += (i + 1)
                                    lMonth[i] = zero
                                } else {
                                    lMonth[i] = (i + 1)
                                }
                            }
                            return lMonth
                        }
                    }

                    ComboBox {
                        id: years
                        Layout.fillWidth: true
                        contentItem.enabled: false
                        font.pointSize: 14
                        Material.background: "transparent"
                        Material.foreground: "#707070"
                        model: setYear()

                        function setYear() {
                            var currentYear = new Date
                            currentYear = (currentYear.getFullYear() - 5)
                            var lYear = new Array
                            for (var i = 0; i <= 10; i++) {
                                lYear[i] = currentYear++
                            }
                            return lYear
                        }
                    }
                }
            }

            TextField {
                id: cv2Code
                Layout.fillWidth: true
                placeholderText: qsTr("CV2 Code:")
                inputMethodHints: Qt.ImhDigitsOnly
                validator: RegExpValidator {
                    regExp: /\d{3}/
                }
            }
        }

        Item {
            Layout.fillWidth: true
            Layout.preferredHeight: 75
            Image {
                width: parent.width / 1.5
                fillMode: Image.PreserveAspectFit
                anchors.horizontalCenter: parent.horizontalCenter
                source: "qrc:/imgs/visa-master-card-american-express-logo.png"
            }
        }

        WideRoundButton {
            id: confirmButton
            Layout.fillWidth: true
            text: qsTr("Confirm")
            onClicked: {
                Qt.quit()
            }
        }
    }
}
