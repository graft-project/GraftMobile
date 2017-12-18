import QtQuick 2.9
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.2

GridLayout {
    id: gridLayout

    property string bigString: ""
    property int textSize: 20
    property int textAlignment: 0x0004
    readonly property int mnemonicPhraseSize: 25

    anchors {
        centerIn: parent
        left: parent.left
        right: parent.right
        leftMargin: 5
        rightMargin: 5
    }
    columns: 5
    rows: 5
    columnSpacing: 8
    rowSpacing: 35

    Component.onCompleted: {
        var splitBigString = bigString.split(' ', mnemonicPhraseSize)
        for (var i = 0; i < mnemonicPhraseSize; i++)
        {
            gridLayout.children[i].text = splitBigString[i]
        }
    }

    Label { font.pointSize: textSize; Layout.alignment: textAlignment; }
    Label { font.pointSize: textSize; Layout.alignment: textAlignment; }
    Label { font.pointSize: textSize; Layout.alignment: textAlignment; }
    Label { font.pointSize: textSize; Layout.alignment: textAlignment; }
    Label { font.pointSize: textSize; Layout.alignment: textAlignment; }
    Label { font.pointSize: textSize; Layout.alignment: textAlignment; }
    Label { font.pointSize: textSize; Layout.alignment: textAlignment; }
    Label { font.pointSize: textSize; Layout.alignment: textAlignment; }
    Label { font.pointSize: textSize; Layout.alignment: textAlignment; }
    Label { font.pointSize: textSize; Layout.alignment: textAlignment; }
    Label { font.pointSize: textSize; Layout.alignment: textAlignment; }
    Label { font.pointSize: textSize; Layout.alignment: textAlignment; }
    Label { font.pointSize: textSize; Layout.alignment: textAlignment; }
    Label { font.pointSize: textSize; Layout.alignment: textAlignment; }
    Label { font.pointSize: textSize; Layout.alignment: textAlignment; }
    Label { font.pointSize: textSize; Layout.alignment: textAlignment; }
    Label { font.pointSize: textSize; Layout.alignment: textAlignment; }
    Label { font.pointSize: textSize; Layout.alignment: textAlignment; }
    Label { font.pointSize: textSize; Layout.alignment: textAlignment; }
    Label { font.pointSize: textSize; Layout.alignment: textAlignment; }
    Label { font.pointSize: textSize; Layout.alignment: textAlignment; }
    Label { font.pointSize: textSize; Layout.alignment: textAlignment; }
    Label { font.pointSize: textSize; Layout.alignment: textAlignment; }
    Label { font.pointSize: textSize; Layout.alignment: textAlignment; }
    Label { font.pointSize: textSize; Layout.alignment: textAlignment; }
}
