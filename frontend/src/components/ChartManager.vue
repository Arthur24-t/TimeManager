<template>
    <div class="card">
      <div class="card-header">
        <slot name="header">ChartManager</slot>
      </div>
      <div class="card-body">
        <pie-manager />
      </div>
      <div class="card-footer">
        <slot name="footer">Pied de carte</slot>
      </div>
    </div>
</template>

<script>
import PieManager from './PieManager.vue';

    export default {
        name: 'ChartManager',
        components: {
          PieManager
        }
    }
</script>

<style scoped>

</style>