Qt.include("../scripts/globals.js")

var internalQmlObject = Qt.createQmlObject('import QtQuick 2.0; QtObject { signal servDone(int value) }', Qt.application, 'InternalQmlObject');

function servReq(method, params, url, callid) {
    var xhr = new XMLHttpRequest();
    xhr.onreadystatechange=function(){
      if (xhr.readyState==4 && xhr.status==200)
      {
          internalQmlObject.servDone(callid);
          fromid = xhr.responseText
          return jsonString

      }
      if (xhr.readyState==4) {
          internalQmlObject.servDone(callid);
          jsonString = xhr.responseText
          //json = jsonString
          return jsonString


      }
    }
    var async = true;
    xhr.open(method, url, async);
  //Need to send proper header information with POST request
  xhr.setRequestHeader('Content-type', 'application/json');
  xhr.setRequestHeader('Content-length', params.length);
  xhr.setRequestHeader('Accept', 'application/vnd.marketplace.v1');
    xhr.setRequestHeader('Connection', 'close');
    if (params.length) {
        xhr.send(params);
    }
    else xhr.send();
}

