import QtQuick 2.4

BorderImage {
    id: root
       border.bottom: 8
       source: "../images/toolbar.png"
       property int navheight
       Component.onCompleted: {
          //console.log(width, height, navheight, entry.depth)
       }




       Rectangle {
           id: backButton
           width: opacity ? root.navheight : 0
           anchors.left: parent.left
           anchors.leftMargin: 20
           opacity: entry.depth > 1 ? 1 : 0
           anchors.verticalCenter: parent.verticalCenter
           antialiasing: true
           height: root.navheight
           radius: 4
           color: backmouse.pressed ? "#222" : "transparent"
           Behavior on opacity { NumberAnimation{} }
           Image {
               anchors.verticalCenter: parent.verticalCenter
               source: "../images/navigation_previous_item.png"
               width: root.navheight
               height: root.navheight
           }
           MouseArea {
               id: backmouse
               anchors.fill: parent
               anchors.margins: -10
               onClicked: {

                   if (entry.depth > 1) {
                      //console.log(entry.depth)
                       entry.pop()
                   }
               }
           }
       }
       Rectangle {
           id: hamb
           width: root.navheight//opacity ? root.navheight : 0
           anchors.right: parent.right
           anchors.rightMargin: 2
           //opacity: entry.depth !=2 ? 1 : 0
           anchors.verticalCenter: parent.verticalCenter
           antialiasing: true
           height: root.navheight
           radius: 4
           color: textmouse.pressed ? "#222" : "transparent"
           Behavior on opacity { NumberAnimation{} }
           Image {
               anchors.verticalCenter: parent.verticalCenter
               source: "../images/hamburgerwhite.png"
               width: root.navheight*0.8
               height: root.navheight*0.8
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
           id: roleRect
           width: root.navheight
           height: root.height
           anchors.top: parent.top
           anchors.left: banner.right
           color: "cyan"
           visible: true
           radius:6
           Text {
               anchors.verticalCenter:  parent.verticalCenter
               text: "Roles"
           }

           MouseArea {
               anchors.fill: parent
               onClicked: {
                   while (entry.depth > 1) {
                       entry.pop()
                   }
                   entry.pushOther(6)

              }
           }
       }
       Rectangle {
           id: peopleRect
           width: root.navheight
           height: root.height
           anchors.top: parent.top
           anchors.left: roleRect.right
           color: "lightgreen"
           visible: true
           radius:6
           Text {
               anchors.verticalCenter:  parent.verticalCenter
               text: "People"
           }

           MouseArea {
               anchors.fill: parent
               onClicked: {
                   while (entry.depth > 1) {
                       entry.pop()
                   }


              }
           }
       }
       Rectangle {
           id: churchRect
           width: root.navheight
           height:root.height
           anchors.top: parent.top
           anchors.left: peopleRect.right
           color: "lightyellow"
           visible: true
           radius:6
           Text {
               anchors.verticalCenter:  parent.verticalCenter
               text: "Church"
           }

           MouseArea {
               anchors.fill: parent
               onClicked: {
                   while (entry.depth > 1) {
                       entry.pop()
                   }
                   entry.pushOther(5)

              }
           }
       }
       Rectangle {
           id: calendarRect
           width: root.navheight
           height:root.height
           anchors.top: parent.top
           anchors.left: churchRect.right
           color: "coral"
           visible: true
           radius:6
           Text {
               anchors.verticalCenter:  parent.verticalCenter
               text: "Calendar"
           }

           MouseArea {
               anchors.fill: parent
               onClicked: {
                   while (entry.depth > 1) {
                       entry.pop()
                   }
                   entry.pushOther(11)

              }
           }
       }
       Rectangle {
           id: templatesRect
           width: root.navheight
           height:root.height
           anchors.top: parent.top
           anchors.left: calendarRect.right
           color: "lightblue"
           visible: true
           radius:6
           Text {
               anchors.verticalCenter:  parent.verticalCenter
               text: "Volunteer Templates"
           }

           MouseArea {
               anchors.fill: parent
               onClicked: {
                   while (entry.depth > 1) {
                       entry.pop()
                   }
                   entry.pushOther(8)

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
   }

