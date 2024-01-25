<template>
  <div>Challenge
    <chord />
  </div>
</template>
<script lang="coffee">
  import chord from '@/components/chord.vue'
  export default
    components:
      chord: chord
    setup: ->
      return {}
</script>