<template>
  <div class="beat">
    <div class="control">
      <button @click="createNote($event)">
        <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 512 512"><!--! Font Awesome Pro 6.2.0 by @fontawesome - https://fontawesome.com License - https://fontawesome.com/license (Commercial License) Copyright 2022 Fonticons, Inc. --><path d="M403.8 34.4c12-5 25.7-2.2 34.9 6.9l64 64c6 6 9.4 14.1 9.4 22.6s-3.4 16.6-9.4 22.6l-64 64c-9.2 9.2-22.9 11.9-34.9 6.9s-19.8-16.6-19.8-29.6V160H352c-10.1 0-19.6 4.7-25.6 12.8L284 229.3 244 176l31.2-41.6C293.3 110.2 321.8 96 352 96h32V64c0-12.9 7.8-24.6 19.8-29.6zM164 282.7L204 336l-31.2 41.6C154.7 401.8 126.2 416 96 416H32c-17.7 0-32-14.3-32-32s14.3-32 32-32H96c10.1 0 19.6-4.7 25.6-12.8L164 282.7zm274.6 188c-9.2 9.2-22.9 11.9-34.9 6.9s-19.8-16.6-19.8-29.6V416H352c-30.2 0-58.7-14.2-76.8-38.4L121.6 172.8c-6-8.1-15.5-12.8-25.6-12.8H32c-17.7 0-32-14.3-32-32s14.3-32 32-32H96c30.2 0 58.7 14.2 76.8 38.4L326.4 339.2c6 8.1 15.5 12.8 25.6 12.8h32V320c0-12.9 7.8-24.6 19.8-29.6s25.7-2.2 34.9 6.9l64 64c6 6 9.4 14.1 9.4 22.6s-3.4 16.6-9.4 22.6l-64 64z"/></svg>
      </button>
      <button class="btn-delete" @click="remove()">
        <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 448 512"><!--! Font Awesome Pro 6.2.0 by @fontawesome - https://fontawesome.com License - https://fontawesome.com/license (Commercial License) Copyright 2022 Fonticons, Inc. --><path d="M160 400C160 408.8 152.8 416 144 416C135.2 416 128 408.8 128 400V192C128 183.2 135.2 176 144 176C152.8 176 160 183.2 160 192V400zM240 400C240 408.8 232.8 416 224 416C215.2 416 208 408.8 208 400V192C208 183.2 215.2 176 224 176C232.8 176 240 183.2 240 192V400zM320 400C320 408.8 312.8 416 304 416C295.2 416 288 408.8 288 400V192C288 183.2 295.2 176 304 176C312.8 176 320 183.2 320 192V400zM317.5 24.94L354.2 80H424C437.3 80 448 90.75 448 104C448 117.3 437.3 128 424 128H416V432C416 476.2 380.2 512 336 512H112C67.82 512 32 476.2 32 432V128H24C10.75 128 0 117.3 0 104C0 90.75 10.75 80 24 80H93.82L130.5 24.94C140.9 9.357 158.4 0 177.1 0H270.9C289.6 0 307.1 9.358 317.5 24.94H317.5zM151.5 80H296.5L277.5 51.56C276 49.34 273.5 48 270.9 48H177.1C174.5 48 171.1 49.34 170.5 51.56L151.5 80zM80 432C80 449.7 94.33 464 112 464H336C353.7 464 368 449.7 368 432V128H80V432z"/></svg>
      </button>
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
          # trigger computed by useRest
          return if (props.useRest && !props.useRest)
          return [] if !props.restAt
          _restAt = decimalToBinary Number(props.restAt)
          console.log 'compouted restAt'
          String(_restAt).split('').map (r)-> Number r
        set: (value)->
          console.log 'restAt set'
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
      watch (()-> props.useRest), (n)->
        restAt.value = null if !n
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
<style lang="sass" scoped>
</style>