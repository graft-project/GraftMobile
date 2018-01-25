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
        passMode: true
        onTextChanged: comparePassword(password.text, confirmPassword.text)
    }

    LinearEditItem {
        id: confirmPassword
        maximumLength: 50
        title: Qt.platform.os === "android" ? qsTr("Confirm password") : qsTr("Confirm password:")
        passMode: true
        matchPassText.text: qsTr("")
        onTextChanged: comparePassword(password.text, confirmPassword.text)
    }

    function comparePassword(pass, confirmPass) {
        var compare = false
        if (pass !== confirmPass) {
            confirmPassword.matchPassText.text = qsTr("Your passwords don't match!")
            confirmPassword.matchPassText.color = "#f33939"
            compare = true
        } else {
            confirmPassword.matchPassText.text = qsTr("Your passwords are the same!")
            confirmPassword.matchPassText.color = "#3F3F3F"
        }
        confirmPassword.confirmPass = compare
        return compare
    }
}
