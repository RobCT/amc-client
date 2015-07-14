import QtQuick 2.4
import QtQuick.Controls 1.3
import QtQuick.Layouts 1.1
import QtQuick.Dialogs 1.2
import QtQuick.LocalStorage 2.0
import QtQuick.Controls.Styles 1.2
import "." as Local
import "../controllers" as Cont

Rectangle {
    id: top
    anchors.fill: parent
    color: "#edcece"
    property bool newp
    property var record
    Component.onCompleted: {
        record = {"firstname":"","lastname":""}

        if (!newp) {
            record = entry.lists.loaded
        }
    }

    ToolBar {
        id: tb1
        width: top.width
        height: (top.height/11) | 0
        anchors.top: parent.top

        property int deltah: parent.height - height
        Local.ToolBarContent {
            id: tbint
            width:parent.width
            height:parent.height
            navheight: top.height/8

        }
    }

    RowLayout {
        id: rowLayout1
        width: parent.width
        height:tb1.deltah
        anchors.leftMargin:   top.width/5
        anchors.rightMargin:   top.width/5
        anchors.bottomMargin:   top.width/5
        anchors.top: tb1.bottom





        Column {
            id: column2
            anchors.left: parent.left
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            width: parent.width*7/16

            Rectangle {
                anchors.right: parent.right
                anchors.rightMargin: 0
                anchors.left: parent.left
                anchors.leftMargin: 0
                color: "beige"
                radius: 4
                height: parent.height/4



            Text {
                id: text1

                text: qsTr("First Name")
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: parent.left
                anchors.leftMargin: parent.width/6
                verticalAlignment: verticalCenter


            }
            }
            Rectangle {
                anchors.right: parent.right
                anchors.rightMargin: 0
                anchors.left: parent.left
                anchors.leftMargin: 0
                color: "beige"
                radius: 4
                height: parent.height/4

            Text {
                id: text2

                text: qsTr("Last Name")
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: parent.left
                anchors.leftMargin: parent.width/6
                verticalAlignment: verticalCenter
                height: parent.height/4

            }
            }
            Rectangle {
                anchors.right: parent.right
                anchors.rightMargin: 0
                anchors.left: parent.left
                anchors.leftMargin: 0
                color: "beige"
                radius: 4
                height: parent.height/4

            Text {
                id: text3

                text: qsTr("Date of  Birth")
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: parent.left
                anchors.leftMargin: parent.width/6
                verticalAlignment: verticalCenter
                height: parent.height/4

            }
            }
            Rectangle {
                anchors.right: parent.right
                anchors.rightMargin: 0
                anchors.left: parent.left
                anchors.leftMargin: 0
                color: "beige"
                radius: 4
                height: parent.height/4

            Text {
                id: text4

                text: qsTr("Church")
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: parent.left
                anchors.leftMargin: parent.width/6
                verticalAlignment: verticalCenter
                height: parent.height/4


            }
            }
        }

        Rectangle {
            id: rectangle1
            anchors.left: column2.right
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            width: parent.width/8

            height: 117
            color: "#ffffff"

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    entry.lists.loaded = top.record
                    entry.pop()
                }
            }
        }
        Column {
            id: column1
            anchors.left: rectangle1.right
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            width: parent.width*7/16


            TextField {
                id: textField1
                anchors.right: parent.right
                anchors.rightMargin: 0
                anchors.left: parent.left
                anchors.leftMargin: 0
                placeholderText: qsTr("Text Field")
                text: top.record.firstname
                height: parent.height/4
                onEditingFinished: {
                    if (!top.newp) entry.lists.update = true
                    else entry.lists.create = true
                    top.record.firstname = text

                }
            }

            TextField {
                id: textField2
                anchors.left: parent.left
                anchors.leftMargin: 0
                anchors.right: parent.right
                anchors.rightMargin: 0
                placeholderText: qsTr("Text Field")
                text: top.record.lastname
                height: parent.height/4
                onEditingFinished: {
                    if (!top.newp) entry.lists.update = true
                    else entry.lists.create = true
                    top.record.lastname = text
                }
            }
            TextField {
                id: textField3
                anchors.right: parent.right
                anchors.rightMargin: 0
                anchors.left: parent.left
                anchors.leftMargin: 0
                placeholderText: qsTr("Text Field")
                //text: top.record.dob_ap
                height: parent.height/4
                onEditingFinished: {
                    if (!top.newp) entry.lists.update = true
                    else entry.lists.create = true
                    //top.record.dob_ap = text
                }
            }

            ComboBox {
                id: combo1
                anchors.right: parent.right
                anchors.rightMargin: 0
                anchors.left: parent.left
                anchors.leftMargin: 0
                height: parent.height/4
                model: comboModel

                Component.onCompleted: {
                   /* cont1.getAll()
                    var element = {"name_c": ""}
                    var ind
                    for (ind=0 ; ind <= cont1.model1.count; ind++) {
                        element.name_c = cont1.model1.get(ind).name_c
                        comboModel.append(element)
                    } */
                }
                onPressedChanged: {
                    if (cont1.model1.count > model.count) {
                    var element = {"name_c": ""}
                    var ind
                    for (ind=0 ; ind < cont1.model1.count; ind++) {
                        element.name_c = cont1.model1.get(ind).name_c
                        comboModel.append(element)
                    }
                    var cid = top.record.church_id_ap
                    for (ind=0 ; ind < cont1.model1.count; ind++) {
                    if (cid == cont1.model1.get(ind).idchurches) currentIndex = ind
                    }
                    }
                }
                onCurrentIndexChanged: {
                    if (!top.newp) entry.lists.update = true
                    else entry.lists.create = true
                    //top.record.church_id_ap = cont1.model1.get(currentIndex).idchurches
                }
            }
        }
    }

    ListModel {
        id: comboModel
    }

}

