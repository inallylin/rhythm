<template>
  <teleport to=".modal-wrapper" v-if="isOpen">
    <div class="modal">
      <div class="modal__head" v-if="$slots.title">
        <slot name="title"></slot>
        <div class="modal__head__actions">
          <slot name="actions:header"></slot>
        </div>
        <button class="modal__dismiss" @click="answer(false)"><icon-xmark /></button>
      </div>
      <div class="modal__body" v-if="$slots.content">
        <slot name="content"></slot>
      </div>
      <div class="modal__foot">
        <div class="modal__foot__actions" v-if="$slots['actions:foot:left']">
          <slot name="actions:foot:left" :answer="answer"></slot>
        </div>
        <div class="modal__foot__actions" v-if="$slots['actions:foot:right']">
          <slot name="actions:foot:right" :answer="answer"></slot>
        </div>
      </div>
      <div class="modal__bgclose" @click="answer(false)"></div>
    </div>
  </teleport>
</template>
<script lang="coffee">
  import { reactive, computed } from 'vue'
  import iconXmark from '@/components/icon/xmark.vue'
  export default
    components:
      'icon-xmark': iconXmark
    setup: ->
      state = reactive
        promise: null
        resolve: null
      isOpen = computed ->
        !!state.promise
      open = ->
        state.promise = new Promise (resolve)->
          state.resolve = resolve
      answer = (_ans)->
        state.resolve? _ans
        state.promise = null
      close = ->
        answer false
      return {
        open
        close
        answer
        isOpen
      }
</script>