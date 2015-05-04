module.exports =
  attributes:
    id:
      type: 'integer'
      autoIncrement: true

    user:
      model: 'user'
      required: true

    content:
      type: 'text'
      required: true
      maxLength: 1024
      size: 1024
