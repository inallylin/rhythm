import { sleep } from '@/mixins/tools.coffee'
export default ->
  audioContext = null
  audioOscillator = null
  audioGain = null
  gc = null
  init = ->
    return if audioContext
    audioContext = new AudioContext()
    gc = setInterval ()->
      await audioContext?.close?()
      init()
    , 1000 * 60 * 10
  start = (_type = 'triangle', _frequency = 820, _options)->
    # options: { scale, debounce }
    clearTimeout gc
    await init() if !audioContext
    audioGain = audioContext.createGain()
    audioGain.connect(audioContext.destination)
    audioOscillator = audioContext.createOscillator()
    audioOscillator.type = _type
    audioOscillator.frequency.value = _frequency
    audioOscillator.connect(audioGain)
    audioOscillator.start(0)
    if _options?.debounce
      await sleep(_options.debounce * 1.5 * 100)
    soundLength = (_options?.scale || 1) * 1.5
    stop(soundLength)
  stop = (_debounce)->
    audioGain?.gain?.exponentialRampToValueAtTime(
      0.00001, audioContext.currentTime + _debounce
    )
  destroy = ->
    audioOscillator?.stop?(audioContext.currentTime)
  reset = ->
    new Promise (resolve)->
      clearInterval gc if gc
      try
        await audioContext?.close?()
        audioContext = null
      catch e
      init()
      await sleep(3 * 1000)
      resolve()
  return {
    init
    start
    stop
    destroy
    reset
  }