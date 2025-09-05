#include "workspacelayoutpagemodel.h"

#include "global/translation.h"

using namespace au::appshell;
using namespace muse;

WorkspaceLayoutPageModel::WorkspaceLayoutPageModel(QObject* parent)
    : QObject(parent)
{
    // Listen to theme changes to update image paths
    uiConfiguration()->currentThemeChanged().onNotify(this, [this]() {
        updateWorkspaces();
    });
}

void WorkspaceLayoutPageModel::load()
{
    // Initialize with workspace options
    m_workspaces.clear();

    WorkspaceInfo modern;
    modern.code = "modern";
    modern.title = qtrc("appshell/gettingstarted", "Modern");
    modern.description = qtrc("appshell/gettingstarted", "A clearer interface. Ideal for new users");
    modern.imagePath = "resources/UILayout_LightMode.png"; // Will be updated based on theme
    modern.selected = true;
    m_workspaces.append(modern);

    WorkspaceInfo classic;
    classic.code = "classic";
    classic.title = qtrc("appshell/gettingstarted", "Classic");
    classic.description = qtrc("appshell/gettingstarted", "Closely matches the layout of Audacity 3");
    classic.imagePath = "resources/UILayout_LightMode.png"; // Will be updated based on theme
    classic.selected = false;
    m_workspaces.append(classic);

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
    if (currentWorkspaceCode() == workspaceCode) {
        return;
    }

    // Update selection state
    for (WorkspaceInfo& workspace : m_workspaces) {
        workspace.selected = (workspace.code == workspaceCode);
    }

    emit workspacesChanged();

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

QString WorkspaceLayoutPageModel::currentWorkspaceCode() const
{
    for (const WorkspaceInfo& workspace : m_workspaces) {
        if (workspace.selected) {
            return workspace.code;
        }
    }
    return "modern"; // Default fallback
}

QString WorkspaceLayoutPageModel::currentImagePath() const
{
    for (const WorkspaceInfo& workspace : m_workspaces) {
        if (workspace.selected) {
            return workspace.imagePath;
        }
    }
    return ""; // Fallback
}

QString WorkspaceLayoutPageModel::pageTitle()
{
    return qtrc("appshell/gettingstarted", "What UI layout (workspace) do you want?");
}

void WorkspaceLayoutPageModel::updateWorkspaces()
{
    // Update image paths based on current theme
    const bool isDarkTheme = uiConfiguration()->isDarkMode();
    const QString imagePath = isDarkTheme ? "resources/UILayout_DarkMode.png" : "resources/UILayout_LightMode.png";

    for (WorkspaceInfo& workspace : m_workspaces) {
        workspace.imagePath = imagePath;
    }

    emit workspacesChanged();
}
