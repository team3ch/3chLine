assert = require 'assert'

fail = (err) ->
  assert.fail(err)

describe 'User', ()->
  user1 = null
  user1NoPop = null
  user1Pop = null
  tw = null

  before (done)->
    User.create(
      userId: 'zoi',
      password: 'pass',
      username: 'aoba'
    ).then((u)->
      assert u.userId == 'zoi'
      user1 = u
    , fail).finally(done)

  describe '#id', () ->
    it 'should be numeric', ()->
      assert(typeof user1.id == 'number')

    it 'should be intager', ()->
      assert.strictEqual(user1.id, parseInt(user1.id, 10))

  describe '#userId', () ->
    it 'is required', (done) ->
      User.create({
        password: 'pass',
        username: 'missing userId'
      }).then(fail, (e) ->
        assert /required/.test(e.errors.userId)
      ).finally(done)

    it 'should be 20 chars or less', (done)->
      User.create(
        userId: '12345678901234567890',
        password: 'pass',
        username: '20 chars'
      ).then(() ->
        assert(true)
      , fail).finally(done)

    it 'should not be 21 chars or more', (done) ->
      User.create(
        userId: '123456789012345678901',
        password: 'pass',
        username: '21 chars'
      ).then(fail, (e)->
        assert /maxLength/.test(e.errors.userId)
      ).finally done

    it 'should be string', () ->
      assert(typeof user1.username == 'string')

    describe 'should be alphanumericdashed', () ->
      it 'should accept number-only userId', (done) ->
        User.create(
          userId: '0123456798',
          password: 'pass',
          username: 'only number'
        ).catch(fail).finally(done)

      it 'should accept alphabet-only userId', (done)->
        User.create(
          {
            userId: 'abcdefghij',
            password: 'pass',
            username: 'only alphabet'
          }, {
            userId: 'klmnopqrstuvwxyz',
            password: 'pass',
            username: 'only alphabet2'
          }
        ).catch(fail).finally(done)

      it 'should accept dash-only userId', (done)->
        User.create(
          userId: '-_',
          password: 'pass',
          username:"hyphen and underscore"
        ).catch(fail).finally(done)

      it 'should not accept comma', (done)->
        User.create(
          userId: ',',
          password: 'pass',
          username: 'comma'
        ).then(fail, ()->
          assert(true)
        ).finally(done)

    it 'should be unique', (done)->
      User.create(
        userId: 'zoi',
        password: 'pass',
        username: 'aoba-2nd'
      ).then(fail, (e)->
        assert /already exists/.test(e.errors.userId)
      ).finally(done)

  describe '#password', ()->
    it 'should be required', (done) ->
      User.create(
        userId: 'pass_missing'
        username: 'nopassword'
      ).then(assert.fail, (err)->
        assert(/required/.test(err.errors.password))
      ).finally(done)
    it 'should be crypted', () ->
      assert.notStrictEqual(user1.password, 'pass')
    it 'should be 20 chars or less', (done) ->
      pass = '12345678901234567890'
      assert.strictEqual(pass.length, 20)
      User.create(
        userId: 'pass20'
        password: pass
        username: 'pass20'
      ).then(assert, fail).finally(done)
    it 'should not be 21 chars or more', (done)->
      pass = '123456789012345678901'
      assert.strictEqual(pass.length, 21)
      User.create(
        userId: 'pass21'
        password: pass
        username: 'pass21'
      ).then(fail, (err)->
        assert /20 chars or less/.test(err)
      ).finally(done)
    it 'should not be in JSON', ()->
      json = user1.toJSON()
      assert.equal(/password/.test(json), false)

  describe '#username', ()->
    it 'is required', (done)->
      User.create(
        userId: 'username_missing',
        password: 'pass',
      ).then(fail, (e) ->
        assert /required/.test(e.errors.username)
      ).finally(done)

    it 'should be string', () ->
      assert.strictEqual typeof user1.username, 'string'

    it 'should be 128 chars or less', (done)->
      name128 = '12345678901234567890123456789012345678901234567890' +
                '12345678901234567890123456789012345678901234567890' +
                '1234567890123456789012345678'
      assert.equal name128.length, 128
      User.create(
        userId: '128',
        password: 'pass',
        username: name128
      ).then(()->
        assert true
      , fail).finally(done)

    it 'should not be 129 chars or more', (done) ->
      name129 = '12345678901234567890123456789012345678901234567890' +
                '12345678901234567890123456789012345678901234567890' +
                '12345678901234567890123456789'
      assert.equal name129.length, 129
      User.create(
        userId: '129',
        password: 'pass',
        username: name129
      ).then(fail, (e)->
        assert /maxLength/.test(e.errors.username)
      ).finally(done)

  describe '#tweets', () ->

    before (done) ->
      Tweet.create(
        user: user1.id,
        content: 'kumatta'
      ).then(() ->
        User.findOne(user1.id)
      ).then((data) ->
        user1NoPop = data
        User.findOne(user1.id).populate('tweets')
      ).then((data) ->
        user1Pop = data
        tw = user1Pop.tweets[0]
      ).catch(fail).finally(done)

    it 'should be an empty Array without population', () ->
      assert.strictEqual(user1NoPop.tweets.length, 0)

    it 'should be a Array with population', () ->
      assert.strictEqual(user1Pop.tweets.length, 1)

    describe 'should be a Array of Tweets', ()->
      it 'elm has user', ()->
        assert.strictEqual tw.user, user1Pop.id
