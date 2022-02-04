<template>
  <div class="beat" @click="createNote($event)" hint="Change">
    {{note}}, {{beats}}
    <input type="text" v-model="note">
    <div :class="['note__wrapper', {quarter: note == 1, tie: hasTie}]">
      <span :class="['note', {rest: n == -1, afterRest: afterRest(j)}]" v-for="n, j in beats">
        <template v-if="n > 0">v</template>
      </span>
    </div>
    <div v-if="showCode" class="number__wrapper">
      <span :class="['number', {rest: n == -1}]"
        v-for="n, j in beats.slice().reverse()">
        <template v-if="n > 0">{{feint(j+1, n)}}</template>
      </span>
    </div>
    <div v-if="showArrow"
      :class="['arrow__wrapper', {quarter: note == 1, tie: note % 2 == 0}]">
      <span :class="['arrow', {rest: n == -1}]" v-for="n, j in beats">
        <template v-if="n != 0">v</template>
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
        return if act == -1
        return '-' if !act
        n
      ramdon = (max, min)->
        return Math.random() < 0.5 if !max
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
      beats = computed ->
        _beats = decimalToBinary(note.value)
        _beatsArray = String(_beats).split ''
        _beatsArray.map (beat) -> rest Number beat
      hasTie = computed ->
        beats?.value % 2 == 0 && beats.value[0] != -1
      afterRest = (index)->
        next = beats.value[index+1]
        next = beats.value[index+2] if !next
        next = beats.value[index+3] if !next
        return true if next && next == -1
      rest = (beat)->
        return beat if beat || ramdon()
        -1
      createNote = (e)->
        e.target.blur() if e
        note.value = ramdon 15, 1
        if props.index == 1 && note.value%2 == 0
          note.value -= 1
      createNote()
      return {
        note
        createNote
        beats
        feint
        hasTie
        afterRest
      }
</script>