import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

import "../theme"
import "../widgets"
import Users 1.0


Item {
    id: root
    implicitHeight: 500
    implicitWidth: 500

    CustomButton {
        anchors.fill: parent
        text: qsTr("Добавить")
        onClicked: newUserPopup.open()
    }

    Connections {
        target: users
        function onUpdateUserList() {
            userListView.model = users.getUsersList()
        }
    }

    Popup {
        id: newUserPopup
        width: 400
        height: 350
        modal: true
        x: (window.width - width) / 2
        y: (parent.height - window.height) / 2
        closePolicy: Popup.NoAutoClose
        focus: true
        background: Rectangle { color: Theme.card_background_color}

        onClosed: {
            nameField.text = ""
            password.text = ""
        }

        Rectangle {
            anchors.fill: parent
            width: parent.width
            height: parent.height
            color: Theme.card_background_color
            radius: 20

            ColumnLayout {
                anchors.fill: parent
                spacing: Theme.big_gap
                anchors.margins: Theme.big_gap
                anchors.centerIn: parent

                CustomText {
                    text: qsTr("Создание нового пользователя")
                    Layout.fillWidth: true
                    font.pointSize: Theme.font_regular_size
                }

                RowLayout {
                    Layout.fillHeight: true
                    Layout.fillWidth: true
                    spacing: Theme.gap

                    CustomText {
                        Layout.preferredWidth: parent.width / 3
                        Layout.fillHeight: true
                        text: qsTr("Имя пользователя:")
                    }
                    TextField {
                        id: nameField
                        Layout.fillHeight: true
                        Layout.fillWidth: true
                        Layout.margins: Theme.big_gap
                        placeholderText: qsTr("Имя пользователя")
                        background: Rectangle {
                            color: Theme.background_color
                            border.color: Theme.accent_color
                        }
                        font.pixelSize: Theme.font_regular_size
                        color: Theme.white
                        validator: RegExpValidator {
                            regExp: /[a-z0-9._-]+/
                        }
                    }
                }

                RowLayout {
                    Layout.fillHeight: true
                    Layout.fillWidth: true
                    spacing: Theme.gap

                    CustomText {
                        Layout.preferredWidth: parent.width / 3
                        Layout.fillHeight: true
                        text: qsTr("Пароль:")
                    }
                    TextField {
                        id: password
                        Layout.fillHeight: true
                        Layout.fillWidth: true
                        Layout.margins: Theme.big_gap
                        placeholderText: qsTr("Пароль")
                        validator: RegExpValidator {
                            regExp: /[a-z0-9._-]+/
                        }
                        background: Rectangle {
                            color: Theme.background_color
                            border.color: Theme.accent_color
                        }
                        font.pixelSize: Theme.font_regular_size
                        color: Theme.white
                    }
                }

                RowLayout {
                    Layout.fillHeight: true
                    Layout.fillWidth: true
                    spacing: Theme.gap

                    CustomButton {
                        Layout.fillHeight: true
                        Layout.preferredWidth: parent.width / 2
                        text: qsTr("Отменить")
                        onClicked: newUserPopup.close()
                    }

                    CustomButton {
                        Layout.fillHeight: true
                        Layout.fillWidth: true
                        text: qsTr("Создать")
                        enabled: nameField.text !== "" && password.text !== ""
                        onClicked: {
                            users.addUser(nameField.text, password.text)
                            newUserPopup.close()
                        }
                    }
                }

                Item {
                    Layout.fillHeight: true
                    Layout.fillWidth: true
                }
            }
        }
    }
}
