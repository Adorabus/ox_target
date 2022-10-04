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
            if entry.job == Job and (entry.grade or 1) == JobGrade then
                return true
            end
        end
    elseif filter.job then
        return Job == filter.job and JobGrade >= (filter.grade or 1)
    elseif filter.company then
        return GroupRank(filter.company) >= (filter.grade or 1)
    end
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