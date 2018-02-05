import QtQuick 2.9
import QtQuick.Layouts 1.3
import com.device.platform 1.0
import "components"

ColumnLayout {
    property alias passwordText: passwordField.text
    property alias confirmPasswordText: confirmPasswordField.text
    property bool wrongPassword: false

    spacing: 0

    LinearEditItem {
        id: passwordField
        maximumLength: 50
        title: Detector.isPlatform(Platform.Android) ? qsTr("Password") : qsTr("Password:")
        passwordMode: true
        onTextChanged: comparePassword(passwordField.text, confirmPasswordField.text)
    }

    LinearEditItem {
        id: confirmPasswordField
        maximumLength: 50
        title: Detector.isPlatform(Platform.Android) ? qsTr("Confirm password") : qsTr("Confirm password:")
        passwordMode: true
        onTextChanged: comparePassword(passwordField.text, confirmPasswordField.text)
    }

    function comparePassword(password, confirmPassword) {
        var unequal = false
        if (password !== confirmPassword) {
            confirmPasswordField.attentionText = qsTr("Your passwords don't match!")
            unequal = true
        } else {
            confirmPasswordField.attentionText = confirmPasswordField.text.length === 0 ?
                        qsTr("") : qsTr("Your passwords are the same!")
        }
        wrongPassword = unequal
        confirmPasswordField.wrongFieldColor = unequal
        return unequal
    }
}
