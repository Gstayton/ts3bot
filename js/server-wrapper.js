// Generated by CoffeeScript 1.7.1
(function() {
  var queue, wrapper;

  queue = require('./queues');

  wrapper = function(server) {
    var Command_Queue, wrap;
    Command_Queue = new queue.PriorityQueue();
    wrap = {
      Server_Flood_Commands: 10,
      Server_Flood_Time: 3,
      Recent_Commands: 0,
      Reset_Flood_Count: function() {
        return wrap.Recent_Commands = 0;
      },
      execute: function(err, str, priority, _callback) {
        var arg, args, command, _i, _len;
        args = [];
        for (_i = 0, _len = arguments.length; _i < _len; _i++) {
          arg = arguments[_i];
          args.push(arguments[_i]);
        }
        console.log(args);
        err = args.shift();
        if (args.length > 0) {
          str = args.shift();
        } else {
          str = null;
        }
        if (args.length > 0) {
          priority = args.shift();
        } else {
          priority = 5;
        }
        if (err) {
          return _callback(err);
        }
        console.log(str);
        console.log(priority);
        console.log(_callback);
        console.log({
          string: str,
          callback: _callback
        });
        if (str != null) {
          Command_Queue.push({
            string: str,
            callback: _callback
          }, priority);
        }
        if (wrap.Recent_Commands < wrap.Server_Flood_Commands) {
          command = Command_Queue.pop();
          server.execute(command.string, command.callback);
          return wrap.Recent_Commands++;
        } else {
          console.log("Timeout");
          return setTimeout(wrap.execute(), 1000);
        }
      },
      parseStr: function(str) {
        return str.split(' ').join('\\s');
      },
      sendMsg: function(msg) {
        msg = wrap.parseStr(msg);
        return wrap.execute(null, "sendtextmessage targetmode=2 msg=" + msg);
      },
      sendPm: function(msg, tgt) {
        msg = wrap.parseStr(msg);
        return wrap.execute(null, "sendtextmessage targetmode=3 target=" + tgt + " msg=" + msg);
      },
      subscribeToNotify: function(event, id) {
        if (id != null) {
          id = "id=" + id;
        } else {
          id = "";
        }
        return wrap.execute(null, "servernotifyregister event=" + event + " " + id);
      },
      moveToChannel: function(clid, cid, cpw) {
        if (cpw != null) {
          cpw = "cpw=" + cpw;
        } else {
          cpw = "";
        }
        return wrap.execute(null, "clientmove clid=" + clid + " cid=" + cid + " " + cpw);
      },
      getClients: function() {
        var response;
        response = {};
        wrap.execute(null, "clientlist", function(ret) {
          return response = ret;
        });
        return response;
      },
      whoAmI: function() {
        var response;
        response = {};
        wrap.execute(null, "whoami", function(ret) {
          return response = ret;
        });
        return response;
      },
      getCurrentChannel: function() {
        return wrap.whoAmI().client_channel_id;
      },
      getCurrentCid: function() {
        return wrap.whoAmI().client_id;
      },
      getClientName: function() {
        return wrap.getClients();
      }
    };
    setInterval(wrap.Reset_Flood_Count, wrap.Server_Flood_Time * 1000);
    return wrap;
  };

  module.exports = wrapper;

}).call(this);
