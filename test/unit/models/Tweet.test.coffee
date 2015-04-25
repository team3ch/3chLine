assert = require 'assert'

describe 'Tweet', () ->
  user1 = null
  tweet1 = null

  before (done)->
    User.create(
      userId: 'rin',
      username: 'tooyama'
    ).exec(() ->
      User.find().limit(1).then((data) ->
        user1 = data[0]
        Tweet.create(
          user: user1.id,
          content: 'kou chan!'
        ).exec () ->
          Tweet.find().limit(1).then (data) ->
            tweet1 = data[0]
          done()
      ).catch(done)
    )

  describe '#id', () ->
    it 'should be numeric', () ->
      assert(typeof user1.id == 'number')

    it 'should be intager', () ->
      assert.strictEqual(user1.id, parseInt(user1.id, 10))
