<template>
  <div class="section">
    <div class="section__head">
      Choose Rhythm to Use
    </div>
    <div class="section__body note-option__list">
      <note-selector v-model.multi="options" ref="componentSelector" />
    </div>
    <div class="section__foot">
      <button class="btn-outline" @click="applyAll">All</button>
      <button class="btn-outline" @click="applyRandom" v-if="allOptions.length > 4">Random 4</button>
      <button @click="apply" :disabled="isDisabled">Go !</button>
      <p class="text-info" v-if="isDisabled">
        Atleast choose 2 rhythm, 1 without tie
      </p>
    </div>
  </div>
</template>
<script lang="coffee">
  import { ref, computed } from 'vue'
  import note from '@/components/note.vue'
  import noteSelector from '@/components/note-selector.vue'
  export default
    props:
      modelValue:
        type: Array
        default: []
    components:
      note: note
      'note-selector': noteSelector
    emits: ['update:modelValue']
    setup: (props, {emit})->
      options = ref []
      componentSelector = ref null
      allOptions = computed ->
        return [] if !componentSelector.value
        [...componentSelector.value?.options]
      isDisabled = computed ->
        return true if options.value.length <= 1
        options.value?.every (o)-> o%2 == 0
      applyRandom = ->
        _withoutTie = Math.floor(Math.random() * 8) * 2 - 1
        _withoutTie = 1 if _withoutTie < 0
        _options = [1..15].filter (o)->
          o != _withoutTie
        .sort ()-> Math.random() - 0.5
        emit 'update:modelValue', [_withoutTie, ..._options.splice(0, 3)]
      applyAll = ->
        emit 'update:modelValue', allOptions.value
      apply = ->
        emit 'update:modelValue', options.value
      return {
        componentSelector
        allOptions
        options
        apply
        applyAll
        applyRandom
        isDisabled
      }
</script>
<style lang="sass" scoped>
  @import '@/assets/sass/mixins'
  .section
    +max-screen(768)
      margin-top: 6px
  .note-option
    flex: 0 0 auto
    width: 150px
    color: var(--theme-color)
    > input
      position: fixed
      pointer-events: none
      opacity: 0
      width: 0
      height: 0
      &:not(:checked)
        + label
          opacity: .5
          color: color(gray)
          transition: .2s
          &:hover
            opacity: 1
    > label
      cursor: pointer
      > .beat
        pointer-events: none
        padding: 0
        padding-bottom: 1em
    &__list
      display: flex
      flex-wrap: wrap
      justify-content: center
      align-items: center
      max-width: 700px
      margin: 0 auto
</style>