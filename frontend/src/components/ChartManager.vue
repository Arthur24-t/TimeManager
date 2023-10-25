<template>
    <div class="card">
      <div class="card-header">
        <slot name="header">ChartManager</slot>
      </div>
      <div class="card-body">
      </div>
      <div class="card-footer">
        <slot name="footer">Pied de carte</slot>
      </div>
    </div>
</template>

<script>
    export default {
        name: 'ChartManager'
    }
</script>

<style scoped>

</style>