import QtQuick 2.4
import QtQuick.Controls 1.3
import QtQuick.Layouts 1.1
import QtQuick.Dialogs 1.2
import QtQuick.LocalStorage 2.0
import QtQuick.Controls.Styles 1.2
import QtQuick.Window 2.2
import "." as Local
import "../controllers" as Cont
import "../scripts/moment.js" as D
import "../components" as Comp

Rectangle {
    id: top
    width: parent.width
    height: parent.height
    property var rowheight
    color: "linen"
    property var index
    Component.onCompleted:  {
        if (visible) {

        //console.log("Booooo",Screen.width,Screen.height)
        if (top.index > 0 ) {

            cont2.getAll()
            cont3.getAll()
        }

        }
    }
    onVisibleChanged: {
        if (visible) {
            cont2.getAll()
            if (entry.lists.update) {
                console.log(JSON.stringify(entry.lists.loaded))
                cont3.updatePerson(JSON.stringify(entry.lists.loaded), entry.pid)
                entry.lists.update = false
                cont1.getEvent(editev.index)
            }
            else if (entry.lists.create) {
                console.log(JSON.stringify(entry.lists.loaded))
                cont3.newPerson(JSON.stringify(entry.lists.loaded))
                entry.lists.create = false
            }
        }
    }


   Row {
       width: parent.width
       height: parent.height

       ListView {
           id: volunteers
           x: 0
           width: parent.width/2

           height: parent.height
           delegate: volunteersDelegate
           headerPositioning: ListView.OverlayHeader
           header: volunteersHeader
           property int rowheight: (height -30)/rowcount | 0
           property var pa
           property var ra
           property int ready: 0
           property int rowcount
           onReadyChanged: {
               if (ready == 2) {
                   cont1.getEvent(top.index)
               }
           }

       }
       Component {
           id: volunteersDelegate
           Item {
               width: parent.width

               height: volunteers.rowheight

               Row {
                   width: volunteers.width
                   height: volunteers.rowheight

                   Rectangle {
                       width: volunteers.width/9 ;
                       height: parent.height
                       border.color: "grey"
                       border.width: 1


                        Text {  width: parent.width ;height: parent.height; horizontalAlignment: Text.AlignHCenter ;verticalAlignment: Text.AlignVCenter;text:  rowindex }
                   }
                   Rectangle {
                       border.color: "grey"
                       border.width: 1
                        width: volunteers.width/3 ;
                        height: parent.height
                        x: volunteers.width/9
                       Text { width: parent.width ;height: parent.height; wrapMode: Text.WordWrap  ;verticalAlignment: Text.AlignVCenter;text:  about }
                   }
                   Rectangle {
                       border.color: "grey"
                       border.width: 1
                       width: volunteers.width*2/9 ;
                       height: parent.height
                       x:volunteers.width*4/9
                   Text {  width: parent.width ;height: parent.height; wrapMode: Text.WordWrap  ;verticalAlignment: Text.AlignVCenter;text: role_id ? volunteers.ra[parseInt(role_id)] : "" }
                   }
                   Rectangle {
                       border.color: "grey"
                       border.width: 1
                        width: volunteers.width*3/9 ;
                        height: parent.height
                        x: volunteers.width*6/9
                   Text {  width: parent.width ;height: parent.height; wrapMode: Text.WordWrap  ; verticalAlignment: Text.AlignVCenter; text: person_id ? volunteers.pa[parseInt(person_id)] : "" }
                   }
               }
           }
       }
       Component {
           id: volunteersHeader
           Item {
               width: parent.width
               height: 30//parent.height/volunteers.model.count ? parent.height/volunteers.model.count : 30
               Row {
                   height:parent.height
                   Rectangle {
                       width: volunteers.width/9 ;
                       height: parent.height
                       border.color: "grey"
                       border.width: 1
                      Text { width: parent.width ;height: parent.height; verticalAlignment: Text.AlignVCenter;  text: '<b>Row:</b> ' }
                   }
                   Rectangle {
                       border.color: "grey"
                       border.width: 1
                        width: volunteers.width/3 ;
                        height: parent.height
                        x: volunteers.width/9
                      Text { width: parent.width ;height: parent.height; verticalAlignment: Text.AlignVCenter ;text: '<b>About:</b> ' }
                   }
                   Rectangle {
                       border.color: "grey"
                       border.width: 1
                       width: volunteers.width*2/9 ;
                       height: parent.height
                       x:volunteers.width*4/9
                       Text {  width: parent.width ;height: parent.height; verticalAlignment: Text.AlignVCenter;text: '<b>Job:</b> ' }
                   }
                   Rectangle {
                       border.color: "grey"
                       border.width: 1
                        width: volunteers.width*3/9 ;
                        height: parent.height
                        x: volunteers.width*6/9
                        Text {  width: parent.width ;height: parent.height; verticalAlignment: Text.AlignVCenter; text: '<b>Volunteer:</b> ' }
                   }
               }
           }
       }


       Rectangle {
           id: controls
           color: "yellow"
           visible: true
           //anchors.left: volunteers.right
           height:parent.height
           x: parent.width/2
           width:parent.width/8
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
                       //var rid = tabAllRoles.model.get(tabAllRoles.currentRow).id
                       //cont2.newPersonRole(top.pid, rid)

                      // console.log(entry.pid)
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
                       //var rid = tabRoles.model.get(tabRoles.currentRow).id
                       //console.log(tabRoles.currentRow, riid)
                       //cont2.deletePersonRole(top.pid, rid )

                       //console.log(entry.pid)
                       //cont1.getRoles(top.pid)


                   }
               }
           }
           Rectangle {
               id: addrole
               width: parent.width
               height: parent.height/5
               anchors.top: act2.bottom
               anchors.left: parent.left



               radius: 10
               color: "coral"

               Text {
                   width: parent.width ;height: parent.height; verticalAlignment: Text.AlignVCenter;
                   text: "ADD ROLE"
               }

               MouseArea {
                   anchors.fill: parent
                   onClicked: {
                       entry.push(editRoles)
                       //var rid = tabRoles.model.get(tabRoles.currentRow).id
                       //console.log(tabRoles.currentRow, riid)
                       //cont2.deletePersonRole(top.pid, rid )

                       //console.log(entry.pid)
                       //cont1.getRoles(top.pid)


                   }
               }
           }
           Rectangle {
               id: addperson
               width: parent.width
               height: parent.height/5
               anchors.top: addrole.bottom
               anchors.left: parent.left
                visible: false

               radius: 10
               color: "beige"

               Text {
                   width: parent.width ;height: parent.height; verticalAlignment: Text.AlignVCenter;
                   text: "ADD PERSON"
               }

               MouseArea {
                   anchors.fill: parent
                   onClicked: {
                       entry.push({item: editPerson, properties: {newp: true}})
                       //var rid = tabRoles.model.get(tabRoles.currentRow).id
                       //console.log(tabRoles.currentRow, riid)
                       //cont2.deletePersonRole(top.pid, rid )

                       //console.log(entry.pid)
                       //cont1.getRoles(top.pid)


                   }
               }
           }
       }
       TabView {
           id: rolesnpeople
            //anchors.left: controls.right
           x: parent.width*5/8
           width:parent.width*3/8
           height:parent.height
           property var rolemodel
           property var peoplemodel
           Tab {
               title: "Roles"
               onVisibleChanged: {
                   if (visible) {
                       addrole.visible = true
                       addperson. visible = false
                   }
               }

               TableView {
               id: tvroles
               model: rolesnpeople.rolemodel
               onCurrentRowChanged:  {
                   act1.visible = true
               }

               TableViewColumn {
                   role: "description"
                   title: "Role"
               }

               }
           }
           Tab {
               title: "People"
               onVisibleChanged: {
                   if (visible) {
                       addrole.visible = false
                       addperson. visible = true
                   }
               }
               TableView {
               id: tvpeople
               model: rolesnpeople.peoplemodel
               onCurrentRowChanged:  {
                   act1.visible = true
               }
               TableViewColumn {
                   role: "firstname"
                   title: "First Name"
               }
               TableViewColumn {
                   role: "lastname"
                   title: "Last Name"
               }

               }
           }
       }
   }//#02




   Cont.RoleController {
       id: cont2
               onM1readyChanged: {
                   if (cont2.model1.count > 0) {
                       console.log(cont2.model1.count)

                       var roleArray = []
                       var ind
                       for (ind = 0 ; ind < cont2.model1.count; ind++) {
                           roleArray[cont2.model1.get(ind).id]=cont2.model1.get(ind).description

                       }
                       volunteers.ra = roleArray
                       volunteers.ready += 1
                       rolesnpeople.rolemodel = cont2.model1



                   }

               }
               onReadyChanged: {

                       if (status == 200) {
                           //GET

                       }
                       if (status == 201) {
                           //POST
                           cont2.getAll()


                       }
                       if (status == 202) {
                           //PUT
                           cont2.getAll()
                           //console.log("PUTpf")

                       }
                       if (status == 203) {
                           //PUT
                           cont2.getAll()

                       }
                       if (status == 204) {
                           //DELETE
                           cont2.getAll()

                       }
                       if (status == 422) {

                           //error
                           console.log(JSON.stringify(JSON.parse(jsn).errors))
                           entry.status = JSON.stringify(JSON.parse(jsn).errors)


                       }
               }


   }
   Cont.PersonController {
       id: cont3
               onM1readyChanged: {
                   if (cont3.model1.count > 0) {
                       console.log(cont3.model1.count)
                       var personArray = []
                       var ind
                       for (ind = 0 ; ind < cont3.model1.count; ind++) {
                           personArray[cont3.model1.get(ind).id]=cont3.model1.get(ind).firstname + " " + cont3.model1.get(ind).lastname

                       }
                       volunteers.pa = personArray
                       volunteers.ready += 1
                       rolesnpeople.peoplemodel = cont3.model1


                   }

               }
               onReadyChanged: {

                       if (status == 200) {
                           //GET

                       }
                       if (status == 201) {
                           //POST
                           cont3.getAll()


                       }
                       if (status == 202) {
                           //PUT
                           cont3.getAll()
                           //console.log("PUTpf")

                       }
                       if (status == 203) {
                           //PUT
                           cont3.getAll()

                       }
                       if (status == 204) {
                           //DELETE
                           cont3.getAll()

                       }
                       if (status == 422) {

                           //error
                           console.log(JSON.stringify(JSON.parse(jsn).errors))
                           entry.status = JSON.stringify(JSON.parse(jsn).errors)


                       }
               }


   }



    Cont.EventController {
        id:cont1
        onM2readyChanged: {
            if (m2status == 200) {
                volunteers.model = cont1.model2.get(0).volunteersheets
                volunteers.rowcount = volunteers.model.count
                console.log("rowheight", volunteers.rowheight)
                 //top.initModel()
                //console.log(cont1.model2.get(0).volunteersheets.count, cont1.model2.get(0).volunteersheets.get(0).about)

            }
        }

        onReadyChanged: {
            console.log("readyChangedevcomp")

                if (status == 200) {
                    //GET
                    console.log(cont1.model2.get(0).volunteersheets.count, cont1.model2.get(0).volunteersheets.get(0).about)



                }
                if (status == 201) {
                    //POST
                    //cont1.getAll()
                    console.log("popop")
                    editev.returning("Post")
                    //editev.parent.repop()
                    if (ready) entry.pop()



                }
                if (status == 202) {
                    //PUT
                    editev.returning("Put")
                    console.log("popop")
                    //editev.parent.repop()
                     if (ready) entry.pop()

                }
                if (status == 203) {
                    //PUT
                    //cont1.getAll()

                }
                if (status == 204) {
                    //DELETE
                   // cont1.getAll()
                    editev.returning("Delete")
                    console.log("popop")
                    //editev.parent.repop()
                     if (ready) entry.pop()

                }
                if (status == 422) {

                    //error
                    console.log(JSON.stringify(JSON.parse(jsn).errors))
                    entry.status = JSON.stringify(JSON.parse(jsn).errors)


                }
        }

    }
    Component {
        id: editPerson
        Local.EditPersonComp {

        }
    }
    Component {
        id: editRoles
        Local.EditRolesComp {

        }
    }
} //#01






