#ifndef AU_APPSHELL_CLIPVISUALIZATIONPAGEMODEL_H
#define AU_APPSHELL_CLIPVISUALIZATIONPAGEMODEL_H

#include <QObject>
#include <QVariantList>

#include "async/asyncable.h"
#include "modularity/ioc.h"
#include "projectscene/iprojectsceneconfiguration.h"

namespace au::appshell {
struct ClipStyleInfo {
    int style;
    QString title;
    QString description;
    QString imagePath;
    bool selected = false;

    QVariantMap toMap() const
    {
        return {
            { "style", style },
            { "title", title },
            { "description", description },
            { "imagePath", imagePath },
            { "selected", selected }
        };
    }
};

class ClipVisualizationPageModel : public QObject, public muse::async::Asyncable
{
    Q_OBJECT

    muse::Inject<projectscene::IProjectSceneConfiguration> projectSceneConfiguration;

    Q_PROPERTY(QVariantList clipStyles READ clipStyles NOTIFY clipStylesChanged)
    Q_PROPERTY(int currentClipStyle READ currentClipStyle NOTIFY currentClipStyleChanged)
    Q_PROPERTY(QString currentImagePath READ currentImagePath NOTIFY currentClipStyleChanged)
    Q_PROPERTY(QString pageTitle READ pageTitle CONSTANT)

public:
    explicit ClipVisualizationPageModel(QObject* parent = nullptr);

    Q_INVOKABLE void load();
    Q_INVOKABLE void selectClipStyle(int style);

    QVariantList clipStyles() const;
    int currentClipStyle() const;
    QString currentImagePath() const;
    static QString pageTitle();

signals:
    void clipStylesChanged();
    void currentClipStyleChanged();

private:
    void updateClipStyles();

    QList<ClipStyleInfo> m_clipStyles;
};
}

#endif // AU_APPSHELL_CLIPVISUALIZATIONPAGEMODEL_H
