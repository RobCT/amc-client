#ifndef FILEREADER_H
#define FILEREADER_H

#include <QObject>
#include <QFileInfo>
#include <QNetworkAccessManager>
#include <QNetworkRequest>
#include <QNetworkReply>
#include <QTemporaryFile>
#include <QDesktopServices>
#include <QFile>
#include <QDir>
#include <QDebug>
#include <QStandardPaths>
#ifdef Q_OS_ANDROID
#include <QtAndroidExtras/QAndroidJniObject>
#endif
class FileReader : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QByteArray filedata READ filedata)
    Q_PROPERTY(int size READ size)



public:
    explicit FileReader(QObject *parent = 0);
    Q_INVOKABLE void readbytes(const QString &filename);
    Q_INVOKABLE QString read(const QString &filename);
    Q_INVOKABLE QString read_b64(const QString &filename);
    Q_INVOKABLE QString base64_decode(QString string);
    Q_INVOKABLE void upload(const QString &url);
    Q_INVOKABLE void download(const QString &url);
    Q_INVOKABLE void open(const QString filename);
    Q_INVOKABLE void saveDownload(const QString filename, const QString application_type);
    QByteArray filedata() const;
    int size() const;
//#ifdef Q_OS_ANDROID
    Q_INVOKABLE void openandroid(const QString filename, const QString application_type);
//#endif
Q_SIGNALS:
    void downloaded();
    void uploaded();
    void sizeChanged();
    void notificationChanged();

private slots:
  void fileDownloaded(QNetworkReply* pReply);
  void fileUploaded();

private:
    void setSize(int value);
    QString m_data;
    QByteArray m_bytes;
    QByteArray m_DownloadedData;
    QByteArray ba;
    QString m_par;
    QFileInfo m_aboutfile;
    QString m_binstring;
    QNetworkAccessManager *manager;
    QNetworkRequest request;
    QFile m_file;
    QTemporaryFile m_tfile;
    int m_size;
    QFile f;
    QUrl m_qurl;
    #ifdef Q_OS_ANDROID
    QAndroidJniObject m_application_type;
    QAndroidJniObject m_url;
    #endif



};

#endif // FILEREADER_H
