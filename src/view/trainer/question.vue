<template>
  <div class="question">
    {{anwers}}
    <div class="question__answer">
      <note :index="i" :note="n" v-for="n, i in anwers" disabled />
    </div>
    <div class="question__answer" style="background: red">
      <note :index="i" :note="n" v-for="n, i in notes" disabled />
    </div>
    <div class="question__options">
      <button v-for="option in options" @click="add(option)">
        <note :note="option" disabled />
      </button>
      <button @click="undo">x</button>
    </div>
  </div>
</template>
<script lang="coffee">
  import { ref, computed } from 'vue'
  import { getRandomArrayItem } from '@/mixins/tools.coffee'
  import note from '@/components/note.vue'
  export default
    props:
      modelValue:
        type: Array
        default: []
      options:
        type: Array
        default: []
    components:
      note: note
    emits: ['update:modelValue']
    setup: (props, {emit})->
      anwers = ref []
      notes = computed
        get: -> props.modelValue || []
        set: (value)->
          emit 'update:modelValue', value
      undo = ()->
        anwers.value.splice -1, 1
      add = (_option)->
        anwers.value.push _option
      init = ->
        if !notes.value?.length
          _options = [...props.options]
          console.log 123, _options, props.options
          _notes = [0...4].map (i)->
            console.log 'get', i, _options.filter (o)->
              if i == 0 then Number(o)%2 == 1 else true
            _n = getRandomArrayItem _options.filter (o)->
              if i == 0 then Number(o)%2 == 1 else true
          notes.value = _notes
      init()
      console.log 82
      return {
        notes
        anwers
        add
        undo
      }
</script>
<style lang="sass" scoped>
  .beat
    width: 150px
  .question
    &__options
      .beat
        padding: 0
        transform: scale(0.5)
    &__answer
      display: flex
      flex-wrap: wrap
</style>