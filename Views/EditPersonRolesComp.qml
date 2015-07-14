import QtQuick 2.4
import QtQuick.Controls 1.3
import QtQuick.Layouts 1.1
import "." as Local
import "../controllers" as Cont

Rectangle {
    id: top
   // property var record: {"peepID": entry.pid, "roleID": 0}
    property int pid
    height: entry.sheight
    width: entry.swidth


    color: "#edcece"

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

        TableView {
            id: tabRoles
            anchors.top: tb1.bottom

            width: parent.width*7/16

            model: cont2.model3//selectRoles



            anchors.bottom: parent.bottom
            TableViewColumn {
                role: "description"
                title: "Role"
                width: parent.width


            }
            onFocusChanged: {
                if (focus) act2.visible = true
                else act2.visible =false
            }
            Component.onCompleted: {
                cont2.getPersonRoles(top.pid)
            }
        }

        Rectangle {
            id: spacer1


            anchors.top: tb1.bottom


            anchors.left: tabRoles.right
            anchors.bottom: parent.bottom
            width: top.width/8
            color: "cyan"

            Rectangle {
                id: act1
                width: parent.width
                height: parent.height/5
                anchors.top: parent.top
                anchors.left: parent.left


                radius: 10
                color: "blue"
                visible: false
                Image {
                    anchors.verticalCenter: parent.verticalCenter
                    source: "../images/navigation_previous_item.png"
                    width: parent.width
                    height:parent.height
                }
                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        var rid = tabAllRoles.model.get(tabAllRoles.currentRow).id
                        cont2.newPersonRole(top.pid, rid)


                       ////console.log(entry.pid)

                       // cont1.getRoles(entry.pid)

                        //console.log(tabAllRoles.currentRow, top.record.peepID, top.record.roleID)
                    }
                }
            }
            Rectangle {
                id: act2
                width: parent.width
                height: parent.height/5
                anchors.top: act1.bottom
                anchors.left: parent.left


                radius: 10
                color: "red"
                visible: false
                Image {
                    anchors.verticalCenter: parent.verticalCenter
                    source: "../images/delete.png"
                    width: parent.width
                    height:parent.height
                }
                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        var rid = tabRoles.model.get(tabRoles.currentRow).id
                        //console.log(tabRoles.currentRow, riid)
                        cont2.deletePersonRole(top.pid, rid )

                        //console.log(entry.pid)
                        //cont1.getRoles(top.pid)


                    }
                }
            }

        }
        TableView {
            id: tabAllRoles
            anchors.left: spacer1.right


            anchors.top: tb1.bottom

            anchors.right:parent.right

            anchors.bottom: parent.bottom
            model: cont1.model1
            TableViewColumn {
                role: "description"
                title: "Role"
                width: parent.width

            }
            onFocusChanged: {
                if (focus) act1.visible = true
                else act1.visible =false
            }

            onCurrentRowChanged: {





            }

            Component.onCompleted:  {
                cont1.getAll()

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
        Cont.PersonController {
            id:cont2
            onReadyChanged: {

                    if (status == 200) {
                        //GET

                    }
                    if (status == 201) {
                        //POST
                        cont2.getPersonRoles(top.pid)


                    }
                    if (status == 202) {
                        //PUT
                        cont2.getPersonRoles(top.pid)

                    }
                    if (status == 203) {
                        //PUT
                        cont2.getPersonRoles(top.pid)

                    }
                    if (status == 204) {
                        //DELETE
                        cont2.getPersonRoles(top.pid)

                    }
                    if (status == 422) {

                        //error

                       //console.log(JSON.stringify(JSON.parse(jsn).errors))

                        entry.status = JSON.stringify(JSON.parse(jsn).errors)


                    }
            }
    }

 /*   Cont.RoleController {
        id: cont1
        property int model1Count: model1.count
        property int model2Count: model2.count
        property int model3Count: model3.count
        onReadyChanged: {
            if (ready) {
                cont1.getRoles(entry.pid)
            }
        }
        onModel2CountChanged: {
            selectRoles.clear()
            var ind
            for (ind = 0 ; ind < model2Count ; ind++) {
                selectRoles.append(cont1.model2.get(ind))
            }

           //console.log("c",selectRoles.count)

        }




        Component.onCompleted: {
            cont1.getAll()
            cont1.getRoles(entry.pid)

           //console.log(entry.pid)

            cont1.getAllIndex()

        }
    }
    ListModel {
        id: selectRoles


    }*/
}

