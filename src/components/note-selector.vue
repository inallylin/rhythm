<template>
  <div class="note-option__list">
    <div class="note-option" v-for="i in 16">
      <input :id="`note-option-${i}`" :type="inputType" :value="i-1" v-model="notes">
      <label :for="`note-option-${i}`">
        <note :index="1" :note="i - 1" :disabled="true" />
      </label>
    </div>
  </div>
</template>
<script lang="coffee">
  import { ref, computed, defineAsyncComponent } from 'vue'
  note = defineAsyncComponent () => import('@/components/note.vue')
  export default
    props:
      modelValue:
        type: [Number, Array]
        default: 0
      modelModifiers:
        default: ()-> {}
    components:
      note: note
    emits: ['update:modelValue']
    setup: (props, {emit})->
      isMulti = computed ->
        props.modelModifiers?.multi
      inputType = computed ->
        if isMulti.value then 'checkbox' else 'radio'
      notes = computed
        get: ->
          return props.modelValue if !isMulti.value
          if Array.isArray(props.modelValue) then props.modelValue else []
        set: (value)->
          emit 'update:modelValue', value
      return {
        notes
        inputType
      }
</script>
<style lang="sass" scoped>
  @import '@/assets/sass/mixins'
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