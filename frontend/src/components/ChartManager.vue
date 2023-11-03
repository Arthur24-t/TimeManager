<template>
  <div class="card">
    <div class="card-header">
      <div class="chart-manager">
        <slot name="header"><div class="titre">Chart</div></slot>
        <button @click="updateNeedRefresh(true)" class="custom-button">
          Refresh Graph
        </button>
      </div>
    </div>
    <div class="card-body chart">
    <div class="chart-grid">
      <div class="chart-item">
        <pie-chart @needrefresh="updateNeedRefresh(false)" :need-refresh="needrefresh" />
      </div>
      <div class="chart-item">
        <chart-bar @needrefresh="updateNeedRefresh(false)" :need-refresh="needrefresh" />
      </div>
      <div class="chart-item">
        <linear-chart @needrefresh="updateNeedRefresh(false)" :need-refresh="needrefresh" />
      </div>
    </div>
  </div>
    <div class="card-footer">
    </div>
  </div>
</template>

<script>
import ChartBar from './ChartBar.vue';
import PieChart from './PieChart.vue';
import LinearChart from './LinearChart.vue';

export default {
  name: 'ChartManager',
  components: {
    ChartBar,
    PieChart,
    LinearChart
  },
  data() {
    return {
      needrefresh: false
    }
  },
  methods: {
    updateNeedRefresh(e) {
      this.needrefresh = e
    }
  },
};
</script>

<style scoped>

.chart-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
  gap: 20px;
}

.chart-item {
  width: 100%;
}

.card {
  background-color: rgba(255, 255, 255, 0.5);
  overflow: scroll;
  border-radius: 10px;
  box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
  padding: 20px;
  width: calc(100%-40px);
}

.titre {
  font-size: 30px;
  margin-left: 400px;
  font-family: 'Courier New', Courier, monospace;
  font-weight: bold;
}

.card-header {
  background-color: #00a3e0;
  color: white;
  border-top-left-radius: 10px;
  border-top-right-radius: 10px;
  padding: 10px;
  font-weight: bold;
  font-size: 20px;
}

.chart-manager {
  display: flex;
  justify-content: space-between;
  font-size: 1.2rem;
  font-weight: bold;
}

.card-body {
  background-color: transparent;
  display: flex;
  flex-direction: column;
  gap: 3rem;
  padding: 10px;
}

.pie-bar-chart {
  display: flex;
  flex-direction: row;
  justify-content: center;
  align-items: center;
}

.mid {
  width: 50%;
}

.card-footer {
  background-color: #00a3e0;
  border-bottom-left-radius: 10px;
  border-bottom-right-radius: 10px;
  padding: 10px;
  color: white;
}

.custom-button {
  color: white;
  border: 1px solid #ccc; /* Ajout d'une bordure de 1 pixel */
  border-radius: 5px;
  padding: 10px 20px;
  font-size: 18px;
  cursor: pointer;
  background-color: rgb(67, 164, 244); /* Ajout d'un fond blanc */
}

.custom-button:hover {
  background-color: #0074a8;
}


.custom-button:hover {
  background-color: #0074a8; /* Couleur légèrement plus sombre au survol */
}
</style>
