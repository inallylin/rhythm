<template>
  <div :class="['beat', {disabled: disabled}]">
    <slot name="control"></slot>
    <template v-if="note || !useRest">
      <div :class="['note__wrapper', {quarter: isQuarter, tie: hasTie}]">
        <span :class="['note', seqClass(j)]" v-for="n, j in beats">
          <template v-if="n > 0">v</template>
        </span>
      </div>
      <div v-if="showCode" class="number__wrapper">
        <span :class="['number', {rest: n == -1}]"
          v-for="n, j in beats.slice().reverse()">
          <template v-if="n > 0">{{feint(j+1, n)}}</template>
        </span>
      </div>
      <div v-if="showArrow"
        :class="['arrow__wrapper', {quarter: isQuarter, tie: hasTie}]">
        <span :class="['arrow', seqClass(j)]" v-for="n, j in beats">
          <template v-if="n != 0">{{n}}</template>
        </span>
      </div>
      <!-- <p>NOTE:{{note}}</p>
      <p>beats: {{beats.reverse()}}</p>
      <p>restAt: {{restAt}}</p> -->
    </template>
    <template v-else>
      <div class="note__wrapper fullrest">
        <div class="note rest"></div>
      </div>
      <div class="number__wrapper fullrest" v-if="showCode">
        <div class="number" v-for="i in 4"></div>
      </div>
      <div class="arrow__wrapper fullrest" v-if="showArrow">
        <div class="arrow rest"></div>
      </div>
    </template>
  </div>
</template>
<script lang="coffee">
  import { ref, computed, watch } from 'vue'
  import { useStore } from 'vuex'
  import iconRandom from '@/components/icon/random.vue'
  import iconTrashCan from '@/components/icon/trashcan.vue'
  import { createBeats, getRests, ramdon } from '@/mixins/beat.coffee'
  import actionEdit from '@/view/generator/action-edit.vue'
  export default
    props:
      note:
        type: Number
        default: null
      restAt:
        type: Number
        default: null
      index:
        type: Number
        default: 0
      disabled:
        type: Boolean
        default: false
    emits: ['update:note', 'update:restAt', 'remove']
    components:
      'icon-random': iconRandom
      'icon-trash-can': iconTrashCan
      'action-edit': actionEdit
    setup: (props, {emit})->
      store = useStore()
      config = computed -> store.getters.preference
      useRest = computed -> config.value?.rest
      showCode = computed -> config.value?.code
      showArrow = computed -> config.value?.arrow
      note = computed
        get: -> props.note
        set: (value)-> emit 'update:note', value
      feint = (n, act)->
        return if act == -1
        return '-' if !act
        n
      restAt = computed
        get: ->
          return [] if !props.restAt
          getRests(props.restAt)
        set: (value)->
          emit 'update:restAt', value
      beats = computed ->
        createBeats(props.note, props.restAt, useRest.value)
      hasTie = computed ->
        note?.value % 2 == 0 && beats.value[3] != -1
      isQuarter = computed ->
       note.value == 1 && beats.value.indexOf(-1) == -1
      seqClass = (index)->
        _className = []
        _className.push 'rest' if beats.value[index] == -1
        _className.push 'afterEmpty' if beats.value[index+1] == 0
        _className.push 'afterRest' if afterRest(index, -1)
        _className
      afterRest = (index)->
        next = beats.value[index+1]
        next = beats.value[index+2] if !next
        next = beats.value[index+3] if !next
        return true if next && next == -1
      watch beats, (n)->
        _restAt = n.map (b)-> if b == -1 then 1 else 0
        restAt.value = parseInt(_restAt.join(''), 2)
      return {
        note
        beats
        feint
        hasTie
        isQuarter
        seqClass
        useRest
        showCode
        showArrow
      }
</script>