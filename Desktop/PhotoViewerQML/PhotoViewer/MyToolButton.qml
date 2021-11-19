import QtQuick 2.0
import QtQuick.Controls 2.5

ToolButton
{
    id:button
    property alias source:img.source    
    Image {
        id:img
        width:30;height:30
        anchors.centerIn:parent
    }
}
