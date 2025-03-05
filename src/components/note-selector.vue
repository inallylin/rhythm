<template>
  <div class="note-option__list">
    <!-- {{notes}} -->
    <div class="note-option" v-for="i in options">
      <input :id="`note-option-${i}`" :type="inputType" :value="i" v-model="notes">
      <label :for="`note-option-${i}`">
        <note :index="1" :note="i" :disabled="true" />
      </label>
    </div>
  </div>
</template>
<script lang="coffee">
  import { ref, computed, defineAsyncComponent } from 'vue'
  import { useStore } from 'vuex'
  note = defineAsyncComponent () => import('@/components/note.vue')
  import { getNoteOptions } from '@/mixins/beat.coffee'
  export default
    props:
      modelValue:
        type: [Number, Array]
        default: 0
      restAt:
        type: Number
        default: null
      modelModifiers:
        default: ()-> {}
      use16Beat:
        type: Boolean
        default: true
    components:
      note: note
    emits: ['update:modelValue']
    setup: (props, {emit})->
      store = useStore()
      config = computed -> store.getters.preference
      use16Beat = computed -> props.use16Beat
      isMulti = computed ->
        props.modelModifiers?.multi
      inputType = computed ->
        if isMulti.value then 'checkbox' else 'radio'
      options = computed ->
        getNoteOptions(use16Beat.value)
      notes = computed
        get: ->
          return null if props.restAt
          return props.modelValue if !isMulti.value
          if Array.isArray(props.modelValue) then props.modelValue else []
        set: (value)->
          emit 'update:modelValue', value
          emit 'update:restAt', 0
      return {
        notes
        inputType
        options
      }
</script>
<style lang="sass" scoped>
  @import '@/assets/sass/mixins'
  @keyframes out
    0%
      border-color: rgba(yellow, .1)
    100%
      border-color: inherit
  @keyframes in
    0%
      border-color: rgba(yellow, .1)
    100%
      border-color: inherit
  .note-option
    flex: 0 0 auto
    width: 30vw
    max-width: 150px
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
          .beat
            animation: .5s out forwards 1
          &:hover
            opacity: 1
    > label
      cursor: pointer
      > .beat
        pointer-events: none
        padding: 0
        padding-bottom: 1em
        animation: .5s in forwards 1
    &__list
      display: flex
      flex-wrap: wrap
      justify-content: center
      align-items: center
      max-width: 700px
      margin: space(xl) auto
</style>