import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Controls.Material 2.12
import QtQuick.Layouts 1.11
import QtQuick.Shapes 1.12

CheckBox {
    property color background_color_: "grey"
    property color accent_color_: "red"

    property int font_size_: 24
    property int font_minimum_size_: 12
    property color font_color_: "white"
    property string font_family_: "Roboto"

    id: control
    opacity: enabled ? 1.0 : 0.3
    contentItem: Text {
        text: parent.text
        elide: Text.ElideRight
        color: font_color_
        font.family: font_family_
        font.pointSize: font_size_
        minimumPointSize: font_minimum_size_
        leftPadding: parent.indicator.width + parent.spacing
        visible: text != ""
        opacity: control.checked ? 1.0 : 0.3
        verticalAlignment: Text.AlignVCenter
    }

    indicator: Rectangle {
        width: height
        height: (parent.height > 26) ? 26 : parent.height
        x: contentItem.visible ? control.leftPadding : parent.width / 2 - width / 2
        y: parent.height / 2 - height / 2
        radius: 3
        color: background_color_
        border.color: accent_color_

        Rectangle {
            width: parent.width / 2
            height: width
            anchors.centerIn: parent
            radius: 2
            color: accent_color_
            visible: control.checked
        }
    }
}
