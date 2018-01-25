import QtQuick 2.9
import QtQuick.Layouts 1.3
import "components"

ColumnLayout {
    property alias passwordText: password.text
    property alias confirmPasswordText: confirmPassword.text

    spacing: 0

    LinearEditItem {
        id: password
        maximumLength: 50
        title: Qt.platform.os === "android" ? qsTr("Password") : qsTr("Password:")
        echoMode: passMode ? TextInput.Password : TextInput.Normal
        passwordCharacter: '•'
        passMode: true
        visibilityIcon: true
        onTextChanged: comparePassword(password.text, confirmPassword.text)
    }

    LinearEditItem {
        id: confirmPassword
        maximumLength: 50
        title: Qt.platform.os === "android" ? qsTr("Confirm password") : qsTr("Confirm password:")
        echoMode: passMode ? TextInput.Password : TextInput.Normal
        passwordCharacter: '•'
        passMode: true
        visibilityIcon: true
        onTextChanged: comparePassword(password.text, confirmPassword.text)
    }

    function comparePassword(pass, confirmPass) {
        var compare = false
        if (pass !== confirmPass) {
            compare = true
        }
        confirmPassword.confirmPass = compare
        return compare
    }
}
