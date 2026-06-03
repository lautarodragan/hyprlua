local solaar = { dps = {} }

function solaar.change_host(host)
    hl.exec_cmd('solaar config "MX Master 4" change-host ' .. host)
end

function solaar.dps.change_host(host)
    return function()
        solaar.change_host(host)
    end
end

return solaar
