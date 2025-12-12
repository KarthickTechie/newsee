## User Login & FCM Notification Handling

1. Device–User Token Binding

   Whenever a user logs in using their credentials, the application generates a new FCM device token.

   This token is unique per device, per installation.

   During login, the app sends this token to the backend and associates it with the logged-in user ID.

   From that moment, all push notifications intended for that user will be delivered only to that device.

2. Token Refresh Behaviour

   FCM may refresh the token at any time due to:

   App uninstall/reinstall

   Clearing app data

   Device factory reset

   Google Play Services update

   Manual log-out

   Whenever the token changes, the app automatically updates the backend with the new token.

3. Multi-Device Login Restriction

   If the same user logs in on multiple devices, only the latest token is stored.

   This means:

   Push notifications will be delivered only to the most recently logged-in device.

   Older devices (previous logins) will stop receiving notifications.

4. APK Sharing Limitation

   If the user shares your APK with someone else:

   That person’s device will generate its own unique token.

   To receive your notifications, that device must log in using a valid user ID.

   You cannot reuse tokens across devices; FCM does not allow cloning or sharing.
