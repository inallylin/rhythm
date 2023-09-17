<template>
  <teleport to=".modal-wrapper" v-if="isOpen">
    <div class="modal">
      <div class="modal__head">head</div>
      <div class="modal__body">Lorem ipsum dolor, sit amet consectetur adipisicing elit. Et doloribus ab, excepturi, harum similique numquam fuga provident soluta consequuntur cumque quia pariatur at adipisci suscipit culpa ipsum ratione? Quidem, velit.</div>
      <div class="modal__foot">
        {{isOpen}}
        <button @click="answer(false)">Cancel</button>
        <button @click="answer(true)">OK</button>
      </div>
    </div>
  </teleport>
</template>
<script lang="coffee">
  import { reactive, computed } from 'vue'
  export default
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
        state.resolve _ans
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