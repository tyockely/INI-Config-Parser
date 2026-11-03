local INIParser = {}

function INIParser.parse(input_string)
    local config = {}
    local current_section = "global"
    config[current_section] = {}

    for line in input_string:gmatch("[^\r\n]+") do
        -- Trim whitespace and strip comments (; or #)
        line = line:gsub("%s*([;#].*)$", ""):match("^%s*(.-)%s*$")

        if line ~= "" then
            -- Section header: [SectionName]
            local section = line:match("^%[(%w+)%]$")
            if section then
                current_section = section
                config[current_section] = config[current_section] or {}
            else
                -- Key=Value pair
                local key, value = line:match("^([%w_%.]+)%s*=%s*(.-)$")
                if key and value then
                    -- Type casting (booleans and numbers)
                    if value:lower() == "true" then
                        value = true
                    elseif value:lower() == "false" then
                        value = false
                    elseif tonumber(value) then
                        value = tonumber(value)
                    end

                    config[current_section][key] = value
                end
            end
        end
    end

    return config
end

-- Example Demonstration
local sample_ini = [[
# Server Configuration
host = 127.0.0.1
port = 8080
debug = true

[database]
user = root
max_connections = 50
]]

local parsed = INIParser.parse(sample_ini)

print("Parsed Config Output:")
print("Host:", parsed.global.host)
print("Port:", parsed.global.port)
print("Debug Mode:", parsed.global.debug)
print("DB Connections:", parsed.database.max_connections)

return INIParser
