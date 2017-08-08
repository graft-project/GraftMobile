import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3
import QtQuick.Controls.Styles 1.4
import "../"

Item {
    id: paymentConfirmationView

    ColumnLayout {
        id: column

        spacing: 100

        anchors {
            left: parent.left
            right: parent.right
            top: parent.top
            topMargin: 50
            leftMargin: 30
            rightMargin: 30
        }

        TotalView {
            setTextField2: 20
            setTextField4: 20
        }

        ComboBox {
            id: graftCBox
            Layout.preferredWidth: parent.width
            model: ["Graft", "Second", "Third"]
        }

        Rectangle {
            id: confirmButton

            height: 25
            width: 200

            color: "grey"
            radius: 8

            Layout.fillWidth: true

            Layout.leftMargin: 30
            Layout.rightMargin: 30

            Text {
                font.capitalization: Font.MixedCase
                anchors.centerIn: parent
                text: "Confirm"
                font.pointSize: 18
            }
        }
    }
}
