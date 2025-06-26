import { sleep } from '@/mixins/tools.coffee'
import mixinSound from '@/mixins/sound.coffee'
sound = mixinSound()
export default
  state:
    player: null
    track:
      id: null
      value: null
      pointer: 0
      isPlaying:false
  mutations:
    'player.pointer.next': (state) ->
      state.track.pointer += 1
    'player.init': (state) ->
      sound.init()
    'play.stop': (state, _timeout = 0) ->
      clearInterval state.player
      state.track.pointer = 0
      await sleep _timeout
      state.track.isPlaying = false
    'play.start': (state, _interval)->
      state.player = _interval
      state.track.isPlaying = true
    'track.init': (state, _track)->
      # this _track.value can be a ref, dont deconstruct it
      state.track.id = _track.id
      state.track.value = _track.value
  actions:
    'player.init': (context) ->
      context.commit 'player.init'
    'player.start': (context, _track) ->
      await context.dispatch 'player.end'
      context.commit 'track.init', _track
      _g = context.getters
      _interval = setInterval ()->
        _currentNote = _g.track.value[_g.track.pointer]
        if _g.track.pointer >= _g.track.value?.length
          return context.commit 'play.stop', _g.speed
        console.log '_g.speed', _g.speed
        if _currentNote == 1
          isNoteLead = _g.track.pointer % 4 == 0
          params = if _track.shuffle then {
            scale: if isNoteLead then 4/3 else 1
            delay: if isNoteLead then 0 else 1/3
          } else undefined
          sound.start(_g.preference.wave, _g.preference.hz, params)
        else if _currentNote == -1
          sound.stop(0)
        context.commit 'player.pointer.next'
      , _g.speed
      context.commit 'play.start', _interval
    'player.end': (context) ->
      new Promise (resolve)->
        context.commit 'play.stop'
        await sleep context.getters.speed
        resolve()
    'player.reset': (context) ->
      context.dispatch 'loading.start', 'player.reset'
      await sound.reset()
      context.dispatch 'loading.end', 'player.reset'
  getters:
    trackPointer: (state)-> state.track.pointer
    track: (state)-> state.track