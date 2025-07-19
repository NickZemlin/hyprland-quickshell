pragma Singleton
pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import Quickshell.Services.Notifications

Singleton {
    id: root

    property alias list: listModel
    
    ListModel {
        id: listModel
    }

    NotificationServer {
        id: notifServer
        actionsSupported: true
        bodyHyperlinksSupported: true
        bodyImagesSupported: true
        bodyMarkupSupported: true
        bodySupported: true
        imageSupported: true
        keepOnReload: false
        persistenceSupported: true

        onNotification: (notification) => {
            notification.tracked = true
            // Create the notification object
            const newNotifObject = notifComponent.createObject(root, {
                "notificationId": notification.id,
                "notification": notification,
                "time": Date.now(),
            });

            // Properly append to ListModel (this triggers add animation)
            listModel.append({"notif": newNotifObject});
        }
    }

    function discardNotification(id) {
        
        // Find and remove from ListModel (this triggers remove animation)
        for (let i = 0; i < listModel.count; i++) {
            const item = listModel.get(i);
            if (item.notif.notificationId === id) {
                listModel.remove(i);
                break;
            }
        }
        
        // Handle notification server dismissal
        if (notifServer.notifications){
            const notifServerIndex = notifServer.notifications.findIndex((notif) => notif.id === id);
            if (notifServerIndex !== -1) {
                notifServer.notifications[notifServerIndex].dismiss();
            }
        }
    }

    component Notif: QtObject {
        id: wrapper
        required property int notificationId
        property Notification notification
        property list<var> actions: notification?.actions.map((action) => ({
            "identifier": action.identifier,
            "text": action.text,
        })) ?? []
        property bool popup: false
        property string appIcon: notification?.appIcon ?? ""
        property string appName: notification?.appName ?? ""
        property string body: notification?.body ?? ""
        property string image: notification?.image ?? ""
        property string summary: notification?.summary ?? ""
        property double time
        property string urgency: notification?.urgency.toString() ?? "normal"
        property Timer timer
    }

    Component {
        id: notifComponent
        Notif {}
    }
}