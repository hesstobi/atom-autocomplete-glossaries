module.exports =
  commandPrefixes:
    type: 'array'
    item: type: 'string'
    default: ['gls']
    order: 1
    description: '
      An array of prefixes for which completions are activated
    '
