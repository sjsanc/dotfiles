import QtQuick

Rectangle {
    id: clockIsland
    height: parent.height
    color: "#212121"
    radius: 10
    implicitWidth: clockLabel.implicitWidth + 24

    property string clockText: Qt.formatDateTime(new Date(), "HH:mm")

    Timer {
        interval: 30000
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: { clockIsland.clockText = Qt.formatDateTime(new Date(), "HH:mm") }
    }

    Text {
        id: clockLabel
        anchors.centerIn: parent
        text: clockIsland.clockText
        color: "white"
        font.family: "FiraCode Nerd Font"
        font.pixelSize: 16
        font.weight: Font.DemiBold
    }
}
