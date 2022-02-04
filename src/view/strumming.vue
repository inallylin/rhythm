<template>
  <div class="strumming" :style="style">
    <div class="bar">
      <note
        :ref="getNoteInstance"
        :showCode="showCode"
        :showArrow="showArrow"
        :index="i"
        v-for="i in 1" />
    </div>
    <button class="btn-refresh" @click="createRamdon"></button>
    <div class="preference">
      <div class="color-picker">
        <input id="color-picker" type="color" v-model="theme">
        <label for="color-picker" :style="style"></label>
      </div>
      <div class="metre-selector">
        <select v-model="bar">
          <option :id="'metre-' + option.value" type="radio" :value="option.value"  v-for="option in barOptions">
            {{option.label}}
          </option>
        </select>
      </div>
      <div class="checkbox">
        <input id="toggle-code" type="checkbox" v-model="showCode">
        <label for="toggle-code">Code</label>
      </div>
      <div class="checkbox">
        <input id="toggle-arrow" type="checkbox" v-model="showArrow">
        <label for="toggle-arrow">Arrow</label>
      </div>
    </div>
    <!--   {{rythem}}
      <span @click="play">g</span>
      <span @click="stop">s</span> -->
  </div>
</template>
<script lang="coffee">
import { computed, watch, onMounted, ref } from 'vue'
import note from '@/components/note.vue'
export default
  components:
    note: note
  setup: ->
    bar = ref 4
    theme = '#1c5580'
    noteInstance = ref []
    showArrow = ref true
    showCode = ref true
    player = null
    audio = null
    oscillator = null
    gainNode = null
    style = computed -> "color: #{theme}"
    barOptions = ref [
      {
        value: 2
        label: 'Duple'
      }
      {
        value: 3
        label: 'Triple'
      }
      {
        value: 4
        label: 'Quadruple'
      }
    ]
    createRamdon = ->
      for n in noteInstance.value
        n.createNote()
    getNoteInstance = (instance)->
      noteInstance.value.push instance
    return {
      noteInstance
      style
      theme
      bar
      createRamdon
      showCode
      showArrow
      barOptions
      getNoteInstance
    }
</script>
<style lang="sass">
  @import '@/assets/sass/strumming.sass'
</style>