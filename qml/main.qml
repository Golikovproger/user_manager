import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

import "theme"
import Users 1.0

ApplicationWindow {
    id: window
    visible: true
    width: 1366
    height: 768
    minimumWidth: 640
    minimumHeight: 360
    property int selectedIndex: -1
    property string selectedUser: ""
    property string currentGroup: ""

    Component.onCompleted: {
        sudoPopup.open();
    }

    Connections {
        target: users
        function onUpdateUserList() {
            userListView.model = users.getUsersList()
        }

        function onUpdateGroupList() {
            groupListView.model = users.getGroupsList()
        }
    }


    Users {
        id: users
    }

    RowLayout {
        anchors.fill: parent
        anchors.margins: Theme.big_gap
        spacing: Theme.big_gap

        ColumnLayout {
            Layout.preferredWidth: parent.width / 3
            Layout.fillHeight: true
            spacing: Theme.big_gap

            ListView {
                id: userListView
                Layout.fillWidth: true
                Layout.preferredHeight: window.height / 2
                model: users.getUsersList()
                delegate: Item {
                    width: parent.width
                    height: 40

                    RowLayout {
                        Text {
                            text: modelData
                            Layout.fillWidth: true
                        }
                    }

                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            selectedIndex = index
                            selectedUser = modelData
                        }
                    }
                }
            }

            RowLayout {
                Layout.fillWidth: true

                Button {
                    Layout.fillWidth: true
                    text: qsTr("Добавить")
                    onClicked: newUserPopup.open()
                }

                Button {
                    Layout.fillWidth: true
                    text: qsTr("Удалить")
                    onClicked: users.deleteUser(selectedUser)
                }
            }

            Button {
                id: manageGroups
                Layout.fillWidth: true
                text: qsTr("Управление группами")
                onClicked: groupPopup.open()
            }
        }

        Rectangle {
            id: userInfoBlock
            Layout.fillWidth: true
            Layout.fillHeight: true
            color: "#f0f0f0"
            border.color: "#a0a0a0"

            Text {
                id: userInfoText
                anchors.centerIn: parent
                text: selectedIndex != -1 ? "Name: " + selectedUser + "\nPassword: " + "*****" : "Select a user to see the details"
                wrapMode: Text.Wrap
            }
        }

        Button {
            id: changePassword
            text: qsTr("Сменить пароль")
            onClicked: changePasswordPopup.open()
        }
    }

    Popup {
        id: groupPopup
        width: 400
        height: 300
        modal: true

        Rectangle {
            width: parent.width
            height: parent.height
            color: "white"
            border.color: "black"
            border.width: 1
            radius: 5

            ColumnLayout {
                anchors.fill: parent
                anchors.margins: 10
                spacing: 10

                Text {
                    text: qsTr("Groups settings")
                    font.bold: true
                }

                ListView {
                    id: groupListView
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    model: users.getGroupsList()
                    delegate: Item {
                        width: groupListView.width
                        height: 40

                        Rectangle {
                            width: parent.width
                            height: parent.height
                            color: currentGroup === modelData ? "orange" : "transparent"

                            Text {
                                anchors.centerIn: parent
                                text: modelData
                            }

                            MouseArea {
                                anchors.fill: parent
                                onClicked: {
                                    currentGroup = modelData
                                }
                            }
                        }
                    }
                }

//                ListView {
//                        id: groupListView
//                        Layout.fillWidth: true
//                        Layout.fillHeight: true
//                        model: users.getGroupsList()
//                        delegate: Text {
//                            text: modelData
//                        }
//                    }

                RowLayout {
                    Layout.fillWidth: true

                    Button {
                        Layout.fillWidth: true
                        text: qsTr("Add")
                        onClicked: newGroupPopup.open()
                    }

                    Button {
                        Layout.fillWidth: true
                        text: qsTr("Properties")
                    }

                    Button {
                        Layout.fillWidth: true
                        text: qsTr("Delete")
                        onClicked: {
                            users.deleteGroup(currentGroup)
                        }
                    }
                }

                Button {
                    Layout.fillWidth: true
                    text: qsTr("Close")
                    onClicked: groupPopup.close()
                }
            }
        }
    }

    Popup {
        id: newUserPopup
        width: 300
        height: 400
        modal: true

        Rectangle {
            width: parent.width
            height: parent.height
            color: "white"
            border.color: "black"
            border.width: 1
            radius: 5

            ColumnLayout {
                anchors.fill: parent
                anchors.margins: 10
                spacing: 10

                Text {
                    text: qsTr("Create New User")
                    font.bold: true
                }

                Text {
                    text: qsTr("Create a new user")
                }

                TextField {
                    id: nameField
                    placeholderText: qsTr("UserName")
                }

                TextField {
                    id: password
                    placeholderText: qsTr("Password")
                }

                RowLayout {
                    Layout.fillWidth: true
                    spacing: 10

                    Text {
                        text: qsTr("Username must consist of:")
                    }

                    Text {
                        text: "• lower case letters from the English alphabet\n• digits\n• any of the characters '.', '-' and '_'"
                        wrapMode: Text.Wrap
                    }
                }

                RowLayout {
                    Layout.fillWidth: true
                    spacing: 10

                    Button {
                        text: qsTr("Cancel")
                        onClicked: newUserPopup.close()
                    }

                    Button {
                        text: qsTr("OK")
                        onClicked: {
                            users.addUser(nameField.text, password.text)
                            newUserPopup.close()
                        }
                    }
                }
            }
        }
    }

    ListModel {
           id: selectedUsers
       }

    Popup {
        id: newGroupPopup
        width: 300
        height: 400
        modal: true

        Rectangle {
            width: parent.width
            height: parent.height
            color: "white"
            border.color: "black"
            border.width: 1
            radius: 5

            ColumnLayout {
                anchors.fill: parent
                anchors.margins: 10
                spacing: 10

                Text {
                    text: qsTr("Create New Group")
                    font.bold: true
                }

                Text {
                    text: qsTr("Create a new Group")
                }

                TextField {
                    id: groupField
                    placeholderText: qsTr("GroupName")
                }

                GridLayout {
                                anchors.leftMargin: Theme.gap
                                columns: 2
                                Repeater {
                                    id: usersrepeater
                                    model: users.getUsersList()

                                    CheckBox {
                                        id: _level_checkbox_
                                        text: modelData
                                        onClicked: {
                                            if (_level_checkbox_.checked) {
                                                selectedUsers.push(modelData)
                                            } else {
                                                var index = selectedUsers.indexOf(modelData)
                                                if (index > -1) {
                                                    selectedUsers.splice(index, 1)
                                                }
                                            }
                                        }
                                    } // end _level_checkbox_
                                } // Repeater
                            } // GridLayout
                RowLayout {
                    Layout.fillWidth: true
                    spacing: 10

                    Button {
                        text: qsTr("Cancel")
                        onClicked: newGroupPopup.close()
                    }

                    Button {
                        text: qsTr("OK")
                        onClicked: {
                            users.addGroup(groupField.text)
                            for (var i = 0; i < selectedUsers.length; ++i) {
                                                       users.addUserToGroup(selectedUsers[i], groupField.text)
                                                   }
                            newGroupPopup.close()
                        }
                    }
                }
            }
        }
    }

    Popup {
        id: changePasswordPopup
        width: 300
        height: 400
        modal: true
        closePolicy: Popup.NoAutoClose
        Rectangle {
            width: parent.width
            height: parent.height
            color: "white"
            border.color: "black"
            border.width: 1
            radius: 5

            ColumnLayout {
                anchors.fill: parent
                spacing: 20

                TextField {
                    Layout.fillHeight: true
                    Layout.fillWidth: true
                    id: newUserPassword
                    placeholderText: qsTr("NewPassword")
                }

                Button {
                    Layout.fillHeight: true
                    Layout.fillWidth: true
                    text: qsTr("ОК")
                    onClicked: {
                        users.changeUserPassword(selectedUser,newUserPassword.text);
                        changePasswordPopup.close();
                    }
                }
            }
        }
    }

    Popup {
        id: sudoPopup
        width: 300
        height: 400
        modal: true
        closePolicy: Popup.NoAutoClose

        Rectangle {
            width: parent.width
            height: parent.height
            color: "white"
            border.color: "black"
            border.width: 1
            radius: 5

            ColumnLayout {
                anchors.fill: parent
                spacing: 20

                TextField {
                    Layout.fillHeight: true
                    Layout.fillWidth: true
                    id: sudopassword
                    placeholderText: qsTr("SudoPassword")
                }

                Button {
                    Layout.fillHeight: true
                    Layout.fillWidth: true
                    text: qsTr("ОК")
                    onClicked: {
                        users.sudoRules(sudopassword.text);
                        sudoPopup.close();
                    }
                }
            }
        }
    }
}
