validator = (_key, _value)->
  if _key == 'measure'
    _value = if isNaN(_value) then 0 else Number(_value)
  else
    _value = false if typeof _value != 'boolean'
  _value
export default
  state:
    preference:
      measure: 0
  mutations:
    'preference.set': (state, _settings) ->
      for k, v of _settings
        state.preference[k] = v
  actions:
    'acl.branch.clear': (context) ->
      context.commit 'acl.branch.clear'
    'preference.set': (context, _settings) ->
      for k, v of _settings
        _settings[k] = validator(k, v)
      context.commit 'preference.set', _settings
  getters:
    preference: (state) -> state.preference