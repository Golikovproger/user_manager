import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

import "../theme"
import "../widgets"
import "."
import Users 1.0

Item {
    id: root
    implicitHeight: 500
    implicitWidth: 500

    ListModel {
       id: selectedUsersModel
    }

    Connections {
        target: users
        function onUpdateGroupList() {
            groupListView.model = users.getGroupsList()
        }
    }

    CustomButton {
        anchors.fill: parent
        text: qsTr("Добавить")
        onClicked: newGroupPopup.open()
    }

    Popup {
        id: newGroupPopup
        width: 400
        height: 350
        modal: true
        x: (parent.width  - width + (Theme.gap * 4))
        y: (parent.height - height / 2) / 2
        closePolicy: Popup.NoAutoClose
        focus: true

        onClosed: {
            nameField.text = "";
            selectedUsersModel.clear();
            for (var i = 0; i < users_components__list_view.count; ++i) {
                users_components__list_view.itemAtIndex(i).checked = false;
            }
        }

        onOpened: users_components__list_view.model = users.getUsersList()

        background: Rectangle { color: Theme.card_background_color}

        Rectangle {
            anchors.fill: parent
            width: parent.width
            height: parent.height
            color: Theme.card_background_color
            radius: 20

            ColumnLayout {
                anchors.fill: parent
                spacing: Theme.gap
                anchors.margins: Theme.big_gap
                anchors.centerIn: parent

                CustomText {
                    text: qsTr("Создание новой группы")
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
                        text: qsTr("Имя группы:")
                    }
                    TextField {
                        id: nameField
                        Layout.fillHeight: true
                        Layout.fillWidth: true
                        Layout.margins: Theme.big_gap
                        placeholderText: qsTr("Имя группы")
                        background: Rectangle {
                            color: Theme.background_color
                            border.color: Theme.accent_color
                        }
                        font.pixelSize: Theme.font_regular_size
                        color: Theme.white
                    }
                }

                CustomText {
                    text: qsTr("Пользователи группы:")
                    Layout.fillWidth: true
                    horizontalAlignment: Qt.AlignLeft
                }

                Rectangle {
                    Layout.preferredHeight: parent.height / 3
                    Layout.fillWidth: true
                    color: Theme.background_color
                    border.color: Theme.black

                    ListView {
                        id: users_components__list_view
                        anchors.fill: parent
                        clip: true
                        spacing: Theme.gap
                        model: users.getUsersList()
                        delegate: CustomCheckBox {
                            text: modelData
                            background_color_: Theme.card_background_color
                            accent_color_: Theme.accent_color
                            font_size_: Theme.font_small_size
                            font_color_: Theme.text_regular_color
                            checked: false

                            onClicked: {
                                if (checked) {
                                    selectedUsersModel.append({ "name": modelData });
                                } else {
                                    for (var i = 0; i < selectedUsersModel.count; i++) {
                                        if (selectedUsersModel.get(i).name === modelData) {
                                            selectedUsersModel.remove(i);
                                            break;
                                        }
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

                RowLayout {
                    Layout.fillHeight: true
                    Layout.fillWidth: true
                    spacing: Theme.gap

                    CustomButton {
                        Layout.fillHeight: true
                        Layout.preferredWidth: parent.width / 2
                        text: qsTr("Отменить")
                        onClicked: newGroupPopup.close()
                    }

                    CustomButton {
                        Layout.fillHeight: true
                        Layout.fillWidth: true
                        text: qsTr("Создать")
                        enabled: nameField.text !== ""

                        onClicked: {
                            users.addGroup(nameField.text)
                            for (var i = 0; i < selectedUsersModel.count; ++i) {
                                users.addUserToGroup(selectedUsersModel.get(i).name, nameField.text)
                            }
                            newGroupPopup.close()
                        }
                    }
                }
            }
        }
    }
}
