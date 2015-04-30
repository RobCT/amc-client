import QtQuick 2.4

import "../scripts/servReq.js" as F
import "../scripts/globals.js" as G
import "../scripts/moment.js" as D
import "." as L
Item {
    property alias model1: model1.model
    property alias model2: model2.model
    property alias model3: model3.model
    property alias model4: model4

    property alias m2ready: model2.ready
    property alias m2status: model2.status
    property alias ready: model4.ready
    property int readyId
    property alias jsn: model4.json
    property alias status: model4.status




    id: sheetController
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
        id:model3
    }
    L.JSONListModel {
        id:model4
    }

    function internalRefresh(callid) {
        sheetController.readyId = callid
        if (callid == 2) {
            sheetController.ready = true
            getAll()
        }
    }
    function getAll() {
        model1.method = "GET"

        model1.source = ""
        model1.source = G.apiRoot + "/volunteersheets"
        model1.commit()
        //console.log("source ", model1.source)
    }
    function getSheet(pid) {
        model2.method = "GET"

        model2.source = ""
        model2.source = G.apiRoot + "/volunteersheets/" + pid.toString() + '?sheets=true'
        model2.commit()
    }

    function newSheet(user){
        sheetController.ready = false
        var method = 'POST';
        var params =  user;
        var url = G.apiRoot + "/volunteersheets";
        model4.servReq(method, params, url, 2)
        model4.commit()
    }

    function cloneSheet(user){
        sheetController.ready = false
        var method = 'POST';
        var params =  user;
        var url = G.apiRoot + "/template/clone_template";
        model4.servReq(method, params, url, 2)
        model4.commit()
    }

    function updateSheet(Sheet, rid) {
        sheetController.ready = false
        var method = "PUT"
        var params = Sheet
        var url = G.apiRoot + "/volunteersheets/" + rid.toString()
        model4.servReq(method, params, url, 2)
        model4.commit()
    }
    function deleteSheet(pid) {
        sheetController.ready = false
        var method = "DELETE"
        var params = ""
        var url = G.apiRoot + "/volunteersheets/" + pid.toString()
        model4.servReq(method, params, url, 2)
        model4.commit()
    }
    L.HTTP {
        id: http
        onReadyChanged: {
            //console.log("readyChangedathttp")
        }

        onJsnChanged:  {
            //mf.ta1.append(JSON.stringify(jsn)
            //userController.jsn = jsn
           // userController.ready = true
            //console.log(jsn, status)
            //userController.status = status
        }
    }
}

