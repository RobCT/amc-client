import QtQuick 2.0
import QtQuick.Controls 1.3
import QtQuick.Layouts 1.1
import QtQuick.Dialogs 1.2
import QtQuick.Window 2.2
import "../controllers" as Cont
import "../scripts/moment.js" as D
import "../components" as Comp
import "." as L

Rectangle {
    id:top
    width: Screen.width
    height: Screen.height
    color: "lightsteelblue"
    property alias  selectedDate: calendar.selectedDate
    onVisibleChanged: {
        if (visible) tim2.start()

    }

    Timer {
        id: tim2
          interval: 1; running: false; repeat: false
            onTriggered: {
                if (!entry.busy)
                calEvents.getCalendar(calendar.selectedDate.year(),calendar.selectedDate.month()+1,calendar.selectedDate.date(),"day")
                else restart()

            }
    }

    Rectangle {
        id: topRect
        width: parent.width
        height: parent.height/8
        color: "linen"
        Text {
            id: banner
            color: "blue"
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            font.pointSize: 30
        }

        Rectangle {
            id: decMonth
            width: parent.height
            anchors.left: parent.left
            anchors.leftMargin: height*2
            //opacity: entry.depth > 1 ? 1 : 0
            anchors.verticalCenter: parent.verticalCenter
            antialiasing: true
            height: parent.height
            radius: 4
            color: decmouse.pressed ? "#222" : "transparent"
            Behavior on opacity { NumberAnimation{} }
            Image {
                anchors.verticalCenter: parent.verticalCenter
                source: "../images/navigation_previous_item.png"
                width: parent.height
                height: parent.height
            }
            MouseArea {
                id: decmouse
                anchors.fill: parent
                anchors.margins: -10
                onClicked: {
                    calendar.selectedDate = calendar.selectedDate.subtract(1,"days")
                    console.log("dateChanged", calendar.selectedDate)
                }

            }
        }
        Rectangle {
            id: ddecMonth
            width: parent.height
            anchors.left: parent.left
            anchors.leftMargin: height
            //opacity: entry.depth > 1 ? 1 : 0
            anchors.verticalCenter: parent.verticalCenter
            antialiasing: true
            height: parent.height
            radius: 4
            color: ddecmouse.pressed ? "#222" : "transparent"
            Behavior on opacity { NumberAnimation{} }
            Image {
                anchors.verticalCenter: parent.verticalCenter
                source: "../images/double-chevron-left-120.png"
                width: parent.height
                height: parent.height
            }
            MouseArea {
                id: ddecmouse
                anchors.fill: parent
                anchors.margins: -10
                onClicked: {
                    calendar.selectedDate = calendar.selectedDate.subtract(7,"days")
                }

            }
        }
        Rectangle {
            id: incMonth
            width: parent.height
            anchors.right: parent.right
            anchors.rightMargin: height*2
            //opacity: entry.depth > 1 ? 1 : 0
            anchors.verticalCenter: parent.verticalCenter
            antialiasing: true
            height: parent.height
            radius: 4
            color: incmouse.pressed ? "#222" : "transparent"
            Behavior on opacity { NumberAnimation{} }
            Image {
                anchors.verticalCenter: parent.verticalCenter
                source: "../images/navigation_next_item.png"
                width: parent.height
                height: parent.height
            }
            MouseArea {
                id: incmouse
                anchors.fill: parent
                anchors.margins: -10
                onClicked: {
                    calendar.selectedDate = calendar.selectedDate.add(1,"days")
                    console.log("dateChanged", calendar.selectedDate)
                }

            }
        }
        Rectangle {
            id: dincMonth
            width: parent.height
            anchors.right: parent.right
            anchors.rightMargin: height
            //opacity: entry.depth > 1 ? 1 : 0
            anchors.verticalCenter: parent.verticalCenter
            antialiasing: true
            height: parent.height
            radius: 4
            color: dincmouse.pressed ? "#222" : "transparent"
            Behavior on opacity { NumberAnimation{} }
            Image {
                anchors.verticalCenter: parent.verticalCenter
                source: "../images/arrow__chevron-double-bold-2-01-128.png"
                width: parent.height
                height: parent.height
            }
            MouseArea {
                id: dincmouse
                anchors.fill: parent
                anchors.margins: -10
                onClicked: {
                    calendar.selectedDate = calendar.selectedDate.add(7,"days")
                }

            }
        }


    }

    GridView {
        id:calendar
        anchors.top: topRect.bottom
        anchors.topMargin: parent.height/40
        model: calEvents.model3
        property bool busy: entry.busy
        delegate: calDelegate
        width: parent.width
        height: parent.height*7/8
        cellWidth: width
        cellHeight: height
        property var selectedDate
        property var currentDate
        property var currentEvents
        property var currentSheets
        onSelectedDateChanged:  {
            console.log("dateChanged", selectedDate)
            //console.log(selectedDate,selectedDate.year(),selectedDate.month())
            calEvents.getCalendar(selectedDate.year(),selectedDate.month()+1,selectedDate.date(),"day")
            banner.text = selectedDate.format("MMM YYYY")
        }
        function callEdit(id) {
            entry.push({item: editev, properties: {index: id}})
        }
        function callSheet(id) {
            entry.push({item: sheet, properties: {index: id}})
        }

        function eventPlot(events, sceneid, sceney, scenex) {

            var oneHour = 24

            sceney = sceney | 0

            oneHour = sceney/24
            var evx, evy, evw, evh
            var evplot
            var evinst
            var evarray = []
            //console.log(oneHour, events.count, sceneid, sceney, scenex)
            for (var ind = 0; ind < events.count ; ind++) {
                var evend = D.moment(events.get(ind).eventend)
                var evstart =D.moment(events.get(ind).eventstart)
                var evlength = D.moment(evend.diff(evstart))
                evx = 10
                evw = scenex
                evy = evstart.hour() * oneHour + evstart.minute() * oneHour/60
                evh = evlength.hour() * oneHour + evlength.minute() * oneHour/60
                evarray[evarray.length]={"x": evx, "y": evy, "width": evw, "height": evh, "text": events.get(ind).title, "eventId": events.get(ind).id, "clickAction": callEdit, "pressAction": callSheet ,"ovlapCount": 0, "ovlapIndex": 0}
                console.log(events, sceneid, sceney, scenex, evy, evh,events.get(ind).title,D.moment(D.moment(events.get(ind).start)).hour(), D.moment(events.get(ind).start).minute())
            }
            if (evarray.length > 1) {
            for (ind = 0; ind < evarray.length; ind++) {
                for (var iind = ind + 1; iind < evarray.length; iind++) {
                    if ((evarray[ind].y > evarray[iind].y && evarray[ind].y < evarray[iind].y + evarray[iind].height) || ((evarray[iind].y > evarray[ind].y && evarray[iind].y < evarray[ind].y + evarray[ind].height) )) {
                               evarray[ind].ovlapCount =  evarray[ind].ovlapCount + 1
                               evarray[iind].ovlapCount =  evarray[iind].ovlapCount +1
                               evarray[iind].ovlapIndex = evarray[iind].ovlapIndex + 1
                            }
                }
            }
            }

            for (ind = 0; ind < evarray.length; ind++) {
                evplot = Qt.createComponent("../components/EventPlot.qml")
                if (evplot.status == Component.Ready)
                    console.log("evplot ready")
                if (evarray[ind].ovlapCount > 0) {
                    evarray[ind].width = scenex/(evarray[ind].ovlapCount+1)
                    evarray[ind].x = 10 + scenex * evarray[ind].ovlapIndex/(evarray[ind].ovlapCount+1)
                }
                        evinst = evplot.createObject(sceneid, evarray[ind]);

            }

        }


        Timer {
            id: tim1
              interval: 1; running: false; repeat: false
                onTriggered: {
                    if (!entry.busy) {
                        //calendar.selectedDate = D.moment()
                        calendar.currentDate = selectedDate
                        calEvents.getCalendar(selectedDate.year(),selectedDate.month()+1,selectedDate.date(),"day")
                    }
                    else restart()
            }
        }

        Component.onCompleted: {

            tim1.start()

        }

    }

    Component {
            id: calDelegate
            Rectangle {
                id: wrapper
                width: calendar.cellWidth
                height: calendar.cellHeight
                border.width: 1
                border.color: "grey"
                color:  "cyan"
                property var ev: events
                MouseArea {
                    id:clicker
                    width: parent.width
                    height: parent.height
                    onClicked: {


                        calendar.currentIndex = index
                        calendar.currentDate = date
                        calendar.currentEvents = events
                    }

                }
                onEvChanged: {

                    calendar.eventPlot(events, wrapper, height - calInfo.height, width)
                }



                Text {
                    id: calInfo

                    text: D.moment(date).format("ddd Do")
                    color: wrapper.GridView.isCurrentItem ? "red" : "black"
                    MouseArea {
                        width: parent.width
                        height: parent.height
                        onClicked:  {

                            entry.push({item: editev, properties: {setDate: date, index: 0}})



                        }
                    }
                }




        }

    }
    ListModel {
        id: caldata

    }
    Cont.EventController {
        id: calEvents
    }
    Component {
        id: editev
        L.EditEvent {


    }
    }
    Component {
        id:sheet
    L.EditVolunteerSheet {

    }
    }
    Component {
        id: eventRect
        Rectangle {
            property alias text: evTitle.text

            Text {
                id: evTitle
            }
        }
    }





}
