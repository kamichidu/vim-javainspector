local prototype= require 'prototype'

local bridge= prototype {
    default= prototype.no_copy,
}

function bridge.from_nil(value)
    return 'nil'
end

function bridge.from_string(value)
    return "'" .. value .. "'"
end

function bridge.from_number(value)
    return value
end

function bridge.from_boolean(value)
    if value then
        return 1
    else
        return 0
    end
end

function bridge.from_table(value)
    if bridge.is_list(value) then
        return bridge.from_list(value)
    else
        return bridge.from_dict(value)
    end
end

function bridge.from_dict(value)
    local s= '{'
    for k, v in pairs(value) do
        s= s .. bridge.to_vimrepl(k) .. ':' .. bridge.to_vimrepl(v) .. ','
    end
    return s .. '}'
end

function bridge.from_list(value)
    local s= '['
    for _, e in ipairs(value) do
        s= s .. bridge.to_vimrepl(e) .. ','
    end
    return s .. ']'
end

function bridge.to_vimrepl(value)
    if type(value) == 'nil'     then return bridge.from_nil(value)     end
    if type(value) == 'string'  then return bridge.from_string(value)  end
    if type(value) == 'number'  then return bridge.from_number(value)  end
    if type(value) == 'boolean' then return bridge.from_boolean(value) end
    if type(value) == 'table'   then return bridge.from_table(value)   end

    error('cannot convert a ' .. type(value) .. ' value')
end

function bridge.from_jclass(jc)
    if not jc then
        return '{}'
    end

    local flat= {}

    flat.package_name=   jc:package_name()
    flat.canonical_name= jc:canonical_name()
    flat.simple_name=    jc:simple_name()

    return bridge.to_vimrepl(flat)
end

function bridge.is_list(tbl)
    local nkeys= 0
    for _, _ in pairs(tbl) do
        nkeys= nkeys + 1
    end

    return #tbl == nkeys
end

return bridge
