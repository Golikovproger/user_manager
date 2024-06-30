pragma Singleton

import QtQuick 2.0

QtObject {
    id: fallout_theme

    readonly property color background_color: "#303030" // Цвет основного фона

    readonly property color card_background_color: "#3b3b3d" // Цвет фона карточки

    readonly property color button_background_color: "#4c4c4c" // Цвет фона кнопки
    readonly property color button_hovered_color: "#65666d" // Цвет кнопки под курсором
    readonly property color button_checked_color: "#65666d" // Цвет нажатой кнопки
    readonly property color button_disabled_color: "#4a4a4c" // Цвет неактивной кнопки

    readonly property color border_hover_color: "#ff6000" // Цвет границы выделенной кнопки
    readonly property color border_regular_color: "#434343" // Цвет обычной границы кнопки

    readonly property color text_header_color: "#fdf5e6" // Цвет текста заголовка
    readonly property color text_regular_color: "#e5e5e5" // Цвет остального текста
    readonly property color text_pressed_color: "#ff6000" // Цвет текста на нажатой, светлой кнопке
    readonly property color text_disabled_color: "#434343" // Цвет текста на неактивной кнопке

    readonly property color accent_color: "#ff6000" // Для акцентов
    // Прочие цвета
    readonly property color light_red: "#bb2d29"
    readonly property color red: "#FF443D"
    readonly property color light_orange: "#cd7f32"
    readonly property color orange: "#ae6615"
    readonly property color light_yellow: "#ffff00"
    readonly property color yellow: "#b6aa37"
    readonly property color light_green: "#7ba05b"
    readonly property color green: "#1f7e38"
    readonly property color light_sea: "#1ec0c1"
    readonly property color sea: "#068586"
    readonly property color light_blue: "#003153"
    readonly property color blue: "#003366"
    readonly property color light_purple: "#9d68ff"
    readonly property color purple: "#6634c4"
    readonly property color light_magenta: "#f157da"
    readonly property color magenta: "#ff00ff"
    readonly property color white: "#ffffff"
    readonly property color black: "#000000"
    readonly property color dark_grey: "#2b2929"
    readonly property color light_gray: "#3d3d3d"
    readonly property color transparent: "transparent"

    readonly property color shiny: "#ff6000"

    readonly property int border_radius: 10
    readonly property int border_width: 1

    // Расстояние между элементами. Например, между кнопками в одной панели
    readonly property int gap: 5
    readonly property int big_gap: gap * 3

    // Шрифт
    readonly property string font_family: "Roboto"
    readonly property int font_big_size: 20
    readonly property int font_regular_size: 16
    readonly property int font_small_size: 12
    readonly property int font_popup_size: 2 // Насколько пунктов увеличить шрифт при наведении
    property font font: Qt.font({
                                    "family": "Roboto",
                                    "italic": false,
                                    "pointSize": font_regular_size
                                })

    // Уровень прозрачности для полупрозрачных элементов
    readonly property double min_opacity: 0.0
    readonly property double max_opacity: 0.9

    // Компановка
    readonly property int columns_count: 12
    readonly property int rows_count: 16

    // Продолжительность анимации [мс]
    readonly property int animation_duration: 200
}
