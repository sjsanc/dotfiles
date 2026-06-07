import QtQuick
import Quickshell.Hyprland

Rectangle {
    height: parent.height
    color: "#212121"
    radius: 10
    implicitWidth: wsRow.implicitWidth + 8

    Row {
        id: wsRow
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: parent.left
        anchors.leftMargin: 4
        spacing: 0

        Repeater {
            model: 10

            delegate: Rectangle {
                required property int index
                readonly property int wsId: index + 1
                readonly property bool isFocused: Hyprland.focusedWorkspace !== null
                    && Hyprland.focusedWorkspace.id === wsId

                width: 32
                height: 32
                radius: 6
                color: wsHover.containsMouse ? "#595450" : "transparent"

                Text {
                    anchors.centerIn: parent
                    text: parent.wsId
                    color: parent.isFocused ? "white" : "#585858"
                    font.family: "FiraCode Nerd Font"
                    font.pixelSize: 16
                    font.weight: Font.DemiBold
                }

                MouseArea {
                    id: wsHover
                    anchors.fill: parent
                    hoverEnabled: true
                    onClicked: Hyprland.dispatch("workspace " + parent.wsId)
                }
            }
        }
    }
}
