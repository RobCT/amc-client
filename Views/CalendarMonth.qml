import QtQuick 2.4
import QtQuick.Controls 1.3
import QtQuick.Layouts 1.1
import QtQuick.Dialogs 1.2
import QtQuick.Window 2.2
import QtQuick.Controls.Styles 1.2
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
    property bool ready: false
    Component.onCompleted: {
        hamburger.connect(ham)
        weekcalendar.connect(weekcal)
        daycalendar.connect(daycal)
        addevent.connect(plusone)
        //monthcalendar.connect(monthcal)
    }

    onVisibleChanged: {
        if (visible) tim2.start()

    }
    onWidthChanged: {
        //console.log("monthwidth")
    }
    //re use for my calendar? my_calendar is switch
    function ham() {
        if (banner.visible) banner.visible = false
        else banner.visible  = true
    }
    function weekcal() {
        while (entry.depth > entry.startingCalIndex) {
            entry.pop()
        }
        entry.calChangeProperties = {my_calendar: top.my_calendar, selectedDate: D.moment(entry.selectedDate)}//D.moment(calendar.currentDate)}
        entry.push({item: weekComp, replace: false, properties: entry.calChangeProperties})

    }
    function daycal() {
        while (entry.depth > entry.startingCalIndex) {
            entry.pop()
        }
        entry.calChangeProperties = {my_calendar: top.my_calendar,selectedDate: D.moment(entry.selectedDate)}//D.moment(calendar.currentDate)}
        entry.push({item: dayComp, replace: false, properties: entry.calChangeProperties})

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
    function plusone() {
        eventUpdate.create = true
        eventUpdate.evdate = calendar.currentDate
        eventUpdate.evdate.hours(12)
        eventUpdate.fromtime = D.moment({ hour:12, minute:0 })
        eventUpdate.totime = D.moment({ hour:12, minute:0 })
        edevtext.text = ""
        eventUpdate.z = 50
        eventUpdate.visible = true

    }





    Timer {
        id: tim2
          interval: 1; running: false; repeat: false
            onTriggered: {
                if (!entry.busy)
                    if (!top.my_calendar) {
                        //calendar.currentIndex = top.getMonthIndex(entry.selectedDate)
                        //console.log("L84")
                        calEvents.getCalendar(entry.selectedDate.year(),entry.selectedDate.month()+1,01,"month")
                        calendar.currentDate = entry.selectedDate
                    }
                    else
                        calEvents.getMyCalendar(entry.selectedDate.year(),entry.selectedDate.month()+1,01,"month")

                else restart()
            }
    }

    Rectangle {
        id: topRect
        width: parent.width/6
        height: tb1.deltah
        z: 5
        anchors.right: parent.right
        anchors.top: tb1.bottom
        color: "linen"
        Comp.TumblerMonth {
            id: banner
            visible: false
            //anchors.left: parent.left
            //anchors.leftMargin: height
            anchors.horizontalCenter:  parent.horizontalCenter
            width: parent.width
            height: parent.width
            property bool ready: false
            //showType: "months"
            //date: D.moment(new Date)
            onVisibleChanged: {
                if (visible) {
                    date = entry.selectedDate
                    tim3.start()
                }
            }

            onReturnDateChanged: {
                if (ready) {

                parent.height= D.moment(returnDate)

                if (!top.my_calendar) {
                    //console.log("L115")
                    calEvents.getCalendar(entry.selectedDate.year(),entry.selectedDate.month()+1,01,"month")
                }
                else
                    calEvents.getMyCalendar(entry.selectedDate.year(),entry.selectedDate.month()+1,01,"month")
                banner.date =entry.selectedDate//.format("MMM YYYY")
                calendar.currentDate = entry.selectedDate
                }
            }
            Component.onCompleted: {
                banner.date = D.moment(new Date)
            }
        }
        Timer {
            id: tim3
              interval: 2000; running: false; repeat: false
                onTriggered: {
                    banner.ready = true
                }
        }
        ListView {
            id: eventsforday
            model: calEvents.model3.get(calendar.currentIndex).events
            width: parent.width
            property int rowheight: height/5
            anchors.top: banner.visible ? banner.bottom : parent.top
            anchors.bottom: parent.bottom
            delegate: eventsfordayDelegate
            header: Rectangle {
                width: eventsforday.width
                height: hedtext.implicitHeight
                color: "light cyan"
                Text {
                    id: hedtext
                    width: parent.width * 0.9
                    wrapMode: Text.WordWrap
                    text: "Church events \n " + D.moment(calEvents.model3.get(calendar.currentIndex).date).format("dddd Do MMMM YYYY")
                }

            }
        }


        Component {
            id: eventsfordayDelegate
            Item {
                id: efddtop
                width: eventsforday.width
                height: eventsforday.rowheight


                Column {
                    width: eventsforday.width
                    height: eventsforday.rowheight*0.9
                    Rectangle {
                        color: "transparent"
                        width: parent.width
                        height: eventsforday.rowheight*0.05
                    }
                Rectangle {
                    width:parent.width
                    height:parent.height
                    color: "lightyellow"
                    border.color: "blue"
                    border.width: 0.5


                    Column {
                        width:parent.width
                        height:parent.height


                    Rectangle {
                        color: "transparent"
                        width: parent.width
                        height: parent.height * 0.6
                        y: parent.y
                        Text {
                            anchors.left: parent.left
                            anchors.margins: 4
                            width: parent.width*0.9
                            text: title
                            wrapMode: Text.WordWrap
                            font.weight: Font.Bold

                        }
                    }
                    Rectangle {
                        color: "transparent"
                        width: parent.width
                        height: parent.height * 0.4
                        Text {
                            anchors.left: parent.left
                            anchors.margins: 4
                            anchors.verticalCenter: parent.verticalCenter
                            text: D.moment(eventstart).format("HH:mm" ) + " - " + D.moment(eventend).format("HH:mm" )
                            font.weight: Font.Normal

                        }
                    }

                    }
                    MouseArea {
                        width:parent.width
                        height: parent.height
                        onClicked: {
                            if (eventUpdate.visible) {
                                eventUpdate.visible = false
                                eventUpdate.z = 1

                            }
                            else {
                                eventUpdate.create = false
                                eventUpdate.visible = true
                                eventUpdate.idev = id
                                eventUpdate.fromtime = D.moment(eventstart)
                                eventUpdate.totime = D.moment(eventend)
                                eventUpdate.evdate = D.moment(eventdate)
                                eventUpdate.evdate.hours(12)
                                eventUpdate.z = 50
                                edevtext.text = title
                                eufrom.text = D.moment(eventdate).format("ddd Do MMM YYYY ") + D.moment(eventstart).format( "HH:mm" )
                                euto.text = D.moment(eventdate).format("ddd Do MMM YYYY ") + D.moment(eventend).format( "HH:mm" )
                                //console.log(shape.status, Image.Error)
                            }

                            //entry.push({itebm: editev, properties: {index: id}})

                        }
                        onPressAndHold: {
                            entry.push({item: sheet, properties: {index: id}})
                        }
                    }
                    Rectangle {
                        color: "transparent"
                        width: parent.width
                        height: eventsforday.rowheight*0.05
                    }
                }

                }

            }


        }



    }
    ToolBar {
        id: tb1
        width: parent.width
        height: (parent.height/11) | 0
        anchors.top: parent.top
        z: 5

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
        z: 5
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
                    entry.selectedDate = entry.selectedDate.subtract(1,"M")
                    //console.log("L234")
                    calEvents.getCalendar(entry.selectedDate.year(),entry.selectedDate.month()+1,01,"month")
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
                    entry.selectedDate = entry.selectedDate.add(1,"M")
                    //console.log("L277")
                    calEvents.getCalendar(entry.selectedDate.year(),entry.selectedDate.month()+1,01,"month")
                    calendar.currentDate = entry.selectedDate
            }
        }
        }

    }

    GridView {
        id:calendar

        anchors.top: header.bottom
        z: 5
        model: calEvents.model3
        property bool busy: entry.busy
        delegate: calDelegate
        flickableDirection: Flickable.HorizontalFlick
        width: !topRect.visible ? parent.width : parent.width*5/6 | 0
        height: tb1.deltah - header.height - tb1.deltah/30
        cellWidth: width/7 | 0
        cellHeight: height/(model.count/7) +1
        property var selectedDate
        property var currentDate
        property var currentEvents
        rebound: Transition {
            NumberAnimation {
                properties: "x,y"
                duration: 1000
                easing.type: Easing.OutBounce
            }
        }
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
        onFlickEnded:   {
            console.log("moved", x,y, visibleArea.xPosition, visibleArea.yPosition)
            if (visibleArea.xPosition < 0) {
                entry.selectedDate = entry.selectedDate.subtract(1,"M")
                //console.log("L234")
                calEvents.getCalendar(entry.selectedDate.year(),entry.selectedDate.month()+1,01,"month")
                calendar.currentDate = entry.selectedDate
                console.log("right")
            }
            else {
                entry.selectedDate = entry.selectedDate.add(1,"M")
                //console.log("L277")
                calEvents.getCalendar(entry.selectedDate.year(),entry.selectedDate.month()+1,01,"month")
                calendar.currentDate = entry.selectedDate
                console.log("Left")
            }

            returnToBounds()
        }

        onCurrentIndexChanged: {
            if (top.ready )
                calEvents2.getCalendar(entry.selectedDate.year(),entry.selectedDate.month()+1,entry.selectedDate.date(),"day")
        }

        onSelectedDateChanged:  {
            //console.log(selectedDate,selectedDate.year(),selectedDate.month())
            if (!top.my_calendar) {
                //console.log("L373")
                calEvents.getCalendar(entry.selectedDate.year(),entry.selectedDate.month()+1,01,"month")
            }
            else
                calEvents.getMyCalendar(entry.selectedDate.year(),entry.selectedDate.month()+1,01,"month")
            banner.date =entry.selectedDate//.format("MMM YYYY")
        }

        Timer {
            id: tim1
              interval: 1; running: false; repeat: false
                onTriggered: {
                    if (!entry.busy) {
                       entry.selectedDate = D.moment(top.selectedDate)
                        calendar.currentDate =entry.selectedDate
                        //calendar.currentIndex = top.getMonthIndex(entry.selectedDate)
                        if (!top.my_calendar) {
                            //console.log("L388")
                            calEvents.getCalendar(entry.selectedDate.year(),entry.selectedDate.month()+1,01,"month")

                        }
                        else
                            calEvents.getMyCalendar(entry.selectedDate.year(),entry.selectedDate.month()+1,01,"month")
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

                z: 5
                border.color: "grey"
                color: GridView.isCurrentItem ? "blue" : "cyan"
                property bool nowdate: D.moment(D.moment(date).format("YYYY-MM-DD")).isSame(D.moment(new Date).format("YYYY-MM-DD"))

                MouseArea {
                    id:clicker
                    width: parent.width
                    height: parent.height
                    onClicked: {

                        //console.log(events.get(0).title)
                        console.log(nowdate )
                        entry.selectedDate = D.moment(date)
                        calendar.currentIndex = index
                        calendar.currentDate = D.moment(date)
                        calendar.currentEvents = events
                    }
                    onPressAndHold:  {
                        entry.push({item: sheet, properties: {index: editev.index}})

                    }
                }


                Text {
                    id: calInfo

                    text: D.moment(date).format("Do")
                    color: wrapper.GridView.isCurrentItem ? "red" : "black"

                    font.weight: parent.nowdate ? Font.Bold : Font.Normal

                    MouseArea {
                        width: parent.width
                        height: parent.height
                        onClicked:  {

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
                     property int rowheight: height/4//events.count ? height/(events.count) : 30
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
                        }
                    }
                }
            }
         }
    Rectangle {
        id: eventUpdate
        property int idev
        property var fromtime
        property var totime
        property var evdate
        property bool create: false
        color: topRect.color
        visible:false
        border.color: "light grey"
        border.width: 0.4

        width: top.width/2 | 0
        height: top.height
        //anchors.right: parent.right
        x: top.right | 0
        opacity: 0
        anchors.top: top.top

        z: 1
        onZChanged: {
            if (z > 5) {
                animeu.start()
                animeuop.start()
            }
            else {x = top.width; opacity = 0}
        }
       onFromtimeChanged: {
           etutabs.tim1 = fromtime
           eufrom.text = D.moment(evdate).format("ddd Do MMM YYYY ") + D.moment(fromtime).format( "HH:mm" )
       }
       onTotimeChanged: {
           euto.text = D.moment(evdate).format("ddd Do MMM YYYY ") + D.moment(totime).format( "HH:mm" )
           etutabs.tim2 = totime
       }

        Rectangle {
            id: eutop
            color: "green"
            width: parent.width
            height: tb1.height
            anchors.top: parent.top
            radius: 4
            Button {
                id:eucancel
                height: parent.height
                width: parent.width/4

                style: ButtonStyle {
                        background: Rectangle {
                            implicitWidth: parent.width
                            implicitHeight: parent.height
                            border.width: control.activeFocus ? 2 : 1
                            border.color: "#888"
                            radius: 4
                            color: "light green"
                        }
                        label: Text {
                            text: "Cancel"
                            color: "white"
                            font.pixelSize: parent.width/6 | 0
                        }
                }
                onClicked: {
                    eventUpdate.visible = false
                    eventUpdate.z = 1
                }

            }
            Button {
                id:eusave
                height: parent.height
                width: parent.width/4
                anchors.right: parent.right

                style: ButtonStyle {
                        background: Rectangle {
                            implicitWidth: parent.width
                            implicitHeight: parent.height
                            border.width: control.activeFocus ? 2 : 1
                            border.color: "#888"
                            radius: 4
                            color: "light green"
                        }
                        label: Text {
                            text: "Save"
                            color: "white"
                            font.pixelSize: parent.width/6 | 0
                        }
                }
                onClicked: {
                    //
                    //console.log(JSON.stringify({event:{title: edevtext.text,"is_private": false, "user_id": entry.signin.id}} ),eventUpdate.idev)
                    if (eventUpdate.create) {
                        calEvents.newEvent(JSON.stringify({event:{title: edevtext.text,"eventdate": eventUpdate.evdate, "eventstart": etutabs.rettim1, "eventend": etutabs.rettim2 ,"is_private": false, "user_id": entry.signin.id}} ))
                        eventUpdate.visible = false
                        eventUpdate.z = 1

                    }
                    else {

                    calEvents.updateEvent(JSON.stringify({event:{title: edevtext.text,"eventdate": eventUpdate.evdate, "eventstart": etutabs.rettim1, "eventend": etutabs.rettim2 ,"is_private": false, "user_id": entry.signin.id}} ),eventUpdate.idev)
                    eventUpdate.visible = false
                    eventUpdate.z = 1
                    }
                }

            }


        }
        Rectangle {
            id: edevtextbound
            width: parent.width * 0.6; height: edevtext.implicitHeight;
            color: "transparent"
            border.color: "gray"
            border.width: 0.6
            anchors.horizontalCenter: parent.horizontalCenter
            radius: 2
            y: parent.height/8 | 0
        Flickable {
             id: flick

             //width: parent.width; height: parent.height;
             contentWidth: edevtext.paintedWidth
             contentHeight: edevtext.paintedHeight
             clip: true
             anchors.fill: parent

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
                 id: edevtext
                 width: flick.width
                 height: flick.height
                 font.pixelSize:  width * 0.085 | 0
                   text: "placeholder"
                 focus: true
                 wrapMode: TextEdit.Wrap
                 onCursorRectangleChanged: flick.ensureVisible(cursorRectangle)
             }
         }


        }
        Row {
            id:evedfromrow
            anchors.top: edevtextbound.bottom
            anchors.topMargin: parent.height/50 | 0
            anchors.horizontalCenter: parent.horizontalCenter
            height: parent.height/ 11 | 0
            width: parent.width*0.85|0
            Rectangle {
                height: parent.height
                width:parent.width*0.25 | 0
                color: "transparent"
                Text {
                    anchors.left: parent.left
                    anchors.verticalCenter: parent.verticalCenter

                    font.pixelSize: parent.parent.width/14 | 0
                    text: "From"

                }
            }

            Button {
            id:eufrom
            height: parent.height
            width: parent.width*0.75 | 0


            style: ButtonStyle {
                    background: Rectangle {
                        implicitWidth: parent.width
                        implicitHeight: parent.height
                        border.width: control.activeFocus ? 2 : 1
                        border.color: "#888"
                        radius: 4
                        //color: "light blue"
                        gradient: Gradient {
                                        GradientStop { position: 0 ; color: control.pressed ? "#ccc" : "#eee" }
                                        GradientStop { position: 1 ; color: control.pressed ? "#aaa" : "#ccc" }
                                    }
                    }
                    label: Text {
                        id: eufromlab
                        renderType: Text.NativeRendering
                       verticalAlignment: Text.AlignVCenter
                       horizontalAlignment: Text.AlignHCenter
                        text: eufrom.text
                        anchors.centerIn: parent
                        //color: "white"
                        font.pixelSize: parent.width/12 | 0
                    }
            }
            onClicked: {
                /*if (eventTimeUpdate.visible) {
                    eventTimeUpdate.visible = false
                    eventTimeUpdate.z = 1

                }
                else {*/
                    //eventTimeUpdate.visible = true
                    //eventTimeUpdate.z = 100
                    etutabs.currentIndex =0
                    etutabs.tim1 = eventUpdate.fromtime
                    etutabs.tim2 = eventUpdate.totime

            }

        }

        }
        Row {
            id:evedtorow
            anchors.top: evedfromrow.bottom
            anchors.topMargin: parent.height/50 | 0
            anchors.horizontalCenter: parent.horizontalCenter
            height: parent.height/ 11 | 0
            width: parent.width*0.85|0
            Rectangle {
                height: parent.height
                width:parent.width*0.25 | 0
                color: "transparent"
                Text {
                    anchors.left: parent.left
                    anchors.verticalCenter: parent.verticalCenter
                    font.pixelSize: parent.parent.width/14 | 0
                    text: "To"

                }
            }
            Button {
        id:euto
        height: parent.height
        width: parent.width*0.75| 0


        style: ButtonStyle {
                background: Rectangle {
                    implicitWidth: parent.width
                    implicitHeight: parent.height
                    border.width: control.activeFocus ? 2 : 1
                    border.color: "#888"
                    radius: 4
                    //color: "light blue"
                    gradient: Gradient {
                                    GradientStop { position: 0 ; color: control.pressed ? "#ccc" : "#eee" }
                                    GradientStop { position: 1 ; color: control.pressed ? "#aaa" : "#ccc" }
                                }
                }
                label: Text {

                    renderType: Text.NativeRendering
                   verticalAlignment: Text.AlignVCenter
                   horizontalAlignment: Text.AlignHCenter
                    text: euto.text
                    anchors.centerIn: parent
                    //color: "white"
                    font.pixelSize: parent.width/12 | 0
                }
        }
        onClicked: {
            /*if (eventTimeUpdate.visible) {
                eventTimeUpdate.visible = false
                eventTimeUpdate.z = 1

            }
            else {*/
                //eventTimeUpdate.visible = true
                //eventTimeUpdate.z = 100
                etutabs.currentIndex =1

                etutabs.tim1 = eventUpdate.fromtime
                etutabs.tim2 = eventUpdate.totime
                //console.log(eventUpdate.totime,eventUpdate.fromtime)

        }

    }
        }
        TabView {
            id: etutabs
            anchors.top: evedtorow.bottom
            anchors.topMargin: parent.height/50 | 0
            width: parent.width*0.95 | 0
            height: width*0.45|0
            anchors.horizontalCenter: parent.horizontalCenter
            property var tim1
            property var tim2
            property var rettim1
            property var rettim2
            Tab {
               title: "From"


                Comp.TumblerTime {
                    id: te1
                    width:parent.width
                    //height: width*0.25 | 0
                    time: etutabs.tim1
                    onReturnTimeChanged: {
                        etutabs.rettim1 = returnTime
                        eufrom.text = D.moment(eventUpdate.evdate).format("ddd Do MMM YYYY ") + D.moment(returnTime).format( "HH:mm" )

                    }
                }
            }
            Tab {
                title: "To"

                Comp.TumblerTime {
                    id:te2
                    width:parent.width
                    //height: width*0.25 | 0
                    time: etutabs.tim2
                    onReturnTimeChanged: {
                        etutabs.rettim2 = returnTime

                        euto.text = D.moment(eventUpdate.evdate).format("ddd Do MMM YYYY ") + D.moment(returnTime).format( "HH:mm" )
                    }
                }
            }
        }


    }

    Rectangle {
        id: eventTimeUpdate
         width: parent.width*0.4 | 0
         height: parent.height* 0.4 | 0
         visible: false
         z: 1
         y: (top.top | 0) + (top.height - height)/2 | 0
         x: -width
         opacity: 0
         color: topRect.color
         onZChanged: {
             if (z > 5) {

                 animetu.start()
                 animetuop.start()
             }
             else {x = -width; opacity = 0}
         }

    }

    NumberAnimation {
        id: animeu
        target: eventUpdate
        property: "x"
        duration: 400
        easing.type: Easing.InOutQuad
        from: top.width
        to: top.width/2 | 0

    }
    NumberAnimation {
        id: animeuop
        target: eventUpdate
        property: "opacity"
        duration: 400
        easing.type: Easing.InOutQuad
        from: 0
        to: 0.9
    }
    NumberAnimation {
        id: animetu
        target: eventTimeUpdate
        property: "x"
        duration: 400
        easing.type: Easing.InOutQuad
        from: -eventTimeUpdate.width
        to: top.width *0.05 | 0 //(top.width - eventTimeUpdate.width) / 2 | 0
    }
    NumberAnimation {
        id: animetuop
        target: eventTimeUpdate
        property: "opacity"
        duration: 400
        easing.type: Easing.InOutQuad
        from: 0
        to: 0.9
    }


    ListModel {
        id: caldata

    }
    Cont.EventController {
        id: calEvents

        onM3readyChanged: {
            if (m3status == 200) {
                calendar.currentIndex = top.getMonthIndex(entry.selectedDate)
            }
        }
        onReadyChanged: {
            if (status == 201) {
                tim2.start()
            }
            if (status == 202) {
                tim2.start()
            }
        }
    }
    Cont.EventController {
        id: calEvents2
        onM3readyChanged: {
            if (m3status == 200) {

            }
        }
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

