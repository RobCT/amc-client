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


    id: templatesController
    Component.onCompleted: {
        F.internalQmlObject.servDone.connect(internalRefresh);
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
        templatesController.readyId = callid
        if (callid == 2) {
            templatesController.ready = true
            getAll()
        }
    }
    function getAll() {
        model1.method = "GET"
        model1.source = ""
        model1.source = G.apiRoot + "/templates"
        model1.commit()
        console.log("source ", model1.source)
    }
    function getTemplate(pid) {
        model2.method = "GET"
        model2.source = ""
        model2.source = G.apiRoot + "/templates/" + pid.toString() + '?sheets=true'
        model2.commit()
    }


    function newTemplate(user){
        templatesController.ready = false
        var method = 'POST';
        var params =  user;
        var url = G.apiRoot + "/templates";
        model4.servReq(method, params, url, 2)
        model4.commit()
    }
    function updateTemplate(template, rid) {
        templatesController.ready = false
        var method = "PUT"
        var params = template
        var url = G.apiRoot + "/templates/" + rid.toString()
        model4.servReq(method, params, url, 2)
        model4.commit()
    }
    function deleteTemplate(pid) {
        templatesController.ready = false
        var method = "DELETE"
        var params = ""
        var url = G.apiRoot + "/templates/" + pid.toString()
        model4.servReq(method, params, url, 2)
        model4.commit()
    }
    L.HTTP {
        id: http
        onJsnChanged:  {

        }
    }
}

