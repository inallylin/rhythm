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
  import { computed, watch } from 'vue'
  import { useStore } from 'vuex'
  import navigator from '@/components/navigator.vue'
  import preference from '@/components/preference.vue'
  export default
    components:
      navigator: navigator
      preference: preference
    setup: ->
      store = useStore()
      isLoading = computed ->
        store.getters.isLoading
      watch isLoading, (n)->
        document.body.classList.toggle 'loading', n
      return {
      }
</script>
<style lang="sass">
  @import '@/assets/sass/reset'
  @import '@/assets/sass/base'
  @import '@/assets/sass/strumming.sass'
  @import '@/assets/sass/modal.sass'
  @import '@/assets/sass/transition.sass'
</style>