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

    property string currentGroup: ""

    Connections {
        target: users
        function onUpdateGroupList() {
            groupListView.model = users.getGroupsList()
        }
    }

    CustomButton {
        anchors.fill: parent
        text: qsTr("Управление группами")
        onClicked: groupPopup.open()
    }

    Popup {
        id: groupPopup
        width: 400
        height: 350
        modal: true
        x: (window.width - width) / 2
        y: (parent.height - window.height) / 2
        closePolicy: Popup.NoAutoClose
        focus: true
        background: Rectangle { color: Theme.card_background_color}

        Rectangle {
            anchors.fill: parent
            width: parent.width
            height: parent.height
            color: Theme.card_background_color
            radius: 10
            anchors.margins: 0

            ColumnLayout {
                anchors.fill: parent
                spacing: Theme.big_gap
                anchors.margins: Theme.gap
                anchors.centerIn: parent

                CustomText {
                    text: qsTr("Группы доступныe в системе:")
                    Layout.fillWidth: true
                    font.pointSize: Theme.font_regular_size
                }

                RowLayout {
                    Layout.fillHeight: true
                    Layout.fillWidth: true
                    spacing: Theme.gap

                    Rectangle {
                        Layout.fillHeight: true
                        Layout.preferredWidth: parent.width * 0.7
                        color: Theme.background_color
                        border.color: Theme.black

                        ListView {
                            id: groupListView
                            anchors.fill: parent
                            anchors.margins: Theme.gap
                            clip: true
                            model: users.getGroupsList()
                            delegate: Item {
                                width: groupListView.width
                                height: 40

                                Rectangle {
                                    width: parent.width
                                    height: parent.height
                                    color: currentGroup === modelData ? Theme.accent_color : "transparent"

                                    RowLayout {
                                        anchors.fill: parent
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
                                            currentGroup = modelData
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

                    ColumnLayout {
                        Layout.fillHeight: true
                        Layout.fillWidth: true
                        spacing: Theme.gap

//                        CustomButton {
//                            Layout.fillHeight: true
//                            Layout.fillWidth: true
//                            text: qsTr("Добавить")
////                            onClicked: newGroupPopup.open()
//                        }

                        AddNewGroupPopup {
                            Layout.preferredHeight: 60
                            Layout.preferredWidth: dellGroupButton.width
                        }

//                        CustomButton {
//                            Layout.fillHeight: true
//                            Layout.fillWidth: true
//                            text: qsTr("Свойства")
//                        }

                        GroupPropertiesPopup {
                            Layout.preferredHeight: 60
                            Layout.preferredWidth: dellGroupButton.width
                        }

                        CustomButton {
                            id: dellGroupButton
                            Layout.fillHeight: true
                            Layout.fillWidth: true
                            enabled: currentGroup !== ""
                            text: qsTr("Удалить")
                            onClicked: {
                                users.deleteGroup(currentGroup)
                                currentGroup = ""
                            }
                        }
                    }
                }

                RowLayout {
                    Layout.fillWidth: true
                    Layout.preferredHeight: window.height / 10

                    Item {
                        Layout.fillHeight: true
                        Layout.fillWidth: true
                    }

                    CustomButton {
                        Layout.preferredHeight: dellGroupButton.height
                        Layout.preferredWidth: dellGroupButton.width
                        Layout.alignment: Qt.AlignRight
                        text: qsTr("Закрыть")
                        onClicked: {
                            groupPopup.close()
                        }
                    }
                }
            }
        }
    }
}
