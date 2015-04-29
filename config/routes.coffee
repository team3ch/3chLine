module.exports.routes =
  '/':
    view: 'homepage'

  'get /login':
    controller: 'auth'
    action: 'login'

  'post /login':
    controller: 'auth'
    action: 'process'

  '/logout':
    controller: 'auth'
    action: 'logout'
