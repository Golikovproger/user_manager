import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12
import "../theme"

Button {

    property color button_color_: "grey"
    property color button_checked_color_: "grey"
    property color button_hovered_color_: Theme.button_checked_color
    property color button_disabled_color_: "dark grey"

    property color border_color_: "white"
    property color border_checked_color_: "red"
    property color border_hovered_color_: Theme.border_hover_color
    property int border_radius_: 5

    property int font_size_: 24
    property color font_color_: "white"
    property color font_checked_color_: "white"
    property color font_hovered_color_: Theme.text_pressed_color
    property color font_disabled_color_: "grey"

    id: button
    checkable: false
    enabled: true
    text: qsTr("")
    Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
    contentItem: Text {
        text: parent.text
        font.family: "Roboto"
        font.pointSize: Theme.font_small_size
        opacity: enabled ? 1.0 : 0.3

        color: if (parent.checkable) {
                   if (parent.hovered && parent.checked === false) {
                       font_hovered_color_
                   } else
                       parent.checked ? Theme.text_pressed_color : Theme.text_regular_color
               } else {
                   parent.down ? Theme.text_pressed_color : Theme.text_regular_color
               }
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        fontSizeMode: Text.Fit
        elide: Text.ElideRight
        wrapMode: Text.wrapMode
    }
    background: Rectangle {
        color: if (parent.enabled === false)
                   Theme.button_disabled_color
               else if (parent.hovered && parent.checked === false) {
                   Theme.button_hovered_color
               } else if (parent.checked)
                   Theme.button_checked_color
               else
                   Theme.button_background_color
        radius: Theme.border_radius

        border.width: parent.checked || parent.pressed ? 1 : 0
        border.color: if (parent.hovered && parent.checked === false) {
                          Theme.border_hover_color
                      } else if (parent.checked)
                          Theme.border_hover_color
                      else
                          Theme.border_regular_color
    }
    Component.onCompleted: contentItem.wrapMode = Text.WordWrap
}

/*##^## Designer {
    D{i:0;autoSize:true;height:480;width:640}
}
 ##^##*/
