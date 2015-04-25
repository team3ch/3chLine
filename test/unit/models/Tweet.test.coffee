assert = require 'assert'

describe 'Tweet', () ->
  user1 = null
  tweet1 = null

  before (done)->
    User.create(
      userId: 'rin',
      username: 'tooyama'
    ).exec (err, u) ->
      assert.fail() if err
      user1 = u
      Tweet.create(
        user: user1.id,
        content: 'kou chan!'
      ).exec (err, t) ->
        assert.fail() if err
        tweet1 = t
        done()

  describe '#id', () ->
    it 'should be numeric', () ->
      assert(typeof user1.id == 'number')

    it 'should be intager', () ->
      assert.strictEqual(user1.id, parseInt(user1.id, 10))
