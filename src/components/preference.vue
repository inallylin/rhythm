<template>
  <div class="page__nav" v-if="false">
    <div class="preference">
      <div class="color-picker">
        <input id="color-picker" type="color" v-model="config.theme">
        <label for="color-picker" :style="style"></label>
      </div>
      <div class="input">
        <label for="measure">Measure</label>
        <input id="measure" type="Number" min="1" max="100" onfocus="this.select()" v-model="bar">
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
  </div>
  <component is="style">
    :root{
      --theme-color: {{config.theme}};
    }
  </component>
</template>
<script lang="coffee">
  import { reactive } from 'vue'
  import { storage } from '@/mixins/tools.coffee'
  export default
    setup: ->
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
      }
  
</script>