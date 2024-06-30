import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import "../theme"
import "../widgets"

Item {
    id: root
    implicitHeight: 500
    implicitWidth: 500

    CustomButton {
        anchors.fill: parent
        text: qsTr("О программе")
        onClicked: aboutWindow.show()
    }

    ApplicationWindow {
        id: aboutWindow
        visible: false
        minimumWidth: 450
        minimumHeight: 640
        maximumHeight: minimumHeight
        maximumWidth: minimumWidth
        title: qsTr("О программе")
        color: Theme.background_color

        ColumnLayout {
            anchors.fill: parent
            spacing: Theme.big_gap
            anchors.margins: Theme.big_gap

            Image {
                id: appImage
                source: "../../assets/desktop_icon.png"
                Layout.alignment: Qt.AlignCenter
            }

            CustomText {
                Layout.preferredHeight: parent.height / 10
                Layout.fillWidth: true
                text: qsTr("Пользователи и группы")
                font.bold: true
                font.pointSize: Theme.font_regular_size
                color: Theme.text_regular_color
            }

            CustomText {
                Layout.fillHeight: true
                Layout.fillWidth: true
                horizontalAlignment: Text.AlignLeft
                text: qsTr("    Эта программа разработана с использованием C++ и QT/QML и предназначена для управления пользователями и группами операционной системы.\n\n    Основные возможности программы включают:\n - Вывод списка пользователей и групп ОС;\n - Добавление и удаление пользователей;\n - Добавление и удаление групп;\n - Добавление пользователей в группы и исключение из групп;\n - Создание домашнего каталога пользователей;\n - Редактирование паролей пользователей.")
                font.pointSize: Theme.font_small_size
                color: Theme.text_regular_color
            }

            Item {
                Layout.fillHeight: true
                Layout.fillWidth: true
            }

            RowLayout {
                Layout.fillHeight: true
                Layout.fillWidth: true

                Item {
                    Layout.fillHeight: true
                    Layout.fillWidth: true
                }

                CustomButton {
                    Layout.fillHeight: true
                    Layout.fillWidth: true
                    text: qsTr("Закрыть")
                    onClicked: aboutWindow.close()
                }
            }
        }
    }
}
