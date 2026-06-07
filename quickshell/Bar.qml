import QtQuick
import Quickshell

PanelWindow {
    id: bar
    required property var modelData

    screen: modelData

    anchors {
        top: true
        left: true
        right: true
    }

    margins {
        top: 5
        left: 5
        right: 5
    }

    implicitHeight: 40
    color: "transparent"

    Item {
        anchors.fill: parent

        Row {
            anchors {
                left: parent.left
                top: parent.top
                bottom: parent.bottom
            }
            spacing: 5

            WorkspacesIsland {}
            UpdatesIsland { id: updatesIsland }
        }

        Row {
            anchors.centerIn: parent
            height: parent.height
            spacing: 5

            SpotifyIsland {}
            VolumeIsland { id: volIsland }
        }

        Row {
            anchors {
                right: parent.right
                top: parent.top
                bottom: parent.bottom
            }
            spacing: 5

            SysIsland {}
            ConnIsland { id: connIsland }
            ClockIsland {}
            PowerIsland { id: powerIsland }
        }
    }

    PopupWindow {
        anchor.window: bar
        anchor.item: volIsland
        anchor.edges: Edges.Top
        anchor.gravity: Edges.Top
        visible: volIsland.hovered
        color: "transparent"
        width: 150
        height: 56

        Rectangle {
            anchors { fill: parent; bottomMargin: 10 }
            color: "#212121"
            radius: 10

            Text {
                anchors.centerIn: parent
                text: "Volume: " + Math.round(volIsland.vol * 100) + "%"
                color: "white"
                font.family: "FiraCode Nerd Font"
                font.pixelSize: 14
                font.weight: Font.DemiBold
            }
        }
    }

    PopupWindow {
        anchor.window: bar
        anchor.item: connIsland.netAnchorItem
        anchor.edges: Edges.Bottom
        anchor.gravity: Edges.Bottom
        visible: connIsland.netPopupVisible && connIsland.netState !== "disconnected"
        color: "transparent"
        width: 210
        height: 66

        Rectangle {
            anchors { fill: parent; topMargin: 10 }
            color: "#212121"
            radius: 10

            Column {
                anchors {
                    left: parent.left
                    leftMargin: 12
                    verticalCenter: parent.verticalCenter
                }
                spacing: 4

                Text {
                    text: connIsland.netInfo1 !== "" ? connIsland.netInfo1 : "…"
                    color: "white"
                    font.family: "FiraCode Nerd Font"
                    font.pixelSize: 14
                    font.weight: Font.DemiBold
                    width: 186
                    elide: Text.ElideRight
                }

                Text {
                    visible: connIsland.netInfo2 !== ""
                    text: connIsland.netInfo2
                    color: "#585858"
                    font.family: "FiraCode Nerd Font"
                    font.pixelSize: 14
                }
            }
        }
    }

    PopupWindow {
        anchor.window: bar
        anchor.item: connIsland.btAnchorItem
        anchor.edges: Edges.Bottom
        anchor.gravity: Edges.Bottom
        visible: connIsland.btPopupVisible && connIsland.btState !== "off"
        color: "transparent"
        width: 210
        height: btPopupRect.height + 10

        Rectangle {
            id: btPopupRect
            y: 10
            width: parent.width
            height: btPopupCol.implicitHeight + 16
            color: "#212121"
            radius: 10

            Column {
                id: btPopupCol
                anchors {
                    left: parent.left
                    leftMargin: 12
                    top: parent.top
                    topMargin: 8
                }
                spacing: 4

                Text {
                    visible: connIsland.btState === "on"
                    text: "No devices connected"
                    color: "#585858"
                    font.family: "FiraCode Nerd Font"
                    font.pixelSize: 14
                }

                Repeater {
                    model: connIsland.btDevices
                    Text {
                        required property string modelData
                        text: modelData
                        color: "white"
                        font.family: "FiraCode Nerd Font"
                        font.pixelSize: 14
                        font.weight: Font.DemiBold
                        width: 186
                        elide: Text.ElideRight
                    }
                }
            }
        }
    }

    PopupWindow {
        anchor.window: bar
        anchor.item: powerIsland
        anchor.edges: Edges.Bottom
        anchor.gravity: Edges.Bottom
        visible: powerIsland.popupVisible
        color: "transparent"
        width: 140
        height: powerPopupRect.height + 10

        Rectangle {
            id: powerPopupRect
            y: 10
            width: parent.width
            height: powerPopupCol.implicitHeight + 16
            color: "#212121"
            radius: 10

            Column {
                id: powerPopupCol
                anchors {
                    left: parent.left
                    leftMargin: 8
                    right: parent.right
                    rightMargin: 8
                    top: parent.top
                    topMargin: 8
                }
                spacing: 4

                Rectangle {
                    width: parent.width
                    height: 32
                    radius: 6
                    color: suspendHover.hovered ? "#595450" : "transparent"

                    Behavior on color { ColorAnimation { duration: 80 } }

                    Row {
                        anchors { left: parent.left; leftMargin: 8; verticalCenter: parent.verticalCenter }
                        spacing: 8
                        Text {
                            text: "󰤄"
                            color: "#60a5fa"
                            font.family: "FiraCode Nerd Font"
                            font.pixelSize: 15
                            anchors.verticalCenter: parent.verticalCenter
                        }
                        Text {
                            text: "Suspend"
                            color: "white"
                            font.family: "FiraCode Nerd Font"
                            font.pixelSize: 14
                            font.weight: Font.DemiBold
                            anchors.verticalCenter: parent.verticalCenter
                        }
                    }

                    HoverHandler { id: suspendHover }
                    TapHandler {
                        onTapped: {
                            powerIsland.popupVisible = false
                            powerIsland.doSuspend()
                        }
                    }
                }

                Rectangle {
                    width: parent.width
                    height: 32
                    radius: 6
                    color: shutdownHover.hovered ? "#7f1d1d" : "transparent"

                    Behavior on color { ColorAnimation { duration: 80 } }

                    Row {
                        anchors { left: parent.left; leftMargin: 8; verticalCenter: parent.verticalCenter }
                        spacing: 8
                        Text {
                            text: "󰐥"
                            color: "#f87171"
                            font.family: "FiraCode Nerd Font"
                            font.pixelSize: 15
                            anchors.verticalCenter: parent.verticalCenter
                        }
                        Text {
                            text: "Shutdown"
                            color: "white"
                            font.family: "FiraCode Nerd Font"
                            font.pixelSize: 14
                            font.weight: Font.DemiBold
                            anchors.verticalCenter: parent.verticalCenter
                        }
                    }

                    HoverHandler { id: shutdownHover }
                    TapHandler {
                        onTapped: {
                            powerIsland.popupVisible = false
                            powerIsland.doShutdown()
                        }
                    }
                }
            }
        }
    }

    PopupWindow {
        anchor.window: bar
        anchor.item: updatesIsland
        anchor.edges: Edges.Bottom
        anchor.gravity: Edges.Bottom
        visible: updatesIsland.popupVisible
        color: "transparent"
        width: 280
        height: updatesPopupRect.height + 10

        Rectangle {
            id: updatesPopupRect
            y: 10
            width: parent.width
            height: updatesPopupCol.implicitHeight + 16
            color: "#212121"
            radius: 10

            Column {
                id: updatesPopupCol
                anchors {
                    left: parent.left
                    leftMargin: 12
                    top: parent.top
                    topMargin: 8
                    right: parent.right
                    rightMargin: 12
                }
                spacing: 6

                Text {
                    text: updatesIsland.updatesCount === "0" ? "No updates available" : updatesIsland.updatesCount + " updates available"
                    color: "white"
                    font.family: "FiraCode Nerd Font"
                    font.pixelSize: 13
                    font.weight: Font.DemiBold
                }

                ListView {
                    id: pkgList
                    visible: updatesIsland.updatesCount !== "0"
                    width: parent.width
                    height: Math.min(contentHeight, 240)
                    clip: true
                    model: updatesIsland.updatesText.trim() === "" ? [] : updatesIsland.updatesText.trim().split("\n")
                    delegate: Text {
                        required property string modelData
                        text: modelData
                        color: "#aaaaaa"
                        font.family: "FiraCode Nerd Font"
                        font.pixelSize: 12
                        width: pkgList.width
                        elide: Text.ElideRight
                    }
                }
            }
        }
    }
}
