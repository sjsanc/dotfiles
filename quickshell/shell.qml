import QtQuick
import Quickshell

Variants {
    model: Quickshell.screens
    delegate: Component { Bar {} }
}
