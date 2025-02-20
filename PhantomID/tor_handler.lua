local ffi = require("ffi")
local socket = require("socket")

local TorHandler = {}

function TorHandler.start_tor()
    os.execute("service tor start")
    os.execute("iptables -t nat -A OUTPUT -p tcp --syn -j REDIRECT --to-ports 9040")
end

function TorHandler.stop_tor()
    os.execute("service tor stop")
    os.execute("iptables -t nat -D OUTPUT -p tcp --syn -j REDIRECT --to-ports 9040")
end

function TorHandler.check_tor()
    local sock = socket.connect("check.torproject.org", 80)
    if sock then
        sock:send("GET / HTTP/1.1\r\nHost: check.torproject.org\r\n\r\n")
        local response = sock:receive("*a")
        sock:close()
        return string.find(response, "Congratulations") ~= nil
    end
    return false
end

return TorHandler
