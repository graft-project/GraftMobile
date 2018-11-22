#include "graftclienttools.h"
#include <QGuiApplication>
#include <QHostAddress>
#include <QClipboard>
#include <QUrl>

GraftClientTools::GraftClientTools(QObject *parent)
    : QObject(parent)
{

}

bool GraftClientTools::isValidIp(const QString &ip)
{
    QHostAddress validateIp;
    return validateIp.setAddress(ip);
}

bool GraftClientTools::isValidUrl(const QString &urlAddress)
{
    return QUrl(urlAddress, QUrl::StrictMode).isValid();
}

QString GraftClientTools::wideSpacingSimplify(const QString &seed)
{
    return seed.simplified();
}

void GraftClientTools::copyToClipboard(const QString &data)
{
    QClipboard *clipboard = QGuiApplication::clipboard();
    clipboard->setText(data);
}
