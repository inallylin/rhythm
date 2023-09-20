<template>
  <div class="section">
    <div class="section__head">
      Choose Rhythm to Use
    </div>
    <div class="section__body note-option__list">
      <div class="note-option" v-for="i in 16">
        <input :id="`note-option-${i}`" type="checkbox" :value="i-1" v-model="options">
        <label :for="`note-option-${i}`">
          <note :index="1" :note="i - 1" :disabled="true" />
        </label>
      </div>
    </div>
    <div class="section__foot">
      <button @click="apply" :disabled="isDisabled">Go !</button>
      <button class="btn-outline" @click="applyAll">Go with All</button>
      <button class="btn-outline" @click="applyRandom">Go with Random 4</button>
      <p class="text-info" v-if="isDisabled">
        Atleast choose 2 rhythm, 1 without tie
      </p>
    </div>
  </div>
</template>
<script lang="coffee">
  import { ref, computed } from 'vue'
  import note from '@/components/note.vue'
  export default
    props:
      modelValue:
        type: Array
        default: []
    components:
      note: note
    emits: ['update:modelValue']
    setup: (props, {emit})->
      options = ref []
      isDisabled = computed ->
        return true if options.value.length <= 1
        options.value?.every (o)-> o%2 == 0
      applyRandom = ->
        _options = [1..15].sort ()-> Math.random() - 0.5
        emit 'update:modelValue', _options.splice 0, 4
      applyAll = ->
        emit 'update:modelValue', [1..15]
      apply = ->
        emit 'update:modelValue', options.value
      return {
        options
        apply
        applyAll
        applyRandom
        isDisabled
      }
</script>
<style lang="sass" scoped>
  @import '@/assets/sass/mixins'
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