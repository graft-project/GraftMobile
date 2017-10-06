import QtQuick 2.9
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.2

Button {
    padding: 0
    contentItem: Rectangle {
        color: "#FFFFFF"

        RowLayout {
            height: parent.height
            spacing: 10

            Image {
                Layout.preferredHeight: 46
                Layout.preferredWidth: 46
                Layout.leftMargin: 16
                source: "qrc:/imgs/add.png"
            }

            Text {
                Layout.alignment: Text.AlignLeft
                text: qsTr("Add new product")
            }
        }
    }
}
