if GetResourceState('thrillerp') == 'missing' then return end

local inv = exports['trp-inventory']

local Job = 0
local JobGrade = 0
local jobSecond = {}

RegisterNetEvent("Thrille:JobUpdated")
AddEventHandler("Thrille:JobUpdated", function(job, grade)
    Job = job
    JobGrade = grade
end)

RegisterNetEvent("Thrille:JobUpdatedSecond")
AddEventHandler("Thrille:JobUpdatedSecond", function(data)
  jobSecond = data
end)

function GroupName(groupid)
    local name = "Error Retrieving Name"
    local mypasses = jobSecond
    for i=1, #mypasses do
        if mypasses[i]["jobid"] == groupid then
            name = mypasses[i]["business_name"]
        end
    end
    return name
end

function GroupRank(groupid)
    local rank = 0
    local mypasses = jobSecond
    for i=1, #mypasses do
        if mypasses[i]["jobid"] == groupid then
            rank = mypasses[i]["grade"]
        end
    end
    return rank
end

function PlayerHasGroups(filter)
    if filter.jobs then
        for k, entry in pairs(filter.jobs) do
            entry.grade = entry.grade or 1
            if entry.id == Job and JobGrade >= entry.grade then
                return true
            end
        end
    elseif filter.companies then
        for k, entry in pairs(filter.companies) do
            entry.grade = entry.grade or 1
            if GroupRank(entry.id) >= entry.grade then
                return true
            end
        end
    end

    return false
end

function PlayerHasItems(filter)
    local _type = type(filter)

    if _type == 'string' then
        return inv:HasItem(filter)
    elseif _type == 'table' then
        return inv:HasItems(filter)
    end

    return true
end