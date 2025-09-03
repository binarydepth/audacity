#include "workspacelayoutpagemodel.h"

#include "global/translation.h"

using namespace au::appshell;
using namespace muse;

WorkspaceLayoutPageModel::WorkspaceLayoutPageModel(QObject* parent)
    : QObject(parent)
{
}

void WorkspaceLayoutPageModel::load()
{
    // Initialize with workspace options
    m_workspaces.clear();

    WorkspaceInfo modern;
    modern.code = "modern";
    modern.title = qtrc("appshell/gettingstarted", "Modern");
    modern.iconCode = "WORKSPACE";
    modern.selected = true;
    m_workspaces.append(modern);

    WorkspaceInfo classic;
    classic.code = "classic";
    classic.title = qtrc("appshell/gettingstarted", "Classic");
    classic.iconCode = "WORKSPACE_CLASSIC";
    classic.selected = false;
    m_workspaces.append(classic);

    m_selectedWorkspaceCode = "modern";
    updateWorkspaces();

#ifdef MUSE_MODULE_WORKSPACE
    // If workspace manager is available, load actual workspaces
    if (workspaceManager()) {
        // TODO: Load actual workspaces from workspace manager
        // auto workspaces = workspaceManager()->workspaces();
        // Convert to WorkspaceInfo and update m_workspaces
    }
#endif
}

void WorkspaceLayoutPageModel::selectWorkspace(const QString& workspaceCode)
{
    if (m_selectedWorkspaceCode == workspaceCode) {
        return;
    }

    m_selectedWorkspaceCode = workspaceCode;
    updateWorkspaces();

#ifdef MUSE_MODULE_WORKSPACE
    // Apply the workspace selection
    if (workspaceManager()) {
        // TODO: Set the selected workspace
        // workspaceManager()->setCurrentWorkspace(workspaceCode);
    }
#endif
}

QVariantList WorkspaceLayoutPageModel::workspaces() const
{
    QVariantList result;
    for (const WorkspaceInfo& workspace : m_workspaces) {
        result << workspace.toMap();
    }
    return result;
}

void WorkspaceLayoutPageModel::updateWorkspaces()
{
    for (WorkspaceInfo& workspace : m_workspaces) {
        workspace.selected = (workspace.code == m_selectedWorkspaceCode);
    }
    emit workspacesChanged();
}
