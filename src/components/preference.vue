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
    <template v-if="allowConfigNote">
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
    </template>
    <select v-model="config.speed" @click.stop>
      <option :value="s" v-for="s in [150, 167, 200, 250, 300]">
        {{Math.round(60000/(s*4))}}bpm
      </option>
    </select>
    <div class="input" v-if="$route.name == 'trainer'">
      <label for="highlight" @click.stop>
        Highlight
        <select id="highlight" v-model="config.highlight">
          <option :value="0">Off</option>
          <option :value="1">Beat</option>
          <option :value="2">Progress</option>
        </select>
      </label>
    </div>
    <div class="input" v-if="$route.name == 'trainer'">
      <label for="sound" @click.stop>
        Sound
        <select id="sound" v-model="config.sound">
          <option :value="0">Web Audio</option>
          <option :value="1">Cow Bell</option>
          <option :value="2">Attention</option>
        </select>
      </label>
    </div>
    <div class="input" v-if="$route.name == 'trainer' && config.sound == 0">
      <label for="sound" @click.stop>
        Sound config
        <select id="sound" v-model="config.stype">
          <option value="sine">Sine</option>
          <option value="square">Square</option>
          <option value="triangle">Triangle</option>
          <option value="sawtooth">Sawtooth</option>
        </select>
        <div class="hz-selector">
          <input id="hz" type="range" min="164.8" max="1047" v-model="config.hz">
          {{readableHz}}
        </div>
      </label>
    </div>
  </div>
  <component is="style">
    :root{
      --theme-color: {{config.theme}};
    }
  </component>
</template>
<script lang="coffee">
  import { ref, reactive, computed, watch, onMounted } from 'vue'
  import { useRoute } from 'vue-router'
  import { useStore } from 'vuex'
  import { storage, deepCopy } from '@/mixins/tools.coffee'
  import iconPalette from '@/components/icon/palette.vue'
  import iconXmark from '@/components/icon/xmark.vue'
  import hzName from '@/static/hz.json'
  export default
    components:
      'icon-palette': iconPalette
      'icon-xmark': iconXmark
    setup: ->
      route = useRoute()
      store = useStore()
      show = ref false
      inited = ref false
      style = computed -> "color: #{config.theme}; fill: #{config.theme}; "
      preferenceRaw = computed ->
        JSON.parse JSON.stringify(store.getters.preference)
      preference = computed -> store.getters.preference
      allowConfigNote = computed ->
        route.name == 'home'
      config = reactive
        theme: storage 'theme', '#1c5580'
        arrow: storage 'arrow', true
        code: storage 'code', true
        rest: storage 'rest', false
        speed: storage 'speed', 250
        highlight: storage 'highlight', 1
        sound: storage 'sound', 0
        stype: storage 'stype', 'triangle'
        hz: storage 'hz', 830.6
      readableHz = computed ->
        hzkey = Object.keys(hzName).find (k)->
          _hz = hzName[k]
          return k if Math.abs(_hz - config.hz) < 5
        return hzkey if hzkey
        "#{config.hz}Hz"
      sync = ->
        store.dispatch 'preference.set', deepCopy(config)
      watch config, sync

      watch preferenceRaw, (n, o)->
        _numberKeys = ['speed', 'highlight', 'hz']
        return if !inited.value
        for k, v of n
          continue if config[k] == v
          if _numberKeys.indexOf(k) >= 0
            v = Number(v)
          config[k] = v
      init = ->
        sync()
        inited.value = true
      onMounted ->
        init()
      console.log 5
      return {
        config
        show
        style
        allowConfigNote
        readableHz
      }
  
</script>
<style lang="sass" scoped>
  @import '@/assets/sass/_mixins.sass'
  .preference
    +drawer(768)
    max-width: calc(100vw - 220px)
    box-sizing: border-box
    position: fixed
    z-index: 9
    bottom: 0
    padding: space(lg)
    flex-wrap: wrap
    +min-screen(769)
      display: flex
      font-size: .85rem
    +max-screen(768)
      top: 0
      width: 300px
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
  .hz-selector
    display: inline-flex
    vertical-align: middle
    font-size: 12px
    input[type="range"]
      vertical-align: text-top
      margin-right: space(xs)
    +max-screen(768)
      border-top: 1px solid color(light)
      margin-top: space()
      padding-top: space(sm)
      display: flex
      input[type="range"]
        max-width: none
</style>