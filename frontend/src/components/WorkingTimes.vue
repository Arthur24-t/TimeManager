<template>
    <div class="card">
      <div class="card-header">
        <slot name="header">WorkingTimes</slot>
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
        name: 'WorkingTimes'
    }
</script>

<style scoped>

</style>