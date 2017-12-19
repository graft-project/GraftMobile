import QtQuick 2.9
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.2

GridLayout {
    id: gridLayout

    property string mnemonicPhrase: ""
    readonly property int mnemonicPhraseSize: 25

    anchors {
        verticalCenter: parent.verticalCenter
        leftMargin: 5
        rightMargin: 5
    }
    columns: 5
    rows: 5
    columnSpacing: 5
    rowSpacing: 35

    Repeater {
        id: repeater
        model: mnemonicPhrase.split(' ', mnemonicPhraseSize)

        Label {
            font.pointSize: 15
            Layout.alignment: Qt.AlignHCenter
            text: modelData
        }
    }
}
