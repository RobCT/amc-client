#include "filereader.h"
#include <QFile>
#include <QStringBuilder>

FileReader::FileReader(QObject *parent)
        : QObject(parent)
{

}
void FileReader::readbytes(const QString &filename)
{
    QFile file(filename);
    if (!file.open(QIODevice::ReadOnly))
	return;

    m_bytes =  file.readAll();
    this->setSize(m_bytes.size());




}

QByteArray FileReader::filedata() const
{
    return m_bytes;
}

QString FileReader::read(const QString &filename)
{
    QFile file(filename);
    if (!file.open(QIODevice::ReadOnly))
        return QByteArray();

    m_bytes =  file.readAll();
    m_size = m_bytes.size();
    m_data.resize(m_bytes.size());
    m_data = m_bytes;
    return m_data;


}
QString FileReader::base64_decode(QString string){
    QByteArray ba;
    ba.append(string);
    return QByteArray::fromBase64(ba);
}

QString FileReader::read_b64(const QString &filename)
{

    QFileInfo m_aboutfile(filename);
    m_data.reserve(m_aboutfile.size());
    this->readbytes(filename);
    m_data = this->filedata().toBase64();
    m_binstring = base64_decode(this->filedata().toBase64());

    return m_data;



}
void FileReader::upload(const QString &url)
{
    QNetworkAccessManager *manager = new QNetworkAccessManager(this);
    connect(
     manager, SIGNAL (finished(QNetworkReply*)),
     this, SLOT (fileUploaded())
     );
    QNetworkRequest request;
    request.setUrl(QUrl(url));
    request.setRawHeader("Content-Type","application/x-www-form-urlencoded");
    manager->put(request,m_bytes);
}
void FileReader::fileUploaded() {
  //emit a signal
 emit uploaded();
}

void FileReader::download(const QString &url)
{
    QNetworkAccessManager *manager = new QNetworkAccessManager(this);
    connect(
     manager, SIGNAL (finished(QNetworkReply*)),
     this, SLOT (fileDownloaded(QNetworkReply*))
     );
    QNetworkRequest request;
    request.setUrl(QUrl(url));
    manager->get(request);
}
void FileReader::saveDownload(const QString filename, const QString application_type)
{
    QFile m_file(QStandardPaths::writableLocation (QStandardPaths::DownloadLocation) + "/" + filename);


    m_file.open(QIODevice::WriteOnly);
    m_file.write(m_DownloadedData);
    m_qurl = QUrl::fromLocalFile(m_file.fileName());
    m_file.close();
}

void FileReader::open(const QString filename)
{
    //QTemporaryFile m_tfile;
    //m_tfile.setFileTemplate(QStandardPaths::writableLocation (QStandardPaths::DownloadLocation) + "/" + filename);
    //m_tfile.open();
    //m_tfile.setAutoRemove(false);
    //qDebug() << QStandardPaths::writableLocation (QStandardPaths::DownloadLocation) + "/" + filename;
    //QFile m_file(m_tfile.fileName());
    //m_tfile.close();
    //m_tfile.remove();
    QFile m_file(QStandardPaths::writableLocation (QStandardPaths::DownloadLocation) + "/" + filename);

    //m_file.setFileTemplate(QDir::tempPath() + "/" + filename);
    m_file.open(QIODevice::WriteOnly);
    m_file.write(m_DownloadedData);
    //m_qurl = QUrl::fromLocalFile(m_file.fileName());
    m_file.flush();
    m_file.close();

    //m_qurl= m_qurl.adjusted(QUrl::RemoveScheme);
    //QDesktopServices::openUrl(QUrl::fromLocalFile("/tmp/I wonder .docx"));
    //qDebug() << m_qurl;


	QDesktopServices::openUrl(m_qurl);
	//m_file.remove();

}
#ifdef Q_OS_ANDROID
void FileReader::openandroid(const QString filename, const QString application_type)
{
    //QFile m_file(QStandardPaths::writableLocation (QStandardPaths::DownloadLocation) + "/" + filename);
    //m_qurl = QUrl::fromLocalFile(m_file.fileName());
    //m_file.close();
    m_qurl = QUrl::fromLocalFile(QStandardPaths::writableLocation (QStandardPaths::DownloadLocation) + "/" + filename);
    QAndroidJniObject m_url = QAndroidJniObject::fromString(m_qurl.toString());
    //qDebug() << m_url.toString();
    QAndroidJniObject m_application_type = QAndroidJniObject::fromString(application_type);
    //qDebug() << m_application_type.toString();
    QAndroidJniObject::callStaticMethod<void>("org/qtproject/example/testapi/IntentView",
					      "openUrl",
					      "(Ljava/lang/String;Ljava/lang/String;)V",
                          m_url.object<jstring>(),
					      m_application_type.object<jstring>());
    //qDebug() << "after JNI";
}
#endif
#ifndef Q_OS_ANDROID
void FileReader::openandroid(const QString filename, const QString application_type)
{


}
#endif

void FileReader::fileDownloaded(QNetworkReply* pReply) {
 m_DownloadedData = pReply->readAll();
 m_size = m_DownloadedData.size();
 //emit a signal
 pReply->deleteLater();
 emit downloaded();
}
void FileReader::setSize(int value)
{
    if (value != m_size) {
        m_size = value;
        emit sizeChanged();
    }
}

int FileReader::size() const
{
    return m_size;
}


