<template>
  <button @click="edit"><icon-pen/></button>
  <modal ref="componentModal">
    <template #title>
      Change Note
    </template>
    <template #content>
      <input type="number" v-model="note">
      <!-- <note-selector v-model="note" /> -->
    </template>
    <template #actions:foot:right="{answer}">
      <button @click="answer(note)">Save</button>
    </template>
  </modal>
</template>
<script lang="coffee">
  import { ref, computed } from 'vue'
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
      console.log 987
      componentModal = ref null
      note = ref props.modelValue
      edit = ->
        note.value = props.modelValue
        _changedNote = await componentModal.value?.open()
        return if !_changedNote
        emit 'update:modelValue', _changedNote
      return {
        componentModal
        edit
        note
      }
</script>