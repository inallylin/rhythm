<template>
  <div :class="['preference', {open: show}]" @click="show = !show">
    <button class="preference__toggle" @click.stop="show = !show">
      <icon-xmark v-if="show" />
      <icon-palette v-else />
    </button>
    <div class="preference__context">
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
      <div class="formfield">
        <div class="formfield__label">
          Beats
        </div>
        <div class="formfield__field">
          <div class="checkbox" v-if="allowConfigNote">
            <input id="toggle-beat-type" type="checkbox" v-model="config.type">
            <label for="toggle-beat-type">Only 8 Beat</label>
          </div>
          <div class="checkbox" v-if="allowConfigHighlight">
            <input id="toggle-highlight" type="checkbox" v-model="config.highlight">
            <label for="toggle-highlight">Highlight</label>
          </div>
        </div>
      </div>
      <div class="preference-append"></div>
      <div class="btn-group">
        <button class="btn-outline" @click="resetPlayer">
          <icon-arrow-rotate />
          Reset Player
        </button>
      </div>
    </div>
  </div>
  <component is="style">
    :root{
      --theme-color: {{config.theme}};
    }
  </component>
</template>
<script lang="coffee">
  import { ref, reactive, computed, watch, onMounted, onUnmounted, nextTick } from 'vue'
  import { useRoute } from 'vue-router'
  import { useStore } from 'vuex'
  import { storage, deepCopy } from '@/mixins/tools.coffee'
  import iconPalette from '@/components/icon/palette.vue'
  import iconXmark from '@/components/icon/xmark.vue'
  import iconArrorRotate from '@/components/icon/arrow-rotate.vue'
  import hzName from '@/static/hz.json'
  export default
    components:
      'icon-palette': iconPalette
      'icon-xmark': iconXmark
      'icon-arrow-rotate': iconArrorRotate
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
        type: storage 'type', false
      readableHz = computed ->
        hzkey = Object.keys(hzName).find (k)->
          _hz = hzName[k]
          return k if Math.abs(_hz - config.hz) < 5
        return hzkey if hzkey
        "#{config.hz}Hz"
      resetPlayer = ->
        store.dispatch 'player.reset'
      hide = ->
        show.value = false
      sync = ->
        store.dispatch 'preference.set', deepCopy(config)
      init = ->
        sync()
        inited.value = true
      watch config, sync
      watch preferenceRaw, (n, o)->
        _numberKeys = ['speed', 'highlight', 'hz']
        return if !inited.value
        for k, v of n
          continue if config[k] == v
          if _numberKeys.indexOf(k) >= 0
            v = Number(v)
          config[k] = v
      window.addEventListener 'resize', hide
      onMounted ->
        init()
      onUnmounted ->
        window.removeEventListener 'resize', hide
      return {
        config
        show
        style
        allowConfigNote
        allowConfigHighlight
        readableHz
        resetPlayer
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
    flex-wrap: wrap
    align-items: flex-end
    +min-screen(769)
      display: flex
      font-size: .85rem
      pointer-events: none
      .preference__toggle, .preference__context > *
        pointer-events: all
    +max-screen(768)
      top: 0
      width: 300px
      .btn-outline
        border-color: transparent
    &__context
      overflow: auto
      height: 100%
      box-sizing: border-box
      padding: space(lg)
      position: relative
      z-index: 1
      +min-screen(769)
        display: flex
        align-items: flex-end
      +max-screen(768)
        padding-left: 0
        padding-right: 0
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