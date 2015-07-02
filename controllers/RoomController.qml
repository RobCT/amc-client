import QtQuick 2.4

import "../scripts/servReq.js" as F
import "../scripts/globals.js" as G
import "." as L
Item {
    property alias model1: model1.model
    property alias model2: model2.model
    property alias m2ready: model2.ready
    property alias m2status: model2.status
    property alias ready: model4.ready
    property int readyId
    property alias jsn: model4.json
    property alias status: model4.status
    property alias m1ready: model1.ready
    property alias m1status: model1.status


    id: roomsController
    Component.onCompleted: {
        F.internalQmlObject.servDone.connect(internalRefresh);
        //G.apiRoot=Qt.platform.os == "android" ? "192.168.0.103:8080" : "127.0.0.1:8080"
    }
    L.JSONListModel {
        id:model1
    }
    L.JSONListModel {
        id:model2
    }
    L.JSONListModel {
        id:model4
    }
    function internalRefresh(callid) {
        roomsController.readyId = callid
        if (callid == 2) {
            roomsController.ready = true
            getAll()
        }
    }
    function getAll() {
        model1.method = "GET"
        model1.source = ""
        model1.source = G.apiRoot + "/rooms"
        model1.commit()
        ////console.log("source ", model1.source)
    }
    function getEventRoom(event) {
        model1.method = "GET"
        model1.source = ""
        model1.source = G.apiRoot + "/rooms?event_id=" + event.toString()
        model1.commit()
        ////console.log("source ", model1.source)
    }
    function getRoom(pid) {
        model2.method = "GET"
        model2.source = ""
        model2.source = G.apiRoot + "/rooms/" + pid.toString() + '?sheets=true'
        model2.commit()
    }


    function newRoom(user){
        roomsController.ready = false
        var method = 'POST';
        var params =  user;
        var url = G.apiRoot + "/rooms";
        model4.servReq(method, params, url, 2)
        model4.commit()
    }
    function updateRoom(room, rid) {
        roomsController.ready = false
        var method = "PUT"
        var params = room
        var url = G.apiRoot + "/rooms/" + rid.toString()
        model4.servReq(method, params, url, 2)
        model4.commit()
    }
    function deleteRoom(pid) {
        roomsController.ready = false
        var method = "DELETE"
        var params = ""
        var url = G.apiRoot + "/rooms/" + pid.toString()
        model4.servReq(method, params, url, 2)
        model4.commit()
    }

}

