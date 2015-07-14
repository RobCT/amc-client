import QtQuick 2.4
import QtQuick.Dialogs 1.2
import org.qtproject.testapi 1.0
import "../scripts/globals.js" as G
Item {
    id: root
    property var data
    property string filename
    property string content_type
    property int index
    property string desc
    property var addfiles
    property var reader
    function open() {
        fileDialog.open()
    }

    FileDialog {
        id: fileDialog
        visible:false

        function createAttachment() {
            var params = {attachment: {description: root.desc, event_id: root.index, content_type: root.content_type,filename: root.filename }}

            addfiles.newAttachment(JSON.stringify(params))

        }
        onAccepted: {


            var path = fileUrl.toString();
                    // remove prefixed "file:///"
            path = path.replace(/^(file:\/{2})/,"");
                    // unescape html codes like '%23' for '#'

            var cleanPath = decodeURIComponent(path);
            root.filename = fileUrl.toString().split("/").pop()
            root.content_type = "undefined"
            try {
              root.content_type = G.exttoMimeType[root.filename.split(".").pop()]
            }
            catch(err) {
               //console.log("error",err)
            }
            //var datatext = reader.read(cleanPath)
            var ind
            //console.log(datatext)
            root.reader.uploading = true
            root.reader.readbytes(cleanPath)
            //data = reader.read_b64(cleanPath)
            //console.log(data.length)
            //addfiles.upload = B.b64ToByteArray(data)
            //addfiles.upload = data
            addfiles.put = ""

            createAttachment()
            //console.log(dataraw.size)
            //addfiles.sendAttachment(data,content_type,filename, editev.index,  adddesc.text)

        }
    }

}

