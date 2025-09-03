#include "clipvisualizationpagemodel.h"

#include "global/translation.h"

using namespace au::appshell;
using namespace muse;

ClipVisualizationPageModel::ClipVisualizationPageModel(QObject* parent)
    : QObject(parent)
{
}

void ClipVisualizationPageModel::load()
{
    // Initialize with clip style options
    m_clipStyles.clear();

    ClipStyleInfo colorful;
    colorful.code = "colorful";
    colorful.title = qtrc("appshell/gettingstarted", "Colourful");
    colorful.description = qtrc("appshell/gettingstarted", "Each track gets a new colour");
    colorful.selected = true;
    m_clipStyles.append(colorful);

    ClipStyleInfo classic;
    classic.code = "classic";
    classic.title = qtrc("appshell/gettingstarted", "Classic");
    classic.description = qtrc("appshell/gettingstarted", "The clips you know and love");
    classic.selected = false;
    m_clipStyles.append(classic);

    m_selectedStyleCode = "colorful";
    updateClipStyles();
}

void ClipVisualizationPageModel::selectClipStyle(const QString& styleCode)
{
    if (m_selectedStyleCode == styleCode) {
        return;
    }

    m_selectedStyleCode = styleCode;
    updateClipStyles();

    // TODO: Save the clip style preference to configuration
    // This would typically call into a configuration service to persist the setting
    // For example: configuration()->setClipStyle(styleCode == "colorful" ? ClipStyle::COLORFUL : ClipStyle::CLASSIC);
}

QVariantList ClipVisualizationPageModel::clipStyles() const
{
    QVariantList result;
    for (const ClipStyleInfo& style : m_clipStyles) {
        result << style.toMap();
    }
    return result;
}

QString ClipVisualizationPageModel::currentClipStyleCode() const
{
    return m_selectedStyleCode;
}

void ClipVisualizationPageModel::updateClipStyles()
{
    for (ClipStyleInfo& style : m_clipStyles) {
        style.selected = (style.code == m_selectedStyleCode);
    }
    emit clipStylesChanged();
    emit currentClipStyleCodeChanged();
}
