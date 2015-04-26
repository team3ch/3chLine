/**
* User.js
*
* @description :: a user who has an unique userid and username to display.
* @docs        :: http://sailsjs.org/#!documentation/models
*/

module.exports = {

  attributes: {
    id: {
      type: 'integer',
      autoIncrement: true,
      primaryKey: true
    },

    userId: {
      type: 'alphanumericdashed',
      unique: true,
      size: 20,
      maxLength: 20,
      required: true
    },

    username: {
      type: 'string',
      size: 128,
      maxLength: 128,
      required: true
    },

    tweets: {
      collection: 'tweet',
      via: 'user'
    }
  }
};
