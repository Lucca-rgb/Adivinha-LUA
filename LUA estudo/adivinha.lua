local http = require('http')
local url = require('url')

math.randomseed(os.time())
local numero_secreto = math.random(1, 10) -- Número entre 1 e 10
local tentativas = 0

local function reiniciar_jogo()
    numero_secreto = math.random(1, 10)
    tentativas = 0
end

local function processar_palpite(palpite)
    tentativas = tentativas + 1
    if palpite < numero_secreto then
        return "Muito baixo! Tente novamente."
    elseif palpite > numero_secreto then
        return "Muito alto! Tente novamente."
    else
        local mensagem = "Parabéns! Você adivinhou o número em " .. tentativas .. " tentativas!"
        reiniciar_jogo()
        return mensagem
    end
end

local function obter_dica()
    return (numero_secreto % 2 == 0) and "O número secreto é par." or "O número secreto é ímpar."
end

local function handler(req, res)
    local q = url.parse(req.url, true)

    if q.pathname == '/adivinhar' then
        local palpite = tonumber(q.query.palpite)
        
        if not palpite then
            res:setHeader('Content-Type', 'application/json')
            res:finish('{"mensagem":"Por favor, forneça um número válido."}')
            return
        end

        local mensagem = processar_palpite(palpite)
        res:setHeader('Content-Type', 'application/json')
        res:finish('{"mensagem":"' .. mensagem .. '"}')

    elseif q.pathname == '/dica' then
        local mensagem = obter_dica()
        res:setHeader('Content-Type', 'application/json')
        res:finish('{"mensagem":"' .. mensagem .. '"}')

    elseif q.pathname == '/reiniciar' then
        reiniciar_jogo()
        res:setHeader('Content-Type', 'application/json')
        res:finish('{"mensagem":"O jogo foi reiniciado. Tente adivinhar o número!"}')

    else
        res:setHeader('Content-Type', 'text/html')
        res:finish('<h1>404 Not Found</h1>')
    end
end

http.createServer(handler):listen(8080, function()
    print("Servidor rodando na porta 8080")
end)
