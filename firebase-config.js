<script type="module">
  // Import the functions you need from the SDKs you need
  import { initializeApp } from "https://www.gstatic.com/firebasejs/12.5.0/firebase-app.js";
  import { getAnalytics } from "https://www.gstatic.com/firebasejs/12.5.0/firebase-analytics.js";
  // TODO: Add SDKs for Firebase products that you want to use
  // https://firebase.google.com/docs/web/setup#available-libraries

  // Your web app's Firebase configuration
  // For Firebase JS SDK v7.20.0 and later, measurementId is optional
  const firebaseConfig = {
    apiKey: "AIzaSyA5ezNWECVn4vkdEHWhap-mv1B-D8LCN70",
    authDomain: "quiz-43b3e.firebaseapp.com",
    databaseURL: "https://quiz-43b3e-default-rtdb.firebaseio.com",
    projectId: "quiz-43b3e",
    storageBucket: "quiz-43b3e.appspot.com",
    messagingSenderId: "477037762591",
    appId: "1:477037762591:web:ea30670a704b0063819d2a",
    measurementId: "G-7RWKDV2SLP"
  };

  // Initialize Firebase
  const app = initializeApp(firebaseConfig);
  const analytics = getAnalytics(app);
</script>
