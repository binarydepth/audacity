#ifndef AU_APPSHELL_WORKSPACELAYOUTPAGEMODEL_H
#define AU_APPSHELL_WORKSPACELAYOUTPAGEMODEL_H

#include <QObject>
#include <QVariantList>

#include "async/asyncable.h"
#include "modularity/ioc.h"
#include "ui/iuiconfiguration.h"
#include "muse_framework_config.h"

#ifdef MUSE_MODULE_WORKSPACE
#include "workspace/iworkspacemanager.h"
#endif

namespace au::appshell {
struct WorkspaceInfo {
    QString code;
    QString title;
    QString description;
    QString imagePath;
    bool selected = false;

    QVariantMap toMap() const
    {
        return {
            { "code", code },
            { "title", title },
            { "description", description },
            { "imagePath", imagePath },
            { "selected", selected }
        };
    }
};

class WorkspaceLayoutPageModel : public QObject, public muse::async::Asyncable
{
    Q_OBJECT

    Q_PROPERTY(QVariantList workspaces READ workspaces NOTIFY workspacesChanged)
    Q_PROPERTY(QString currentWorkspaceCode READ currentWorkspaceCode NOTIFY workspacesChanged)
    Q_PROPERTY(QString currentImagePath READ currentImagePath NOTIFY workspacesChanged)
    Q_PROPERTY(QString pageTitle READ pageTitle CONSTANT)

    muse::Inject<muse::ui::IUiConfiguration> uiConfiguration;

#ifdef MUSE_MODULE_WORKSPACE
    muse::Inject<muse::workspace::IWorkspaceManager> workspaceManager;
#endif

public:
    explicit WorkspaceLayoutPageModel(QObject* parent = nullptr);

    Q_INVOKABLE void load();
    Q_INVOKABLE void selectWorkspace(const QString& workspaceCode);

    QVariantList workspaces() const;
    QString currentWorkspaceCode() const;
    QString currentImagePath() const;
    static QString pageTitle();

signals:
    void workspacesChanged();

private:
    void updateWorkspaces();

    QList<WorkspaceInfo> m_workspaces;
};
}

#endif // AU_APPSHELL_WORKSPACELAYOUTPAGEMODEL_H
