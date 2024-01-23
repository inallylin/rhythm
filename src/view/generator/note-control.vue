<template>
  <note :class="{disabled: disabled}"
    v-model:note="note"
    v-model:restAt="restAt"
    v-bind="$attrs"
    >
    <template #control>
      <div class="control" v-if="!disabled">
        <button class="btn-carousel" @click="changeNote(-1)"></button>
        <button @click="createNote($event)">
          <icon-random />
        </button>
        <action-edit v-model="note" />
        <button class="btn-delete" @click="remove()">
          <icon-trash-can />
        </button>
        <button class="btn-carousel" @click="changeNote(1)"></button>
      </div>
    </template>
  </note>
</template>
<script lang="coffee">
  import { ref, computed, watch } from 'vue'
  import { useStore } from 'vuex'
  import iconRandom from '@/components/icon/random.vue'
  import iconTrashCan from '@/components/icon/trashcan.vue'
  import { getRests, random, randomNote } from '@/mixins/beat.coffee'
  import actionEdit from '@/view/generator/action-edit.vue'
  import cnote from '@/components/note.vue'
  export default
    props:
      note:
        type: Number
        default: null
      restAt:
        type: Number
        default: null
      disabled:
        type: Boolean
        default: false
      index:
        type: Number
        default: 1
    emits: ['update:note', 'update:restAt', 'remove']
    components:
      note: cnote
      'icon-random': iconRandom
      'icon-trash-can': iconTrashCan
      'action-edit': actionEdit
    setup: (props, {emit})->
      store = useStore()
      config = computed -> store.getters.preference
      useRest = computed -> config.value?.rest
      use16Beat = computed -> config.value?.type
      note = computed
        get: -> props.note
        set: (value)-> emit 'update:note', value
      restAt = computed
        get: -> props.restAt
        set: (value)-> emit 'update:restAt', value
      createNote = (e)->
        e.target.blur() if e
        restAt.value = null
        _allowTie = props.index != 0
        _note = randomNote(use16Beat.value, _allowTie)
        note.value = _note
        if !_note && props.useRest && random(0.03)
          restAt.value = 8
      remove = -> emit 'remove'
      changeNote = (_diff)->
        _note = note.value + _diff
        _note = 15 if _note < 0
        _note = 0 if _note > 15
        note.value = _note
      watch use16Beat, -> createNote()
      watch useRest, -> createNote()
      createNote() if !note.value && note.value != 0
      return {
        note
        createNote
        remove
        restAt
        changeNote
      }
</script>