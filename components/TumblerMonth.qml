import QtQuick 2.4
import QtQuick.Controls 1.3
import QtQuick.Layouts 1.1
//import QtQuick.Dialogs 1.2
//import QtQuick.LocalStorage 2.0
import QtQuick.Controls.Styles 1.2
import custom.controls 1.1 as Tumb
import "../scripts/moment.js" as D
Rectangle {
    id: eventRect
    property var date
    property var returnDate
    property bool inhibitReturn: true
    color: "linen"
    onDateChanged: {


        inhibitReturn = true // break feedback loop
        tyears.currentIndex = (D.moment(eventRect.date).year() - 2000 | 0)
        tmonths.currentIndex = (D.moment(eventRect.date).month() | 0)
       // tdays.currentIndex = (D.moment(eventRect.date).date() - 1 )
        inhibitReturn = false

    }


    function dtChanged() {
        if (!inhibitReturn) {
        var dt = D.moment(new Date(tyears.model.get(tyears.currentIndex).disp,tmonths.model.get(tmonths.currentIndex).dispNo -1,01))
        dt.hours(12)
        //console.log("wherfrom2",dt, tyears.colid, tmonths.colid, tdays.colid)
        eventRect.returnDate = dt
        }
    }






   Tumb.Tumbler {
       id: banner
       width: parent.width
       height: parent.height




/*       TumblerColumn {
           id: tdays

           model: days
           role:"disp"
           onCurrentIndexChanged: dtChanged()
      }*/
       Tumb.TumblerColumn {
           id: tmonths

           model: months
           role:"disp"
           onCurrentIndexChanged: dtChanged()
      }
       Tumb.TumblerColumn {
           id: tyears

           model: years
           role:"disp"
           onCurrentIndexChanged: dtChanged()
      }
   }




    ListModel {
        id: months


        ListElement {
            disp: "Jan"
            dispNo: 1
        }
        ListElement {
            disp: "Feb"
            dispNo: 2
        }
        ListElement {
            disp: "Mar"
            dispNo: 3
        }
        ListElement {
            disp: "Apr"
            dispNo: 4
        }
        ListElement {
            disp: "May"
            dispNo: 5
        }
        ListElement {
            disp: "Jun"
            dispNo: 6
        }
        ListElement {
            disp: "Jul"
            dispNo: 7
        }
        ListElement {
            disp: "Aug"
            dispNo: 8
        }
        ListElement {
            disp: "Sep"
            dispNo: 9
        }
        ListElement {
            disp: "Oct"
            dispNo: 10
        }
        ListElement {
            disp: "Nov"
            dispNo: 11
        }
        ListElement {
            disp: "Dec"
            dispNo: 12
        }

    }
    ListModel {
        id: years


        ListElement {
            disp: 2000
        }
        ListElement {
            disp: 2001
        }
        ListElement {
            disp: 2002
        }
        ListElement {
            disp: 2003
        }
        ListElement {
            disp: 2004
        }
        ListElement {
            disp: 2005
        }
        ListElement {
            disp: 2006
        }
        ListElement {
            disp: 2007
        }
        ListElement {
            disp: 2008
        }
        ListElement {
            disp: 2009
        }
        ListElement {
            disp: 2010
        }
        ListElement {
            disp: 2011
        }
        ListElement {
            disp: 2012
        }
        ListElement {
            disp: 2013
        }
        ListElement {
            disp: 2014
        }
        ListElement {
            disp: 2015
        }
        ListElement {
            disp: 2016
        }
        ListElement {
            disp: 2017
        }
        ListElement {
            disp: 2018
        }
        ListElement {
            disp: 2019
        }
        ListElement {
            disp: 2020
        }
        ListElement {
            disp: 2021
        }
        ListElement {
            disp: 2022
        }
        ListElement {
            disp: 2023
        }
        ListElement {
            disp: 2024
        }
        ListElement {
            disp: 2025
        }
        ListElement {
            disp: 2026
        }
        ListElement {
            disp: 2027
        }
        ListElement {
            disp: 2028
        }
        ListElement {
            disp: 2029
        }

    }
    ListModel {
        id: days


        ListElement {
            disp: 1
        }
        ListElement {
            disp: 2
        }
        ListElement {
            disp: 3
        }
        ListElement {
            disp: 4
        }
        ListElement {
            disp: 5
        }
        ListElement {
            disp: 6
        }
        ListElement {
            disp: 7
        }
        ListElement {
            disp: 8
        }
        ListElement {
            disp: 9
        }
        ListElement {
            disp: 10
        }
        ListElement {
            disp: 11
        }
        ListElement {
            disp: 12
        }
        ListElement {
            disp: 13
        }
        ListElement {
            disp: 14
        }
        ListElement {
            disp: 15
        }
        ListElement {
            disp: 16
        }
        ListElement {
            disp: 17
        }
        ListElement {
            disp: 18
        }
        ListElement {
            disp: 19
        }
        ListElement {
            disp: 20
        }
        ListElement {
            disp: 21
        }
        ListElement {
            disp: 22
        }
        ListElement {
            disp: 23
        }
        ListElement {
            disp: 24
        }
        ListElement {
            disp: 25
        }
        ListElement {
            disp: 26
        }
        ListElement {
            disp: 27
        }
        ListElement {
            disp: 28
        }
        ListElement {
            disp: 29
        }
        ListElement {
            disp: 30
        }
        ListElement {
            disp: 31
        }

    }
    ListModel {
        id: weeks


        ListElement {
            disp: "Wk1"
            dispNo: 1
        }
        ListElement {
            disp: "Wk2"
            dispNo: 2
        }
        ListElement {
            disp: "Wk3"
            dispNo: 3
        }
        ListElement {
            disp: "Wk4"
            dispNo: 4
        }
        ListElement {
            disp: "Wk5"
            dispNo: 5
        }
        ListElement {
            disp: "Wk6"
            dispNo: 6
        }
        ListElement {
            disp: "Wk7"
            dispNo: 7
        }
        ListElement {
            disp: "Wk8"
            dispNo: 8
        }
        ListElement {
            disp: "Wk9"
            dispNo: 9
        }
        ListElement {
            disp: "Wk10"
            dispNo: 10
        }
        ListElement {
            disp: "Wk11"
            dispNo: 11
        }
        ListElement {
            disp: "Wk12"
            dispNo: 12
        }
        ListElement {
            disp: "Wk13"
            dispNo: 13
        }
        ListElement {
            disp: "Wk14"
            dispNo: 14
        }
        ListElement {
            disp: "Wk15"
            dispNo: 15
        }
        ListElement {
            disp: "Wk16"
            dispNo: 16
        }
        ListElement {
            disp: "Wk17"
            dispNo: 17
        }
        ListElement {
            disp: "Wk18"
            dispNo: 18
        }
        ListElement {
            disp: "Wk19"
            dispNo: 19
        }
        ListElement {
            disp: "Wk20"
            dispNo: 20
        }
        ListElement {
            disp: "Wk21"
            dispNo: 21
        }
        ListElement {
            disp: "Wk22"
            dispNo: 22
        }
        ListElement {
            disp: "Wk23"
            dispNo: 23
        }
        ListElement {
            disp: "Wk24"
            dispNo: 24
        }
        ListElement {
            disp: "Wk25"
            dispNo: 25
        }
        ListElement {
            disp: "Wk26"
            dispNo: 26
        }
        ListElement {
            disp: "Wk27"
            dispNo: 27
        }
        ListElement {
            disp: "Wk28"
            dispNo: 28
        }
        ListElement {
            disp: "Wk29"
            dispNo: 29
        }
        ListElement {
            disp: "Wk30"
            dispNo: 30
        }
        ListElement {
            disp: "Wk31"
            dispNo: 31
        }
        ListElement {
            disp: "Wk32"
            dispNo: 32
        }
        ListElement {
            disp: "Wk33"
            dispNo: 33
        }
        ListElement {
            disp: "Wk34"
            dispNo: 34
        }
        ListElement {
            disp: "Wk35"
            dispNo: 35
        }
        ListElement {
            disp: "Wk36"
            dispNo: 36
        }
        ListElement {
            disp: "Wk37"
            dispNo: 37
        }
        ListElement {
            disp: "Wk38"
            dispNo: 38
        }
        ListElement {
            disp: "Wk39"
            dispNo: 39
        }
        ListElement {
            disp: "Wk40"
            dispNo: 40
        }
        ListElement {
            disp: "Wk41"
            dispNo: 41
        }
        ListElement {
            disp: "Wk42"
            dispNo: 42
        }
        ListElement {
            disp: "Wk43"
            dispNo: 43
        }
        ListElement {
            disp: "Wk44"
            dispNo: 44
        }
        ListElement {
            disp: "Wk45"
            dispNo: 45
        }
        ListElement {
            disp: "Wk46"
            dispNo: 46
        }
        ListElement {
            disp: "Wk47"
            dispNo: 47
        }
        ListElement {
            disp: "Wk48"
            dispNo: 48
        }
        ListElement {
            disp: "Wk49"
            dispNo: 49
        }
        ListElement {
            disp: "Wk50"
            dispNo: 50
        }
        ListElement {
            disp: "Wk51"
            dispNo: 51
        }
        ListElement {
            disp: "Wk52"
            dispNo: 52
        }


    }
}

