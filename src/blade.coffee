fayeURL = "http://localhost:#{window.location.port}/faye"
client = new Faye.Client fayeURL
channel = "/tests"

subscribe = (callback) ->
  client.subscribe(channel, callback)

publish = (event, data = {}) ->
  data.browser = window.navigator.userAgent
  data.event = event
  client.publish(channel, data)


testNumber = null

QUnit.begin (details) ->
  testNumber = 1
  publish("begin", total: details.totalTests)

QUnit.testDone (details) ->
  result = details.failed is 0
  name = "#{details.module}: #{details.name}"
  number = testNumber++
  publish("result", {result, name, number})

QUnit.done (details) ->
  publish("end", details)


subscribe ({command} = {}) ->
  switch command
    when "start"
      window.location.reload()