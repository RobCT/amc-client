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

            cont1.getEvent(top.index)
            cont3.getAll()
        }

        }
    }
    onVisibleChanged: {
        if (visible) {
            cont3.getAll()

        }
    }
    ToolBar {
        id: tb1
        width: parent.width
        height: (parent.height/11) | 0
        anchors.top: parent.top

        property int deltah: parent.height - height
        Local.ToolBarContent {
            id: tbint
            width:parent.width
            height:parent.height
            navheight: editev.height/8

        }
    }

   Row {
       width: parent.width
       height: tb1.deltah
       anchors.top: tb1.bottom



       ListView {
           id: volunteers
           x: 0
           width: parent.width/2

           height: parent.height
           delegate: volunteersDelegate
           headerPositioning: ListView.OverlayHeader
           header: volunteersHeader
           property int rowheight: (height -30)/4 //rowcount | 0
           property var pa
           property var ra
           property int ready: 0
           property int rowcount
           property var sheetid
           property var currentIndex
           property string dialogin
           property string dialogout
           onReadyChanged: {
               if (ready == 2) {
                   cont1.getEvent(top.index)
               }
           }

       }


       Component {
           id: volunteersDelegate
           Item {
               id: vold
               width: parent.width

               height: volunteers.rowheight
               function rclicked() {
                   //console.log(index, id)
                   act2.visible=true
                   act1.visible=false
                   volunteers.sheetid = id
                   volunteers.currentIndex = index
                  //console.log("rclick",volunteers.sheetid , volunteers.model.get(volunteers.currentIndex).id)

               }
               Dialog {
                   id: getInp
                   y: 20
                   onVisibleChanged: {
                       if (visible) {
                       inp.text = volunteers.dialogin
                      //console.log("diain", volunteers.dialogin)
                       }
                   }
                    Rectangle {
                        id: getInpRect
                        implicitWidth: inp.implicitWidth
                        implicitHeight: inp.implicitHeight
                       TextField {
                           id: inp
                           visible: true
                           //width: parent.width
                           //height: parent.height
                           //x: (volunteers.width/9 + volunteers.width/60) | 0
                           anchors.verticalCenter: getInpRect.verticalCenter
                           style: TextFieldStyle {
                               id: styleit
                               font.pointSize: 26
                               background: Rectangle {
                                   //color: index == volunteers.currentIndex ? "aquamarine" : "transparent"
                                   border.width: 1}
                           }
                           //height: parent.height  ;
                           verticalAlignment: Text.AlignVCenter;
                           //text: volunteers.model.get(volunteers.currentIndex).about
                           onEditingFinished: {
                               aboutma.enabled = true

                               cont4.updateSheet(JSON.stringify({"about": text}),id)
                           }
                           onVisibleChanged:  {
                               if (visible) {
                               text = volunteers.dialogin
                              //console.log("diain", volunteers.dialogin)
                               }
                           }
                       }

                   }
                    onAccepted: {
                        aboutma.enabled = true
                        cont4.updateSheet(JSON.stringify({"about": inp.text}),id)
                    }
               }

               Row {
                   width: volunteers.width
                   height: volunteers.rowheight

                   Rectangle {
                       width: volunteers.width/9 ;
                       height: parent.height
                       border.color: "grey"
                       border.width: 1
                       color: index == volunteers.currentIndex ? "aquamarine" : "transparent"


                        Text {  width: parent.width ;height: parent.height; horizontalAlignment: Text.AlignHCenter ;verticalAlignment: Text.AlignVCenter;text:  rowindex }
                        MouseArea {
                            width: parent.width
                            height: parent.height
                            onClicked:  {
                                vold.rclicked()
                            }
                        }
                   }
                   Rectangle {
                       border.color: "grey"
                       border.width: 1
                       color: index == volunteers.currentIndex ? "aquamarine" : "transparent"
                        width: volunteers.width/3 ;
                        height: parent.height
                        x: volunteers.width/9 | 0
                        Text { id: disp;  width: parent.width ;height: parent.height; wrapMode: Text.WordWrap  ;verticalAlignment: Text.AlignVCenter;text: about }

                       TextField {
                           id: inp2
                           visible: false
                           //width: parent.width - parent.width/10 ;
                           //x: (volunteers.width/9 + volunteers.width/60) | 0
                           y: parent.y + parent.height/2 - height/2
                           style: TextFieldStyle {
                               id: styleit
                               font.pointSize: 26
                               background: Rectangle {
                                   color: index == volunteers.currentIndex ? "aquamarine" : "transparent"
                                   border.width: 0}
                           }
                           //height: parent.height  ;
                           verticalAlignment: Text.AlignVCenter;
                           text: about
                           onEditingFinished: {
                               aboutma.enabled = true
                               disp.visible = true
                               inp.visible = false
                               cont4.updateSheet(JSON.stringify({"about": text}),id)
                           }

                       }
                       MouseArea {
                           id: aboutma
                           width: parent.width
                           height: parent.height
                           onClicked:  {
                               vold.rclicked()
                           }
                           onPressAndHold: {
                               enabled = false
                               volunteers.dialogin = about
                              //console.log("diain1", volunteers.dialogin)
                               //disp.visible = false
                               //inp.visible = true
                               getInp.open()

                           }
                       }
                   }
                   Rectangle {
                       border.color: "grey"
                       border.width: 1
                       color: index == volunteers.currentIndex ? "aquamarine" : "transparent"
                       width: volunteers.width*2/9 ;
                       height: parent.height
                       x:volunteers.width*4/9
                   Text {  width: parent.width ;height: parent.height; wrapMode: Text.WordWrap  ;verticalAlignment: Text.AlignVCenter;text: role_id ? volunteers.ra[parseInt(role_id)] : "" }
                   MouseArea {
                       width: parent.width
                       height: parent.height
                       onClicked:  {
                           vold.rclicked()
                       }
                   }
                   }
                   Rectangle {
                       border.color: "grey"
                       border.width: 1
                       color: index == volunteers.currentIndex ? "aquamarine" : "transparent"
                        width: volunteers.width*3/9 ;
                        height: parent.height
                        x: volunteers.width*6/9
                   Text {  width: parent.width ;height: parent.height; wrapMode: Text.WordWrap  ; verticalAlignment: Text.AlignVCenter; text: person_id ? volunteers.pa[parseInt(person_id)] : "" }
                   MouseArea {
                       width: parent.width
                       height: parent.height
                       onClicked:  {
                           vold.rclicked()
                       }
                   }
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
                       if (rolesnpeople.currentIndex == 1) {
                           var pid =  rolesnpeople.tvpCurrentRecord.id
                           cont4.updateSheet(JSON.stringify({"person_id": pid}), volunteers.model.get(volunteers.currentIndex).id)

                       }
                       else {
                           var rid =  rolesnpeople.tvrCurrentRecord.id
                           cont4.newSheet(JSON.stringify({"event_id": top.index, "about": "add your text here", "rowindex": volunteers.model.count + 1, "role_id": rid}))
                           //cont1.getEvent(top.index)
                       }

                       //var rid = tabAllRoles.model.get(tabAllRoles.currentRow).id
                       //cont2.newPersonRole(top.pid, rid)

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
                       cont4.deleteSheet(volunteers.model.get(volunteers.currentIndex).id)

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
                   text: "CLONE"
               }

               MouseArea {
                   anchors.fill: parent
                   onClicked: {

                    cont4.cloneSheet(JSON.stringify({"event_id": top.index , "template_id": tvtemplates.model.get(tvtemplates.currentRow).id}))

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
           Rectangle {
               id: addsheet
               width: parent.width
               height: parent.height/5
               anchors.top: addrole.bottom
               anchors.left: parent.left
                visible: false

               radius: 10
               color: "palegoldenrod"

               Text {
                   width: parent.width ;height: parent.height; verticalAlignment: Text.AlignVCenter;
                   text: "ADD VOLUNTEER"
               }

               MouseArea {
                   anchors.fill: parent
                   onClicked: {



                   }
               }
       }
       }



               TableView {
               id: tvtemplates

               onActivated: {
                   if (focus) {
                   act1.visible = true
                   act2.visible = false
                   }
               }
               onCurrentRowChanged: {
                   //rolesnpeople.tvrCurrentRecord = model.get(currentRow)
               }

               TableViewColumn {
                   role: "title"
                   title: "Template"
               }

               }



   }//#02





   Cont.TemplateController {
       id: cont3
               onM1readyChanged: {
                   if (cont3.model1.count > 0) {

                       tvtemplates.model = cont3.model1


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
                           //cont3.getAll()
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
                          //console.log(JSON.stringify(JSON.parse(jsn).errors))
                           entry.status = JSON.stringify(JSON.parse(jsn).errors)


                       }
               }


   }
   Cont.SheetController {
       id: cont4

               onReadyChanged: {

                       if (status == 200) {
                           //GET

                       }
                       if (status == 201) {
                           //POST
                           entry.push({item: editSheet,replace: true, properties: {index: top.index}})


                       }
                       if (status == 202) {
                           //PUT
                           cont1.getEvent(top.index)
                           //console.log("PUTpf")

                       }
                       if (status == 203) {
                           //PUT
                           cont1.getEvent(top.index)

                       }
                       if (status == 204) {
                           //DELETE
                           cont1.getEvent(top.index)

                       }
                       if (status == 422) {

                           //error
                          //console.log(JSON.stringify(JSON.parse(jsn).errors))
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
               //console.log("rowheight", volunteers.rowheight)
                 //top.initModel()
                //console.log(cont1.model2.get(0).volunteersheets.count, cont1.model2.get(0).volunteersheets.get(0).about)

            }
        }

        onReadyChanged: {
           //console.log("readyChangedevcomp")

                if (status == 200) {
                    //GET
                   //console.log(cont1.model2.get(0).volunteersheets.count, cont1.model2.get(0).volunteersheets.get(0).about)



                }
                if (status == 201) {
                    //POST
                    //cont1.getAll()
                   //console.log("popop")
                    editev.returning("Post")
                    //editev.parent.repop()
                    if (ready) entry.pop()



                }
                if (status == 202) {
                    //PUT
                    editev.returning("Put")
                   //console.log("popop")
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
                   //console.log("popop")
                    //editev.parent.repop()
                     if (ready) entry.pop()

                }
                if (status == 422) {

                    //error
                   //console.log(JSON.stringify(JSON.parse(jsn).errors))
                    entry.status = JSON.stringify(JSON.parse(jsn).errors)


                }
        }

    }
    Component {
        id: editSheet
        Local.EditVolunteerSheet {

        }
    }
    Component {
        id: editRoles
        Local.EditRolesComp {

        }
    }
} //#01






