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

    Users {
        id: users
    }

    CustomButton {
        anchors.fill: parent
        text: qsTr("Сменить пароль")
        enabled: window.selectedUser !== ""
        onClicked: changePassPopup.open()
    }

    Popup {
        id: changePassPopup
        width: 400
        height: 350
        modal: true
        x: (parent.width - window.width - width / 2) / 2
        y: (parent.height - window.height  + height) / 2
        closePolicy: Popup.NoAutoClose
        focus: true

        background: Rectangle { color: Theme.card_background_color}

        onClosed: {
            passwordField.text = ""
            confirmPasswordField.text = ""
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
                    text: qsTr("Смена пароля " + window.selectedUser)
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
                        text: qsTr("Введите новый пароль:")
                    }

                    TextField {
                        id: passwordField
                        Layout.fillHeight: true
                        Layout.fillWidth: true
                        echoMode: TextInput.Password
                        Layout.margins: Theme.big_gap
                        placeholderText: qsTr("Пароль")
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

                    CustomText {
                        Layout.preferredWidth: parent.width / 3
                        Layout.fillHeight: true
                        text: qsTr("Подтвердите пароль:")
                    }

                    TextField {
                        id: confirmPasswordField
                        echoMode: TextInput.Password
                        Layout.fillHeight: true
                        Layout.fillWidth: true
                        Layout.margins: Theme.big_gap
                        placeholderText: qsTr("Пароль")
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
                        Layout.preferredWidth: parent.width / 2 - Theme.gap
                        text: qsTr("Отменить")
                        onClicked: {
                            changePassPopup.close();
                        }
                    }

                    CustomButton {
                        Layout.fillHeight: true
                        Layout.fillWidth: true
                        text: qsTr("Изменить")
                        enabled: passwordField.text !== "" && confirmPasswordField.text !== ""
                        onClicked: {
                            if (passwordField.text === confirmPasswordField.text) {
                                users.changeUserPassword(window.selectedUser, passwordField.text)
                                changePassPopup.close();
                            }
                            else
                            {
                                passwordField.text = ""
                                confirmPasswordField.text = ""
                                passwordField.placeholderText = "Пароли не совпадают!"
                                passwordField.placeholderTextColor = Theme.red
                                confirmPasswordField.placeholderText = "Пароли не совпадают!"
                                confirmPasswordField.placeholderTextColor = Theme.red
                            }
                        }
                    }
                }
            }
        }

    }
}
