import QtQuick 2.12
import Qt.labs.platform 1.0
import QtQuick.Controls 2.5
import QtQuick.Controls.Material 2.5
import QtQuick.Layouts 1.14
import Qt.labs.folderlistmodel 2.12
import ModelData 1.0
//import Controller 1.0
ApplicationWindow{
    id:root
    width:700
    height:560
    visible:true
    color:'white'
    function maximizeImage(img,text,index)
    {
        stackView.pop()
        stackView.push(maximizedImage)
        maximizedImage.imageSource = img.source
        maximizedImage.text = text
        maximizedImage.currentIndex = index
        maximizedImage.count = fileModel.count-1
    }
    function changeCurrentIndex(index)
    {
        var filePath = fileModel.get(index,ImageModel.SourceRole)
        var text = fileModel.get(index,ImageModel.FilePathRole)
        maximizedImage.imageSource = filePath
        maximizedImage.text = text
    }
    function makeViewChange()
    {
        stackView.pop()
        console.log("Make View Changed");
        console.log("Depth: "+stackView.depth);
        switch(comboBox.currentIndex)
        {
        case 0:
        {
            stackView.push(listViewContainer)
            break
        }
        case 1:
        {
            stackView.push(gridViewContainer)
            break
        }
        case 2:
        {
            stackView.push(pathViewContainer)
            break
        }
        }
    }
    Component{id:gridViewContainer;GridViewContainer{}}
    Component{id:listViewContainer;ListViewContainer{}}
    Component{id:pathViewContainer;PathViewContainer{}}
    Component{id:slideShowEffect;SlideShowEffect{}}
    ImageModel{
        id:fileModel
        data:dataForModel
        onMakeViewChange:
        {
            if (fileModel.count)
            {
                root.makeViewChange();
            }
        }
        onCountChanged:{
            if (fileModel.count===0)
            {
                console.log("CHanged");
                root.setTheCurrentIndex(0,comboBox.currentIndex);
                console.log("CHanged1");
                stackView.push(openFileView);
            }


        }
    }

    function setTheCurrentIndex(desiredIndex,currentIndex)
    {
        if (desiredIndex!==currentIndex)
        {

            if (desiredIndex>currentIndex)
            {
                console.log("Comehere");
                for (var i=currentIndex;i<desiredIndex;i++)
                {
                    comboBox.incrementCurrentIndex()
                }
            }
            else
            {
                for (var i=currentIndex;i>desiredIndex;i--)
                {
                    comboBox.decrementCurrentIndex()
                }
            }
        }
    }
    // file dialog belongs to QtQuick.labs.platforms
    header: ToolBar {
        contentHeight:ToolButton.implicitHeight
        Material.background:'lightsteelblue'
        id:bar
        Item{
            anchors.fill:parent
            id:row1
            RowLayout {
                spacing:10
                MyToolButton {
                    id:openButton
                    source:"qrc:/images/open-file-icon.png"
                    ToolTip.visible: hovered
                    ToolTip.text:"Open File"
                    onClicked:{
                        //                             fileModel.pickingFile()
                        stackView.push(openFileView)
                    }
//                    Menu{
//                        id:menu
//                        MenuItem{
//                            icon.source: "qrc:/images/open-file-icon.png"
//                            text:"Local"
//                        }
//                        MenuItem{
//                            text:"Internet"
//                            icon.source:"qrc:/images/internet.png"
//                        }
//                    }
                }
                MyToolButton {
                    id:list
                    source:"qrc:/images/listIcon.png"

                    ToolTip.visible: hovered
                    ToolTip.text:"Show set of pictures in List View"
                    onClicked:{
                        if (stackView.currentItem.objectName==="slideShowEffect")
                        {
                            stackView.push(listViewContainer)
                        }
                        else{
                            var index = comboBox.find('list')
                            var currentIndex = comboBox.currentIndex
                            setTheCurrentIndex(index,currentIndex)
                        }
                    }
                }
                MyToolButton {
                    id:grid
                    source:"qrc:/images/grid.png"
                    ToolTip.visible: hovered
                    ToolTip.text:"Show set of pictures in Grid View"
                    onClicked:{
                        var index = comboBox.find('grid')
                        var currentIndex = comboBox.currentIndex
                        setTheCurrentIndex(index,currentIndex)
                    }
                }
                MyToolButton {
                    id:pathIcon
                    source:"qrc:/images/stackVIew.png"
                    ToolTip.visible: hovered
                    ToolTip.text:"Show set of pictures in Path View"
                    onClicked:{
                        var index = comboBox.find('path')
                        var currentIndex = comboBox.currentIndex
                        setTheCurrentIndex(index,currentIndex)
                    }

                }
                MyToolButton {
                    id:slideShow
                    source:"qrc:/images/slideShow.png"
                    ToolTip.visible: hovered
                    ToolTip.text:"Presentation"
                    onClicked: {
                        if (fileModel.count>=2)
                        {

                            stackView.push(slideShowEffect)
                        }
                    }
                }
            }
            ComboBox{
                id:comboBox
                anchors.right:parent.right
                anchors.rightMargin:30
                model:['list','grid','path']
                ToolTip{
                    text:"Choose the View"
                    visible:parent.hovered
                }
                onCurrentIndexChanged: {
                    if (fileModel.count!==0)
                        root.makeViewChange()
                }
            }
        }
    }
    // can not use fielModel in this line because it is loaded first when app is running
    // unlike other view such as list view and path view, it is loaded until called
    Page{
        width:root.width
        height:root.height
        visible:true
        id:maximizedImage
        property alias imageSource:clickingImage.source
        property alias text:maximizeImageLabelText.text
        property int currentIndex
        property int count
        Rectangle{
            anchors.fill:parent
            color:'white'
            focus:true
            Image{
                id:clickingImage
                width:500
                height:400
                smooth:true
                anchors{top:parent.top;topMargin:20;horizontalCenter: parent.horizontalCenter}
                Keys.onEscapePressed: {
                    makeViewChange()
                }
            }
            Label{
                id:maximizeImageLabelText
                anchors{top:clickingImage.bottom;topMargin:10;horizontalCenter: clickingImage.horizontalCenter}
                height:36
                font.pixelSize: 20
            }
            Rectangle{
                anchors{left:parent.left;top:parent.top;bottom:parent.bottom}
                width:imageLeft.width*2
                MouseArea{
                    anchors.fill:parent
                    hoverEnabled: true
                    onEntered: {
                        imageLeft.opacity = 1
                    }
                    onExited: {
                        imageLeft.opacity = 0.3
                    }
                }
                Image{
                    source:"qrc:/ButtonImages/arrow.png"
                    rotation:180
                    id:imageLeft
                    opacity:0.3
                    anchors{left:parent.left;bottom:parent.bottom;leftMargin:10;bottomMargin: 70}
                    Behavior on opacity{
                        NumberAnimation{duration:500}
                    }
                    MouseArea{
                        anchors.fill:parent;onReleased: {

                            if (maximizedImage.currentIndex>0)
                            {
                                console.log("Current Index: "+maximizedImage.currentIndex);
                                maximizedImage.currentIndex--
                                changeCurrentIndex(maximizedImage.currentIndex)
                            }
                            else{
                                makeViewChange()
                            }
                        }
                    }
                }
            }
            Rectangle{
                anchors{right:parent.right;top:parent.top;bottom:parent.bottom}
                width:imageRight.width*2

                MouseArea{
                    anchors.fill:parent
                    hoverEnabled: true
                    onEntered: {
                        imageRight.opacity = 1
                    }
                    onExited: {
                        imageRight.opacity = 0.3
                    }
                }
                Image{
                    source:"qrc:/ButtonImages/arrow.png"
                    id:imageRight
                    opacity:0.3
                    anchors{right:parent.right;bottom:parent.bottom;rightMargin:10;bottomMargin: 70}
                    Behavior on opacity{
                        NumberAnimation{duration:500}
                    }
                    MouseArea{
                        anchors.fill:parent;onReleased: {

                            if (maximizedImage.currentIndex<maximizedImage.count)
                            {
                                maximizedImage.currentIndex++
                                changeCurrentIndex(maximizedImage.currentIndex)
                            }
                            else{
                                makeViewChange()
                            }
                        }
                    }
                }
            }
        }
    }

    StackView{
        id:stackView
        anchors.fill:parent
        initialItem:openFileView
        focus:true

    }
    Component{
        id:openFileView
        Page{
            id:rootItem
            width:root.width
            height:root.height
            visible:true
            property alias size:bar.height
            Component.onCompleted: {
                console.log("width and height: %1 %2".arg(width).arg(height))
                console.log("openFileView loaded")
            }

            StackLayout {
                Component.onCompleted: {
                    console.log("StackView loaded")
                }

                width: parent.width
                currentIndex: bar.currentIndex
                Item {
                    id: openFileBar
                    Page{
                        width:root.width
                        height:root.height
                        visible:true

                        Item{
                            anchors.centerIn:parent
                            id: container
                            property color tint: "transparent"
                            width: labelText.width + 70 ; height: labelText.height + 18
                            BorderImage {
                                anchors { fill: container; leftMargin: -6; topMargin: -6; rightMargin: -8; bottomMargin: -8 }
                                source: 'images/box-shadow.png'
                                id:borderImage
                                border.left: 10; border.top: 10; border.right: 10; border.bottom: 10
                            }
                            Image { id:image;anchors.fill: parent; source: "images/cardboard.png"; antialiasing: true; }
                            Rectangle {
                                anchors.fill: container; color: container.tint; visible: container.tint != ""
                                opacity: 0.25

                            }
                            Text { id: labelText; text:'Load Images';font.pixelSize: 15; anchors.centerIn: parent;font.family:"Helvetica";font.capitalization: Font.MixedCase }

                            MouseArea {
                                anchors { fill: parent; leftMargin: -20; topMargin: -20; rightMargin: -20; bottomMargin: -20 }
                                hoverEnabled: true
                                onClicked: fileModel.pickingFile()
                            }
                        }
                    }
                }
                Item {
                    id: internetBar
                    Page{
                        width:root.width
                        height:root.height
                        ListView{
                            id:listView
                            clip:true
                            ScrollBar.vertical: ScrollBar{
                                hoverEnabled:true
                                active:hovered|pressed
                                anchors{right:parent.right;bottom:parent.bottom;top:parent.top}
                                parent:listView
                                //policy:ScrollBar.AlwaysOn
                                snapMode:ScrollBar.SnapOnRelease
                            }
                            anchors.fill:parent
                            anchors{
                                leftMargin:20
                                rightMargin:20
                                bottomMargin:120
//                                top:rootItem.size
                                topMargin:size
                            }
                            model:fileModel
                            delegate:SwipeDelegate {
                                id: swipeDelegate
                                Text{
                                    text: filePath
                                    anchors{
                                        left:listViewItemImage.right
                                        leftMargin:30
                                        verticalCenter: parent.verticalCenter
                                    }

                                    font.pointSize: 18
                                }
                                Image{
                                    anchors{left:parent.left;verticalCenter: parent.verticalCenter}
                                    source:model.source
                                    width:128;height:128
                                    anchors{left:parent.left;leftMargin:20}
                                    id:listViewItemImage
                                    MouseArea{
                                        anchors.fill:parent;
                                        onClicked: {
                                            maximizeImage(listViewItemImage,filePath,index)
                                        }
                                    }
                                }
                                Image{
                                    source:"qrc:/ButtonImages/TrashBin.png"
                                    id:imageRemove
                                    height:32;width:32
                                    anchors{
                                        right:parent.right
                                        verticalCenter: parent.verticalCenter
                                        rightMargin: 30
                                    }
                                    MouseArea{
                                        anchors.fill:parent
                                        onClicked: {
                                            dataForModel.removeItem(index)
                                        }
                                    }
                                }
                                width: parent.width
                                height:160
                                ListView.onRemove: SequentialAnimation {
                                    PropertyAction {
                                        target: swipeDelegate
                                        property: "ListView.delayRemove"
                                        value: true
                                    }
                                    NumberAnimation {
                                        target: swipeDelegate
                                        property: "height"
                                        to: 0
                                        easing.type: Easing.InOutQuad
                                    }
                                    PropertyAction {
                                        target: swipeDelegate
                                        property: "ListView.delayRemove"
                                        value: false
                                    }
                                }

                                swipe.right: Label {
                                    id: deleteLabel
                                    text: qsTr("Delete")
                                    font.pointSize: 18
                                    font.bold:true
                                    color: "white"
                                    verticalAlignment: Label.AlignVCenter
                                    padding: 12
                                    height: parent.height
                                    anchors.right: parent.right

                                    SwipeDelegate.onClicked: listView.model.remove(index)

                                    background: Rectangle {
                                        color: deleteLabel.SwipeDelegate.pressed ? Qt.darker("#00e600", 1.5) : "#00e600"
                                    }
                                }
                            }
                        }
                        //////////////////
                        RowLayout{
                            id:rowWidth
                            anchors{
                                left:parent.left
                                right:parent.right
                                leftMargin:80
                                rightMargin:80
                                top:listView.bottom
                                //top:parent.top

                            }



                            TextField{
                                id:textField
                                width:Math.max(400,parent.width-200)
                                Layout.fillWidth: true
                                placeholderText: "Enter the images' link here!"
                                Component.onCompleted: {
                                    console.log("Text width : "+textField.width)
                                }
                                onEditingFinished: {
                                    if (textField.text !== "")
                                    {
                                        fileModel.appendPics(textField.text)

                                        textField.clear()
                                    }


                                }
                            }

                            Button{
                                text:"Done"
                                onClicked:     {
                                    fileModel.emitMakeViewChange();
                                }

                            }
                            Button{
                                text:"Ok"
                                onPressAndHold:    {
                                    fileModel.appendPics(textField.text)
                                    textField.clear()
                                }
                            }
                            Button{
                                text:"Cancel"
                                onClicked: {
                                    textField.clear();
                                }
                            }

                        }
                    }
                }

            }
            TabBar {
                Component.onCompleted: {
                    console.log("TabBar loaded");
                }

                z:2
                id: bar
                width: parent.width
                anchors.top:parent.top
                TabButton {
                    text: qsTr("Local")
                    id:localButton
                    background: Rectangle {
                              implicitWidth: 100
                              implicitHeight: 40
                              opacity: enabled ? 1 : 0.3
                              color: bar.currentIndex===0?'#b8b894':"#f2f2f2"

                          }
                }
                TabButton {
                    text: qsTr("Internet")

                    id:internetButton
                    background: Rectangle {
                              implicitWidth: 100
                              implicitHeight: 40
                              opacity: enabled ? 1 : 0.3
//                              color: internetButton.down ? "#d0d0d0" : "#e0e0e0"
                              color: bar.currentIndex===1?'#b8b894':"#f2f2f2"
                          }
                }
            }
        }
    }
    //    Switch{
    //        anchors.bottom: parent.bottom
    //        anchors.bottomMargin:20
    //        text:qsTr("On")
    //    }



}

