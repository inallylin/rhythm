decimalToBinary = (x)->
  bin = 0
  i = 1
  while (x != 0)
    rem = x % 2
    x = parseInt(x / 2)
    bin = bin + rem * i
    i = i * 10
  String(bin).padStart 4, 0
ramdon = (max = 0.5, min)->
  return Math.random() < max if !min
  Math.floor(Math.random() * max) + min
ramdonRest = (_beat)->
  _r = ramdon(0.9)
  return _beat if _beat || _r
  -1
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
    return ramdonRest(_beatNumber) if _useRest && _restId != null
    _beatNumber

decodeFullnote = (code, i)->
  [_note, _rest] = String(code).match(/.{1,2}/g)
  _note = parseInt Number(_note)
  _rest = parseInt Number(_rest) if _rest
  [_note, _rest]
export {
  createBeats
  getRests
  ramdon
  decodeFullnote
}