/* JSONListModel - a QML ListModel with JSON and JSONPath support
 *
 * Copyright (c) 2012 Romain Pokrzywka (KDAB) (romain@kdab.com)
 * Licensed under the MIT licence (http://opensource.org/licenses/mit-license.php)
 */

import QtQuick 2.4
import "jsonpath.js" as JSONPath
import "../scripts/servReq.js" as Func
import "../scripts/globals.js" as G


Item {
    id: intmodel

    property string source: ""
    property var json: http.jsn
    property string query: ""
    property int readyId
    property string method
    property string params
    property alias ready: http.ready
    property alias status: http.status


    property ListModel model : ListModel { id: jsonModel }
    property alias count: jsonModel.count
    Component.onCompleted: {
        Func.internalQmlObject.servDone.connect(internalCom);
        method = "GET"

    }
    function internalCom(callid)    {
        if (callid == 99) {
            //ready = true
        }
    }

    onSourceChanged: {
        somethingChanged()
    }
    onParamsChanged: {
        somethingChanged()
    }

    onJsonChanged: updateJSONModel()
    onQueryChanged: updateJSONModel()

    function updateJSONModel() {
        jsonModel.clear();
        //console.log(json)

        if ( json === "" )
            return;
        try{
            var    a=JSON.parse(json);
         }catch(e){
              //error in the above string(in this case,yes)!

            return;
         }


        var objectArray = parseJSONString(json, query);
        //console.log("count", objectArray)
        //jsonModel.append(objectArray)

        for ( var key in objectArray ) {
            var jo = objectArray[key];
            //console.log(jo)
            jsonModel.append( jo );
        }
       // }
    }

    function parseJSONString(jsonString, jsonPathQuery) {
        var objectArray = JSON.parse(jsonString);
        if ( jsonPathQuery !== "" )
            objectArray = JSONPath.jsonPath(objectArray, jsonPathQuery);

        return objectArray;
    }
    function somethingChanged() {
        if (method === "GET") {

            try {
                G.jsonString = ""
               http.servReq("GET", "", source, 99)
                console.log("source",source, json)
                ready = false
                G.jsonString = json

            } catch(e) {

                return;
            }
        }
        else {
            try {
               http.servReq(method, params, source, 99)
                console.log("source",source, json)
                //ready = false
                method = "GET"
            } catch(e) {

                return;
            }

        }
    }

    HTTP {
        id: http
        onJsnChanged:  {
            //mf.ta1.append(JSON.stringify(jsn))
        }
    }
}
