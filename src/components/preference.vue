<template>
  <div :class="['preference', {open: show}]" @click="show = !show">
    <button class="preference__toggle" @click.stop="show = !show">
      <icon-xmark v-if="show" />
      <icon-palette v-else />
    </button>
    <div class="color-picker">
      <input id="color-picker" type="color" v-model="config.theme">
      <label for="color-picker"></label>
    </div>
    <div class="checkbox">
      <input id="toggle-code" type="checkbox" v-model="config.code">
      <label for="toggle-code">Code</label>
    </div>
    <div class="checkbox">
      <input id="toggle-arrow" type="checkbox" v-model="config.arrow">
      <label for="toggle-arrow">Arrow</label>
    </div>
    <div class="checkbox">
      <input id="toggle-rest" type="checkbox" v-model="config.rest">
      <label for="toggle-rest">Rest</label>
    </div>
  </div>
  <component is="style">
    :root{
      --theme-color: {{config.theme}};
    }
  </component>
</template>
<script lang="coffee">
  import { ref, reactive, computed, watch } from 'vue'
  import { useStore } from 'vuex'
  import { storage, deepCopy } from '@/mixins/tools.coffee'
  import iconPalette from '@/components/icon/palette.vue'
  import iconXmark from '@/components/icon/xmark.vue'
  export default
    components:
      'icon-palette': iconPalette
      'icon-xmark': iconXmark
    setup: ->
      store = useStore()
      show = ref false
      style = computed -> "color: #{config.theme}; fill: #{config.theme}; "
      config = reactive
        theme: storage 'theme', '#1c5580'
        arrow: storage 'arrow', true
        code: storage 'code', true
        rest: storage 'rest', false
      sync = ->
        store.dispatch 'preference.set', deepCopy(config)
      watch config, sync
      sync()
      return {
        config
        show
        style
      }
  
</script>
<style lang="sass" scoped>
  @import '@/assets/sass/_mixins.sass'
  %formfield
    +min-screen(769)
      margin-right: space()
    +max-screen(768)
      margin: 0
      margin-bottom: space()
      background: white
    > label
      +max-screen(768)
        border-color: transparent
  .input, .checkbox, .color-picker
    @extend %formfield
  .preference
    +drawer(768)
    position: fixed
    z-index: 9
    bottom: 0
    padding: space(lg)
    +min-screen(769)
      display: flex
    +max-screen(768)
      top: 0
    .color-picker > label
      +max-screen(768)
        min-height: 2em
        width: 100%
        box-sizing: border-box
        border: 2px solid white
    &__toggle
      bottom: 0
      top: auto
      margin: 0
</style>