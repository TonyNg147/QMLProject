#include "imagelistmodel.h"
#include "QFileDialog"
#include <QDir>
#include <QDebug>
#include <QUrl>
ImageListModel::ImageListModel(QObject *parent)
    : QAbstractListModel(parent),m_data(nullptr)
{
    qDebug()<<"Contrusctor";
}

int ImageListModel::rowCount(const QModelIndex &parent) const
{
    // For list models only the root node (an invalid parent) should return the list's size. For all
    // other (valid) parents, rowCount() should return 0 so that it does not become a tree model.
    if (parent.isValid()||!m_data)
        return 0;
    return m_data->items().size();
    // FIXME: Implement me!
}

QVariant ImageListModel::data(const QModelIndex &index, int role) const
{
    if (!index.isValid()||!m_data)
        return QVariant();
    const DataItem& item = m_data->items().at(index.row());
    switch(role)
    {
        case SourceRole:
        {

            return item.source;
        }
        case FilePathRole:
        {

            return item.filePath;
        }
    }

    // FIXME: Implement me!
    return QVariant();
}

bool ImageListModel::setData(const QModelIndex &index, const QVariant &value, int role)
{
    if (!m_data)
    {
        return false;
    }
    DataItem item = m_data->items().at(index.row());
    switch(role)
    {
        case SourceRole:
        {
            item.source = value.toString();
            break;
        }
        case FilePathRole:
        {
            item.filePath = value.toString();
            break;
        }
    }
    if(m_data->setItemAt(index.row(),item)) {
        // FIXME: Implement me!
        emit dataChanged(index, index, QVector<int>() << role);
        return true;
    }
    return false;
}

Qt::ItemFlags ImageListModel::flags(const QModelIndex &index) const
{
    if (!index.isValid())
        return Qt::NoItemFlags;

    return Qt::ItemIsEditable; // FIXME: Implement me!
}

DataForModel* ImageListModel::data() const
{
    return m_data;
}

void ImageListModel::setData(DataForModel* data)
{
    beginResetModel();
    if (m_data)
    {
        m_data->disconnect(this);
    }
    m_data = data;
    if(m_data)
    {
        connect(m_data,&DataForModel::preAppendItem,this,[=](){
            const int& index = m_data->items().size();
            qDebug()<<"PreAppend";
            beginInsertRows(QModelIndex(),index,index);
        });
        connect(m_data,&DataForModel::postAppendItem,this,[=](){
            qDebug()<<"PostAppend";
            endInsertRows();
            emit countChanged();
        });
        connect(m_data,&DataForModel::preRemoveItem,this,[=](int index){
            qDebug()<<"Remove rows";
            beginRemoveRows(QModelIndex(),index,index);
        });
        connect(m_data,&DataForModel::postRemoveItem,this,[=](){
            endRemoveRows();
            emit countChanged();
        });
    }
    endResetModel();
}

QHash<int, QByteArray> ImageListModel::roleNames() const
{
    QHash<int,QByteArray> roles;
    roles[SourceRole] = "source";
    roles[FilePathRole] = "filePath";
    return roles;
}

int ImageListModel::count() const
{
    if (m_data)
    {
        return m_data->items().count();
    }
    return 0;
}

QString ImageListModel::get(int index,int role) const
{
    if (index>=0&&index<m_data->items().size())
    {

//            return m_data->items().at(index).source;
        switch(role){
        case SourceRole:
            return m_data->items().at(index).source;
        case FilePathRole:
            return m_data->items().at(index).filePath;
        }

    }
    return "";
}

void ImageListModel::pickingFile()
{
    QStringList names = QFileDialog::getOpenFileNames(nullptr,"Choose images",
                                                      QDir::fromNativeSeparators("C:\\Users\\OS\\Desktop\\PhotoViewerQML\\PhotoViewer\\Fancy Cars"),
                                                      tr("Images (*.png *.jpg)"));
    for (int i=0;i<names.count();i++)
    {
        QString source = names[i];
        //QString text  = "file:///"+source;
        QString filePath = source.right(source.size()-1-source.lastIndexOf('/'));
        source = "file:///"+source;
        m_data->appendItem(source,filePath);
    }
    emit makeViewChange();
}

void ImageListModel::appendPics(QString path)
{
    QUrl url = QUrl(path);
    qDebug()<<"Is relative: "<<url.isValid();
    //qDebug()<<"Is absolute: "<<QUrl(path).isRelative();
    m_data->appendItem(path,QString("Pic %1").arg(count()+1));
}

void ImageListModel::emitMakeViewChange()
{
    qDebug()<<"Call emit make view";
    emit makeViewChange();
}

void ImageListModel::setCount(int newCount)
{
    if (m_count == newCount)
        return;
    m_count = newCount;
    emit countChanged();
}
