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
    title: qsTr("User & Groups")

    property int selectedIndex: -1
    property string selectedUser: ""
    property string currentGroup: ""

    Users {
        id: users
    }

    ListModel {
        id: userModel
        ListElement { name: "Alice"; group: "Admin"; info: "Alice is an administrator." }
        ListElement { name: "Bob"; group: "User"; info: "Bob is a standard user." }
        ListElement { name: "Charlie"; group: "Guest"; info: "Charlie is a guest." }
    }

    RowLayout {
        anchors.fill: parent
        anchors.margins: Theme.big_gap
        spacing: Theme.big_gap

        ColumnLayout {
            Layout.preferredWidth: parent.width / 3
            Layout.fillHeight: true
            spacing: Theme.big_gap

//            ListView {
//                id: userListView
//                Layout.fillWidth: true
//                Layout.preferredHeight: window.height / 2
//                model: users.getUsersList()
//                delegate: Item {
//                    width: parent.width
//                    height: 40

//                    RowLayout {
//                        Text {
//                            text: model.name
//                            Layout.fillWidth: true
//                        }
//                    }

//                    MouseArea {
//                        anchors.fill: parent
//                        onClicked: {
//                            selectedIndex = index
//                            selectedUser = model.name
//                        }
//                    }
//                }
//            }

            ListView {
                    id: listView
                    Layout.fillWidth: true
                                    Layout.preferredHeight: window.height / 2
                    model: ListModel {
                        ListElement { text: "Output will appear here" }
                    }
                    delegate: Text {
                        text: model.text
                    }
                }

                Component.onCompleted: {
                    var outputList = users.getUsersList()
                    listView.model.clear();
                    for (var i = 0; i < outputList.length; i++) {
                        listView.model.append({"text": outputList[i]});
                    }

                    var outputLists = users.getGroupsList()
                    groupListView.model.clear();
                    for (var j = 0; j < outputLists.length; j++) {
                        groupListView.model.append({"text": outputLists[j]});
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
                text: selectedIndex != -1 ? "Name: " + userModel.get(selectedIndex).name + "\nGroup: " + userModel.get(selectedIndex).group + "\nInfo: " + userModel.get(selectedIndex).info : "Select a user to see the details"
                wrapMode: Text.Wrap
            }
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

//                ListView {
//                    id: groupListView
//                    Layout.fillWidth: true
//                    Layout.fillHeight: true
//                    model: ListModel {
//                        ListElement { text: "Output will appear here" }
//                    }
//                    delegate: Item {
//                        width: parent.width
//                        height: 40

//                        Rectangle {
//                            width: parent.width
//                            height: parent.height
//                            color: currentGroup === model.name ? "orange" : "transparent"

//                            Text {
//                                anchors.centerIn: parent
//                                text: model.name
//                            }

//                            MouseArea {
//                                anchors.fill: parent
//                                onClicked: {
//                                    currentGroup = model.name
//                                }
//                            }
//                        }
//                    }
//                }

                ListView {
                        id: groupListView
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        model: ListModel {
                            ListElement { text: "Output will appear here" }
                        }
                        delegate: Text {
                            text: model.text
                        }
                    }

                RowLayout {
                    Layout.fillWidth: true

                    Button {
                        Layout.fillWidth: true
                        text: qsTr("Add")
                    }

                    Button {
                        Layout.fillWidth: true
                        text: qsTr("Properties")
                    }

                    Button {
                        Layout.fillWidth: true
                        text: qsTr("Delete")
                        onClicked: {
                            if (currentGroup !== "") {
                                for (var i = 0; i < groupListView.model.count; i++) {
                                    if (groupListView.model.get(i).name === currentGroup) {
                                        groupListView.model.remove(i)
                                        currentGroup = ""
                                        break
                                    }
                                }
                            }
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
                            newUserPopup.close()
                        }
                    }
                }
            }
        }
    }
}
