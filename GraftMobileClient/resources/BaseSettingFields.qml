import QtQuick 2.9
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.2
import QtQuick.Controls.Material 2.2
import com.graft.design 1.0
import com.device.platform 1.0
import "components"

ColumnLayout {
    property alias displayCompanyName: companyNameTextField.visible
    property alias companyTitle: companyNameTextField.title
    property alias addressTitle: addressTextField.title
    property alias portTitle: portTextField.title
    property alias ipTitle: ipTextField.title

    property alias companyNameText: companyNameTextField.text
    property alias serviceURLSwitch: serviceURLSwitch.checked
    property alias addressText: addressTextField.text
    property alias serviceAddr: serviceAddr.checked
    property alias httpsSwitch: httpsSwitch.checked
    property alias portText: portTextField.text
    property alias ipText: ipTextField.text

    spacing: 0
    anchors.fill: parent

    LinearEditItem {
        id: companyNameTextField
        maximumLength: 50
        Layout.alignment: Qt.AlignTop
        text: GraftClient.settings("companyName") ? GraftClient.settings("companyName") : ""
    }

    ColumnLayout {
        Layout.topMargin: Detector.isPlatform(Platform.IOS | Platform.Desktop) ? 9 : 0
        Layout.fillWidth: true
        spacing: 2

        Label {
            text: qsTr("Service")
            font.pixelSize: Detector.isPlatform(Platform.IOS | Platform.Desktop) ?
                                16 : switchLabel.font.pixelSize
            color: "#8e8e93"
        }

        RowLayout {
            spacing: 0

            Label {
                Layout.fillWidth: true
                Layout.alignment: Label.AlignLeft | Label.AlignVCenter
                text: qsTr("Enable HTTPS")
            }

            Switch {
                id: httpsSwitch
                Layout.topMargin: 5
                checked: GraftClient.httpsType()
                Material.accent: ColorFactory.color(DesignFactory.Foreground)
                onCheckedChanged: {
                    replaceNetworkType(addressTextField.text)
                    if (serviceAddr.checked) {
                        addressFieldFocus()
                    } else if (serviceURLSwitch.checked) {
                        urlFieldFocus()
                    }
                }
            }
        }

        RowLayout {
            spacing: 0

            Label {
                id: switchLabel
                Layout.fillWidth: true
                Layout.alignment: Label.AlignLeft | Label.AlignVCenter
                text: qsTr("Use own service address")
            }

            Switch {
                id: serviceAddr
                Material.accent: ColorFactory.color(DesignFactory.Foreground)
                checked: GraftClient.useOwnServiceAddress()
                onCheckedChanged: {
                    if (serviceAddr.checked) {
                        serviceURLSwitch.checked = false
                        addressFieldFocus()
                    }
                }
            }
        }

        RowLayout {
            id: serviceAddrLayout
            enabled: serviceAddr.checked
            anchors {
                right: parent.right
                left: parent.left
            }
            spacing: 20
            state: "hidden"
            states: [
                State {
                    name: "hidden"
                    when: !serviceAddr.checked
                    PropertyChanges {
                        target: serviceAddrLayout
                        visible: false
                        opacity: 0
                    }
                }
            ]
            transitions: Transition {
                PropertyAnimation {
                    property: "opacity"
                    duration: 800
                }
            }

            LinearEditItem {
                id: ipTextField
                inputMask: "000.000.000.000; "
                inputMethodHints: Qt.ImhDigitsOnly
                showLengthIndicator: false
                Layout.preferredWidth: 130
                fieldCursorPosition: 0
                text: GraftClient.useOwnServiceAddress() ? GraftClient.settings("ip") : ""
            }

            LinearEditItem {
                id: portTextField
                inputMethodHints: Qt.ImhDigitsOnly
                showLengthIndicator: false
                Layout.preferredWidth: 100
                text: GraftClient.useOwnServiceAddress() ? GraftClient.settings("port") : ""
                validator: RegExpValidator {
                    regExp: /\d{1,5}/
                }
            }
        }

        RowLayout {
            spacing: 0

            Label {
                id: serviceURLLabel
                Layout.fillWidth: true
                Layout.alignment: Label.AlignLeft | Label.AlignVCenter
                text: qsTr("Use own service URL")
            }

            Switch {
                id: serviceURLSwitch
                Material.accent: ColorFactory.color(DesignFactory.Foreground)
                checked: GraftClient.useOwnUrlAddress()
                onCheckedChanged: {
                    replaceNetworkType(addressTextField.text)
                    if (serviceURLSwitch.checked) {
                        serviceAddr.checked = false
                        urlFieldFocus()
                    }
                }
            }
        }

        LinearEditItem {
            id: addressTextField
            enabled: serviceURLSwitch.checked
            inputMethodHints: Qt.ImhHiddenText
            Layout.alignment: Qt.AlignTop
            text: GraftClient.useOwnUrlAddress() ? GraftClient.settings("address") : "http://"
            showLengthIndicator: false
            fieldCursorPosition: httpsSwitch.checked ? 8 : 7
            onUpdateText: replaceNetworkType(addressTextField.text)
            state: "hidden"
            states: [
                State {
                    name: "hidden"
                    when: !serviceURLSwitch.checked
                    PropertyChanges {
                        target: addressTextField
                        visible: false
                        opacity: 0
                    }
                }
            ]
            transitions: Transition {
                PropertyAnimation {
                    property: "opacity"
                    duration: 800
                }
            }
        }
    }

    function replaceNetworkType(text) {
        var regExp = text.match(new RegExp(/^https?:\/\//g))
        if (regExp !== null) {
            if (regExp.toString() === "https://" && !httpsSwitch.checked) {
                addressTextField.text = text.replace(/https/i, "http")
            } else if (regExp.toString() === "http://" && httpsSwitch.checked) {
                addressTextField.text = text.replace(/http/i, "https")
            }
        } else {
            addressTextField.text = !httpsSwitch.checked ? "http://" : "https://"
        }
    }

    function addressFieldFocus() {
        if (ipTextField.text.length === 3) {
            ipTextField.inFocus = serviceAddr.checked
        } else if (portTextField.text.length === 0) {
            portTextField.inFocus = serviceAddr.checked
        } else {
            ipTextField.inFocus = false
            portTextField.inFocus = false
        }
    }

    function urlFieldFocus() {
        if (httpsSwitch.checked) {
            addressTextField.inFocus = addressTextField.text.length < 9 ?
                        serviceURLSwitch.checked : false
        } else {
            addressTextField.inFocus = addressTextField.text.length < 8 ?
                        serviceURLSwitch.checked : false
        }
    }

    function clearField() {
        ipTextField.actionTextField.clear()
        portTextField.actionTextField.clear()
        addressTextField.actionTextField.clear()
        companyNameTextField.actionTextField.clear()
    }

    function length() {
        return companyNameTextField.text.length
    }

    function updateSettings() {
        httpsSwitch.checked = GraftClient.httpsType()
        serviceURLSwitch.checked = GraftClient.useOwnUrlAddress()
        serviceAddr.checked =GraftClient.useOwnServiceAddress()
        if (GraftClient.useOwnServiceAddress()) {
            ipTextField.text = GraftClient.settings("ip")
            portTextField.text = GraftClient.settings("port")
        }
        if (GraftClient.useOwnUrlAddress()) {
            addressTextField.text = GraftClient.settings("address")
        }
    }
}
