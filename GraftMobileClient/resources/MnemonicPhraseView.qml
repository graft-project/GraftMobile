import QtQuick 2.9
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.2
import com.device.platform 1.0

GridLayout {
    id: gridLayout

    property string mnemonicPhrase: ""
    readonly property int mnemonicPhraseSize: 25

    anchors {
        verticalCenter: parent.verticalCenter
        leftMargin: 0
        rightMargin: 0
    }
    columns: 5
    rows: 5
    columnSpacing: 5
    rowSpacing: Detector.detectDevice() === Platform.IPhoneSE ? 25 : 45

    Repeater {
        id: repeater
        model: mnemonicPhrase.split(' ', mnemonicPhraseSize)

        Label {
            font.pixelSize: 14
            Layout.alignment: Qt.AlignHCenter
            text: modelData
        }
    }
}
