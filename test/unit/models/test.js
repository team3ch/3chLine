var assert = require('assert');

describe.only('User', function() {
  describe('#id', function() {
    it('should be numeric', function(done) {
      User.find().limit(1).then(function(data) {
        user = data[0]
        assert.equal(user.id, parseInt(user.id, 10))
        done();
      }).catch(done)
    });
  })
})
