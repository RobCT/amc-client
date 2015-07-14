import QtQuick 2.4
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
    property var  selectedDate
    property bool my_calendar: false
    property var ent: entry
    property bool ready: false
    Component.onCompleted: {
        hamburger.connect(ham)
        monthcalendar.connect(monthcal)
        //tim2.start()
    }
    onVisibleChanged: {
        if (ready ) {
            if (visible) tim2.start()
        }

    }    function ham() {
        if (topRect.visible) topRect.visible = false
        else topRect.visible  = true

    }
    function monthcal() {
        while (ent.depth > ent.startingCalIndex) {
            console.log("pop",ent.depth)
            ent.pop()
        }
        entry.calChangeProperties = {my_calendar: top.my_calendar, selectedDate: D.moment(entry.selectedDate)}// D.moment(calendar.currentDate)}
        //entry.push({item: entry.cal, replace: false, properties: entry.calChangeProperties})

    }
    function getMonthIndex(dt) {
        try {
         if (!dt.isMoment) dt = D.moment(dt)
        }
        catch(e) {

        }
        dt.hour(1); dt.minute(0); dt.second(0)
        var ind
        var caldt
        for (ind = 0; ind < calEvents.model3.count; ind++) {
            caldt = D.moment(calEvents.model3.get(ind).date)
            caldt.hour(1); caldt.minute(0); caldt.second(0)
            //console.log(ind, dt, caldt, D.moment(dt.format("YYYY-MM-DD")).isSame(caldt.format("YYYY-MM-DD")), caldt.format("DD-MM-YYYY"), D.moment('2010-10-20').isSame('2010-10-20'))

            if (D.moment(dt.format("YYYY-MM-DD")).isSame(caldt.format("YYYY-MM-DD"))) {
                return ind
            }
        }
    }


    Timer {
        id: tim2
          interval: 1; running: false; repeat: false
            onTriggered: {
                if (!entry.busy) {
                    calendar.currentDate = entry.selectedDate
                    //console.log("L69")
                    calEvents.getCalendar(entry.selectedDate.year(),entry.selectedDate.month()+1,entry.selectedDate.date(),"week")
                }
                else restart()

            }
    }

    Rectangle {
        id: topRect
        width: parent.width/6
        height: tb1.deltah
        color: "linen"
        anchors.right: parent.right
        anchors.top: tb1.bottom
        Comp.TumblerWeek {
            id: bannerweek

            anchors.horizontalCenter:  parent.horizontalCenter
            width: parent.width
            height: parent.width

            //date: D.moment(new Date)
            onReturnDateChanged: {
                if (top.ready) {
                    //console.log("isitme",returnDate)
                   entry.selectedDate = D.moment(returnDate)
                    //console.log("L94")
                    calEvents.getCalendar(entry.selectedDate.year(),entry.selectedDate.month()+1,entry.selectedDate.date(),"week")
                    bannerweek.date = entry.selectedDate//.format("MMM YYYY")
                    calendar.currentDate = entry.selectedDate
                }
            }
            Component.onCompleted: {
                bannerweek.date = D.moment(entry.selectedDate)
               //console.log("seldate",entry.selectedDate)
            }
        }


        Rectangle {
            id: week
            width: parent.width
            anchors.top: bannerweek.bottom
            anchors.topMargin: 20

            antialiasing: true
            height: parent.width
            radius: 4
            color: weekmouse.pressed ? "#222" : "transparent"
            Behavior on opacity { NumberAnimation{} }
            Text {
                anchors.centerIn: parent
                text: "Day"
                font.pointSize: 30
            }

            MouseArea {
                id: weekmouse
                anchors.fill: parent
                anchors.margins: -10
                onClicked: {
                    entry.push({item: dayComp, properties: {selectedDate: D.moment(calendar.currentDate)}})
                }

            }
        }

    }
    ToolBar {
        id: tb1
        width: parent.width
        height: (parent.height/11) | 0
        anchors.top: parent.top

        property int deltah: parent.height - height
        L.ToolBarCalendarContent {
            id: tbint
            width:parent.width
            height:parent.height
            navheight: top.height/8

        }
    }
    Rectangle {
        id: header
        anchors.top: tb1.bottom
        height: parent.height/20
        color: "light green"
        width: !topRect.visible ? parent.width : parent.width*5/6 | 0
        Rectangle {

            id: decButton
            width: parent.height
            anchors.left: parent.left
            anchors.leftMargin: 5
            anchors.verticalCenter: parent.verticalCenter
            antialiasing: true
            height: parent.height
            radius: 4
            color: backmouse.pressed ? "#222" : "transparent"
            Behavior on opacity { NumberAnimation{} }
            Image {
                anchors.verticalCenter: parent.verticalCenter
                source: "../images/navigation_previous_item.png"
                width: parent.height
                height: parent.height
            }
            MouseArea {
                id: backmouse
                anchors.fill: parent
                anchors.margins: -10
                onClicked: {
                    entry.selectedDate = entry.selectedDate.subtract(1,"w")
                    //console.log("L181")
                    calEvents.getCalendar(entry.selectedDate.year(),entry.selectedDate.month()+1,entry.selectedDate.date(),"week")
                    calendar.currentDate = entry.selectedDate

            }
        }
        }
        Rectangle {
            width: parent.width/3
            height: parent.height
            color: "transparent"
            anchors.centerIn: parent
            Text {
                anchors.centerIn: parent
                text: entry.selectedDate.format("MMMM YYYY")
            }
        }

        Rectangle {

            id: plusButton
            width: parent.height
            anchors.right: parent.right
            anchors.rightMargin: 5
            anchors.verticalCenter: parent.verticalCenter
            antialiasing: true
            height: parent.height
            radius: 4
            color: plusmouse.pressed ? "#222" : "transparent"
            Behavior on opacity { NumberAnimation{} }
            Image {
                anchors.verticalCenter: parent.verticalCenter
                source: "../images/navigation_next_item.png"
                width: parent.height
                height: parent.height
            }
            MouseArea {
                id: plusmouse
                anchors.fill: parent
                anchors.margins: -10
                onClicked: {
                    entry.selectedDate = entry.selectedDate.add(1,"w")
                    //console.log("L222")
                    calEvents.getCalendar(entry.selectedDate.year(),entry.selectedDate.month()+1,entry.selectedDate.date(),"week")
                    calendar.currentDate = entry.selectedDate
            }
        }
        }
    }
    GridView {
        id:calendar
        anchors.top: header.bottom
        //anchors.topMargin: parent.height/40
        model: calEvents.model3
        property bool busy: entry.busy
        delegate: calDelegate
        width: !topRect.visible ? parent.width : parent.width*5/6 | 0
        height: tb1.deltah - header.height - tb1.deltah/30
        cellWidth: width/7 | 0
        cellHeight: height/(model.count/7) +1
        property var selectedDate
        property var currentDate
        property var currentEvents
        header:         Rectangle {
            id: headerDays
            height: tb1.deltah/30
            width: calendar.width
            color: "light cyan"
            Row {
                height: parent.height
                width:parent.width
            Rectangle {
                width: parent.width/7
                height: parent.height
                color: "transparent"
                Text {
                    anchors.centerIn: parent
                    text: "Sun"
                }
            }
            Rectangle {
                width: parent.width/7
                height: parent.height
                color: "transparent"
                Text {
                    anchors.centerIn: parent
                    text: "Mon"
                }
            }
            Rectangle {
                width: parent.width/7
                height: parent.height
                color: "transparent"
                Text {
                    anchors.centerIn: parent
                    text: "Tue"
                }
            }
            Rectangle {
                width: parent.width/7
                height: parent.height
                color: "transparent"
                Text {
                    anchors.centerIn: parent
                    text: "Wed"
                }
            }
            Rectangle {
                width: parent.width/7
                height: parent.height
                color: "transparent"
                Text {
                    anchors.centerIn: parent
                    text: "Thu"
                }
            }
            Rectangle {
                width: parent.width/7
                height: parent.height
                color: "transparent"
                Text {
                    anchors.centerIn: parent
                    text: "Fri"
                }
            }
            Rectangle {
                width: parent.width/7
                height: parent.height
                color: "transparent"
                Text {
                    anchors.centerIn: parent
                    text: "Sat"
                }
            }
            }


        }
        /*onSelectedDateChanged:  {
           //console.log("dateChanged", selectedDate)
            //console.log(selectedDate,selectedDate.year(),selectedDate.month())
            calEvents.getCalendar(entry.selectedDate.year(),entry.selectedDate.month()+1,entry.selectedDate.date(),"week")
            bannerweek.date = selectedDate//.format("MMM YYYY")
        }*/

        Timer {
            id: tim1
              interval: 1; running: false; repeat: false
                onTriggered: {
                    if (!entry.busy) {
                       entry.selectedDate = D.moment(top.selectedDate)
                        calendar.currentDate = entry.selectedDate
                        //console.log("L333")
                        calEvents.getCalendar(entry.selectedDate.year(),entry.selectedDate.month()+1,entry.selectedDate.date(),"week")
                        top.ready = true
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
                color: GridView.isCurrentItem ? "blue" : "cyan"
                MouseArea {
                    id:clicker
                    width: parent.width
                    height: parent.height
                    onClicked: {
                        //console.log(events.get(0).title)
                        entry.selectedDate = D.moment(date)
                        calendar.currentIndex = index
                        calendar.currentDate = date
                        calendar.currentEvents = events
                    }
                    onDoubleClicked: {

                    }
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

               ListView {
                    id: eventList
                    width: calendar.cellWidth
                    height: calendar.cellHeight
                    model: events
                    property color highlighted: wrapper.color
                    property var rowheight: events.count ? height/(events.count) : 30
                    anchors.top: calInfo.bottom
                    anchors.bottom: parent.bottom
                    delegate: eventDelegate
                }
               Component {
                   id: eventDelegate
                   Item {
                       id: del1
                       width: eventList.width
                       height: eventList.rowheight
                       Column {
                           width:parent.width
                           height: eventList.rowheight
                       Rectangle {
                           width:parent.width
                           height: parent.height/8
                           color: eventList.highlighted
                           border.width: 1
                           border.color: "grey"
                       }
                       Rectangle {
                           width:parent.width
                           height: parent.height*3/4
                           color: "lightyellow"
                           border.color: "blue"
                           border.width: 0.5

                           Text {
                           width: parent.width ;height: parent.height; horizontalAlignment: Text.AlignHCenter ;verticalAlignment: Text.AlignVCenter;
                           wrapMode: Text.WordWrap
                           text: title + " \n @ " + D.moment(eventstart).format("HH:mm" )
                       }


                       MouseArea {
                           width:parent.width
                           height: parent.height
                           onClicked: {
                               entry.push({item: editev, properties: {index: id}})

                           }
                           onPressAndHold: {
                               entry.push({item: sheet, properties: {index: id}})
                           }

                       }

                       }
                       Rectangle {
                           width:parent.width
                           height: parent.height/8
                           color: eventList.highlighted
                           border.width: 1
                           border.color: "grey"
                       }
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
        onM3readyChanged: {

            if (m3status == 200) {
                //console.log(m3jsn)
                calendar.currentIndex = top.getMonthIndex(entry.selectedDate)
            }
        }
    }
    Component {
        id: editev
        L.EditEvent3 {


    }
    }
    Component {
        id: dayComp
        L.CalendarDay {


    }
    }

    Component {
        id:sheet
    L.EditVolunteerSheet {

    }
    }





}

