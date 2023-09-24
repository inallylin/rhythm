validator = (_key, _value)->
  _defaultBoolean = (_value)->
    return false if typeof _value != 'boolean'
    _value
  switch _key
    when 'measure'
      if isNaN(_value) then 0 else Number(_value)
    when 'code'
      _defaultBoolean(_value)
    when 'arrow'
      _defaultBoolean(_value)
    when 'rest'
      _defaultBoolean(_value)
    else
      _value
export default
  state:
    preference:
      measure: 0
      speed: 250
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
    speed: (state) -> state.preference.speed