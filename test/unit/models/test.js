describe.only('User', function() {
  describe('#find()', function() {
    it('hoge equals hoge', function(done) {
      'hoge'.should.equal('hoge');
      done();
    })
    /**
    User.find().then(function(data) {
      (data.length).should.equal(1)
    }).catch(done)
    */
  })
})
