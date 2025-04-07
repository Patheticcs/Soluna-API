if not getgenv()._soluna_api_loaded then
    getgenv()._soluna_api_loaded = true
    loadstring(game:HttpGet("https://raw.githubusercontent.com/Patheticcs/Soluna-API/refs/heads/main/src/api/main.lua", true))()
end
