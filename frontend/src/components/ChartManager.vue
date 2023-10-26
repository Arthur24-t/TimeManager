<template>
    <div class="card">
      <div class="card-header">
        <slot name="header">ChartManager</slot>
      </div>
      <div class="card-body chart">
        <pie-manager />
        <chart-bar />
        <linear-chart />
      </div>
      <div class="card-footer">
        <slot name="footer">Pied de carte</slot>
      </div>
  </div>
</template>
 
<script>
import ChartBar from './ChartBar.vue';

import PieManager from './PieManager.vue';
import LinearChart from './LinearChart.vue';

export default {
  name: 'ChartManager',
  components: {
    ChartBar,
    PieManager,
    LinearChart
  }
};
</script>

<style scoped>

.chart {
  display: flex;
  flex-direction: row;
  gap: 1.5rem;
}

</style>