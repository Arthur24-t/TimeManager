<template>
    <div class="card">
      <div class="card-header">
        <div class="chart-manager">
          <slot name="header">ChartManager</slot>
          <button @click="updateNeedRefresh(true)">
            Refresh Graph
          </button>
        </div>
      </div>
      <div class="card-body chart">
        <div class="pie-bar-chart">
          <div class="mid">
            <pie-chart @needrefresh="updateNeedRefresh(false)" :need-refresh="needrefresh" />
          </div>
          <div class="mid">
            <chart-bar @needrefresh="updateNeedRefresh(false)" :need-refresh="needrefresh"  />
          </div>
        </div>
        <linear-chart @needrefresh="updateNeedRefresh(false)" :need-refresh="needrefresh" />
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

.card {
  overflow: scroll;
  height: 95vh;
}

.chart {
  display: flex;
  flex-direction: column;
  gap: 3rem;
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

.chart-manager {
  display: flex;
  justify-content: space-between;
  font-size: 1.2rem;
  font-weight: bold;
}

</style>