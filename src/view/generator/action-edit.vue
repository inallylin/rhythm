<template>
  <button @click="edit"><icon-pen/></button>
  <modal ref="componentModal">
    <template #title>
      Change Note
    </template>
    <template #content>
      <note-selector v-model="note" />
    </template>
  </modal>
</template>
<script lang="coffee">
  import { ref, computed, watch } from 'vue'
  import modal from '@/components/modal.vue'
  import iconPen from '@/components/icon/pen.vue'
  import noteSelector from '@/components/note-selector.vue'
  export default
    props:
      modelValue:
        type: Number
        default: 0
    components:
      modal: modal
      'icon-pen': iconPen
      'note-selector': noteSelector
    emits: ['update:modelValue']
    setup: (props, {emit})->
      componentModal = ref null
      note = computed
        get: -> props.modelValue
        set: (value)->
          emit 'update:modelValue', value
      edit = ->
        componentModal.value?.open()
      watch note, ->
        componentModal.value?.close()
      return {
        componentModal
        edit
        note
      }
</script>