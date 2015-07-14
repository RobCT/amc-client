import QtQuick 2.4

import "../scripts/servReq.js" as F
import "../scripts/globals.js" as G
import "." as L
Item {
    id:subscriptionsController
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
    property string username



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
        subscriptionsController.readyId = callid
        if (callid == 2) {
            subscriptionsController.ready = true
            getAll()
        }
    }
    function getAll() {
        model1.method = "GET"
        model1.source = ""
        model1.source = G.apiRoot + "/subscriptions"
        model1.commit()
        ////console.log("source ", model1.source)
    }
    function getSubscription(pid) {
        model2.method = "GET"
        model2.source = ""
        model2.source = G.apiRoot + "/subscriptions/" + pid.toString() + '?sheets=true'
        model2.commit()
    }


    function newSubscription(p){
        subscriptionsController.ready = false
        var method = 'POST';
        var params = p
        var url = G.apiRoot + "/subscriptions";
        model4.servReq(method, params, url, 2)
        model4.commit()
    }
    function updateSubscription(subscription, rid) {
        subscriptionsController.ready = false
        var method = "PUT"
        var params = subscription
        var url = G.apiRoot + "/subscriptions/" + rid.toString()
        model4.servReq(method, params, url, 2)
        model4.commit()
    }
    function deleteSubscription(pid) {
        subscriptionsController.ready = false
        var method = "DELETE"
        var params = ""
        var url = G.apiRoot + "/subscriptions/" + pid.toString()
        model4.servReq(method, params, url, 2)
        model4.commit()
    }
    onJsnChanged:  {
        try {
        var objectArray = JSON.parse(jsn).user;
            //console.log(jsn)
        } catch(e) {
            return
        }
        try {
            if (objectArray.username.length)
            root.username = objectArray.username
            else {
                var un = objectArray.email.split('@')[0];
                root.username = un
            }


        } catch(e) {
            return
    }

}
}

