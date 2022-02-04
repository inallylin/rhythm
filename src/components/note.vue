<template>
  <div class="beat" @click="createNote($event)" hint="Change">
    {{note}}, {{beats}}
    <input type="text" v-model="note">
    <div :class="['note__wrapper', {quarter: note == 1, tie: note % 2 == 0}]">
      <span class="note" v-for="n, j in beats">
        <template v-if="n">v</template>
      </span>
    </div>
    <div v-if="showCode" class="number__wrapper">
      <span class="number" v-for="note, j in beats.slice().reverse()">
        {{feint(j+1, note)}}
      </span>
    </div>
    <div v-if="showArrow" :class="['arrow__wrapper', {quarter: note == 1, tie: note % 2 == 0}]">
      <span class="arrow" v-for="n, j in beats">
        <template v-if="n">v</template>
      </span>
    </div>
  </div>
</template>
<script lang="coffee">
  import { ref, computed } from 'vue'
  export default
    props:
      index:
        type: Number
        default: 0
      showCode:
        type: Boolean
        default: false
      showArrow:
        type: Boolean
        default: false
    setup: (props)->
      note = ref null
      feint = (n, act)->
        return '-' if !act
        n
      ramdon = (max, min)->
        Math.floor(Math.random() * max) + min
      decimalToBinary = (x)->
        bin = 0
        i = 1
        while (x != 0)
          rem = x % 2
          x = parseInt(x / 2)
          bin = bin + rem * i
          i = i * 10
        String(bin).padStart 4, 0
      beat = (note)->
        _beats = decimalToBinary(note)
        _beatsArray = String(_beats).split ''
        _beatsArray.map (beat) -> Number beat
      beats = computed ->
        _beats = decimalToBinary(note.value)
        _beatsArray = String(_beats).split ''
        _beatsArray.map (beat) -> Number beat
      createNote = (e)->
        e.target.blur() if e
        note.value = ramdon 15, 1
        if props.index == 1 && note.value%2 == 0
          note.value -= 1
      createNote()
      return {
        note
        createNote
        beat
        beats
        feint
      }
</script>