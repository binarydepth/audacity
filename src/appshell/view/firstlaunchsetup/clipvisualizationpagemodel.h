#ifndef AU_APPSHELL_CLIPVISUALIZATIONPAGEMODEL_H
#define AU_APPSHELL_CLIPVISUALIZATIONPAGEMODEL_H

#include <QObject>
#include <QVariantList>

#include "async/asyncable.h"
#include "modularity/ioc.h"

namespace au::appshell {

struct ClipStyleInfo {
    QString code;
    QString title;
    QString description;
    bool selected = false;

    QVariantMap toMap() const {
        return {
            { "code", code },
            { "title", title },
            { "description", description },
            { "selected", selected }
        };
    }
};

class ClipVisualizationPageModel : public QObject, public muse::async::Asyncable
{
    Q_OBJECT

    Q_PROPERTY(QVariantList clipStyles READ clipStyles NOTIFY clipStylesChanged)
    Q_PROPERTY(QString currentClipStyleCode READ currentClipStyleCode NOTIFY currentClipStyleCodeChanged)

public:
    explicit ClipVisualizationPageModel(QObject* parent = nullptr);

    Q_INVOKABLE void load();
    Q_INVOKABLE void selectClipStyle(const QString& styleCode);

    QVariantList clipStyles() const;
    QString currentClipStyleCode() const;

signals:
    void clipStylesChanged();
    void currentClipStyleCodeChanged();

private:
    void updateClipStyles();

    QList<ClipStyleInfo> m_clipStyles;
    QString m_selectedStyleCode;
};
}

#endif // AU_APPSHELL_CLIPVISUALIZATIONPAGEMODEL_H
