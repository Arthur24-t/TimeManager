<template>
  <!-- <router-view /> -->
  <div class="square-left"></div>
  <div v-if="isIdentificationPage" class="identification-view">
    <identification />
  </div>
  <div v-else class="main-view">
    <nav-bar />
    <div class="right-view">
      <router-view />
    </div>
  </div>
  <div class="square-right"></div>
</template>

<script>
import Identification from './components/Identification.vue';
import NavBar from './components/NavBar.vue';

export default {
  name: 'App',
  components: {
    Identification,
    NavBar
  },
  data() {
    return {
      authentified: localStorage.getItem('token'),
    }
  },
  computed: {
    isIdentificationPage() {
      return (this.$route.path === '/identification' || localStorage.getItem("user") === null)
    }
  },
}
</script>

<style>
.square-left {
  width: 750px;
  height: 750px;
  transform: rotate(-45deg);
  flex-shrink: 0;
  border-radius: 160px;
  background: rgba(198, 224, 225, 0.50);
  position: fixed;
  z-index: -1;
  top: -35%;
  left: -10%;
}
.square-right {
  width: 750px;
  height: 750px;
  transform: rotate(-45deg);
  flex-shrink: 0;
  border-radius: 160px;
  background: rgba(145, 188, 194, 0.50);
  position: fixed;
  z-index: -1;
  top: 45%;
  left: 66%;
}

.identification-view {
  display: flex;
  align-items: center;
  justify-content: center;
}

.main-view {
  display: flex;
  gap: 3rem;
}

.right-view {
  width: 100%;
}

.card {
  border: 1px solid #ccc;
  background-color: white;
  border-radius: 4px;
  padding: 16px;
  margin: 8px;
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
}

.card-header {
  font-size: 1.2rem;
  font-weight: bold;
}

.card-body {
  margin-top: 10px;
}

.card-footer {
  margin-top: 10px;
  color: #666;
}

.user-clock {
  display: grid;
  grid-template-columns: 50% 50%;
  gap: 0.5rem;
}

:-webkit-scrollbar {
  width: 3px;
}

/* Track */
:-webkit-scrollbar-track {
  box-shadow: inset 0 0 5px grey;
  border-radius: 10px;
}

/* Handle */
:-webkit-scrollbar-thumb {
  background: grey;
  border-radius: 10px;
}

@media (max-width: 1250px) {
    .right-view {
      width: 85%;
    }
}

@media (max-width: 1000px) {
    .right-view {
      width: 75%;
    }
}

@media (max-width: 700px) {
    .right-view {
      width: 75%;
    }
}
</style>