var assert = require('assert');

describe.only('User', function() {
  describe('#find()', function() {
    it('user should have his/her id', function(done) {
      User.find().limit(1).then(function(data) {
        user = data[0]
        assert.equal(user.id, parseInt(user.id, 10))
        done();
      }).catch(done)
    })
  })
})
