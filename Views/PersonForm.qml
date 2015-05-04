import QtQuick 2.4
import QtQuick.Controls 1.3
import QtQuick.Layouts 1.1
import QtQuick.Window 2.2
import QtQuick.Dialogs 1.2
import QtQuick.LocalStorage 2.0
import "." as Local
import "../controllers" as Cont
//import "../scripts/functions.js" as Func
import "../scripts/globals.js" as G
import "../scripts/moment.js" as D
import "../components" as Comp



Item {
    id: personForm
    width: 640
    height: 480

    onVisibleChanged: {
        if (visible) {
            if (entry.lists.update) {
                console.log(JSON.stringify(entry.lists.loaded))
                cont1.updatePerson(JSON.stringify(entry.lists.loaded), entry.pid)
                entry.lists.update = false
            }
            else if (entry.lists.create) {
                console.log(JSON.stringify(entry.lists.loaded))
                cont1.newPerson(JSON.stringify(entry.lists.loaded))
                entry.lists.create = false
            }
        }
    }
    Component.onCompleted: {

    }
    RowLayout {
        anchors.top: row1.bottom
        Button {
            id: button1
            text: qsTr("Press Me 1")
            onClicked: {
                cont1.updatePerson(JSON.stringify({"person":{"roles_ids": [1]}}), 2)



            }
        }

        Button {
            id: button2
            text: qsTr("Press Me 2")
            onClicked: {
                console.log(Qt.platform.os)
            }
        }

        Button {
            id: button3
            text: qsTr("Press Me 3")
            onClicked: {
                var dt = D.moment(new Date(2015,05,01))


                entry.push({item: tumblr, properties: {date: dt, showType: "weeks"}})
            }
        }
    }
    Row {
        id: row1
        x: 17
        y: 26
        width: parent.width
        height: parent.height *0.8

        TableView {
            id: tableView1
            width: parent.width*0.6
            height: parent.height
            model: cont1.model1
            TableViewColumn {
                role: "firstname"
                title: "First Name"
                width: tableView1.width/2
            }
            TableViewColumn {
                role: "lastname"
                title: "Last Name"
                width: tableView1.width/2
            }
            Component.onCompleted: {
                cont1.getAll()
            }
            onFocusChanged: {
                if (focus) {
                    delRect.visible = true
                    addRect.visible = true
                    editRect.visible = true
                    rolesRect.visible = true
                }
                else {
                    delRect.visible = false
                    addRect.visible = false
                    editRect.visible = false
                    rolesRect.visible = false
                }
            }

            onCurrentRowChanged:  {
                var pid = model.get(tableView1.currentRow).id
                //console.log(pid)
                cont1.getPersonRoles(pid)
                console.log(cont1.model2.count, cont1.model2.source)
                 /*jsonModel2.source = "http://192.168.0.103/roleind?personid=" + peep.toString()

*/

            }
        }

        Rectangle {
            id: rectangle1
            width: parent.width*0.1
            height: parent.height
            color: "#ffffff"
            Rectangle {
                id: delRect
                width: parent.width
                height: parent.height/4
                anchors.top: parent.top
                color: "red"
                visible: false
                radius:15
                Text {
                    anchors.verticalCenter:  parent.verticalCenter
                    text: "DELETE"
                }

                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        if (tableView1.model.get(tableView1.currentRow).id) {
                            cont1.deletePerson(tableView1.model.get(tableView1.currentRow).id)
                        }
                    }
                }
            }
            Rectangle {
                id: addRect
                width: parent.width
                height: parent.height/4
                anchors.top: parent.top
                anchors.topMargin: parent.height/4
                color: "cyan"
                visible: false
                radius:15
                Text {
                    anchors.verticalCenter:  parent.verticalCenter
                    text: "Add Person"
                }

                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                    /*    entry.model = tableView1.model
                        entry.row = tableView1.currentRow
                        entry.pid = tableView1.model.get(tableView1.currentRow).id
                        entry.lists.loaded = tableView1.model.get(tableView1.currentRow)
                        */
                        entry.pushOther(3)
                   }
                }
            }
            Rectangle {
                id: editRect
                width: parent.width
                height: parent.height/4
                anchors.top: parent.top
                anchors.topMargin: parent.height*2/4
                color: "lightgreen"
                visible: false
                radius:15
                Text {
                    anchors.verticalCenter:  parent.verticalCenter
                    text: "Edit Person"
                }

                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        //entry.model = tableView1.model
                        //entry.row = tableView1.currentRow
                        entry.pid = tableView1.model.get(tableView1.currentRow).id
                        entry.lists.loaded = tableView1.model.get(tableView1.currentRow)
                        entry.pushOther(2)
                   }
                }
            }
            Rectangle {
                id: rolesRect
                width: parent.width
                height: parent.height/4
                anchors.top: parent.top
                anchors.topMargin: parent.height*3/4
                color: "lightyellow"
                visible: false
                radius:15
                Text {
                    anchors.verticalCenter:  parent.verticalCenter
                    text: "Edit Roles"
                }

                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        //entry.model = tableView1.model
                        //entry.row = tableView1.currentRow
                        entry.pid = tableView1.model.get(tableView1.currentRow).id
                        entry.lists.loaded = tableView1.model.get(tableView1.currentRow)
                        console.log("pid?", entry.lists.loaded.id)
                        entry.pushOther(4)
                   }
                }
            }
        }

        TableView {
            id: tableView2
            width: parent.width*0.3
            height: parent.height
            model: cont1.model3
            TableViewColumn {
                role: "description"
                title: "Role"
                width: parent.width
            }
        }
    }

        Cont.PersonController {
            id:cont1
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
                        //console.log("PUTpf")

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
                        console.log(JSON.stringify(JSON.parse(jsn).errors))
                        entry.status = JSON.stringify(JSON.parse(jsn).errors)


                    }
            }
    }
        Cont.SessionController {
            id:cont2
    }
        Component {
            id: tumblr
            Comp.DateTumblerInput {

            }
        }
}
