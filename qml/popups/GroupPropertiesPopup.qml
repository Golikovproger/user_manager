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
        text: qsTr("Свойства")
        onClicked: groupPropertiesPopup.open()
        enabled: currentGroup !== ""
    }

    Popup {
        id: groupPropertiesPopup
        width: 400
        height: 350
        modal: true
        x: (parent.width  - width + (Theme.gap * 4))
        y: (parent.height - height + Theme.gap * 8 ) / 2
        closePolicy: Popup.NoAutoClose
        focus: true

        background: Rectangle { color: Theme.card_background_color}

        onOpened: {
            users_components__list_view.model = users.getUsersList()
        }
        Rectangle {
            anchors.fill: parent
            width: parent.width
            height: parent.height
            color: Theme.card_background_color
            radius: 10

            ColumnLayout {
                anchors.fill: parent
                spacing: Theme.gap
                anchors.margins: Theme.big_gap
                anchors.centerIn: parent

                CustomText {
                    text: qsTr("Свойства группы " + currentGroup)
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
                        id: groupNameField
                        Layout.fillHeight: true
                        Layout.fillWidth: true
                        Layout.margins: Theme.big_gap
                        readOnly: true
                        placeholderText: qsTr(currentGroup)
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
                            id: usersCheckBox
                            text: modelData
                            background_color_: Theme.card_background_color
                            accent_color_: Theme.accent_color
                            font_size_: Theme.font_small_size
                            font_color_: Theme.text_regular_color

                            checked: users.getUsersInGroup(currentGroup).indexOf(modelData) !== -1

                            onClicked: {
                                if (checked) {
                                    selectedUsersModel.append({ "name": modelData });
                                    users.addUserToGroup(modelData, currentGroup);
                                } else {
                                    for (var i = 0; i < selectedUsersModel.count; i++) {
                                        if (selectedUsersModel.get(i).name === modelData) {
                                            selectedUsersModel.remove(i);
                                            break;
                                        }
                                    }
                                    users.removeUserFromGroup(modelData, currentGroup);
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

                    Item {
                        Layout.fillHeight: true
                        Layout.preferredWidth: parent.width / 2
                    }

                    CustomButton {
                        Layout.fillHeight: true
                        Layout.fillWidth: true
                        text: qsTr("OК")
                        onClicked: {
                            groupPropertiesPopup.close()
                        }
                    }
                }
            }
        }
    }
}
