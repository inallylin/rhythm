<template>
  <button @click="edit">
    <slot><icon-pen/></slot>
  </button>
  <modal ref="componentModal">
    <template #title>
      Change Note
    </template>
    <template #content>
      <note-selector :use16Beat="use16Beats" v-model="note" v-model:restAt="restAt" />
    </template>
  </modal>
</template>
<script lang="coffee">
  import { ref, computed, watch } from 'vue'
  import { useStore } from 'vuex'
  import modal from '@/components/modal.vue'
  import iconPen from '@/components/icon/pen.vue'
  import noteSelector from '@/components/note-selector.vue'
  export default
    props:
      modelValue:
        type: Number
        default: 0
      restAt:
        type: Number
        default: null
    components:
      modal: modal
      'icon-pen': iconPen
      'note-selector': noteSelector
    emits: ['update:modelValue']
    setup: (props, {emit})->
      store = useStore()
      componentModal = ref null
      config = computed -> store.getters.preference
      use16Beats = computed -> !config.value?.type
      note = computed
        get: -> props.modelValue
        set: (value)->
          emit 'update:modelValue', value
      restAt = computed
        get: -> props.restAt
        set: (value)->
          emit 'update:restAt', value
      edit = ->
        componentModal.value?.open()
      watch [note, restAt], ->
        componentModal.value?.close()
      return {
        componentModal
        edit
        note
        restAt
        use16Beats
      }
</script>