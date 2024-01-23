decimalToBinary = (x)->
  bin = 0
  i = 1
  while (x != 0)
    rem = x % 2
    x = parseInt(x / 2)
    bin = bin + rem * i
    i = i * 10
  String(bin).padStart 4, 0
random = (max = 0.5, min)->
  return Math.random() < max if !min
  Math.floor(Math.random() * max) + min
randomRest = (_beat)->
  _r = random(0.9)
  return _beat if _beat || _r
  -1
getNoteOptions = (_use16Beat = true, _allowTie = true)->
  [0..15].filter (_number)->
    _isEven = _number % 2 != 0
    _is8Beat = _number < 8 && (_number % 4) < 2
    (_allowTie || _isEven) &&  (_is8Beat || _use16Beat)
randomNote = (_use16Beat = true, _allowTie = true)->
  getNoteOptions(_use16Beat, _allowTie)
  .sort ()->
    Math.random() - 0.5
  .pop()
getRests = (_restId)->
  _restAt = decimalToBinary Number(_restId)
  String(_restAt).split('').map (r)-> Number r
createBeats = (_noteId, _restId, _useRest)->
  _beats = decimalToBinary(_noteId)
  _restArray = if _useRest && _restId then getRests(_restId) else []
  _beatsArray = String(_beats).split ''
  _beatsArray.map (_beat, i) ->
    _beatNumber = Number(_beat)
    return -1 if !_beatNumber && _restArray[i]
    return randomRest(_beatNumber) if _useRest && _restId == null
    _beatNumber

decodeFullnote = (code, i)->
  [_note, _rest] = String(code).match(/.{1,2}/g)
  _note = parseInt Number(_note)
  _rest = parseInt Number(_rest) if _rest
  [_note, _rest]
export {
  createBeats
  getRests
  randomNote
  random
  decodeFullnote
  getNoteOptions
}