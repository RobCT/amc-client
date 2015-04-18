import QtQuick 2.4
import QtQuick.Controls 1.3
import QtQuick.Layouts 1.1
import QtQuick.Dialogs 1.2
import QtQuick.LocalStorage 2.0
import QtQuick.Controls.Styles 1.2
import "." as Local
import "../controllers" as Cont
import "../scripts/moment.js" as D
import "../components" as Comp

Rectangle {
    id: top
    width: parent.width
    height: parent.height
    color: "#edcece"
    property bool newp
    property var record
    property int key_index
    property var selected_date
    Component.onCompleted: {
        record = {"title":"","date":"","start":null,"end":null}

        if (!newp) {
            record = entry.lists.loaded
            var dy = D.moment(selected_date)
            console.log(selected_date)
            cont1.getDay(dy.year(), dy.month(), dy.date())
            tim3.start()

        }
        else {
            record.date_ae  = entry.lists.blank.date
            df1.date = entry.lists.blank.date
        }

    }
    function initModel() {
        if (cont1.model2.count > 0) {
        entry.lists.loaded.title = cont1.model2.get(0).title
        entry.lists.loaded.date = cont1.model2.get(0).date
        entry.lists.loaded.start = cont1.model2.get(0).start
        entry.lists.loaded.end = cont1.model2.get(0).end
        entry.lists.loaded.id = cont1.model2.get(0).id
        top.record = entry.lists.loaded
        }
    }

    Column {
        id: rowLayout1
        anchors.fill: parent
        anchors.margins:  parent.width/8
        spacing: 5

        TableView {
            id: eventSelect
            width:parent.width
            height: parent.height/3
            model: cont1.model2
            TableViewColumn {
                role: "title"
                title: "Title"
            }
            TableViewColumn {
                role: "date"
                title: "Date"
            }
            TableViewColumn {
                role: "start"
                title: "Start time"
            }

            Component.onCompleted: {


            }
            onCurrentRowChanged: {
                if (!newp) {
                    entry.lists.loaded.title = cont1.model2.get(currentRow).title
                    entry.lists.loaded.date = cont1.model2.get(currentRow).date
                    entry.lists.loaded.start = cont1.model2.get(currentRow).start
                    entry.lists.loaded.end = cont1.model2.get(currentRow).end

                    entry.lists.loaded.id = cont1.model2.get(currentRow).id
                    top.record = entry.lists.loaded
                    //console.log("rowchange",top.record.start_ae, top.record.duration_ae)
                    //console.log(te1.time, te2.time)
                    if (te1.time != top.record.start) te1.time = top.record.start
                    if (te2.time != top.record.end) te2.time = top.record.end




                }
            }

        }
        }
        Row {
            height: parent.height*2/3
            width: parent.width





        Column {
            id: column2
            //anchors.left: parent.left
            height:parent.height
            //anchors.top: eventSelect.bottom
            //anchors.bottom: parent.bottom
            width: parent.width*7/16

            Rectangle {

                width: parent.width
                color: "beige"
                radius: 4
                height: parent.height/5



            Text {
                id: text1

                text: qsTr("Title")
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
                    entry.lists.loaded = top.record
                    console.log("mmm", entry.lists.loaded.date)
                    entry.pop()
                }
            }
            Column {
                width: parent.width
                height: parent.height

            Rectangle {
                id: upcreate
                radius: 6
                width: parent.width
                height: parent.height/3
                color: "lightyellow"
                Text {
                    anchors.verticalCenter:  parent.verticalCenter
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: newp ? "Create" : "Update"
                }
                MouseArea {
                    width: parent.width
                    height: parent.height
                    onClicked:  {
                        if (!top.newp) {
                            tim2.dt = D.moment(entry.lists.loaded.date)
                            cont1.updateEvent(JSON.stringify(top.record), entry.lists.loaded.id)
                            tim2.start()
                        }
                        else {
                            top.newp = false
                            entry.lists.update = true
                            entry.lists.create = false
                            tim2.dt = D.moment(entry.lists.loaded.date)
                            cont1.newEvent(JSON.stringify(top.record))
                            tim2.start()


                        }


                    }
                }

            }
            Rectangle {
                id: save
                radius: 6
                width: parent.width
                height: parent.height/3
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
                        top.newp = true
                        entry.lists.update = false
                        entry.lists.create = true
                        top.record.date = cont1.model2.get(0).date
                        top.record.title = ""
                        top.record.start = "00:00"
                        top.record.end = "00:00"
 //                       top.record.id_type_ae = cont1.model3.get(0).id_amc_event_type




                    }
                }

            }
            Rectangle {
                id: del
                radius: 6
                width: parent.width
                height: parent.height/3
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
                        tim2.dt = D.moment(entry.lists.loaded.date)
                       cont1.deleteEvent(entry.lists.loaded.id)
                        tim2.start()

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


            TextField {
                id: textField1

                width: parent.width
                placeholderText: qsTr("Text Field")
                text: top.record.title
                height: parent.height/5
                onEditingFinished: {
                    if (!top.newp) entry.lists.update = true
                    else entry.lists.create = true
                    top.record.title = text

                }
            }

            Comp.DateEdit {
                id: df1

                width: parent.width
                height: parent.height/5
                ratio: 0.8
                bcolor: "white"
                date: top.record.date
                onGoodDateChanged: {
                    if (!top.newp) entry.lists.update = true
                    else entry.lists.create = true
                    console.log(date,top.record.date)
                    top.record.date = D.moment(date).format("YYYY-MM-DD")
                    console.log(date,top.record.date)
                }

            }


            Comp.TimeEdit {
                id: te1
                width: parent.width
                time: top.record.start
                height: parent.height/5
                ratio: 0.8
                bcolor: "white"
                onTimeChanged: {
                    if (!top.newp) entry.lists.update = true
                    else entry.lists.create = true
                    top.record.start = time
                }

            }
            Comp.TimeEdit {
                id:te2
                width: parent.width
                time: top.record.end
                height: parent.height/5
                ratio: 0.8
                bcolor: "white"
                onTimeChanged: {
                    if (!top.newp) entry.lists.update = true
                    else entry.lists.create = true
                    top.record.end = time
                }

            }



            ComboBox {
                id: combo1

                width: parent.width
                height: parent.height/5
                model: comboModel

                Component.onCompleted: {

                    cont1.getTypes()



                    tim1.start()


                }
                function loadMod() {
/*                   if (cont1.model3.count > 0) {
                    var ind
                    var element = {"description_aet": ""}

                    for (ind=0 ; ind < cont1.model3.count; ind++) {

                        element.description_aet = cont1.model3.get(ind).description_aet
                        comboModel.append(element)
                    }
                    var cid = top.record.type_id_ae

                    for (ind=0 ; ind < cont1.model3.count; ind++) {
                    if (cid == cont1.model3.get(ind).idamc_event_type) {
                        currentIndex = ind
                    }
                                    }
                    if (newp) {
                        top.record.type_id_ae = cont1.model3.get(0).idamc_event_type
                    }

                    }*/
                }


                onCurrentIndexChanged: {

/*                    if (!top.newp) entry.lists.update = true
                    else entry.lists.create = true
                    if (cont1.model3.count > 0)
                    top.record.type_id_ae = cont1.model3.get(currentIndex).id_amc_event_type

 */               }
            }
        }
        }

    Cont.EventController {
        id:cont1
    }
    ListModel {
        id: comboModel
    }
    Timer {
        id: tim1
            interval: 1; running: false; repeat: false
            onTriggered: {
                if (cont1.model3Ready)
                combo1.loadMod()
                else restart()
        }
    }
    Timer {
        id: tim2
        property var dt
            interval: 500; running: false; repeat: false
            onTriggered: {
                if (cont1.ready) {
                cont1.getDay(dt.year(), dt.month(), dt.date())

                }

                else restart()
        }
    }
    Timer {
        id: tim3
            interval: 1; running: false; repeat: false
            onTriggered: {
                if (cont1.model2Ready)
               top.initModel()
                else restart()
        }
    }



}

