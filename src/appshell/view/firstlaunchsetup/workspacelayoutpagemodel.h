#ifndef AU_APPSHELL_WORKSPACELAYOUTPAGEMODEL_H
#define AU_APPSHELL_WORKSPACELAYOUTPAGEMODEL_H

#include <QObject>
#include <QVariantList>

#include "async/asyncable.h"
#include "modularity/ioc.h"

#ifdef MUSE_MODULE_WORKSPACE
#include "workspace/iworkspacemanager.h"
#endif

namespace au::appshell {

struct WorkspaceInfo {
    QString code;
    QString title;
    QString iconCode;
    bool selected = false;

    QVariantMap toMap() const {
        return {
            { "code", code },
            { "title", title },
            { "iconCode", iconCode },
            { "selected", selected }
        };
    }
};

class WorkspaceLayoutPageModel : public QObject, public muse::async::Asyncable
{
    Q_OBJECT

    Q_PROPERTY(QVariantList workspaces READ workspaces NOTIFY workspacesChanged)

#ifdef MUSE_MODULE_WORKSPACE
    muse::Inject<muse::workspace::IWorkspaceManager> workspaceManager;
#endif

public:
    explicit WorkspaceLayoutPageModel(QObject* parent = nullptr);

    Q_INVOKABLE void load();
    Q_INVOKABLE void selectWorkspace(const QString& workspaceCode);

    QVariantList workspaces() const;

signals:
    void workspacesChanged();

private:
    void updateWorkspaces();

    QList<WorkspaceInfo> m_workspaces;
    QString m_selectedWorkspaceCode;
};
}

#endif // AU_APPSHELL_WORKSPACELAYOUTPAGEMODEL_H
