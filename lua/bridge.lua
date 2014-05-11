local prototype= require 'prototype'

local bridge= prototype {
    default= prototype.no_copy,
}

function bridge.to_vimrepl(jc)
end

function bridge.is_list(tbl)
    local nkeys= 0
    for _, _ in pairs(tbl) do
        nkeys= nkeys + 1
    end

    return #tbl == nkeys
end

return bridge
