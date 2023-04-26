importScripts("https://www.gstatic.com/firebasejs/9.6.10/firebase-app-compat.js");
importScripts("https://www.gstatic.com/firebasejs/9.6.10/firebase-messaging-compat.js");

const firebaseConfig = {
  apiKey: "AIzaSyCtXJYFpsSXvNFoPfzoRMTHAQnuJIbEDSA",
  appId: "1:772956890608:web:f210e0f5066e03484ce935",
  messagingSenderId: "772956890608",
  projectId: "edms-77162",
  authDomain: "edms-77162.firebaseapp.com",
  storageBucket: "edms-77162.appspot.com",
  databaseURL: "https://edms-77162-default-rtdb.firebaseio.com",
}

firebase.initializeApp(firebaseConfig);
const messaging = firebase.messaging();
