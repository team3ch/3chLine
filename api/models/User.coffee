bcrypt = require 'bcrypt'

module.exports =
  attributes:
    id:
      type: 'integer'
      autoIncrement: true
      primaryKey: true

    userId:
      type: 'alphanumericdashed'
      unique: true
      size: 20
      maxLength: 20
      required: true

    password:
      type: 'string'
      required: true

    username:
      type: 'string'
      size: 128
      maxLength: 128
      required: true

    tweets:
      collection: 'tweet'
      via: 'user'

    toJSON: ()->
      ret = this.toObject()
      delete ret.password
      ret

  beforeCreate: (user, cb)->
    cb('password should be 20 chars or less') if user.password.length > 20
    bcrypt.genSalt 11, (err, salt)->
      bcrypt.hash user.password, salt, (err, hash)->
        if err
          console.log err
          cb err
        else
          user.password = hash
          cb()
