validator = (_key, _value)->
  switch _key
    when 'measure'
      if isNaN(_value) then 0 else Number(_value)
    when 'code'
      false if typeof _value != 'boolean'
    when 'arrow'
      false if typeof _value != 'boolean'
    when 'rest'
      false if typeof _value != 'boolean'
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