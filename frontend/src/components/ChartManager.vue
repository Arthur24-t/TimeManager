<template>
    <div class="card">
      <div class="card-header">
        <slot name="header">ChartManager</slot>
      </div>
      <div class="card-body chart">
        <div class="pie-bar-chart">
          <pie-chart />
          <chart-bar />
        </div>
        <linear-chart />
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
  }
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
  gap: 1.5rem;
}

</style>