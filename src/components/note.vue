<template>
  <div class="beat">
    <div class="control">
      <button @click="createNote($event)">Change</button>
      <button class="btn-delete" @click="remove()">Remove</button>
    </div>
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
  import { ref, computed, watch } from 'vue'
  export default
    props:
      note:
        type: Number
        default: null
      restAt:
        type: Number
        default: null
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
    emits: ['update:note', 'update:restAt', 'remove']
    setup: (props, {emit})->
      note = computed
        get: -> props.note
        set: (value)-> emit 'update:note', value
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
      restAt = computed
        get: ->
          return [] if !props.restAt
          _restAt = decimalToBinary Number(props.restAt)
          String(_restAt).split('').map (r)-> Number r
        set: (value)->
          emit 'update:restAt', value

      beats = computed ->
        _beats = decimalToBinary(note.value)
        _beatsArray = String(_beats).split ''
        _beatsArray.map (beat, i) ->
          return -1 if !Number(beat) && restAt.value[i] != undefined
          return rest Number beat if props.restAt != null
          Number beat
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
        aa = ramdon(0)
        return beat if !props.useRest || beat || ramdon(0.9)
        -1
      createNote = (e)->
        e.target.blur() if e
        restAt.value = null
        if props.useRest && ramdon(0.03)
          _note = 0
        else
          _note = ramdon 15, 1
          if props.index == 0 && _note%2 == 0
            _note -= 1
        note.value = _note
      remove = -> emit 'remove'
      watch beats, (n)->
        _restAt = n.map (b)-> if b == -1 then 1 else 0
        restAt.value = parseInt(_restAt.join(''), 2)
      createNote() if !note.value
      return {
        note
        createNote
        beats
        feint
        hasTie
        isQuarter
        seqClass
        remove
      }
</script>