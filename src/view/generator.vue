<template>
  <div class="navpage">
    <div class="navpage__page">
      <TransitionGroup tag="div" class="bar" name="list" mode="out-in">
        <note
          :ref="getNoteInstance"
          :index="i"
          :key="i"
          @remove="remove(i)"
          v-model:note="notes[i]"
          v-model:restAt="rests[i]"
          v-for="note, i in notes" />
      </TransitionGroup>
    </div>
    <div class="navpage__nav">
      <teleport to=".preference-append" v-if="inited">
        <div class="input">
          <label for="measure">
            Measure
            <input id="measure" type="Number" min="1" max="100" onfocus="this.select()"
              v-model="measure">
          </label>
        </div>
      </teleport>
      <div class="control">
        <player
          :notes="notes"
          :rests="rests"
          :useRest="config.rest"
          >
          <template #="{play, isPlaying}">
            <button @click="play()" :disabled="isPlaying">
              <icon-play />
            </button>
          </template>
        </player>
        <button @click="createRandom()">
          <icon-random />
        </button>
        <button class="btn-add" @click="add">
          <icon-plus />
        </button>
      </div>
    </div>
  </div>
</template>
<script lang="coffee">
import { computed, watch, onMounted, ref, reactive, nextTick } from 'vue'
import { useStore } from 'vuex'
import { useRoute, useRouter } from 'vue-router'
import note from '@/view/generator/note-control.vue'
import { storage } from '@/mixins/tools.coffee'
import iconRandom from '@/components/icon/random.vue'
import iconPlus from '@/components/icon/plus.vue'
import iconPlay from '@/components/icon/play.vue'
import player from '@/components/player.vue'
export default
  components:
    note: note
    player: player
    'icon-random': iconRandom
    'icon-plus': iconPlus
    'icon-play': iconPlay
  setup: ->
    store = useStore()
    router = useRouter()
    route = useRoute()
    config = computed -> store.getters.preference
    noteInstance = ref []
    notes = ref []
    rests = ref []
    inited = ref false
    componentPlayer = ref null
    style = computed -> "color: #{config.theme}; fill: #{config.theme}; "
    url = computed
      get: ->
        codes = notes.value.map (note, i)->
          encode note, rests.value[i]
        codes.join()
      set: (value)->
        codes = value.split(',')
        codes.forEach (code, i)-> decode code, i
    measure = computed
      get: -> notes.value?.length
      set: (value)->
        syncConfig 'measure', value
        _diff = Number(value) - notes.value.length
        for i in [0...Math.abs(_diff)]
          if _diff > 0 then add() else notes.value.splice -1, 1
    createRandom = ->
      for n in noteInstance.value
        n?.createNote()
    add = ->
      notes.value.push null
    getNoteInstance = (instance)->
      noteInstance.value.push instance
    getUrlCode =->
      return if !route.query?.code
      url.value = route.query?.code
      # syncRest
      _codes = route.query?.code?.split ','
      if _codes.some (c)-> c.length == 4
        syncConfig 'rest', true
    watch measure, (n)->
      noteInstance.value.length = 0
    watch url, (n)->
      router.replace
        name: route.name
        query:
          code: n
    decode = (code, i)->
      return if isNaN(code)
      [_note, _rest] = String(code).match(/.{1,2}/g)
      _note = parseInt Number(_note)
      _rest = parseInt Number(_rest || 0)
      rests.value[i] = null
      if _note == 0 && _rest != 8
        _rest = 0
      notes.value[i] = _note
      rests.value[i] = _rest
    encode = (note, rest)->
      noteCode = String(note).padStart(2, 0)
      restCode = String(rest).padStart(2, 0)
      restCode = '' if !rest
      "#{noteCode}#{restCode}"
    syncConfig = (_key, _value)->
      _config = {}
      _config[_key] = _value
      store.dispatch 'preference.set', _config
    remove = (i)->
      notes.value.splice i, 1
      rests.value.splice i, 1
    getUrlCode()
    measure.value = 4 if !measure.value
    onMounted ->
      await nextTick()
      inited.value = true
    return {
      noteInstance
      createRandom
      config
      getNoteInstance
      add
      notes
      rests
      remove
      measure
      inited
      componentPlayer
    }
</script>