import QtQuick 2.4
import QtQuick.Controls 1.3
import QtQuick.Layouts 1.1
import QtQuick.Window 2.2
import QtQuick.Dialogs 1.2
import QtQuick.LocalStorage 2.0
import Qt.WebSockets 1.0
import org.qtproject.testapi 1.0
import Qt.labs.folderlistmodel 2.1
import "." as Local
import "../controllers" as Cont
//import "../scripts/functions.js" as Func
import "../scripts/globals.js" as G
import "../scripts/moment.js" as D
import "../components" as Comp
//import "../scripts/bs64.js" as B




Item {
    id: personForm
    width: parent.width
    height: parent.height



    onVisibleChanged: {
        if (visible) {
            if (entry.lists.update) {
                //console.log(JSON.stringify(entry.lists.loaded))
                cont1.updatePerson(JSON.stringify(entry.lists.loaded), entry.pid)
                entry.lists.update = false
            }
            else if (entry.lists.create) {
                //console.log(JSON.stringify(entry.lists.loaded))
                cont1.newPerson(JSON.stringify(entry.lists.loaded))
                entry.lists.create = false
            }
        }
    }



    RowLayout {
        anchors.top: row1.bottom
        z: 5
        Button {
            id: button1
            visible: false
            text: qsTr("Press Me 1")
            onClicked: {

                var ind
                var buf = new ArrayBuffer
                for (ind = 0; ind <= 255; ind++) {
                    //console.log(String.fromCharCode(ind).charCodeAt(0))
                }





            }
        }

        Button {
            id: button2
            visible: false
            text: qsTr("Press Me 2")
            onClicked: {

            }
        }

        Button {
            id: button3
            visible: false
            text: qsTr("Press Me 3")
            onClicked: {
                var data = reader.read_b64("/home/robin/Dropbox/Messy_Church/02May2015Celebration/Service Flow - Andy.pptx")
                //console.log(data.length)
                var slice = addfiles.splitBuild(data)
                //console.log(slice.length)
                var parsarray = []
                var init = {attachment: {init: "", multi_part: ""}}
                parsarray[0] = init

                var ind
                for (ind = 0; ind < slice.length; ind++) {
                    parsarray[ind+1] = {attachment: {description:"new file", sequence: 1,how_many: 3,event_id: 7, multi_part: "", part: "",content_type: G.exttoMimeType["pptx"],filename: "Service Flow - Andy.pptx" }}
                    parsarray[ind+1]["attachment"]["part"] = slice[ind]
                    parsarray[ind+1]["attachment"]["how_many"] = slice.length
                    parsarray[ind+1]["attachment"]["sequence"] = ind+1


                    //console.log(slice[ind].length)
                }
                fileDialog.parsarray = parsarray
                fileDialog.arrind = 0
                addfiles.newAttachment(JSON.stringify(fileDialog.parsarray[0]))
            }
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
            navheight: personForm.height/8

        }
    }

    Row {
        id: row1
        x: 17
        y: 26
        z: 5
        width: parent.width
        height: tb1.deltah *0.9
        anchors.top: tb1.bottom

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
                //console.log(cont1.model2.count, cont1.model2.source)
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
                        //console.log("pid?", entry.lists.loaded.id)
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
                        //console.log(JSON.stringify(JSON.parse(jsn).errors))
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
        Component {
            id: updateUser
            Local.UpdateUser {

            }
        }
        FileDialog {
            id: fileDialog
            title: "Please choose a file"
            visible:false
            property var data
            property string filename
            property string content_type
            property bool donext: false
            property bool uperror: false
            property var parsarray: []
            property int arrind: 0


            onAccepted: {
                arrind = 0

                var path = fileUrl.toString();
                        // remove prefixed "file:///"
                path = path.replace(/^(file:\/{2})/,"");
                        // unescape html codes like '%23' for '#'

                var cleanPath = decodeURIComponent(path);
                folders.folder = fileUrl
                filename = fileUrl.toString().split("/").pop()

                //console.log("You chose: " + filename)
                content_type = "undefined"
                try {
                  content_type = G.exttoMimeType[filename.split(".").pop()]
                }
                catch(err) {
                   //console.log(err)
                }

               //console.log("mime", content_type)
                //var obj = new FileReader
                //var pars = {attachment: {description:"new file", sequence: 1,how_many: 3,event_id: 6, multi_part: "", part: "",content_type: fileDialog.content_type,filename: fileDialog.filename, file: {content_type: fileDialog.content_type, filename: fileDialog.filename, data: "split here"}}}

                var pars = {attachment: {description:"new file", sequence: 1,how_many: 3,event_id: 6, multi_part: "", part: "",content_type: fileDialog.content_type,filename: fileDialog.filename }}
                var pars1 = {attachment: {description:"new file", sequence: 1,init: "",how_many: 3, event_id: 6, multi_part: "", part: "",content_type: fileDialog.content_type,filename: fileDialog.filename }}
                var pars2 = {attachment: {description:"new file", sequence: 3,how_many: 3,event_id: 6, multi_part: "", part: "",content_type: fileDialog.content_type,filename: fileDialog.filename}}

                var init = {attachment: {init: "", multi_part: ""}}
                parsarray[0] = init
                parsarray[1] = {attachment: {description:"new file", sequence: 1,how_many: 3,event_id: 7, multi_part: "", part: "",content_type: fileDialog.content_type,filename: fileDialog.filename }}
                parsarray[2] = {attachment: {description:"new file", sequence: 1,how_many: 3,event_id: 7, multi_part: "", part: "",content_type: fileDialog.content_type,filename: fileDialog.filename }}
                parsarray[3] = {attachment: {description:"new file", sequence: 3,how_many: 3,event_id: 7, multi_part: "", part: "",content_type: fileDialog.content_type,filename: fileDialog.filename}}

                var parsString = JSON.stringify(pars)
                var cutup = parsString.split("split here")
                //console.log(cutup[0], "b",cutup[1])
                data = reader.read_b64(cleanPath)
                var slice = addfiles.splitBuild(data)
                //console.log(slice.length)
                var ind
                for (ind = 0; ind < slice.length; ind++) {
                    //console.log(slice[ind].length)
                }

                //var test = "0123456789012345678901234567890"
                //console.log(test.slice(0,10),test.slice(10,20),test.slice(20,test.length ))
                var dataend = data.length
                var data1 = data.slice(0, 5000)

                var data2 = data.slice(5000,10000)

                var data3 = data.slice(10000, data.length)
                parsarray[1]["attachment"]["part"] = data1
                parsarray[2]["attachment"]["part"] = data2
                parsarray[3]["attachment"]["part"] = data3
                parsarray[3]["attachment"]["sequence"] = 3
                //console.log(data1.length,data2.length,data3.length, data.length)

                addfiles.buildAttachment(JSON.stringify(parsarray[arrind]))
                /*console.log("one")
                fileDialog.donext = true
                wait.start()
                parsarray[1]["attachment"]["part"] = data1
                addfiles.buildAttachment(JSON.stringify(pars))
               //console.log("two")
                fileDialog.donext = true
                wait.start()
                pars["attachment"]["part"] = data2
                addfiles.buildAttachment(JSON.stringify(pars))
               //console.log("three")
                fileDialog.donext = true
                wait.start()
                pars2["attachment"]["part"] = data3
                pars2["attachment"]["sequence"] = 3
                addfiles.buildAttachment(JSON.stringify(pars2))
               //console.log("four")
                wait.start()

                //addfiles.newAttachment(reader.parameterstring)
                visible = false*/
            }
            onRejected: {
                //console.log("Canceled")
                visible = false
            }
            function dobuild(pars) {
                addfiles.newAttachment(JSON.stringify(pars))
            }

            //Component.onCompleted: visible = true
        }
        Timer {
            id: wait
            interval: 10000; running: false; repeat: false
              onTriggered: {
                  //console.log("trig")
                  if (fileDialog.donext) {
                      //console.log(".")
                     restart()
                  }

              }
        }

        FileReader {
            id: reader
        }
        FolderListModel {
            id: folders
        }
        Cont.AttachmentController {
            id: addfiles
            Component.onCompleted: {
                getAll()
                getAttachment(14)
            }
            onReadyChanged: {

                    if (status == 200) {
                        //console.log(jsn)


                    }
                    if (status == 201) {



                    }
                    if (status == 202) {
                        fileDialog.arrind += 1
                        //console.log("done",fileDialog.arrind )
                        fileDialog.dobuild(fileDialog.parsarray[fileDialog.arrind])
                    }

                    if (status == 422) {

                                     //error
                                     //console.log(JSON.stringify(JSON.parse(jsn).errors))
                                     fileDialog.uperror = false


                                 }
                    if (status == 500) {

                                     //error
                                     //console.log(JSON.stringify(JSON.parse(jsn).errors))
                                     fileDialog.uperror = true
                                        fileDialog.donext = false


                                 }
                         }
                     }
                     Cont.HTTP {
                         id: http
                     }
                     

             }
