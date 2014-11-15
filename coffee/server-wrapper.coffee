queue = require('./queues')


wrapper = (server)->
	Command_Queue = new queue.PriorityQueue()

	wrap = {
		Server_Flood_Commands: 10
		Server_Flood_Time: 3
		Recent_Commands: 0
		Reset_Flood_Count: ()->
			wrap.Recent_Commands = 0
		execute: (err, str, priority, _callback) ->
			args = []
			for arg in arguments
				args.push(arguments[_i])

			console.log(args)

			err = args.shift()

			if args.length > 0
				str = args.shift()
			else str = null
			if args.length > 0
				priority = args.shift()
			else priority = 5

			if err
				return _callback(err)

			console.log str
			console.log priority
			console.log _callback
			console.log {string: str, callback: _callback}

			if str?
				Command_Queue.push({string: str, callback: _callback}, priority)
			if(wrap.Recent_Commands < wrap.Server_Flood_Commands)
				command = Command_Queue.pop()
				server.execute(command.string, command.callback)
				wrap.Recent_Commands++
			else
				console.log("Timeout")
				setTimeout(wrap.execute(), 1000)
		parseStr: (str) ->
			str.split(' ').join('\\s')
		sendMsg: (msg) ->
			msg = wrap.parseStr(msg)
			wrap.execute null, "sendtextmessage targetmode=2 msg=#{msg}"
		sendPm: (msg, tgt) ->
			msg = wrap.parseStr(msg)
			wrap.execute null, "sendtextmessage targetmode=3 target=#{tgt} msg=#{msg}"
		subscribeToNotify: (event, id) ->
			if id?
				id = "id=#{id}"
			else
				id = ""
			wrap.execute null, "servernotifyregister event=#{event} #{id}",
		moveToChannel: (clid, cid, cpw) ->
			if cpw?
				cpw = "cpw=#{cpw}"
			else
				cpw = ""
			wrap.execute null, "clientmove clid=#{clid} cid=#{cid} #{cpw}"
		getClients: () ->
			response = {}
			wrap.execute null, "clientlist", (ret) ->
				response = ret
			return response
		whoAmI: () ->
			response = {}
			wrap.execute null, "whoami", (ret) ->
				response = ret
			return response
		getCurrentChannel: ->
			wrap.whoAmI().client_channel_id
		getCurrentCid: ->
			wrap.whoAmI().client_id
		getClientName: ->
			wrap.getClients()
	}

	setInterval(wrap.Reset_Flood_Count, wrap.Server_Flood_Time * 1000)

	return wrap
module.exports = wrapper
