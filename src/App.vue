<template>
  <div class="modal-wrapper"></div>
  <navigator />
  <preference />
  <router-view class="page" v-slot="{ Component }">
    <transition name="list" mode="out-in">
      <component :is="Component" />
    </transition>
  </router-view>
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
  @import '@/assets/sass/strumming.sass'
  @import '@/assets/sass/modal.sass'
  @import '@/assets/sass/transition.sass'
</style>