import QtQuick 2.4

BorderImage {
    id: root
       border.bottom: 8
       source: "../images/toolbar2.png"
       property int navheight
       Component.onCompleted: {
          //console.log(width, height, navheight, entry.depth)
       }




       Rectangle {
           id: backButton
           width: opacity ? parent.height : 0
           anchors.left: parent.left
           anchors.leftMargin: 20
           opacity: entry.depth > 1 ? 1 : 0
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

                   if (entry.depth > 1) {
                      entry.pop({item:entry.initialItem, immediate: false})

                   }
               }
           }
       }
       Rectangle {
           id: hamb
           width: parent.height//opacity ? parent.height : 0
           anchors.right: parent.right
           anchors.rightMargin: 2
           //opacity: entry.depth !=2 ? 1 : 0
           anchors.verticalCenter: parent.verticalCenter
           antialiasing: true
           height: parent.height
           radius: 4
           color: textmouse.pressed ? "#222" : "transparent"
           Behavior on opacity { NumberAnimation{} }
           Image {
               anchors.verticalCenter: parent.verticalCenter
               source: "../images/hamburgerwhite.png"
               width: parent.height*0.8
               height: parent.height*0.8
           }
           MouseArea {
               id: textmouse
               anchors.fill: parent
               anchors.margins: -10
               onClicked: {
                  hamburger()
               }
           }
       }
       Rectangle {
           id: month
           Behavior on x { NumberAnimation{ easing.type: Easing.OutCubic} }
           x: banner.x + banner.width + 20
           width: monthText.implicitWidth
           color: "transparent"
           anchors.verticalCenter: parent.verticalCenter
           antialiasing: true
           height: parent.height
           Text {
               id:monthText
               color: "white"
               font.pixelSize:root.height/2 | 0
               anchors.verticalCenter: parent.verticalCenter
               //Behavior on x { NumberAnimation{ easing.type: Easing.OutCubic} }
               //x: banner.x + banner.width + 20
               text: "Month"

           }
           MouseArea {
               id: monthmouse
               anchors.fill: parent
               anchors.margins: -10
               onClicked: {
                   monthcalendar()
               }
           }

       }
       Rectangle {
           id: week
           Behavior on x { NumberAnimation{ easing.type: Easing.OutCubic} }
           x: month.x + month.width + 20
           width: weekText.implicitWidth
           color: "transparent"
           //opacity: entry.depth !=2 ? 1 : 0
           anchors.verticalCenter: parent.verticalCenter
           antialiasing: true
           height: parent.height
           Text {
               id:weekText
               color: "white"
               font.pixelSize:root.height/2 | 0
               anchors.verticalCenter: parent.verticalCenter
               //Behavior on x { NumberAnimation{ easing.type: Easing.OutCubic} }
               //x: month.x + month.width + 20
               text: "Week"

           }
           MouseArea {
               id: weekhmouse
               anchors.fill: parent
               anchors.margins: -10
               onClicked: {
                   weekcalendar()
               }
           }
       }
       Rectangle {
           id: day
           Behavior on x { NumberAnimation{ easing.type: Easing.OutCubic} }
           x: week.x + week.width + 20
           width: dayText.implicitWidth
           color: "transparent"
           //anchors.left: week.right
           //anchors.leftMargin: 2
           //opacity: entry.depth !=2 ? 1 : 0
           anchors.verticalCenter: parent.verticalCenter
           antialiasing: true
           height: parent.height
           Text {
               id:dayText
               color: "white"
               font.pixelSize:root.height/2 | 0
               anchors.verticalCenter: parent.verticalCenter
               //Behavior on x { NumberAnimation{ easing.type: Easing.OutCubic} }
               //x: week.x + week.width + 20
               text: "Day"

           }
           MouseArea {
               id: dayhmouse
               anchors.fill: parent
               anchors.margins: -10
               onClicked: {
                   daycalendar()
               }
           }

       }
       Text {
           id: banner
           font.pixelSize:root.height/2 | 0
           Behavior on x { NumberAnimation{ easing.type: Easing.OutCubic} }
           x: backButton.x + backButton.width + 20
           anchors.verticalCenter: parent.verticalCenter
           color: "white"
           text: "Church Planner"
       }
       Rectangle {
           id: plus
           width: parent.height//opacity ? parent.height : 0
           anchors.right: hamb.left
           anchors.rightMargin: 2
           //opacity: entry.depth !=2 ? 1 : 0
           anchors.verticalCenter: parent.verticalCenter
           antialiasing: true
           height: parent.height
           radius: 4
           color: plusmouse.pressed ? "#222" : "transparent"
           Behavior on opacity { NumberAnimation{} }
           Image {
               anchors.verticalCenter: parent.verticalCenter
               source: "../images/plus.svg"
               width: parent.height*0.8
               height: parent.height*0.8
           }
           MouseArea {
               id: plusmouse
               anchors.fill: parent
               anchors.margins: -10
               onClicked: {
                    addevent()
               }
           }
       }
   }

