<template>
  <div class="beat" @click="createNote($event)" hint="Change">
    {{beats}}
    <template v-if="note">
      <div :class="['note__wrapper', {quarter: isQuarter, tie: hasTie}]">
        <span :class="['note', seqClass(j)]" v-for="n, j in beats">
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
        :class="['arrow__wrapper', {quarter: isQuarter, tie: hasTie}]">
        <span :class="['arrow', seqClass(j)]" v-for="n, j in beats">
          <template v-if="n != 0">{{n}}</template>
        </span>
      </div>
    </template>
    <template v-else>
      <div class="note__wrapper fullrest">
        <div class="note rest"></div>
      </div>
      <div class="number__wrapper fullrest" v-if="showCode">
        <div class="number" v-for="i in 4"></div>
      </div>
      <div class="arrow__wrapper fullrest" v-if="showArrow">
        <div class="arrow rest"></div>
      </div>
    </template>
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
      useRest:
        type: Boolean
        default: false
    setup: (props)->
      note = ref null
      feint = (n, act)->
        return if act == -1
        return '-' if !act
        n
      ramdon = (max = 0.5, min)->
        return Math.random() < max if !min
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
        note?.value % 2 == 0 && beats.value[3] != -1
      isQuarter = computed ->
       note.value == 1 && beats.value.indexOf(-1) == -1
      seqClass = (index)->
        _className = []
        _className.push 'rest' if beats.value[index] == -1
        _className.push 'afterEmpty' if beats.value[index+1] == 0
        _className.push 'afterRest' if afterRest(index, -1)
        _className
      afterRest = (index)->
        next = beats.value[index+1]
        next = beats.value[index+2] if !next
        next = beats.value[index+3] if !next
        return true if next && next == -1
      rest = (beat)->
        return beat if !props.useRest || beat || ramdon(0.9)
        -1
      createNote = (e)->
        e.target.blur() if e
        note.value = 0
        return if props.useRest && ramdon(0.03)
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
        isQuarter
        seqClass
      }
</script>