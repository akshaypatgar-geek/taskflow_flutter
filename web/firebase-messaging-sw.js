importScripts('https://www.gstatic.com/firebasejs/9.23.0/firebase-app-compat.js');
importScripts('https://www.gstatic.com/firebasejs/9.23.0/firebase-messaging-compat.js');

// Function to fetch config and initialize Firebase
async function initializeFirebase() {
  try {
    const response = await fetch('/app_config.json');
    const config = await response.json();

    firebase.initializeApp({
      apiKey: config.firebaseApiKey,
      appId: config.firebaseAppId,
      messagingSenderId: config.firebaseMessagingSenderId,
      projectId: config.firebaseProjectId,
      authDomain: config.firebaseAuthDomain,
      storageBucket: config.firebaseStorageBucket,
    });

    const messaging = firebase.messaging();

    messaging.onBackgroundMessage((payload) => {
      console.log('[firebase-messaging-sw.js] Received background message ', payload);
      const notificationTitle = payload.notification.title;
      const notificationOptions = {
        body: payload.notification.body,
        icon: '/icons/Icon-192.png',
        data: payload.data
      };

      self.registration.showNotification(notificationTitle, notificationOptions);
    });
  } catch (error) {
    console.error('Failed to initialize Firebase in Service Worker:', error);
  }
}

self.addEventListener('notificationclick', (event) => {
  event.notification.close();
  const taskId = event.notification.data ? event.notification.data.taskId : null;
  if (!taskId) return;

  // Navigate to the Flutter route. GoRouter will handle auth redirects.
  const targetUrl = `/#/tasks/${taskId}`;

  event.waitUntil(
    clients.matchAll({ type: 'window', includeUncontrolled: true }).then((clientList) => {
      for (const client of clientList) {
        if (client.url.includes(self.location.origin) && 'navigate' in client) {
          return client.navigate(targetUrl).then((c) => c.focus());
        }
      }
      return clients.openWindow(targetUrl);
    })
  );
});

initializeFirebase();
