import QtQuick 2.9
import QtQuick.Layouts 1.3
import "components"

ColumnLayout {
    property alias passwordText: passwordField.text
    property alias confirmPasswordText: confirmPasswordField.text

    spacing: 0

    LinearEditItem {
        id: passwordField
        maximumLength: 50
        title: Qt.platform.os === "android" ? qsTr("Password") : qsTr("Password:")
        passwordMode: true
        onTextChanged: comparePassword(passwordField.text, confirmPasswordField.text)
    }

    LinearEditItem {
        id: confirmPasswordField
        maximumLength: 50
        title: Qt.platform.os === "android" ? qsTr("Confirm password") : qsTr("Confirm password:")
        passwordMode: true
        onTextChanged: comparePassword(passwordField.text, confirmPasswordField.text)
    }

    function comparePassword(password, confirmPassword) {
        var unequal = false
        confirmPasswordField.attentionText = password !== confirmPassword ?
                    qsTr("Your passwords don't match!") : confirmPasswordField.text.length === 0 ?
                    qsTr("") : qsTr("Your passwords are the same!")
        unequal = password !== confirmPassword
        confirmPasswordField.wrongFieldColor = unequal
        return unequal
    }
}
