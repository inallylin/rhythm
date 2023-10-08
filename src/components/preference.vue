<template>
  <div :class="['preference', {open: show}]" @click="show = !show">
    <button class="preference__toggle" @click.stop="show = !show">
      <icon-xmark v-if="show" />
      <icon-palette v-else />
    </button>
    <div class="color-picker">
      <input id="color-picker" type="color" v-model="config.theme">
      <label for="color-picker">
        <icon-palette />
      </label>
    </div>
    <div class="formfield" v-if="allowConfigNote">
      <div class="formfield__label">
        Note
      </div>
      <div class="formfield__field">
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
    </div>
    <div class="formfield">
      <div class="formfield__label">
        Sound
      </div>
      <div class="formfield__field">
        <select v-model="config.speed" @click.stop>
          <option :value="s" v-for="s in [150, 167, 200, 250, 300]">
            {{Math.round(60000/(s*4))}}bpm
          </option>
        </select>
        <select id="sound" v-model="config.wave" @click.stop>
          <option value="sine">Sine</option>
          <option value="square">Square</option>
          <option value="triangle">Triangle</option>
          <option value="sawtooth">Sawtooth</option>
        </select>
        <div class="hz-selector" @click.stop>
          <input id="hz" type="range" min="164.8" max="1047" v-model="config.hz">
          <label class="hz-selector__text">{{readableHz}}</label>
        </div>
      </div>
    </div>
    <div class="input" v-if="allowConfigHighlight">
      <label for="highlight" @click.stop>
        Highlight
        <select id="highlight" v-model="config.highlight">
          <option :value="0">Off</option>
          <option :value="1">For Beat</option>
          <option :value="2">Progress</option>
        </select>
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
      allowConfigHighlight = computed ->
        route.name == 'trainer'
      allowConfigNote = computed ->
        route.name == 'home'
      config = reactive
        theme: storage 'theme', '#1c5580'
        arrow: storage 'arrow', true
        code: storage 'code', true
        rest: storage 'rest', false
        speed: storage 'speed', 250
        highlight: storage 'highlight', 1
        wave: storage 'wave', 'triangle'
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
      return {
        config
        show
        style
        allowConfigNote
        allowConfigHighlight
        readableHz
      }
  
</script>
<style lang="sass" scoped>
  @import '@/assets/sass/_mixins.sass'
  .preference
    +drawer(768)
    // max-width: calc(100% - 650px)
    box-sizing: border-box
    position: fixed
    z-index: 9
    bottom: 0
    padding: space(lg)
    flex-wrap: wrap
    align-items: flex-end
    +min-screen(769)
      display: flex
      font-size: .85rem
    +max-screen(768)
      top: 0
      width: 300px
    &__toggle
      bottom: 0
      top: auto
      margin: 0
  .hz-selector
    +label
    vertical-align: middle
    font-size: 12px
    padding-left: space()
    padding-right: space()
    background-color: white
    input[type="range"]
      display: block
      width: 100%
    &__text[class]
      color: color(dark)
      font-size: 12px
      +min-screen(769)
        position: absolute
        background: white
        width: auto
        top: -0.75rem
        left: 1rem
        padding-left: 0.5em
        padding-right: 0.5em
      +max-screen(768)
        width: 4em
        padding-left: space(xs)
        padding-right: space(xs)
        background: var(--theme-color)
        border-radius: 2px
        color: white
        margin-left: space(sm)
        line-height: 1.7
        opacity: 0.5
    +max-screen(768)
      border-color: transparent
      &[class]
        display: flex
      input[type="range"]
        max-width: none
        flex: 1 1 1%
</style>