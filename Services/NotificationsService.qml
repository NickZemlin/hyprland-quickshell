pragma Singleton
pragma ComponentBehavior: Bound


import QtQuick
import Quickshell
import Quickshell.Services.Notifications

Singleton {
    id: root

    property list<Notif> list: []
    onListChanged: {
        console.log("List changed. New length:", list.length);
        console.log("Current list content:", JSON.stringify(list.map(notif => ({
            notif
        })), null, 2));
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
            console.log(JSON.stringify(notification))
                        const newNotifObject = notifComponent.createObject(root, {
                "notificationId": notification.id,
                "notification": notification,
                "time": Date.now(),
            });
			root.list = [...root.list, newNotifObject];
        }
    }

    function discardNotification(id) {
        console.log("[Notifications] Discarding notification with ID: " + id);
        const index = root.list.findIndex((notif) => notif.notificationId === id);
        const notifServerIndex = list.findIndex((notif) => notif.id + root.idOffset === id);
        if (index !== -1) {
            root.list.splice(index, 1);
        }
        if (notifServerIndex !== -1) {
            list[notifServerIndex].dismiss()
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

        readonly property Connections conn: Connections {
            target: wrapper.notification.Component

            function onDestruction(): void {
                wrapper.destroy();
            }
        }
    }

    Component {
        id: notifComponent
        Notif {}
    }
}