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
    property var selectedDate
    property bool my_calendar: false
    Component.onCompleted: {
        hamburger.connect(ham)
    }

    onVisibleChanged: {
        if (visible) tim2.start()

    }
    onWidthChanged: {
        //console.log("monthwidth")
    }
    //re use for my calendar? my_calendar is switch
    function ham() {
        if (topRect.visible) topRect.visible = false
        else topRect.visible  = true
    }

    Timer {
        id: tim2
          interval: 1; running: false; repeat: false
            onTriggered: {
                if (!entry.busy)
                    if (!top.my_calendar)
                        calEvents.getCalendar(calendar.selectedDate.year(),calendar.selectedDate.month()+1,01,"month")
                    else
                        calEvents.getMyCalendar(calendar.selectedDate.year(),calendar.selectedDate.month()+1,01,"month")

                else restart()
            }
    }

    Rectangle {
        id: topRect
        width: parent.width/6
        height: tb1.deltah
        anchors.right: parent.right
        anchors.top: tb1.bottom
        color: "linen"
        Comp.TumblerMonth {
            id: banner
            //anchors.left: parent.left
            //anchors.leftMargin: height
            anchors.horizontalCenter:  parent.horizontalCenter
            width: parent.width
            height: parent.width
            //showType: "months"
            //date: D.moment(new Date)
            onReturnDateChanged: {
                calendar.selectedDate = returnDate
            }
            Component.onCompleted: {
                banner.date = D.moment(new Date)
            }
        }


        Rectangle {
            id: week
            width: parent.width
            //anchors.right: parent.horizontalCenter
            anchors.top: banner.bottom
            anchors.topMargin: 20
            //opacity: entry.depth > 1 ? 1 : 0
            //anchors.verticalCenter: parent.verticalCenter
            antialiasing: true
            height: parent.width
            radius: 4
            color: weekmouse.pressed ? "#222" : "transparent"
            Behavior on opacity { NumberAnimation{} }
            Text {
                anchors.centerIn: parent
                text: "Week"
                font.pointSize: 30
            }

            MouseArea {
                id: weekmouse
                anchors.fill: parent
                anchors.margins: -10
                onClicked: {
                    entry.push({item: weekComp, replace: false, properties: {my_calendar: top.my_calendar, selectedDate: D.moment(calendar.currentDate)}})
                }

            }
        }
        Rectangle {
            id: day
            width: parent.width
            anchors.top: week.bottom
            anchors.topMargin: 20
            //anchors.left: parent.horizontalCenter
            //anchors.leftMargin: height
            //opacity: entry.depth > 1 ? 1 : 0
            //anchors.verticalCenter: parent.verticalCenter
            antialiasing: true
            height: parent.width
            radius: 4
            color: daymouse.pressed ? "#222" : "transparent"
            Behavior on opacity { NumberAnimation{} }
            Text {
                anchors.centerIn: parent
                text: "Day"
                font.pointSize: 30
            }

            MouseArea {
                id: daymouse
                anchors.fill: parent
                anchors.margins: -10
                onClicked: {
                    entry.push({item: dayComp, replace: false, properties: {my_calendar: top.my_calendar, selectedDate: D.moment(calendar.currentDate)}})
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
        L.ToolBarContent {
            id: tbint
            width:parent.width
            height:parent.height
            navheight: top.height/8

        }
    }
    GridView {
        id:calendar
        anchors.top: tb1.bottom

        model: calEvents.model3
        property bool busy: entry.busy
        delegate: calDelegate
        width: !topRect.visible ? parent.width : parent.width*5/6 | 0
        height: tb1.deltah
        cellWidth: width/7 | 0
        cellHeight: height/(model.count/7) +1
        property var selectedDate
        property var currentDate
        property var currentEvents
        onSelectedDateChanged:  {
            //console.log(selectedDate,selectedDate.year(),selectedDate.month())
            if (!top.my_calendar)
                calEvents.getCalendar(selectedDate.year(),selectedDate.month()+1,01,"month")
            else
                calEvents.getMyCalendar(selectedDate.year(),selectedDate.month()+1,01,"month")
            banner.date = selectedDate//.format("MMM YYYY")
        }

        Timer {
            id: tim1
              interval: 1; running: false; repeat: false
                onTriggered: {
                    if (!entry.busy) {
                        calendar.selectedDate = top.selectedDate
                        calendar.currentDate = calendar.selectedDate
                        if (!top.my_calendar)
                            calEvents.getCalendar(selectedDate.year(),selectedDate.month()+1,01,"month")
                        else
                            calEvents.getMyCalendar(selectedDate.year(),selectedDate.month()+1,01,"month")

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
                        calendar.currentIndex = index
                        calendar.currentDate = date
                        calendar.currentEvents = events
                    }
                    onPressAndHold:  {
                        entry.push({item: sheet, properties: {index: editev.index}})

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
                        //    entry.lists.blank = {"date":""}
                        //    entry.lists.blank.date = D.moment(date).format("YYYY-MM-DD")
                        //    entry.pushOther(8)
                            //dialog1.index = 0
                            //dialog1.setDate = date
                            //top.visible = false
                            //dialog1.open()
                            entry.push({item: editev, properties: {setDate: D.moment(date), index: 0}})



                        }
                    }
                }

                ListView {
                     id: eventList
                     width: calendar.cellWidth
                     height: calendar.cellHeight
                     model: events
                     property color highlighted: wrapper.color
                     property var rowheight: height/4//events.count ? height/(events.count) : 30
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
/*                        Rectangle {
                            width:parent.width
                            height: parent.height/8
                            color: eventList.highlighted
                            border.width: 1
                            border.color: "grey"
                        }*/
                        Rectangle {
                            width:parent.width
                            height: delText.implicitHeight
                            color: "lightyellow"
                            border.color: "blue"
                            border.width: 0.5

                            Text {
                                id: delText
                            width: parent.width ;height: parent.height; horizontalAlignment: Text.AlignHCenter ;verticalAlignment: Text.AlignVCenter;
                            wrapMode: Text.WordWrap
                            text: title
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
/*                        Rectangle {
                            width:parent.width
                            height: parent.height/8
                            color: eventList.highlighted
                            border.width: 1
                            border.color: "grey"
                        }*/
                        }

                        }
                    }
/*                TableView {
                    id: eventSelect
                    width: calendar.cellWidth

                    anchors.top: calInfo.bottom
                    anchors.bottom: parent.bottom
                    model: events
                    headerVisible: false
                    visible: true
                    TableViewColumn {
                        role: "title"
                        title: "Title"
                        width: calendar.cellWidth
                    }
                   TableViewColumn {
                        role: "eventdate"
                        title: "Date"
                        width: calendar.cellWidth/2
                    }
                    onClicked: {
                        //console.log("dcev",eventSelect.currentRow, events.get(eventSelect.currentRow).id )
                        //dialog1.index = events.get(eventSelect.currentRow).id
                        //top.visible = false
                        //dialog1.open()
                        entry.push({item: editev, properties: {index: events.get(eventSelect.currentRow).id}})

                    }


            }*/
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
        L.EditEvent3 {


    }
    }
    Component {
        id: weekComp
        L.CalendarWeek {


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

