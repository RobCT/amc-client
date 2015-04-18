import QtQuick 2.4

import "../scripts/servReq.js" as F
import "../scripts/globals.js" as G
import "../scripts/moment.js" as D
import "." as L
Item {
    property alias model1: model1.model
    property alias model2: model2.model
    property alias model3: model3.model
    property alias ready: http.ready
    property int readyId
    property alias jsn: http.jsn
    property alias status: http.status



    id: eventsController
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

    function internalRefresh(callid) {
        eventsController.readyId = callid
        if (callid == 2) {
            eventsController.ready = true
            getAll()
        }
    }
    function getAll() {
        model1.source = ""
        model1.source = G.apiRoot + "/events"
        console.log("source ", model1.source)
    }
    function getEvent(pid) {
        model2.source = ""
        model2.source = G.apiRoot + "/events/" + pid.toString()
    }
    function getCalendar(year, month, day, type) {
        eventsController.ready = false
        model3.params = JSON.stringify({"events":{"year": year, "month": month, "day": day, "type": type}})
        model3.method =  "POST"
        model3.source = G.apiRoot + "/event/calendar"
        //http.servReq(method, params, url, 2)


    }

    function getMonth(year, month) {
        var sd = D.moment([year,month,1])
        var ed = D.moment([year,month,1])

        var dd = ed
        dd = dd.add(1,'months')
        dd = dd.subtract(1,'days')
        model2.source = ""
        model2.source =  G.apiRoot + "/events?date_from=" + sd.format('YYYY-M-DD') + '&date_to=' + dd.format('YYYY-M-DD')

    }
    function getDay(year, month, day) {
        var sd = D.moment([year,month,day])


        model2.source = ""
        model2.source =  G.apiRoot + "/events?date_from=" + sd.format('YYYY-M-DD') + '&date_to=' + sd.format('YYYY-M-DD')

    }

    function newEvent(user){
        eventsController.ready = false
        var method = 'POST';
        var params =  user;
        var url = G.apiRoot + "/events";
        http.servReq(method, params, url, 2)
    }
    function updateEvent(Event, rid) {
        eventsController.ready = false
        var method = "PUT"
        var params = Event
        var url = G.apiRoot + "/events/" + rid.toString()
        http.servReq(method, params, url, 2)
    }
    function deleteEvent(pid) {
        eventsController.ready = false
        var method = "DELETE"
        var params = ""
        var url = G.apiRoot + "/events/" + pid.toString()
        http.servReq(method, params, url, 2)
    }
    L.HTTP {
        id: http
        onJsnChanged:  {
            //mf.ta1.append(JSON.stringify(jsn)
            //userController.jsn = jsn
           // userController.ready = true
            //console.log(jsn, status)
            //userController.status = status
        }
    }
}

