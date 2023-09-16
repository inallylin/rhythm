<template>
  <div :class="['preference', {open: show}]" @click="show = !show">
    <button class="preference__toggle" @click.stop="show = !show">
      <icon-xmark v-if="show" />
      <icon-palette v-else />
    </button>
    <div class="color-picker">
      <input id="color-picker" type="color" v-model="config.theme">
      <label for="color-picker" :style="style"></label>
    </div>
    <div class="input" :style="style">
      <label for="measure">
        Measure
        <input id="measure" type="Number" min="1" max="100" onfocus="this.select()" v-model="bar" @click.stop>
      </label>
    </div>
    <div class="checkbox" :style="style">
      <input id="toggle-code" type="checkbox" v-model="config.code">
      <label for="toggle-code">Code</label>
    </div>
    <div class="checkbox" :style="style">
      <input id="toggle-arrow" type="checkbox" v-model="config.arrow">
      <label for="toggle-arrow">Arrow</label>
    </div>
    <div class="checkbox" :style="style">
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
  import { ref, reactive, computed } from 'vue'
  import { storage } from '@/mixins/tools.coffee'
  import iconPalette from '@/components/icon/palette.vue'
  import iconXmark from '@/components/icon/xmark.vue'
  export default
    components:
      'icon-palette': iconPalette
      'icon-xmark': iconXmark
    setup: ->
      show = ref false
      style = computed -> "color: #{config.theme}; fill: #{config.theme}; "
      config = reactive
        theme: storage 'theme', '#1c5580'
        arrow: storage 'arrow', true
        code: storage 'code', true
        rest: storage 'rest', false
      syncConfig = (codeString)->
        _codes = codeString.split ','
        if _codes.some (c)-> c.length == 4
          config.rest = true
      return {
        config
        show
        style
      }
  
</script>
<style lang="sass" scoped>
  @import '@/assets/sass/_mixins.sass'
  .preference
    +drawer(768)
    position: fixed
    z-index: 10
    bottom: 0
    padding: space(lg)
    +min-screen(769)
      display: flex
    +max-screen(768)
      top: 0
    .input, .checkbox, .color-picker
      +min-screen(769)
        margin-right: space()
      +max-screen(768)
        margin: 0
        margin-bottom: space()
        background: white
      > label
        +max-screen(768)
          border-color: transparent
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
      cursor: pointer
</style>