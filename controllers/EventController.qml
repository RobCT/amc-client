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
    property alias m3ready: model3.ready
    property alias m3status: model3.status
    property alias m3jsn: model3.json





    id: eventsController
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
        id:model3
    }

    L.JSONListModel {
        id:model4
    }


    function internalRefresh(callid) {
        eventsController.readyId = callid
        if (callid == 2) {
            eventsController.ready = true
            getAll()
        }
    }
    function getAll() {

        model1.method = "GET"

        model1.source = ""
        model1.source = G.apiRoot + "/events"
        model1.commit()
        ////console.log("source ", model1.source)
    }
    function getEvent(pid) {
        model2.method = "GET"

        model2.source = ""
        model2.source = G.apiRoot + "/events/" + pid.toString() + '?sheets=true'
        model2.commit()
    }
    function getCalendar(year, month, day, type) {
        eventsController.ready = false
        model3.params = JSON.stringify({"event":{"year": year, "month": month, "day": day, "type": type}})
        model3.method =  "POST"
        //console.log("params", model3.params)

        model3.source = G.apiRoot + "/event/calendar"
        model3.commit()
        //http.servReq(method, params, url, 2)


    }
    function getMyCalendar(year, month, day, type) {
        eventsController.ready = false
        model3.params = JSON.stringify({"event":{"year": year, "month": month, "day": day, "type": type}})
        model3.method =  "POST"
        //console.log("params", model3.params)

        model3.source = G.apiRoot + "/event/my_calendar"
        model3.commit()

        //http.servReq(method, params, url, 2)


    }

    function getMonth(year, month) {
        var sd = D.moment([year,month,1])
        var ed = D.moment([year,month,1])

        var dd = ed
        dd = dd.add(1,'months')
        dd = dd.subtract(1,'days')

        model2.method = "GET"
        model2.source = ""
        model2.source =  G.apiRoot + "/events?date_from=" + sd.format('YYYY-M-DD') + '&?date_to=' + dd.format('YYYY-M-DD')
        model2.commit()

    }
    function getDay(year, month, day) {
        var sd = D.moment([year,month,day])


        model2.method = "GET"
        model2.source = ""
        model2.source =  G.apiRoot + "/events?event_date=" + sd.format('YYYY-M-DD')
        model2.commit()

    }

    function newEvent(user){
        eventsController.ready = false
        var method = 'POST';
        var params =  user;
        var url = G.apiRoot + "/events";

        model4.servReq(method, params, url, 2)
        model4.commit()

    }
    function updateEvent(Event, rid) {
        eventsController.ready = false
        var method = "PUT"
        var params = Event
        var url = G.apiRoot + "/events/" + rid.toString()

        model4.servReq(method, params, url, 2)
        model4.commit()

    }
    function deleteEvent(pid) {
        eventsController.ready = false
        var method = "DELETE"
        var params = ""
        var url = G.apiRoot + "/events/" + pid.toString()

        model4.servReq(method, params, url, 2)
        model4.commit()
    }
    L.HTTP {
        id: http
        onReadyChanged: {
            ////console.log("readyChangedathttp")
        }


        onJsnChanged:  {
            //mf.ta1.append(JSON.stringify(jsn)
            //userController.jsn = jsn
           // userController.ready = true

            ////console.log(jsn, status)

            //userController.status = status
        }
    }
}

