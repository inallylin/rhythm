<template>
  <navigator />
  <router-view v-slot="{ Component }">
    <transition name="list" mode="out-in">
      <component :is="Component" />
    </transition>
  </router-view>
  <preference />
</template>

<script lang="coffee">
  import navigator from '@/components/navigator.vue'
  import preference from '@/components/preference.vue'
  export default
    components:
      navigator: navigator
      preference: preference
    setup: ->
      return {}
</script>
<style lang="sass">
  @import '@/assets/sass/reset'
  @import '@/assets/sass/base'
</style>