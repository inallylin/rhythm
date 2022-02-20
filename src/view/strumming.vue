<template>
  <div class="strumming" :style="style">
    <div class="bar">
      <note
        :ref="getNoteInstance"
        :useRest="useRest"
        :showCode="showCode"
        :showArrow="showArrow"
        :index="i"
        v-for="i in bar" />
      <button class="btn-add" @click="add"></button>
    </div>
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
        <input id="toggle-code" type="checkbox" v-model="useRest">
        <label for="toggle-code">Rest</label>
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
    theme = ref '#1c5580'
    noteInstance = ref []
    showArrow = ref true
    showCode = ref true
    useRest = ref false
    player = null
    audio = null
    oscillator = null
    gainNode = null
    style = computed -> "color: #{theme.value}"
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
    add = ->
      bar.value += 1
    getNoteInstance = (instance)->
      noteInstance.value.push instance
    return {
      noteInstance
      style
      theme
      bar
      createRamdon
      useRest
      showCode
      showArrow
      barOptions
      getNoteInstance
      add
    }
</script>
<style lang="sass">
  @import '@/assets/sass/strumming.sass'
</style>