#include "graftclienttools.h"

#include <QRegularExpressionMatch>
#include <QRegularExpression>
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

QString GraftClientTools::dotsRemove(const QString &message)
{
    return QString(message).remove(QChar('.'), Qt::CaseInsensitive);
}

GraftClientTools::NetworkType GraftClientTools::networkType(const QString &text)
{
    if (!text.isEmpty())
    {
        if (QRegularExpressionMatch(QRegularExpression("http://").match(text, 0)).hasMatch())
        {
            return NetworkType::Http;
        }
        else if (QRegularExpressionMatch(QRegularExpression("https://").match(text, 0)).hasMatch())
        {
            return NetworkType::Https;
        }
    }
    return NetworkType::None;
}

