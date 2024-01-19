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
  import { createBeats, getRests, ramdon } from '@/mixins/beat.coffee'
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
      note = computed
        get: -> props.note
        set: (value)-> emit 'update:note', value
      restAt = computed
        get: -> props.restAt
        set: (value)-> emit 'update:restAt', value
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
      changeNote = (_diff)->
        _note = note.value + _diff
        _note = 15 if _note < 0
        _note = 0 if _note > 15
        note.value = _note
      watch useRest, (n)->
        if n
          restAt.value = getRests(props.restAt)
        else
          restAt.value = null
      createNote() if !note.value && note.value != 0
      return {
        note
        createNote
        remove
        restAt
        changeNote
      }
</script>