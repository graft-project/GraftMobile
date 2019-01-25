import QtQuick 2.9
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.2
import com.device.platform 1.0

GridLayout {
    id: gridLayout

    property string mnemonicPhrase: ""
    readonly property int mnemonicPhraseSize: 25
    property real screenWidth: 0

    columns: 3//screenWidth > 420 ? 5 : 4 // Use the 3 colums
    rows: 5
    columnSpacing: 5
    rowSpacing: 5 //Detector.detectDevice() === Platform.IPhoneSE ? 25 : 45 ---Old version to use

    Repeater {
        id: repeater
        model: mnemonicPhrase.split(' ', mnemonicPhraseSize)

        Label {
            id: labelText
            font.pixelSize: 14
            Layout.fillWidth: true
            Layout.minimumWidth: 80
            horizontalAlignment: Qt.AlignHCenter
            Layout.alignment: Label.AlignHCenter
            Layout.columnSpan: (index === 24 && gridLayout.columns === 3) ? 3 : 1 //For 3
            Layout.columnSpan: (index === 24 && gridLayout.columns === 4) ? 4 : 1 //For 4
            text: modelData
        }
    }
}
