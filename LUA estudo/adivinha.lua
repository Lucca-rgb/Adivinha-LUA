local http = require('http')
local url = require('url')
math.randomseed(os.time())
local numero_secreto = math.random(1, 10) -- Número entre 1 e 10
local tentativas = 0

local function handler(req, res)
    local q = url.parse(req.url, true)
    if q.pathname == '/adivinhar' then
        local palpite = tonumber(q.query.palpite)
        tentativas = tentativas + 1
        local mensagem

        if palpite < numero_secreto then
            mensagem = "Muito baixo! Tente novamente."
        elseif palpite > numero_secreto then
            mensagem = "Muito alto! Tente novamente."
        else
            mensagem = "Parabéns! Você adivinhou o número em " .. tentativas .. " tentativas!"
            -- Reinicia o jogo
            numero_secreto = math.random(1, 10)
            tentativas = 0
        end

        res:setHeader('Content-Type', 'application/json')
        res:finish('{"mensagem":"' .. mensagem .. '"}')
    else
        res:setHeader('Content-Type', 'text/html')
        res:finish('<h1>404 Not Found</h1>')
    end
end

http.createServer(handler):listen('')
