import QtQuick 2.4
import QtQuick.Controls 1.3
import QtQuick.Layouts 1.1
import QtQuick.Dialogs 1.2
import QtQuick.LocalStorage 2.0
import QtQuick.Controls.Styles 1.2
import QtQuick.Window 2.2
import org.qtproject.testapi 1.0
import "." as Local
import "../controllers" as Cont
import "../scripts/moment.js" as D
import "../components" as Comp
import "../scripts/globals.js" as G

Rectangle {
    id: editev

    property var index
    property int room
    property var setDate
    property bool my_calendar: false
    property var usern
    width: parent.width
    height: parent.height



    Component.onCompleted:  {

        hamburger.connect(ham)

        if (visible) {

        //console.log("Booooo",Screen.width,Screen.height)
        if (editev.index > 0 ) {
            cont4.getAll()
            cont3.getEventRoom(editev.index)
            cont1.getEvent(editev.index)
        }
        else {
            df1.date = editev.setDate
        }
        }
    }
    function ham() {
        if (topRect.visible) topRect.visible = false
        else topRect.visible  = true
    }
    //x: (Screen.desktopAvailableWidth - width)/2
    //y: (Screen.desktopAvailableHeight - height)/2
    //signal returning(string whereFrom)





Rectangle {
    id: top
    width: parent.width
    height: parent.height
    color: "linen"
    property int actionheight

    onVisibleChanged: {
        if (visible) {

       // console.log("Booooo",Screen.width,Screen.height)
        if (editev.index > 0 ) {
            //console.log(entry.editProperties.editDone,entry.editProperties.editTime,entry.editProperties.editType)
            if (entry.editProperties.editDone && entry.editProperties.editType == "Date") {
                entry.editProperties.editObject.date = entry.editProperties.editDate
            }
            else if (entry.editProperties.editDone && entry.editProperties.editType == "Time") {
                entry.editProperties.editObject.time = entry.editProperties.editTime
                //console.log("here")
            }
            else if (entry.editProperties.editDone && entry.editProperties.editType == "Text") {
                entry.editProperties.editObject.text = entry.editProperties.editText
            }
            else  cont1.getEvent(editev.index)

        }
        else {
            df1.date = editev.setDate
        }
        }
    }

   function initModel() {
        //console.log("init")
        if (cont1.model2.count > 0) {
        // console.log("doinit")
        textField1.text = cont1.model2.get(0).title
        df1.date = cont1.model2.get(0).eventdate
        te1.time = cont1.model2.get(0).eventstart
        te2.time = cont1.model2.get(0).eventend
         if (cont1.model2.get(0).volunteersheets.count) {

             actionheight = 4
             clone.visible = false
             sheets.visible = true
         }
         else {
             sheets.visible = false
             actionheight = 4
             clone.visible = true
         }

        }

    }
   function stringUp() {
       var jsn
        if (editev.my_calendar)
            jsn = {"event":{"title": textField1.text, "eventdate": df1.date, "eventstart": te1.returnTime, "eventend": te2.returnTime , "is_private": true, "user_id": entry.signin.id}}
        else
            jsn = {"event":{"title": textField1.text, "eventdate": df1.date, "eventstart": te1.returnTime, "eventend": te2.returnTime , "is_private": false, "user_id": entry.signin.id}}

       return JSON.stringify((jsn))

   }
   Rectangle {
       id: dragrect
       width: parent.width/30
       height: parent.height
       opacity: 0
       x: parent.width*3/4 - parent.width/30
       anchors.top: parent.top
       MouseArea {
           anchors.fill: parent
           drag.target: parent;
           drag.axis: Drag.XAxis
       }
   }
   Rectangle {
       id: topRect
       //width: parent.width/4
       height: parent.height
       anchors.right: parent.right
       anchors.left: dragrect.right
       border.width: 1
       visible: false
       color: "linen"
       Button {
           id: addmessage
           width: parent.width
           onClicked: {
               messInRect.visible ? messInRect.visible = false : messInRect.visible = true
           }
       }
       Image {
           id: draghandle
           source: "../images/horizontal_drag.png"
           width:top.width/40
           height: width*3/4
           anchors.right: topRect.left
           anchors.verticalCenter: topRect.verticalCenter
       }


       Rectangle {
           id: messInRect
           width:parent.width
           height: messIn.implicitHeight + sendMessage.height
           visible: false
           anchors.top: addmessage.bottom
           border.width: 1
           Flickable {
                id: flick2

                width: parent.width; height:  messIn.implicitHeight;
                contentWidth: messIn.paintedWidth
                contentHeight: messIn.paintedHeight
                clip: true

                function ensureVisible(r)
                {
                    if (contentX >= r.x)
                        contentX = r.x;
                    else if (contentX+width <= r.x+r.width)
                        contentX = r.x+r.width-width;
                    if (contentY >= r.y)
                        contentY = r.y;
                    else if (contentY+height <= r.y+r.height)
                        contentY = r.y+r.height-height;
                }

                TextEdit {
                    id: messIn
                    width: flick2.width
                    height: flick2.height
                    selectByMouse: true
                    focus: true
                    wrapMode: TextEdit.Wrap
                    onCursorRectangleChanged: flick2.ensureVisible(cursorRectangle)
                }
            }

       Button {
           id: sendMessage
           anchors.top: flick2.bottom
           width: parent.width
           onClicked: {
               parent.visible = false
               sock.sendMessage(messIn.text)
               cont2.newMessage(JSON.stringify({body: messIn.text, event_id: editev.index}))
           }
       }
       }
       FlipBar {
           id: flipbar
           property bool flipped: false
           //delta: startRotation
           width: parent.width
           anchors.top :messInRect.visible ? messInRect.bottom : addmessage.bottom
           anchors.bottom: parent.bottom
        front: Rectangle {
            anchors.fill: flipbar
       ListView {
           id: lvmessage
           anchors.fill: parent

           //height: parent.height- messInRect.height - addmessage.height

           delegate: messageDelegate
           model: lmmessage

           Component.onCompleted: {
               cont2.getAllForRoom(index)
           }



       }
        }
        back: Rectangle {
            id: attachments
            anchors.fill: flipbar
            TableView {
                id: tvattach
                model: addfiles.model1
                width: parent.width
                anchors.top: parent.top
                anchors.bottom: addone.top
                TableViewColumn {
                    role: "filename"
                    title: "file"
                }
                TableViewColumn {
                    role: "file_size"
                    title: "size"

                }
                TableViewColumn {
                    role: "file_updated_at"
                    title: "updated"

                }

                onCurrentRowChanged: {
                    addfiles.getAttachment(addfiles.model1.get(currentRow).id)
                }

            }

            Button {
                id: addone
                anchors.bottom: flip.top
                width: parent.width/2
                text: "ADD"
                onClicked: {
                    fileDialog.open()
                }
            }
            Button {
                id: getatt
                anchors.bottom: adddesc.top
                anchors.left: addone.right
                width: parent.width/2
                text: "OPEN"
                onClicked: {
                                    Qt.openUrlExternally(addfiles.model2.get(0).file)
                }
            }
            TextField {
                id: adddesc
                placeholderText: "optional file description"
                anchors.left: flip.right
                anchors.bottom: parent.bottom
                width: parent.width/2

            }
            Button {
                id: flip
                anchors.bottom: delattach.top
                width: parent.width/2
                text: "Flip back"

                onClicked: {
                    flipbar.flipDown()
                    flipbar.flipped = true
                }
            }
            Button {
                id: delattach
                anchors.bottom:  parent.bottom
                width: parent.width/2
                text: "DEL"
                onClicked: {
                    addfiles.deleteAttachment(addfiles.model1.get(tvattach.currentRow).id)
                }
            }


        }
       }
       Component {
           id: messageDelegate
           Item {
               id: del1
               width: lvmessage.width
               height: uname.implicitHeight + body.implicitHeight

               Rectangle {
                   width:parent.width
                   height: parent.height


                   border.color: "blue"
                   border.width: 0.5
                   color: "#2699bf"

                   Rectangle { color: "#33ccff"; width: parent.width; height: 1 }
                   Rectangle { color: "#1a6680"; width: parent.width; height: 1; anchors.bottom: parent.bottom }

                   Text {
                       id: uname
                   width: parent.width ; horizontalAlignment: Text.AlignLeft ;//verticalAlignment: Text.AlignVCenter;
                   wrapMode: Text.WordWrap
                   text: name + msgDate()
                   anchors { left: parent.left; leftMargin: 10; top: parent.top; topMargin: 0 }
                   font.pixelSize: top.width/48 | 0
                   font.bold: true
                   color: "white"
                   linkColor: "white"
                   function msgDate() {
                       var dt = D.moment(created_at)
                       var dtnow = D.moment(new Date())
                       if (dt.year() == dtnow.year() && dt.month() == dtnow.month() && dt.date() == dtnow.date()) {
                           return dt.format('   h:m a')
                       }
                       else {
                           return dt.format('   Do MMM YYYY')
                       }
                   }
               }
                   Text {
                       id: body
                   width: parent.width ; horizontalAlignment: Text.AlignLeft ;//verticalAlignment: Text.AlignVCenter;
                   wrapMode: Text.WordWrap
                   text: message
                   anchors { left: parent.left; leftMargin: 10; top: uname.bottom; topMargin: 0; right: parent.right; rightMargin: 10  }
                   font.pixelSize: top.width/48 | 0
                   font.bold: false
                   color: "#adebff"
                   linkColor: "white"
               }
                   MouseArea {
                       anchors.fill: parent
                       onPressAndHold: {
                           flipbar.flipUp()
                           flipbar.flipped = true
                       }
                   }
               }

           }

       }


    }

        Row {
            height: parent.height
            width: !topRect.visible ? parent.width : parent.width- topRect.width - dragrect.width | 0

        Column {
            id: column2
            //anchors.left: parent.left
            height:parent.height
            //anchors.top: eventSelect.bottom
            //anchors.bottom: parent.bottom
            width: parent.width*7/16

            Rectangle {

                width: parent.width
                y: parent.height/5
                color: "beige"
                radius: 4
                height: parent.height/5



            Text {
                id: text1
                height: parent.height
                text: qsTr("Title")
                font.pixelSize: height * 0.3
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: parent.left
                anchors.leftMargin: parent.width/6
                verticalAlignment: Text.AlignVCenter


            }
            }
            Rectangle {
                width: parent.width
                color: "beige"
                radius: 4
                height: parent.height/5

            Text {
                id: text2

                text: qsTr("Date")
                font.pixelSize: height * 0.3
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: parent.left
                anchors.leftMargin: parent.width/6
                verticalAlignment: Text.AlignVCenter
                height: parent.height

            }
            }
            Rectangle {
                width: parent.width
                color: "beige"
                radius: 4
                height: parent.height/5

            Text {
                id: text3

                text: qsTr("Start time")
                font.pixelSize: height * 0.3

                anchors.verticalCenter: parent.verticalCenter
                anchors.left: parent.left
                anchors.leftMargin: parent.width/6
                verticalAlignment: Text.AlignVCenter
                height: parent.height

            }
            }
            Rectangle {
                width: parent.width
                color: "beige"
                radius: 4
                height: parent.height/5

            Text {
                id: text4

                text: qsTr("End")
                font.pixelSize: height * 0.3
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: parent.left
                anchors.leftMargin: parent.width/6
                verticalAlignment: Text.AlignVCenter
                height: parent.height
            }


            }
            Rectangle {
                width: parent.width
                color: "beige"
                radius: 4
                height: parent.height/5

            Text {
                id: text5

                text: qsTr("Type")
                font.pixelSize: height * 0.3
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: parent.left
                anchors.leftMargin: parent.width/6
                verticalAlignment: Text.AlignVCenter
                height: parent.height


            }
            }
        }

        Rectangle {
            id: rectangle1
            //anchors.left: column2.right
            //anchors.top: eventSelect.bottom
            //anchors.bottom: parent.bottom
            height:parent.height
            width: parent.width/8


            color: "#ffffff"

            MouseArea {
                anchors.fill: parent
                onClicked: {

 //                   entry.lists.loaded = top.record
   //                 console.log("mmm", entry.lists.loaded.date)
     //               entry.pop()
                }
            }
            Column {
                width: parent.width
                height: parent.height

            Rectangle {
                id: upcreate
                radius: 6
                width: parent.width
                height: parent.height/top.actionheight
                color: "lightyellow"
                Text {
                    anchors.verticalCenter:  parent.verticalCenter
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: editev.index === 0 ? "Create" : "Update"
                }
                MouseArea {
                    width: parent.width
                    height: parent.height
                    onClicked:  {
                        if (editev.index > 0) {
                            //tim2.dt = D.moment(entry.lists.loaded.date)
                            cont1.updateEvent(top.stringUp(), editev.index)
                            //console.log(top.stringUp())

                            //tim2.start()
                        }
                        else {
                            //top.newp = false
                            //entry.lists.update = true
                            //entry.lists.create = false
                            //tim2.dt = D.moment(entry.lists.loaded.date)
                            cont1.newEvent(top.stringUp())
                            //console.log(top.stringUp())

                            //tim2.start()


                        }


                    }
                }

            }
            Rectangle {
                id: save
                radius: 6
                width: parent.width
                height: parent.height/top.actionheight
                color: "skyblue"
                Text {
                    anchors.verticalCenter:  parent.verticalCenter
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: "New"
                }
                MouseArea {
                    width: parent.width
                    height: parent.height
                    onClicked:  {
                        //console.log(editev.index)
                        if (editev.index > 0 ) {
                            cont1.getEvent(index)
                        }

 //                       top.record.id_type_ae = cont1.model3.get(0).id_amc_event_type




                    }
                }

            }
            Rectangle {
                id: del
                radius: 6
                width: parent.width
                height: parent.height/top.actionheight
                color: "red"
                Text {
                    anchors.verticalCenter:  parent.verticalCenter
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: "Delete"
                }
                MouseArea {
                    width: parent.width
                    height: parent.height
                    onClicked:  {

                       cont1.deleteEvent(editev.index)


                    }
                }
            }
            Rectangle {
                id: sheets
                radius: 6
                width: parent.width
                height: parent.height/top.actionheight
                color: "steelblue"
                visible: false
                Text {
                    anchors.verticalCenter:  parent.verticalCenter
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: "Volunteer\n Sheet"
                }
                MouseArea {
                    width: parent.width
                    height: parent.height
                    onClicked:  {

                       entry.push({item: sheet, properties: {index: editev.index}})


                    }
                }
            }
            Rectangle {
                id: clone
                radius: 6
                width: parent.width
                height: parent.height/top.actionheight
                color: "aqua"
                visible: false
                Text {
                    anchors.verticalCenter:  parent.verticalCenter
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: "Clone \nVolunteer\n Sheets"
                }
                MouseArea {
                    width: parent.width
                    height: parent.height
                    onClicked:  {

                        entry.push({item: cloneSheet, properties: {index: editev.index}})


                    }
                }
            }
            }
        }
        Column {
            id: column1
            //anchors.left: rectangle1.right
            //anchors.top: eventSelect.bottom
            //anchors.bottom: parent.bottom
            height:parent.height
            width: parent.width*7/16

            Flickable {
                 id: flick

                 width: parent.width; height: parent.height/5;
                 contentWidth: textField1.paintedWidth
                 contentHeight: textField1.paintedHeight
                 clip: true

                 function ensureVisible(r)
                 {
                     if (contentX >= r.x)
                         contentX = r.x;
                     else if (contentX+width <= r.x+r.width)
                         contentX = r.x+r.width-width;
                     if (contentY >= r.y)
                         contentY = r.y;
                     else if (contentY+height <= r.y+r.height)
                         contentY = r.y+r.height-height;
                 }

                 TextEdit {
                     id: textField1
                     width: flick.width
                     height: flick.height
                     font.pixelSize:  height * 0.3

                     focus: true
                     wrapMode: TextEdit.Wrap
                     onCursorRectangleChanged: flick.ensureVisible(cursorRectangle)
                 }
             }

/*            TextField {
                id: textField1

                width: parent.width
                placeholderText: qsTr("Text Field")

                height: parent.height/5
                onEditingFinished: {


                }
            }*/

            Comp.DateEdit {
                id: df1

                width: parent.width
                height: parent.height/5
                ratio: 0.8
                bcolor: "white"
                //date:
                onGoodDateChanged: {
                    //if (!top.newp) entry.lists.update = true
                   // else entry.lists.create = true
                    //console.log(date,top.record.date)
                    //top.record.events.date = D.moment(date).format("YYYY-MM-DD")
                    //console.log(date,top.record.events.date)
                }

            }

            Comp.TimeTumblerInput {
                id:te1
                width:parent.width
                height: parent.height/5
            }


  /*          Comp.TimeEdit {
                id: te1
                width: parent.width
                //time:
                height: parent.height/5
                ratio: 0.8
                bcolor: "white"
                onTimeChanged: {

                }
                onTimeActiveFocusChanged:  {

                        if (editev.visible) {
                        entry.editProperties = {toEdit: time, editDone: false, recordId: editev.index, editObject: te1, editType: "Time"}
                        entry.push({item: timeInput, properties: {toEdit: time, recordId: editev.index}})
                        }

                }

                onFocusChanged: {
                    if (!focus) {
                        Qt.inputMethod.hide()
                    }
                    else {
                        entry.editProperties = {toEdit: time, editDone: false, recordId: editev.index, editObject: df1}
                        entry.push({item: editText, properties: {toEdit: time, recordId: editev.index}})
                    }
                }

            } */

            Comp.TimeTumblerInput {
                id:te2
                width:parent.width
                height: parent.height/5
            }
 /*           Comp.TimeEdit {
                id:te2
                width: parent.width
                //time:
                height: parent.height/5
                ratio: 0.8
                bcolor: "white"

                onTimeChanged: {

                }
                onFocusChanged: {
                    if (!focus) {
                        Qt.inputMethod.hide()
                    }
                }

            }*/

        }
        }
        Component {
            id:sheet
        Local.EditVolunteerSheet {

        }
        }

    Cont.EventController {
        id:cont1
        onM2readyChanged: {
            if (m2status == 200) {
                 top.initModel()
            }
        }

        onReadyChanged: {
            //console.log("readyChangedevcomp")

                if (status == 200) {
                    //GET
                    top.initModel()

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
        id: cloneSheet
        Local.CloneVolunteerSheet {

        }
    }
    Component {
        id: dateInput
        Comp.DateInput {

        }
    }
    Component {
        id: timeInput
        Comp.TimeInput {

        }
    }
    Cont.MessageController {
        id: cont2
        onM1readyChanged: {
            //console.log(m1status)
            if (m1status == 200) {
                var ind
                for (ind = 0; ind < model1.count; ind++) {
                    lmmessage.insert(0,{name: editev.usern[model1.get(ind).user_id], message: model1.get(ind).body, created_at: model1.get(ind).created_at} )
                    //console.log(editev.usern, editev.usern.length, editev.usern[model1.get(ind).user_id])
                }

            }
        }
    }
    Cont.UserController {
        id: cont4
        onM1readyChanged: {
            //console.log(m1status)
            if (m1status == 200) {
                var ind
                var usernames = {}

                for (ind = 0; ind < model1.count; ind++) {
                    if (model1.get(ind).username.length)
                    usernames[model1.get(ind).id] = model1.get(ind).username

                    else {
                        var un = model1.get(ind).email.split('@')[0];
                        usernames[model1.get(ind).id] = un
                    }


                }
                editev.usern = usernames


            }
        }
    }
    Cont.RoomController {
        id: cont3
        onM1readyChanged: {
            //console.log(m1status)
            if (m1status == 200) {
                //console.log(model1.count)
                 if (model1.count == 1) {
                     editev.room = model1.get(0).id

                     //console.log("roomid", editev.room)
                 }
            }
            if (m1status == 201) {
                 if (model1.count == 1) {
                     editev.room = model1.get(0).id
                     //console.log("roomid", editev.room)
                 }
            }
        }
    }
    Cont.SocketController {
        id: sock
        room: editev.room
        onNewMessageChanged: {
            if (newMessage) {
                //console.log("room check", editev.room, message.name, message.room, message.message)
                if (editev.room == message.room) {
                lmmessage.insert(0,message)
                }
                //console.log("added", lmmessage.count)
            }

        }
        Component.onCompleted: {

            active = true
        }
    }
    ListModel {
        id: lmmessage

    }
    FileDialog {
        id: fileDialog
        visible:false
        property var data
        property string filename
        property string content_type
        function createAttachment() {
            var params = {attachment: {description: adddesc.text, event_id: editev.index, content_type: content_type,filename: filename }}

            addfiles.newAttachment(JSON.stringify(params))
        }



        onAccepted: {


            var path = fileUrl.toString();
                    // remove prefixed "file:///"
            path = path.replace(/^(file:\/{2})/,"");
                    // unescape html codes like '%23' for '#'

            var cleanPath = decodeURIComponent(path);
            filename = fileUrl.toString().split("/").pop()
            content_type = "undefined"
            try {
              content_type = G.exttoMimeType[filename.split(".").pop()]
            }
            catch(err) {
                console.log("error",err)
            }
            //var datatext = reader.read(cleanPath)
            var ind
            //console.log(datatext)
            reader.readbytes(cleanPath)
            //data = reader.read_b64(cleanPath)
            //console.log(data.length)
            //addfiles.upload = B.b64ToByteArray(data)
            //addfiles.upload = data
            addfiles.put = ""
            reader.uploading = true
            createAttachment()
            //console.log(dataraw.size)
            //addfiles.sendAttachment(data,content_type,filename, editev.index,  adddesc.text)

        }


    }

    Cont.AttachmentController {
        id: addfiles
        Component.onCompleted: {
            getAllForEvent(editev.index)

        }
        onPutChanged: {
            if (reader.uploading) {
                reader.uploading = false
                reader.upload(put)
            }
        }

        onReadyChanged: {

                if (status == 200) {



                }
                if (status == 201) {

                    getAllForEvent(editev.index)

                }
                if (status == 202) {

                }
                if (status ==204) {

                    getAllForEvent(editev.index)

                }

                if (status == 422) {

                                 //error
                                 console.log("errors",JSON.stringify(JSON.parse(jsn).errors))
                                 fileDialog.uperror = false


                             }
                if (status == 500) {

                                 //error
                                 console.log("errors",JSON.stringify(JSON.parse(jsn).errors))
                                 fileDialog.uperror = true
                                    fileDialog.donext = false


                             }
                     }
                 }
    FileReader {
        id: reader
        property bool uploading: false
    }
}
}





