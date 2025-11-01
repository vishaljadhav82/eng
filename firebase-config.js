<script type="module">
  // Import the functions you need from the SDKs you need
  import { initializeApp } from "https://www.gstatic.com/firebasejs/12.5.0/firebase-app.js";
  import { getAnalytics } from "https://www.gstatic.com/firebasejs/12.5.0/firebase-analytics.js";
  // TODO: Add SDKs for Firebase products that you want to use
  // https://firebase.google.com/docs/web/setup#available-libraries

  // Your web app's Firebase configuration
  // For Firebase JS SDK v7.20.0 and later, measurementId is optional
  const firebaseConfig = {
    apiKey: "AIzaSyAjwffXJTl2wWqVq0dm4IXsYoY2yZgVRAs",
    authDomain: "issue-log-146b9.firebaseapp.com",
    projectId: "issue-log-146b9",
    storageBucket: "issue-log-146b9.firebasestorage.app",
    messagingSenderId: "354502618053",
    appId: "1:354502618053:web:2245f2e70a8b0e588ef9ac",
    measurementId: "G-XWH1NKNRY2"
  };

  // Initialize Firebase
  const app = initializeApp(firebaseConfig);
  const analytics = getAnalytics(app);
</script>
