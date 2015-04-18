import QtQuick 2.0
import QtQuick.Controls 1.3
import QtQuick.Layouts 1.1
import "../controllers" as Cont
import "../scripts/moment.js" as D
Rectangle {
    width: parent.width
    height: parent.height
    color: "lightsteelblue"

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
                    calendar.selectedDate = calendar.selectedDate.subtract(1,"months")
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
                    calendar.selectedDate = calendar.selectedDate.subtract(1,"years")
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
                    calendar.selectedDate = calendar.selectedDate.add(1,"months")
                    //console.log(calendar.selectedDate)
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
                    calendar.selectedDate = calendar.selectedDate.add(1,"years")
                }

            }
        }

    }

    GridView {
        id:calendar
        anchors.top: topRect.bottom
        anchors.topMargin: parent.height/40
        model: calEvents.model3
        delegate: calDelegate
        width: parent.width
        height: parent.height*7/8
        cellWidth: width/7
        cellHeight: height/(model.count/7) +1
        property var selectedDate
        onSelectedDateChanged:  {
            //console.log(selectedDate,selectedDate.year(),selectedDate.month())
            calEvents.getCalendar(selectedDate.year(),selectedDate.month()+1,01,"month")
            banner.text = selectedDate.format("MMM YYYY")
        }


        Component.onCompleted: {
            selectedDate = D.moment()
            calEvents.getCalendar(selectedDate.year(),selectedDate.month()+1,01,"month")


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
                        console.log(calInfo.text, index)
                        calendar.currentIndex = index
                    }
                }

                Text {
                    id: calInfo

                    text: D.moment(date).format("ddd Do")
                    color: wrapper.GridView.isCurrentItem ? "red" : "black"
                }
            }
        }
    ListModel {
        id: caldata

    }
    Cont.EventController {
        id: calEvents
    }

}

