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


    id: messagesController
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
        messagesController.readyId = callid
        if (callid == 2) {
            messagesController.ready = true
            getAll()
        }
    }
    function getAll() {
        model1.method = "GET"
        model1.source = ""
        model1.source = G.apiRoot + "/messages"
        model1.commit()
        ////console.log("source ", model1.source)
    }
    function getAllForRoom(event) {
        model1.method = "GET"
        model1.source = ""
        model1.source = G.apiRoot + "/messages?event_id=" + event.toString()
        model1.commit()
        ////console.log("source ", model1.source)
    }
    function getMessage(mid) {
        model2.method = "GET"
        model2.source = ""
        model2.source = G.apiRoot + "/messages/" + mid.toString()
        model2.commit()
    }


    function newMessage(user){
        messagesController.ready = false
        var method = 'POST';
        var params =  user;
        var url = G.apiRoot + "/messages";
        model4.servReq(method, params, url, 2)
        model4.commit()
    }
    function updateMessage(message, rid) {
        messagesController.ready = false
        var method = "PUT"
        var params = message
        var url = G.apiRoot + "/messages/" + rid.toString()
        model4.servReq(method, params, url, 2)
        model4.commit()
    }
    function deleteMessage(pid) {
        messagesController.ready = false
        var method = "DELETE"
        var params = ""
        var url = G.apiRoot + "/messages/" + pid.toString()
        model4.servReq(method, params, url, 2)
        model4.commit()
    }

}

