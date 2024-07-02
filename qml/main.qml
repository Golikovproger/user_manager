import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

import "theme"
import "widgets"
import "popups"
import Users 1.0

ApplicationWindow {
    id: window
    visible: true
    width: 854
    height: 480
    minimumWidth: 640
    minimumHeight: 360
    color: Theme.background_color

    property int selectedIndex: -1
    property string selectedUser: ""

    Users {
        id: users
    }

    Component.onCompleted: {
        authPopup.open()
    }

    Connections {
        target: users
        function onUpdateUserList() {
            userListView.model = users.getUsersList()
        }
    }

    ColumnLayout {
        anchors.fill: parent
        spacing: Theme.big_gap
        anchors.margins: Theme.big_gap

        RowLayout {
            Layout.fillWidth: true
            Layout.preferredHeight: window.height / 3
            spacing: Theme.big_gap

            Rectangle {
                Layout.fillHeight: true
                Layout.preferredWidth: parent.width / 3 + Theme.gap * 2
                color: Theme.card_background_color
                border.color: Theme.black

                ListView {
                    id: userListView
                    anchors.fill: parent
                    anchors.margins: Theme.gap
                    clip: true
                    model: users.getUsersList()
                    delegate: Item {
                        width: parent.width
                        height: 40

                        Rectangle {
                            width: parent.width
                            height: parent.height
                            color: selectedUser === modelData ? Theme.accent_color : (mouseArea.containsMouse ? "gray" : "transparent")

                            RowLayout {
                                anchors.fill: parent
                                Image {
                                    id: icon
                                    source: "../assets/user.png"
                                }
                                Text {
                                    text: modelData
                                    color: Theme.white
                                    Layout.fillWidth: true
                                    elide: Text.ElideRight
                                }
                            }

                            MouseArea {
                                id: mouseArea
                                anchors.fill: parent
                                hoverEnabled: true
                                onClicked: {
                                    selectedIndex = index
                                    selectedUser = modelData
                                }
                            }
                        }
                    }

                    ScrollBar.vertical: ScrollBar {
                        policy: ScrollBar.AlwaysOn
                        width: Theme.gap
                        active: true

                    }
                }
            }

            Rectangle {
                Layout.fillHeight: true
                Layout.fillWidth: true
                color: "transparent"
                ColumnLayout {
                    anchors.fill: parent
                    anchors.margins: Theme.big_gap
                    spacing: Theme.big_gap

                    RowLayout {
                        Layout.fillWidth: true
                        Layout.preferredHeight: parent.height / 5
                        spacing: Theme.gap

                        Image {
                            id: currentUserIcon
                            source: "../assets/current_user.png"
                        }

                        CustomText {
                            text: selectedIndex != -1 ? qsTr("Имя: " + selectedUser) : qsTr("Имя пользователя")
                            wrapMode: Text.Wrap
                            color: Theme.white
                        }
                        Item {
                            Layout.fillHeight: true
                            Layout.fillWidth: true
                        }

                        CustomButton {
                            text: qsTr("Создать домашнюю папку")
                            enabled: selectedUser !== ""
                            onClicked: users.createUserHome(selectedUser)
                            Layout.preferredHeight: deleteUserButton.height
                            Layout.preferredWidth: deleteUserButton.width * 1.5
                        }
                    }

                    RowLayout {
                        Layout.fillWidth: true
                        Layout.preferredHeight: parent.height / 5
                        spacing: Theme.gap

                        CustomText {
                            id: passText
                            text: selectedIndex != -1 ? qsTr("Пароль: *****") : qsTr("Пароль пользователя")
                            color: Theme.white
                        }

                        Item {
                            Layout.fillHeight: true
                            Layout.fillWidth: true
                        }

                        ChangeUserPasswordPopup {
                            Layout.preferredHeight: deleteUserButton.height
                            Layout.preferredWidth: deleteUserButton.width
                        }
                    }

                    Item {
                        Layout.fillHeight: true
                        Layout.fillWidth: true
                    }
                }
            }
        }

        RowLayout {
            Layout.fillWidth: true
            Layout.preferredHeight: window.height / 5
            spacing: Theme.big_gap

            Item {
                id: buttonsContainer
                Layout.fillHeight: true
                Layout.preferredWidth: window.width / 3

                ColumnLayout {
                    anchors.fill: parent
                    spacing: Theme.gap
                    RowLayout {
                        Layout.fillWidth: true
                        Layout.preferredHeight: parent.height / 2
                        spacing: Theme.gap

                        AddNewUserPopup {
                            Layout.fillHeight: true
                            Layout.preferredWidth: parent.width / 2
                        }

                        CustomButton {
                            id: deleteUserButton
                            text: qsTr("Удалить")
                            enabled: selectedUser !== ""
                            Layout.fillHeight: true
                            Layout.fillWidth: true
                            onClicked: {
                                users.deleteUser(selectedUser)
                                selectedUser = ""
                            }
                        }
                    }
                    GroupManagerPopup {
                        Layout.fillWidth: true
                        Layout.preferredHeight: parent.height / 2
                    }
                }
            }

            Item {
                Layout.fillHeight: true
                Layout.fillWidth: true
            }
        }

        Item {
            Layout.fillHeight: true
            Layout.fillWidth: true
        }

        RowLayout {
            Layout.fillWidth: true
            Layout.preferredHeight: window.height / 10

            AboutProgram {
                Layout.fillHeight: true
                Layout.preferredWidth: parent.width / 5
            }

            Item {
                Layout.fillHeight: true
                Layout.fillWidth: true
            }

            CustomButton {
                Layout.fillHeight: true
                Layout.preferredWidth: parent.width / 5
                text: qsTr("Выгрузить лог")
                onClicked: users.exportToCSV()
            }

            Item {
                Layout.fillHeight: true
                Layout.fillWidth: true
            }

            CustomButton {
                Layout.fillHeight: true
                Layout.preferredWidth: parent.width / 5
                text: qsTr("Закрыть")
                onClicked: {
                    Qt.quit()
                }
            }
        }
    }

    Popup {
        id: authPopup
        width: 400
        height: 400
        modal: true
        closePolicy: Popup.NoAutoClose
        anchors.centerIn: parent
        background: Rectangle {anchors.fill: parent; color:"transparent"}

        property bool passwordVisible: false

        Rectangle {
            width: parent.width
            height: parent.height
            color: Theme.white
            radius: 10

            ColumnLayout {
                anchors.fill: parent
                spacing: Theme.gap
                anchors.margins: Theme.big_gap
                anchors.centerIn: parent

                CustomText {
                    color: Theme.black
                    text: qsTr("Необходима аутентификация")
                    font.pointSize: Theme.font_regular_size
                    Layout.fillWidth: true
                }

                CustomText {
                    color: Theme.black
                    Layout.fillWidth: true
                    text: qsTr("Вам необходимо пройти аутентификацию, чтобы изменить конфигурацию системы.")
                }

                Image {
                    source: "../assets/auth_user.png"
                    Layout.alignment: Qt.AlignCenter
                }

                CustomText {
                    color: Theme.black
                    text: qsTr(users.getUserName())
                    Layout.fillWidth: true
                }

                TextField {
                    id: sudopassword
                    echoMode: authPopup.passwordVisible ? TextInput.Normal : TextInput.Password
                    Layout.fillHeight: true
                    Layout.fillWidth: true
                    Layout.margins: Theme.big_gap
                    placeholderText: qsTr("Пароль")
                    background: Rectangle {
                        border.color: Theme.accent_color
                    }
                    font.pixelSize: Theme.font_big_size
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
                            Qt.quit()
                        }
                    }

                    CustomButton {
                        Layout.fillHeight: true
                        Layout.fillWidth: true
                        text: qsTr("Авторизация")
                        enabled: sudopassword.text !== ""
                        onClicked: {
                            if (users.sudoRules(sudopassword.text))
                                authPopup.close();
                            else
                            {
                                sudopassword.text = ""
                                sudopassword.placeholderText = "Неверный пароль!"
                                sudopassword.placeholderTextColor = Theme.red
                            }
                        }
                    }
                }
            }
        }
    }
}
