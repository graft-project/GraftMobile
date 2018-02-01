import QtQuick 2.9
import QtQuick.Layouts 1.3

ColumnLayout {
    property bool passwordMode: false
    property bool wrongFieldColor: false
    property bool visibilityIcon: false
    property bool letterCountingMode: true
    property int maximumLength: 32767

    spacing: 0
}
