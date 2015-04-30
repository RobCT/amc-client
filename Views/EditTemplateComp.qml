import QtQuick 2.4
import QtQuick.Controls 1.3
import QtQuick.Layouts 1.1
import QtQuick.Dialogs 1.2
import QtQuick.Controls.Styles 1.2
import "." as Local
import "../controllers" as Cont
import "../scripts/moment.js" as D
import "../components" as Comp

Rectangle {
    id: top
    color: "linen"
    width: parent.width
    height: parent.height

    onVisibleChanged: {
        if (visible) {
            cont1.getAll()
            console.log("mmmmmm")
        }
    }
    Component.onCompleted: {
        cont1.getAll()
        console.log("mmmmmm")
    }

   Row {
       width: parent.width
       height: parent.height
    ListView {
        id: templates
        delegate: templatesDelegate
        //header: templatesHeader
        width: parent.width*2/3
        height: parent.height
        property int rowheight: (height -30)/6
        property var currentIndex
        property var dialogin


    }

    Component {
        id: templatesDelegate
        Item {
            id: tdel
            height: templates.rowheight
            width: templates.width


        Rectangle {
            width: templates.width ;
            height: parent.height
            border.color: "grey"
            border.width: 1
            color: index == templates.currentIndex ? "aquamarine" : "transparent"
            Dialog {
                id: getInp
                y: 20
                onVisibleChanged: {
                    if (visible) {
                    inp.text = templates.dialogin
                    console.log("diain", templates.dialogin)
                    }
                }
                 Rectangle {
                     id: getInpRect
                     implicitWidth: inp.implicitWidth
                     implicitHeight: inp.implicitHeight
                    TextField {
                        id: inp
                        visible: true
                        style: TextFieldStyle {
                            id: styleit
                            font.pointSize: 26
                            background: Rectangle {
                                //color: index == volunteers.currentIndex ? "aquamarine" : "transparent"
                                border.width: 1}
                        }
                        //height: parent.height  ;
                        verticalAlignment: Text.AlignVCenter;

                        onEditingFinished: {


                            cont1.updateTemplate(JSON.stringify({"title": text}),id)
                        }
                        onVisibleChanged:  {
                            if (visible) {
                            text = templates.dialogin
                                                        }
                        }
                    }

                }
                 onAccepted: {
                     //aboutma.enabled = true
                     cont1.updateTemplate(JSON.stringify({"title": inp.text}),id)
                 }
            }


             Text {  width: parent.width ;height: parent.height; horizontalAlignment: Text.AlignHCenter ;verticalAlignment: Text.AlignVCenter;text:  title }
             MouseArea {
                 width: parent.width
                 height: parent.height
                 onClicked:  {
                     templates.currentIndex = index
                 }
                 onPressAndHold: {
                     enabled = false
                     templates.dialogin= title
                     getInp.open()

                 }
             }
        }
    }
    }
//    Component {
//        id: templatesHeader
//    }
    Rectangle {
        id: controls
        color: "yellow"
        visible: true
        //anchors.left: volunteers.right
        height:parent.height
        x: parent.width*2/3
        width:parent.width/8
        Rectangle {
            id: act1
            width: parent.width
            height: parent.height/5
            anchors.top: parent.top
            anchors.left: parent.left


            radius: 10
            color: "blue"
            visible: true
            Image {
                anchors.verticalCenter: parent.verticalCenter
                source: "../images/navigation_previous_item.png"
                width: parent.width
                height:parent.height
            }
            MouseArea {
                anchors.fill: parent
                onClicked: {
                    cont1.newTemplate(JSON.stringify({"title": "New title"}))
                }

            }
        }
        Rectangle {
            id: addSheets
            width: parent.width
            height: parent.height/5
            anchors.top: act2.bottom
            anchors.left: parent.left



            radius: 10
            color: "coral"

            Text {
                width: parent.width ;height: parent.height; verticalAlignment: Text.AlignVCenter;
                text: "ADD Volunteer Sheet"
            }

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    entry.push({item: sheets, properties: {index: cont1.model1.get(templates.currentIndex).id}})
                    //var rid = tabRoles.model.get(tabRoles.currentRow).id
                    //console.log(tabRoles.currentRow, riid)
                    //cont2.deletePersonRole(top.pid, rid )

                    //console.log(entry.pid)
                    //cont1.getRoles(top.pid)


                }
            }
        }
    }

   }




    Cont.TemplateController {
        id: cont1
        onM1readyChanged: {
            templates.model = cont1.model1
            console.log(cont1.model1.count)
        }

                onReadyChanged: {

                        if (status == 200) {
                            //GET

                        }
                        if (status == 201) {
                            //POST
                            cont1.getAll()


                        }
                        if (status == 202) {
                            //PUT
                            cont1.getAll()
                            //console.log("PUTpf")

                        }
                        if (status == 203) {
                            //PUT
                            cont1.getAll()

                        }
                        if (status == 204) {
                            //DELETE
                            cont1.getAll()

                        }
                        if (status == 422) {

                            //error
                            console.log(JSON.stringify(JSON.parse(jsn).errors))
                            entry.status = JSON.stringify(JSON.parse(jsn).errors)


                        }
                }


    }
    Component {
        id: sheets
        Local.EditTemplateVolunteerSheet {

        }
    }
}

