/*  Copyright 2019 Aditya Mehra <aix.m@outlook.com>
    Copyright 2018 Marco Martin <mart@kde.org>

    This library is free software; you can redistribute it and/or
    modify it under the terms of the GNU Lesser General Public
    License as published by the Free Software Foundation; either
    version 2.1 of the License, or (at your option) version 3, or any
    later version accepted by the membership of KDE e.V. (or its
    successor approved by the membership of KDE e.V.), which shall
    act as a proxy defined in Section 6 of version 3 of the license.
    
    This library is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
    Lesser General Public License for more details.
    
    You should have received a copy of the GNU Lesser General Public
    License along with this library.  If not, see <http://www.gnu.org/licenses/>.
*/

import QtQuick 2.9
import QtQml.Models 2.2
import QtQuick.Controls 2.2 as Controls
import QtQuick.Layouts 1.3
import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.components 2.0 as PlasmaComponents
import org.kde.plasma.extras 2.0 as PlasmaExtras
import org.kde.plasma.plasmoid 2.0
import org.kde.kirigami 2.5 as Kirigami
import org.kde.private.mycroftplasmoid 1.0 as MycroftPlasmoid
import Mycroft 1.0 as Mycroft

Item {
    id: root
    implicitWidth: Kirigami.Units.gridUnit * 20
    implicitHeight: Kirigami.Units.gridUnit * 32
    property bool cfg_notifications: plasmoid.configuration.notifications
    property var incomingString
    
    Connections {
        target: Mycroft.MycroftController
        onIntentRecevied: { 
            if(type == "recognizer_loop:utterance") {
                incomingString = data.utterances[0]
            }
        }
    }
    
    Item {
        id: topBar
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        height: Kirigami.Units.gridUnit * 4

        ColumnLayout{
            anchors.fill: parent
            
            TopBarViewComponent {
                id: topBarView
                Layout.fillWidth: true
                Layout.preferredHeight: Kirigami.Units.gridUnit * 2
            }
            
            PlasmaCore.SvgItem {
                Layout.fillWidth: true
                Layout.preferredHeight: horlineSvg.elementSize("horizontal-line").height

                elementId: "horizontal-line"
                svg: PlasmaCore.Svg {
                    id: horlineSvg2;
                    imagePath: "widgets/line"
                }
            }
            
            PlasmaComponents.TabBar {
                id: tabBar
                visible: true
                Layout.fillWidth: true
                Layout.preferredHeight: Kirigami.Units.gridUnit * 1.5

                PlasmaComponents.TabButton {
                    id: mycroftTab
                    iconSource: "go-home"
                    text: i18n("Conversation")
                }

                PlasmaComponents.TabButton {
                    id: mycroftSkillsTab
                    iconSource: "games-hint"
                    text: i18n("Hints & Tips")
                }

                PlasmaComponents.TabButton {
                    id: mycroftMSMinstTab
                    iconSource: "kmouth-phresebook-new"
                    text: i18n("Skill Browser")
                }
            }

            PlasmaCore.SvgItem {
                Layout.fillWidth: true
                Layout.preferredHeight: horlineSvg.elementSize("horizontal-line").height

                elementId: "horizontal-line"
                svg: PlasmaCore.Svg {
                    id: horlineSvg;
                    imagePath: "widgets/line"
                }
            }
        }
    }

    ColumnLayout {
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: bottomBar.top
        anchors.top: topBar.bottom
        anchors.topMargin: Kirigami.Units.largeSpacing + Kirigami.Units.smallSpacing
        opacity: Mycroft.MycroftController.status == Mycroft.MycroftController.Open
        visible: tabBar.currentTab == mycroftTab;

        Behavior on opacity {
            OpacityAnimator {
                duration: Kirigami.Units.longDuration
                easing.type: Easing.InOutCubic
            }
        }
                
        Item {
            id: delegateItem
            Layout.fillWidth: true
            Layout.fillHeight: true
            
            Mycroft.SkillView {
                id: skillView
                anchors.fill: parent
                Kirigami.Theme.colorSet: Kirigami.Theme.View
                anchors.margins: Kirigami.Units.largeSpacing
                clip: true
                onCurrentItemChanged: {
                    backgroundVisible = false
                }

                Connections {
                    id: mycroftConnection
                    target: Mycroft.MycroftController
                    
                    onFallbackTextRecieved: {
                        Mycroft.MycroftController.sendRequest("skill.desktop.applet.conversation", {"query": incomingString, "speak": data.utterance})
                        if (!plasmoid.expanded && cfg_notifications == true) {
                            var post = data.utterance;
                            var title = "Mycroft's Reply:"
                            var notiftext = " " + post;
                            MycroftPlasmoid.Notify.mycroftResponse(title, notiftext);
                        }
                    }
                }
            }
        }        
    }
    
    Item {
        id: bottomBar
        anchors.bottom: root.bottom
        anchors.left: root.left
        anchors.right: root.right
        height: Kirigami.Units.gridUnit * 2

        BottomBarViewComponent {
            id: bottomBarView
        }
    }

    Image {
        anchors.centerIn: parent
        opacity: Mycroft.MycroftController.status != Mycroft.MycroftController.Open
        source: "../images/logo.png"
        
        Behavior on opacity {
            OpacityAnimator {
                duration: Kirigami.Units.longDuration
                easing.type: Easing.InOutCubic
            }
        }
    }
    
    ColumnLayout {
        id: mycroftSkillscolumntab
        visible: tabBar.currentTab == mycroftSkillsTab;
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: bottomBar.top
        anchors.top: topBar.bottom
        anchors.topMargin: Kirigami.Units.largeSpacing + Kirigami.Units.smallSpacing
        anchors.bottomMargin: Kirigami.Units.smallSpacing
        
        HintsViewComponent {
            id: hintsView
        }
    }
    
    ColumnLayout {
        id: mycroftMsmColumn
        visible: tabBar.currentTab == mycroftMSMinstTab;
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: bottomBar.top
        anchors.top: topBar.bottom
        anchors.topMargin: Kirigami.Units.largeSpacing + Kirigami.Units.smallSpacing
        anchors.bottomMargin: Kirigami.Units.smallSpacing
        
        SkillsInstallerComponent{
            id: skillsInstallerView
        }
    }
}
