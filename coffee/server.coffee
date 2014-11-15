ts = require('ts3sq')
wrapper = require('./server-wrapper')

main = {
	start: (config, _callback)->
		client = new ts.ServerQuery(config.host, config.sqPort)

		wrapper = wrapper(client)

		client.on 'ready', ()->
			wrapper.execute null, "login #{config.loginName} #{config.loginPwd}"
			wrapper.execute null, "use port=#{config.sid}", (ret) ->
				console.log ret
				console.log 'connected'
			wrapper.execute null, "clientupdate client_nickname=#{wrapper.parseStr(config.displayName)}", (ret)->
				console.log ret
			wrapper.execute null, "whoami", (ret)->
				console.log("Test")
				ids = {}
				ids.client_id = ret.response[0].client_id
				wrapper.execute null, 'channelfind pattern=Test', (ret) ->
					console.log ret
					ids.channelID = ret.response[0].cid
					wrapper.execute null, "clientmove clid=#{ ids.client_id } cid=#{ ids.channelID }", (ret) ->
						console.log(ret)

			if _callback?
				_callback()

			return client
}

module.exports = main
