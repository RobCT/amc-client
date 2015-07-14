import QtQuick 2.4
import QtQuick.Controls 1.3
import QtQuick.Window 2.2
import QtQuick.Controls.Styles 1.2
import QtQuick.Dialogs 1.2
import QtQuick.LocalStorage 2.0
import QtQuick.Layouts 1.1
import Qt.labs.settings 1.0
//import custom.controls 1.1
import "." as L
import "../components" as Comp
import "../scripts/moment.js" as D
import "../scripts/globals.js" as G
//import "../controllers" as Cont






Rectangle {
    id: mainWindow
    //title: qsTr("")
    width: 800//Screen.width
    height: 600//Screen.height
    property int navheight
    navheight: height/8
    visible: true
    property string topwidg: "Top"
    signal hamburger()
    signal weekcalendar()
    signal monthcalendar()
    signal daycalendar()
    signal addevent()
    property var statusBar: StatusBar {
        RowLayout {

            Label { id:status; text: entry.status }
        }
    }



    Settings {
        id: settings
        property string email
        property string password
        property string username


    }

    Rectangle {
        color: "black"/*"#212126"*/
        anchors.fill: parent
    }
    property var toolBar: BorderImage {
        border.bottom: 8
        source: "../images/toolbar.png"
        width: mainWindow.parent.width
        height: mainWindow.parent.height/11
        anchors.top: mainWindow.parent.top

        Rectangle {
            id: backButton
            width: opacity ? mainWindow.navheight : 0
            anchors.left: parent.left
            anchors.leftMargin: 20
            opacity: entry.depth > 1 ? 1 : 0
            anchors.verticalCenter: parent.verticalCenter
            antialiasing: true
            height: mainWindow.navheight
            radius: 4
            color: backmouse.pressed ? "#222" : "transparent"
            Behavior on opacity { NumberAnimation{} }
            Image {
                anchors.verticalCenter: parent.verticalCenter
                source: "../images/navigation_previous_item.png"
                width: mainWindow.navheight
                height: mainWindow.navheight
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
            width: mainWindow.navheight//opacity ? mainWindow.navheight : 0
            anchors.right: parent.right
            anchors.rightMargin: 2
            //opacity: entry.depth !=2 ? 1 : 0
            anchors.verticalCenter: parent.verticalCenter
            antialiasing: true
            height: mainWindow.navheight
            radius: 4
            color: textmouse.pressed ? "#222" : "transparent"
            Behavior on opacity { NumberAnimation{} }
            Image {
                anchors.verticalCenter: parent.verticalCenter
                source: "../images/hamburgerwhite.png"
                width: mainWindow.navheight*0.8
                height: mainWindow.navheight*0.8
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
            width: mainWindow.navheight
            height: mainWindow.height/11
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
            width: mainWindow.navheight
            height: mainWindow.height/11
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
            width: mainWindow.navheight
            height:mainWindow.height/11
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
            width: mainWindow.navheight
            height:mainWindow.height/11
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
            width: mainWindow.navheight
            height:mainWindow.height/11
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
            font.pixelSize: mainWindow.height/20
            Behavior on x { NumberAnimation{ easing.type: Easing.OutCubic} }
            x: backButton.x + backButton.width + 20
            anchors.verticalCenter: parent.verticalCenter
            color: "white"
            text: "Church Planner"
        }
    }
    StackView {
        id: entry
        anchors.fill: parent
        property var editProperties: {"toEdit": ""  , "editText": "", editTime: "null", editDate: "", editDone: false, recordId: "", editType: "" }
        property string status
        property var calChangeProperties: {"my_calendar": false, "selectedDate": D.moment(new Date)}
        property var lists
        property var pid
        property var signin: {"id": 0,"signedin": false, "auth_token": "", "socket_token": "", "userName": "", "currentEmail": "", "currentPassword": ""}
        property var initialItem: personComp
        property var cal: calendar
        property var  selectedDate
        property int startingCalIndex
        onSelectedDateChanged: {
            console.log("seldatechng", selectedDate)
        }
        onStartingCalIndexChanged: {
            console.log("calind", startingCalIndex)
        }

       Component.onCompleted: {
           signin.userName = settings.username
           signin.currentEmail = settings.email
           signin.currentPassword = settings.password

           //console.log(signin.currentPassword,signin.auth_token)
           lists = {"blank": {}, "loaded": {}, "update": false, "create": false}
           if (signin.signedin) {

               push(personComp)
           }
           else {
               //console.log("signin", signin.currentEmail, signin.currentPassword)
               push(signinComp)
           }
        }
       Component.onDestruction: {
           settings.username = signin.userName
           settings.email = signin.currentEmail
           settings.password = signin.currentPassword

           //console.log(signin.currentPassword,signin.auth_token)
       }
        function pushOther(val) {
            //console.log("signal", val )
            if (val === 1) replace(personComp)
            else if (val === 99) push(signinComp)
            else if (val === 2) push({item: editPerson, properties: {newp: false}})
            else if (val === 3) push({item: editPerson, properties: {newp: true}})
            else if (val === 4) push({item: editPersonRoles, properties: {pid: lists.loaded.id}})
            else if (val === 6) push(editRoles)
            else if (val === 7) push(ev2Comp)
            else if (val === 8) push(volTemplates)
            else if (val === 11) {push({item: calendar, properties: {selectedDate: D.moment(new Date)}}); startingCalIndex = depth}
            }




    }

    Component {
        id: personComp
    L.PersonForm {
        id: pf

    }
    }
    Component {
        id: signinComp
    L.SignIn {
        id: si

    }
    }
    Component {
        id: editPerson
        L.EditPersonComp {

        }
    }
    Component {
        id: editRoles
        L.EditRolesComp {

        }
    }
    Component {
        id: editPersonRoles
        L.EditPersonRolesComp {

        }
    }
    Component {
        id: calendar
        L.CalendarMonth {

        }
    }


    Component {
        id: ev2Comp
        Comp.EditEvent {

        }
    }
    Component {
        id: volTemplates
        L.EditTemplateComp {

        }
    }


}

