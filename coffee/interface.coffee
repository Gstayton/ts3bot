server = require('./server')
wrapper = require('./server-wrapper')
util = require('util')

server = server.start({
	host: "192.168.1.62",
	sid: "9987",
	displayName: "Omnius",
	loginName: "kosan",
	loginPwd: "Zb7yiJfd",
	sqPort: 10011
}, ()->
	console.log("Starting")
	wrapper = wrapper(server)

	wrapper.subscribeToNotify("channel", 0)
	wrapper.subscribeToNotify("textchannel")

	server.on "notify", (notification) ->
		console.log(notification)
		if notification.type == "notifytextmessage"
			if notification.body[0].invokername == "Omnius"
				return
			if notification.body[0].msg == "!test"
				wrapper.sendMsg(notification.body[0].invokername)

		if notification.type == "notifyclientmoved"
			console.log(wrapper.whoAmI())
			if notification.body[0].cid == wrapper.getCurrentCid()
				console.log(wrapper.getClients())

			console.log("move")

		console.log notification
)
