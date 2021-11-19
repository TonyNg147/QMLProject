import QtQuick 2.0
Rectangle{
    gradient: Gradient{
        GradientStop{color:"#66ff66";position:0.0}
        GradientStop{color:"#00b300";position:0.3}
        GradientStop{color:"#004d00";position:1.0}
    }
    width:80;height:80
    radius:40
    Text{
        anchors.centerIn: parent
        text:"+"
        font.pixelSize: parent.width-30
        font.bold:true
        color:'#ffff66'
    }
}

