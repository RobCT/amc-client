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
    property var upload
    property var download
    property string put
    property string get



    id: attachmentsController
    Item {
        id: priv
        property var parsarray: []
        property int arrind: 0

    }
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
    L.HTTP {
        id: posts

    }


    function internalRefresh(callid) {
        attachmentsController.readyId = callid
        if (callid == 2) {
            attachmentsController.ready = true
            getAll()
        }
    }
    function getAll() {
        model1.method = "GET"
        model1.source = ""
        model1.source = G.apiRoot + "/attachments"
        model1.commit()
        //////console.log("source ", model1.source)
    }
    function getAllForEvent(event) {
        model1.method = "GET"
        model1.source = ""
        model1.source = G.apiRoot + "/attachments?event_id=" + event.toString()
        model1.commit()
        //////console.log("source ", model1.source)
    }
    function getAttachment(mid) {
        model2.method = "GET"
        model2.source = ""
        model2.source = G.apiRoot + "/attachments/" + mid.toString()
        model2.commit()
    }


    function newAttachment(user){
        attachmentsController.ready = false
        var method = 'POST';
        var params =  user;
        var url = G.apiRoot + "/attachments";
        model4.servReq(method, params, url, 2)
        model4.commit()
    }
    function buildAttachment(user){
        attachmentsController.ready = false
        var method = 'POST';
        var params =  user;
        var url = G.apiRoot + "/attachment/buildpart";
        posts.servReq(method, params, url, 2)
        posts.commit()
    }
    function updateAttachment(attachment, rid) {
        attachmentsController.ready = false
        var method = "PUT"
        var params = attachment
        var url = G.apiRoot + "/attachments/" + rid.toString()
        model4.servReq(method, params, url, 2)
        model4.commit()
    }
    function deleteAttachment(pid) {
        attachmentsController.ready = false
        var method = "DELETE"
        var params = ""
        var url = G.apiRoot + "/attachments/" + pid.toString()
        model4.servReq(method, params, url, 2)
        model4.commit()
    }
    function sendAttachment(file, content_type, filename, event_id, description) {
        if (file.length > 50000) {
            var slice = []
            slice = splitBuild(file)
            var parsarray = []
            var init = {attachment: {init: "", multi_part: ""}}
            parsarray[0] = init

            var ind
            for (ind = 0; ind < slice.length; ind++) {
                parsarray[ind+1] = {attachment: {description:description, sequence: 1,how_many: 3,event_id: event_id, multi_part: "", part: "",content_type: content_type,filename: filename }}
                parsarray[ind+1]["attachment"]["part"] = slice[ind]
                parsarray[ind+1]["attachment"]["how_many"] = slice.length
                parsarray[ind+1]["attachment"]["sequence"] = ind+1

            }
            priv.parsarray = parsarray
            priv.arrind = 0
            newAttachment(JSON.stringify(priv.parsarray[0]))
        }
        else {
            var pars = {attachment: {description:description,event_id: event_id, file: {content_type: content_type, filename: filename, data: file}}}
            newAttachment(JSON.stringify(pars))
        }
    }

    function splitBuild(file) {
        var ind
        var slice = []
        var strslic = ""
        for (ind = 0; ind < (file.length/50000 | 0) ; ind++) {
            ////console.log(ind, ind*50000,(ind+1)*50000)
            //strslic = file.slice(ind*5000000, (ind+1)*5000000)
            slice[ind] = file.slice(ind*50000, (ind+1)*50000)
        }
        ////console.log((file.length/50000 | 0) + 1,(file.length/50000 | 0) * 50000)
        slice[(file.length/50000 | 0) ] = file.slice((file.length/50000 | 0) * 50000, file.length)
        return slice
    }
    onReadyChanged: {

            if (status == 202) {
                var ret = JSON.parse(jsn)
                attachmentsController.put = ret["put"]
                    ////console.log(ret["id"], ret["put"])
                //toAWS('PUT', upload, ret["put"])


            }
            if (status == 203) {
                var del = jsn
                ////console.log("deljsn",del)
                attachmentsController.servReq('DELETE', "", del)



            }


    }
    function servReq(method, params, url) {
        var xhr = new XMLHttpRequest();
        var async = true;
        xhr.open(method, url, async);
        xhr.send();
    }
}










