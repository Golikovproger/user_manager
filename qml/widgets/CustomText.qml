import QtQuick 2.15
import QtQuick.Controls 2.15
import QtGraphicalEffects 1.15
import QtQuick.Layouts 1.15
import "../theme"
Text {
    width: 100
    height: 100
    verticalAlignment: Text.AlignVCenter
    horizontalAlignment: Text.AlignHCenter
    transformOrigin: Item.Center
    minimumPointSize: Theme.font_small_size
    font.family: Theme.font_family
    font.pointSize: Theme.font_small_size
    fontSizeMode: Text.Fit
    color: Theme.text_regular_color
    wrapMode: Text.WordWrap
    elide: Text.ElideMiddle
    opacity: enabled ? Theme.max_opacity : Theme.min_opacity
}
