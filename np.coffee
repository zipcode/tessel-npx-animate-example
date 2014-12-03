console.log "very start"

tessel = require "tessel"
accel = require('accel-mma84').use(tessel.port['A']);
hw = process.binding "hw"
Neopixels = require "neopixels"
_ = require "lodash"
pixel_count = 60
buff_length = pixel_count * 3

np = new Neopixels
buffer = new Buffer(32 for x in [0..buff_length])
backing = new Buffer(0 for x in [0..buff_length])

process.on "neopixel_animation_complete", ->
  console.log "*"

animate = ->
  #return if !ready
  status = hw.neopixel_animation_buffer buff_length, buffer
  return if status == 3
  throw new Error "SCT is already in use by "+['Inactive','PWM','Read Pulse','Neopixels'][status] if status

interval = setInterval animate, 60

pixels = (data, index) ->
  Math.max 0, Math.min 255, Math.floor data[index] * 255

accel.on "ready", -> accel.on "data", (data) ->
  r = pixels(data, 0)
  g = pixels(data, 1)
  b = pixels(data, 2)
  console.log "#{r} #{g} #{b}"
  backing[i*3] = r for i in [0..pixel_count]
  backing[i*3+1] = g for i in [0..pixel_count]
  backing[i*3+2] = b for i in [0..pixel_count]
  tmp = buffer
  buffer = backing
  backing = tmp
  console.log "#{data[0].toFixed 2} #{data[1].toFixed 2}, #{data[2].toFixed 2}"

console.log "Ready"
