<template>
  <div class="navpage" :style="style">
    <div :class="['navpage__nav', {open: nav}]">
      <button class="navpage__nav__toggle" @click="nav = !nav">Settings</button>
      <div class="preference">
        <div class="color-picker">
          <input id="color-picker" type="color" v-model="theme">
          <label for="color-picker" :style="style"></label>
        </div>
        <div class="input">
          <label for="measure">Measure</label>
          <input id="measure" type="Number" min="1" max="100" onfocus="this.select()" v-model="bar">
        </div>
        <div class="checkbox">
          <input id="toggle-rest" type="checkbox" v-model="useRest">
          <label for="toggle-rest">Rest</label>
        </div>
        <div class="checkbox">
          <input id="toggle-code" type="checkbox" v-model="showCode">
          <label for="toggle-code">Code</label>
        </div>
        <div class="checkbox">
          <input id="toggle-arrow" type="checkbox" v-model="showArrow">
          <label for="toggle-arrow">Arrow</label>
        </div>
      </div>
    </div>
    <div class="navpage__page">
      <div class="control">
        <button @click="createRamdon()">Random</button>
        <button class="btn-add" @click="add"></button>
      </div>
      <TransitionGroup tag="div" class="bar" name="list" mode="out-in">
        <note
          :ref="getNoteInstance"
          :useRest="useRest"
          :showCode="showCode"
          :showArrow="showArrow"
          :index="i"
          :key="i"
          @remove="remove(i)"
          v-model:note="notes[i]"
          v-model:restAt="rests[i]"
          v-for="note, i in notes" />
      </TransitionGroup>
    </div>

  </div>
</template>
<script lang="coffee">
import { useRouter } from 'vue-router'
import { computed, watch, onMounted, ref } from 'vue'
import note from '@/components/note.vue'
export default
  components:
    note: note
  setup: ->
    router = useRouter()
    theme = ref '#1c5580'
    noteInstance = ref []
    showArrow = ref true
    showCode = ref true
    useRest = ref true
    nav = ref false
    notes = ref []
    rests = ref []
    style = computed -> "color: #{theme.value}"
    url = computed
      get: ->
        codes = notes.value.map (note, i)->
          encode note, rests.value[i]
        codes.join()
      set: (value)->
        codes = value.split(',')
        codes.forEach (code, i)-> decode code, i
    bar = computed
      get: -> notes.value.length
      set: (value)->
        _diff = Number(value) - notes.value.length
        for i in [0...Math.abs(_diff)]
          if _diff > 0 then add() else notes.value.splice -1, 1
    createRamdon = ->
      for n in noteInstance.value
        n.createNote()
    add = ->
      notes.value.push 0
    getNoteInstance = (instance)->
      noteInstance.value.push instance
    getUrlCode =->
      search = location.search.replace '?', ''
      params = {}
      search.split("&").forEach (param)->
        [key, value] = param.split "="
        params[key] = value
      url.value = params.code if params.code
    watch url, (n)->
      router.replace
        name: router.currentRoute.value.name
        query:
          code: n
    decode = (code, i)->
      [_note, _rest] = String(code).match(/.{1,2}/g)
      rests.value[i] = null
      notes.value[i] = parseInt Number(_note)
      rests.value[i] = parseInt Number(_rest) if _rest
    encode = (note, rest)->
      noteCode = String(note).padStart(2, 0)
      restCode = String(rest).padStart(2, 0)
      restCode = '' if !rest
      "#{noteCode}#{restCode}"
    remove = (i)->
      notes.value.splice i, 1
      rests.value.splice i, 1
    getUrlCode()
    bar.value = 4 if !bar.value
    return {
      noteInstance
      style
      theme
      bar
      createRamdon
      useRest
      showCode
      showArrow
      getNoteInstance
      add
      notes
      rests
      getUrlCode
      remove
      nav
    }
</script>
<style lang="sass">
  @import '@/assets/sass/strumming.sass'
</style>