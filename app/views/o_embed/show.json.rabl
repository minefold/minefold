object @obj
type = @obj.class.name.downcase

node(:type) {type}
extends 'o_embed/base'

glue(@obj) {
  extends "o_embed/_#{type}", photo: @obj
}
