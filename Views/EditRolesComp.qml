import QtQuick 2.4
import QtQuick.Controls 1.3
import QtQuick.Layouts 1.1
import QtQuick.Dialogs 1.2
import QtQuick.Controls.Styles 1.2
import QtQuick.LocalStorage 2.0
import QtPositioning 5.4
import "../controllers" as Cont

import "." as L

Item {
    id:top
    width:parent.width

    height: parent.height
    ToolBar {
        id: tb1
        width: parent.width
        height: (parent.height/11) | 0
        anchors.top: parent.top

        property int deltah: parent.height - height
        L.ToolBarContent {
            id: tbint
            width:parent.width
            height:parent.height
            navheight: top.height/8

        }
    }

    Rectangle {
        id: mainRect
        property var record
        property bool create
        color: "black"

        width:parent.width
        height:tb1.deltah
        anchors.top: tb1.bottom

        Component.onCompleted: {
            create = false
            record = {"description_ar":""}
        }

        Rectangle {
            id: rectangle1
            anchors.left: tableView1.right

            width: parent.width/8
            height: parent.height
            color: "#ffffff"

        Rectangle {
            id: newRect
            width: parent.width
            height: parent.height/4
            anchors.top: parent.top
            anchors.topMargin: parent.height/4
            color: "cyan"
            visible: true
            radius:15
            Text {
                anchors.verticalCenter:  parent.verticalCenter
                text: "NEW"
            }

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    mainRect.create = true
                    textField1.text = ""






               }
            }
        }
        Rectangle {
            id: saveRect
            width: parent.width
            height: parent.height/4
            anchors.top: parent.top
            anchors.topMargin: parent.height*2/4
            color: "lightgreen"
            visible: true
            radius:15
            Text {
                anchors.verticalCenter:  parent.verticalCenter
                text: "SAVE"
            }

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    if (mainRect.create) {
                        cont1.newRole(JSON.stringify(mainRect.record))
                        mainRect.create = false
                    }
                    else {
                        cont1.updateRole(JSON.stringify(mainRect.record), tableView1.model.get(tableView1.currentRow).id)
                    }

               }
            }
        }
        Rectangle {
            id: delRect
            width: parent.width
            height: parent.height/4
            anchors.top: parent.top
            anchors.topMargin: parent.height*3/4
            color: "orange"
            visible: true
            radius:15
            Text {
                anchors.verticalCenter:  parent.verticalCenter
                text: "DELETE"
            }

            MouseArea {
                anchors.fill: parent
                onClicked:
                    if (tableView1.focus) {

                       //console.log(tableView1.model.get(tableView1.currentRow).id, tableView1.currentRow)

                        cont1.deleteRole(tableView1.model.get(tableView1.currentRow).id)
                       //console.log(tableView1.model.get(tableView1.currentRow).id, tableView1.currentRow)

                    }
                    }
            }
        }





        TableView  {
            id: tableView1

            width: parent.width/2
            height: parent.height
            model: cont1.model1


            TableViewColumn {
                role: "description"
                title: "Role"

            }
            Component.onCompleted: {
                cont1.getAll()

               //console.log(cont1.model1.count)


            }
            onCurrentRowChanged:  {
                if (focus) {

                   //console.log(mainRect.record.description)


                    textField1.text = model.get(currentRow).description

               }
            }

        }
        ColumnLayout {
            id: columnLayout1
            anchors.left: rectangle1.right
            width: parent.width*3/8
            height: parent.height


            TextField {
                id: textField1
                anchors.left: parent.left
                anchors.right: parent.right
                placeholderText: qsTr("Text Field")
                text: mainRect.record.description
                onTextChanged:   {
                        mainRect.record.description = text
                    }
            }


        }
    }
    Cont.RoleController {
        id: cont1
        onReadyChanged: {

                if (status == 200) {
                    //GET

                }
                if (status == 201) {
                    //POST
                    cont1.getAll()


                }
                if (status == 202) {
                    //PUT
                    cont1.getAll()

                }
                if (status == 203) {
                    //PUT
                    cont1.getAll()

                }
                if (status == 204) {
                    //DELETE
                    cont1.getAll()

                }
                if (status == 422) {

                    //error

                   //console.log(JSON.stringify(JSON.parse(jsn).errors))

                    entry.status = JSON.stringify(JSON.parse(jsn).errors)


                }
        }
    }




}
