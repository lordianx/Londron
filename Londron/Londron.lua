SCRIPT_VERSION = '1.6.9'
TARGET_BUILD = '3351'
TARGET_VERSION = '1.69'
log.info("version " .. SCRIPT_VERSION)

require('includes.data.globals')
require('includes.utils.functions')
require('includes.utils.samurais_utils')

CURRENT_BUILD = Game.GetBuildNumber()
CURRENT_VERSION = Game.GetOnlineVersion()

if not NETWORK.NETWORK_IS_SESSION_ACTIVE() then
    gui.show_error("Warning" , " This script only works in the Online Mode!")
end


local Menu = gui.add_tab("Londron " .. TARGET_VERSION)

gui.show_success("Londron " .. TARGET_VERSION, " has successfully loaded!")

Menu:add_imgui(function()
    ImGui.SeparatorText("About")
    UI.wrappedText(
        "Londron Inc The Company",
        25)
    ImGui.Dummy(1, 10)
    ImGui.SeparatorText("Script Contents")
    ImGui.BulletText("Self")
    ImGui.BulletText("Recovery")
    ImGui.BulletText("Unlocks")
    ImGui.BulletText("Vehicle")
    ImGui.Dummy(1, 10)
    ImGui.SeparatorText("Game information")
    ImGui.BulletText("Script Version:   v" .. SCRIPT_VERSION)
    ImGui.BulletText("Game Version:   b" .. TARGET_BUILD .. "   Online " .. TARGET_VERSION)
    ImGui.Dummy(1, 10)
end)
------------------------------------

phoneAnim = false

local Self = Menu:add_tab("Self     ")
Self:add_imgui(function()

    ImGui.SeparatorText("Self Menu")

    phoneAnim, _ = ImGui.Checkbox("Use Phone Animations", phoneAnim, true)
    helpmarker(false, "Use the Story Mode phone animations in Online")
    if ImGui.Button("Allow Gender Change") then
        stats.set_int(MPX() .. "ALLOW_GENDER_CHANGE", 52)
        gui.show_success("You can now change your gender!", "Go to M -> Appearance -> Change appearance!")
    end
    helpmarker(false, "Change the gender of your character by pressing this button and then going to the Interaction Menu -> Appearance -> Change appearance")


    ImGui.SeparatorText("Self Menu Information")
    ImGui.BulletText("Upgrade your character's skills")
    ImGui.BulletText("Enable / Disable Fast Run")
    ImGui.BulletText("Set your level")
    ImGui.BulletText("Set your crew level")
    ImGui.BulletText("Edit your Stats")
end)

local Skills = Self:add_tab("Skills Menu")

function updateStats()
    staminaValue = stats.get_int(MPX() .. "SCRIPT_INCREASE_STAM")
    strengthValue = stats.get_int(MPX() .. "SCRIPT_INCREASE_STRn")
    shootingValue = stats.get_int(MPX() .. "SCRIPT_INCREASE_SHO")
    stealthValue = stats.get_int(MPX() .. "SCRIPT_INCREASE_STL")
    flyingValue = stats.get_int(MPX() .. "SCRIPT_INCREASE_DRIV")
    drivingValue = stats.get_int(MPX() .. "SCRIPT_INCREASE_DRIV")
    lungCValue = stats.get_int(MPX() .. "SCRIPT_INCREASE_LUNG")
    mentalValue = stats.get_int(MPX() .. "PLAYER_MENTAL_STATE")
end

updateStats()


Skills:add_imgui(function()
        local fastRunStatus = stats.get_int(MPX() .. "CHAR_ABILITY_1_UNLCK")
        local statusText = (fastRunStatus == -1 and "On") or (fastRunStatus == 0 and "Off") or "unknown"

        ImGui.SeparatorText("Fast Run")
        ImGui.BulletText("Fast Run Status: " .. statusText)
        if ImGui.Button("Enable fast run") then
            for i = 1, 3 do
                stats.set_int(MPX() .. "CHAR_FM_ABILITY_" .. i .. "_UNLCK", -1)
                stats.set_int(MPX() .. "CHAR_ABILITY_" .. i .. "_UNLCK", -1)
            end
            gui.show_success("Enabled Fast Run & Reload", "Switch session to apply!")
        end
        ImGui.SameLine()

        if ImGui.Button("Disable fast run") then
            for i = 1, 3 do
                stats.set_int(MPX() .. "CHAR_FM_ABILITY_" .. i .. "_UNLCK", 0)
                stats.set_int(MPX() .. "CHAR_ABILITY_" .. i .. "_UNLCK", 0)
            end
            gui.show_success("Disabled Fast Run & Reload", "Switch session to apply!")

        end
        helpmarker(false, "Fast Run mode makes your character run & reload 0.25x faster.")
        
        ImGui.SeparatorText("Skills")
        if ImGui.Button("Max Character Skills") then
            stats.set_int(MPX() .. "SCRIPT_INCREASE_DRIV", 100)
            stats.set_int(MPX() .. "SCRIPT_INCREASE_FLY", 100)
            stats.set_int(MPX() .. "SCRIPT_INCREASE_LUNG", 100)
            stats.set_int(MPX() .. "SCRIPT_INCREASE_SHO", 100)
            stats.set_int(MPX() .. "SCRIPT_INCREASE_STAM", 100)
            stats.set_int(MPX() .. "SCRIPT_INCREASE_STL", 100)
            stats.set_int(MPX() .. "SCRIPT_INCREASE_STRN", 100)
            updateStats()
            gui.show_success("Upgraded Skills!")

        end
        ImGui.SameLine()

        if ImGui.Button("Min Character Skills") then
            stats.set_int(MPX() .. "SCRIPT_INCREASE_DRIV", 0)
            stats.set_int(MPX() .. "SCRIPT_INCREASE_FLY", 0)
            stats.set_int(MPX() .. "SCRIPT_INCREASE_LUNG", 0)
            stats.set_int(MPX() .. "SCRIPT_INCREASE_SHO", 0)
            stats.set_int(MPX() .. "SCRIPT_INCREASE_STAM", 0)
            stats.set_int(MPX() .. "SCRIPT_INCREASE_STL", 0)
            stats.set_int(MPX() .. "SCRIPT_INCREASE_STRN", 0)
            updateStats()

            gui.show_success("Downgraded Skills!")

        end

        ImGui.SeparatorText("Set Custom Skills")
        staminaValue, _ = ImGui.SliderInt("Stamina", staminaValue, 0, 100)

        strengthValue, _ = ImGui.SliderInt("Strength", strengthValue, 0, 100)

        shootingValue, _ = ImGui.SliderInt("Shooting", shootingValue, 0, 100)

        stealthValue, _ = ImGui.SliderInt("Stealth", stealthValue, 0, 100)

        flyingValue, _ = ImGui.SliderInt("Flying", flyingValue, 0, 100)

        drivingValue, _ = ImGui.SliderInt("Driving", drivingValue, 0, 100)

        lungCValue, _ = ImGui.SliderInt("Lung Capacity", lungCValue, 0, 100)
        mentalValue, _ = ImGui.SliderInt("Mental State", mentalValue, 0, 100)

        if ImGui.Button("Apply Custom Values") then
            stats.set_int(MPX() .. "SCRIPT_INCREASE_STAM", staminaValue)
            stats.set_int(MPX() .. "SCRIPT_INCREASE_STRN", strengthValue)
            stats.set_int(MPX() .. "SCRIPT_INCREASE_SHO", shootingValue)
            stats.set_int(MPX() .. "SCRIPT_INCREASE_STL", stealthValue)
            stats.set_int(MPX() .. "SCRIPT_INCREASE_FLY", flyingValue)
            stats.set_int(MPX() .. "SCRIPT_INCREASE_DRIV", drivingValue)
            stats.set_int(MPX() .. "SCRIPT_INCREASE_LUNG", lungCValue)
            stats.set_float(MPX() .. "PLAYER_MENTAL_STATE", mentalValue)

            gui.show_success("Applied custom skills!", "Success!")
        end
end)


-- character stats


sex_acts = stats.get_int(MPX() .. "PROSTITUTES_FREQUENTED")
lapdances = stats.get_int(MPX() .. "LAP_DANCED_BOUGHT")
kills = stats.get_int("MPPLY_KILLS_PLAYERS")
deaths = stats.get_int("MPPLY_DEATHS_PLAYER")
kd = (kills/(deaths == 0 and 1 or deaths))


-- distance stats


distance = {{
    name = "Distance Travelled",
    hash = "MPPLY_CHAR_DIST_TRAVELLED"
}, {
    name = "Distance Swiming",
    hash = MPX() .. "DIST_SWIMMING",
}, {
    name = "Distance Walking",
    hash = MPX() .."DIST_WALKING",
}, {
    name = "Distance Running",
    hash = MPX() .."DIST_RUNNING",
}, {
    name = "Distance traveled in cars",
    hash = MPX() .."DIST_CAR",
}, {
    name = "Distance traveled on motorcycles",
    hash = MPX() .."DIST_BIKE",
}, {
    name = "Distance traveled in helicopters",
    hash = MPX() .."DIST_HELI",
}, {
    name = "Distance traveled in planes",
    hash = MPX() .."DIST_PLANE",
}, {
    name = "Distance traveled in boats",
    hash = MPX() .."DIST_BOAT",
}, {
    name = "Distance traveled on ATVs",
    hash = MPX() .."DIST_QUADBIKE",
}, {
    name = "Distance traveled on bicycles",
    hash = MPX() .."DIST_BICYCLE",
}, {
    name = "Farthest stoppie",
    hash = MPX() .."LONGEST_STOPPIE_DIST",
}, {
    name = "Farthest wheelie",
    hash = MPX() .."LONGEST_WHEELIE_DIST",
}, {
    name = "Farthest driven without crashing",
    hash = MPX() .."LONGEST_DRIVE_NOCRASH",
}, {
    name = "Farthest vehicle jump",
    hash = MPX() .."FARTHEST_JUMP_DIST",
}, {
    name = "Highest vehicle jump",
    hash = MPX() .."HIGHEST_JUMP_REACHED",
}, {
    name = "Highest Hydraulic Jump",
    hash = MPX() .."LOW_HYDRAULIC_JUMP",
}, {
    name = "Farthest on Two-Wheels",
    hash = MPX() .."LONGEST_2WHEEL_DIST",
}
}


--time stats


time = {
{
    name = "Time in First Person",
    hash = "MP_FIRST_PERSON_CAM_TIME",
    type = "int",
}, {
    name = "Time in GTA Online",
    hash = "MP_PLAYING_TIME",
    type = "int",
}, {
    name = "Time in DeathMatches",
    hash = "MPPLY_TOTAL_TIME_SPENT_DEATHMAT",
    type = "int",
}, {
    name = "Time in Races",
    hash = "MPPLY_TOTAL_TIME_SPENT_RACES",
    type = "int",
}, {
    name = "Time in Creator Mode",
    hash = "MPPLY_TOTAL_TIME_MISSION_CREATO",
    type = "int",
}, {
    name = "Longest Session",
    hash = MPX() .. "LONGEST_PLAYING_TIME",
    type = "int",
}, {
    name = "Time with this character",
    hash = MPX() .. "TOTAL_PLAYING_TIME",
    type = "int",
}, {
    name = "Average Time in Session",
    hash = MPX() .. "AVERAGE_TIME_PER_SESSON",
    type = "int",
}, {
    name = "Time Swiming",
    hash = MPX() .. "TIME_SWIMMING",
    type = "int",
}, {
    name = "Time Under the water",
    hash = MPX() .. "TIME_UNDERWATER",
    type = "int",
}, {
    name = "Time Walking",
    hash = MPX() .. "TIME_WALKING",
    type = "int",
}, {
    name = "Time in Coverage",
    hash = MPX() .. "TIME_IN_COVER",
    type = "int",
}, {
    name = "Longest wanted duration",
    hash = MPX() .. "LONGEST_CHASE_TIME",
    type = "float",
}, {
    name = "Time in 5 Stars",
    hash = MPX() .. "TOTAL_TIME_MAX_STARS",
    type = "float",
}, {
    name = "Time driving cars",
    hash = MPX() .. "TIME_DRIVING_CAR",
    type = "int",
}, {
    name = "Time riding motorcycles",
    hash = MPX() .. "TIME_DRIVING_BIKE",
    type = "int",
}, {
    name = "Time flying helicopters",
    hash = MPX() .. "TIME_DRIVING_HELI",
    type = "int",
}, {
    name = "Time flying planes",
    hash = MPX() .. "TIME_DRIVING_PLANE",
    type = "int",
}, {
    name = "Time sailing boats",
    hash = MPX() .. "TIME_DRIVING_BOAT",
    type = "int",
}, {
    name = "Time riding ATVs",
    hash = MPX() .. "TIME_DRIVING_QUADBIKE",
    type = "int",
}, {
    name = "Time riding bicycles",
    hash = MPX() .. "TIME_DRIVING_BICYCLE",
    type = "int",
}, {
    name = "Time Stopping",
    hash = MPX() .. "LONGEST_STOPPIE_TIME",
    type = "int",
}, {
    name = "Time Wheelieing",
    hash = MPX() .. "LONGEST_WHEELIE_TIME",
    type = "int",
}, {
    name = "Time Total Wheelieing",
    hash = MPX() .. "TOTAL_WHEELIE_TIME",
    type = "int",
}, {
    name = "Time Driving Two-Wheels",
    hash = MPX() .. "LONGEST_2WHEEL_TIME",
    type = "int",
}}


--cash stats


cash = {
{
    name = "Overall income",
    hash = "MPPLY_TOTAL_EVC",
    type = "int",
}, {
    name = "Overall expenses",
    hash = "MPPLY_TOTAL_SVC",
    type = "int",
}, {
    name = "Spent on weapons & armor",
    hash = MPX() .. "MONEY_SPENT_WEAPON_ARMOR",
    type = "int",
}, {
    name = "Spent on vehicles & maintenance",
    hash = MPX() .. "MONEY_SPENT_VEH_MAINTENANCE",
    type = "int",
}, {
    name = "Spent on style & entertainment",
    hash = MPX() .. "MONEY_SPENT_STYLE_ENT",
    type = "int",
}, {
    name = "Spent on property & utilities",
    hash = MPX() .. "MONEY_SPENT_PROPERTY_UTIL",
    type = "int",
}, {
    name = "Spent on Job & Activity entry fees",
    hash = MPX() .. "MONEY_SPENT_JOB_ACTIVITY",
    type = "int",
}, {
    name = "Spent on contact services",
    hash = MPX() .. "MONEY_SPENT_CONTACT_SERVICE",
    type = "int",
}, {
    name = "Spent on healthcare",
    hash = MPX() .. "MONEY_SPENT_HEALTHCARE",
    type = "int",
}, {
    name = "Dropped or stolen",
    hash = MPX() .. "MONEY_SPENT_DROPPED_STOLEN",
    type = "int",
}, {
    name = "Given to others",
    hash = MPX() .. "MONEY_SPENT_SHARED",
    type = "int",
}, {
    name = "Job cash shared with others",
    hash = MPX() .. "MONEY_SPENT_JOBSHARED",
    type = "int",
}, {
    name = "Earned from Jobs",
    hash = MPX() .. "MONEY_EARN_JOBS",
    type = "int",
}, {
    name = "Earned from selling vehicles",
    hash = MPX() .. "MONEY_EARN_SELLING_VEH",
    type = "int",
}, {
    name = "Spent on betting",
    hash = MPX() .. "MONEY_SPENT_BETTING",
    type = "int",
}, {
    name = "Earned from betting",
    hash = MPX() .. "MONEY_EARN_BETTING",
    type = "int",
}, {
    name = "Earned from Good Sport reward",
    hash = MPX() .. "MONEY_EARN_GOOD_SPORT",
    type = "int",
}, {
    name = "Picked up",
    hash = MPX() .. "MONEY_EARN_PICKED_UP",
    type = "int",
}, {
    name = "Received from others",
    hash = MPX() .. "MONEY_EARN_SHARED",
    type = "int",
}, {
    name = "Job cash shared by others",
    hash = MPX() .. "MONEY_EARN_JOBSHARED",
    type = "int",
}, {
    name = "Spent on vehichles",
    hash = MPX() .. "MONEY_SPENT_ON_VEHICLES",
    type = "int",
}, {
    name = "Spent on weapons",
    hash = MPX() .. "MONEY_SPENT_ON_WEAPONS",
    type = "int",
}, {
    name = "Spent on clothes",
    hash = MPX() .. "MONEY_SPENT_ON_CLOTHES",
    type = "int",
}, {
    name = "Earned from daily objective",
    hash = MPX() .. "MONEY_EARN_DAILY_OBJECTIVE",
    type = "int",
}, {
    name = "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx",
    hash = MPX() .. "MONEY_EARN_DAILY_OBJECTIVE",
    type = "int",
}, {
    name = "Spent on MC",
    hash = MPX() .. "MONEY_SPENT_BIKER_BUSINESS",
    type = "int",
}, {
    name = "Earned from MC",
    hash = MPX() .. "MONEY_EARN_BIKER_BUSINESS",
    type = "int",
}, {
    name = "Spent Boss",
    hash = MPX() .. "MONEY_SPENT_BOSS_GOON",
    type = "int",
}, {
    name = "Earned Boss",
    hash = MPX() .. "MONEY_EARN_BOSS_GOON",
    type = "int",
}}


--stats functions


time_multiplier = 60 * 60 * 1000

for i, distanceStat in ipairs(distance) do
    distance[i].value = stats.get_float(distanceStat.hash)
end


for i, cashStat in ipairs(cash) do
    if cashStat.type == "float" then
        cash[i].value = stats.get_float(cashStat.hash)
    else
        cash[i].value = stats.get_int(cashStat.hash)
    end
end


for i, timeStat in ipairs(time) do
    if timeStat.type == "float" then
        time[i].value = stats.get_float(timeStat.hash) / time_multiplier
    else
        time[i].value = stats.get_int(timeStat.hash) / time_multiplier
    end
end


local Stats = Self:add_tab("Stat Editor")
Stats:add_imgui(function()

    ImGui.BeginTabBar("Stat Editor")
    if ImGui.BeginTabItem("Character Stats") then
        ImGui.SeparatorText("Bad Sport")
        local fastRunStatus = stats.get_bool("MPPLY_CHAR_IS_BADSPORT")
        local statusText = (fastRunStatus == true and "On") or (fastRunStatus == false and "Off") or "unknown"
        ImGui.BulletText("Bad Sport Status: " .. statusText)
        if ImGui.Button("Add to BadSport") then
            stats.set_int("MPPLY_BADSPORT_MESSAGE", -1)
            stats.set_int("MPPLY_BECAME_BADSPORT_NUM", -1)
            stats.set_float("MPPLY_OVERALL_BADSPORT", 60000)
            stats.set_bool("MPPLY_CHAR_IS_BADSPORT", true)
            gui.show_success("Added to bad sport!", "Success!")
        end
        ImGui.SameLine()
        if ImGui.Button("Remove from BadSport") then
            stats.set_int("MPPLY_BADSPORT_MESSAGE", 0)
            stats.set_int("MPPLY_BECAME_BADSPORT_NUM", 0)
            stats.set_float("MPPLY_OVERALL_BADSPORT", 0)
            stats.set_bool("MPPLY_CHAR_IS_BADSPORT", false)
            gui.show_success("Removed from bad sport!", "Success!")
        end
        ImGui.SeparatorText("K/D")
        kd, _ = ImGui.InputFloat("K/D Ratio", kd, -2147483647, 2147483647, "%.2f")
        if ImGui.Button("Apply##KD") then
            stats.set_int("MPPLY_KILLS_PLAYERS", kd)
            stats.set_int("MPPLY_DEATHS_PLAYER", 0)
            stats.set_float("MPPLY_KILL_DEATH_RATIO", kd)
            kills = stats.get_int("MPPLY_KILLS_PLAYERS")
            deaths = stats.get_int("MPPLY_DEATHS_PLAYER")
            gui.show_success("Updated K/D Ratio!")
        end

        ImGui.SeparatorText("Detailed K/D Editor")
        kills, _ = ImGui.InputInt("Kills", kills, -2147483647, 2147483647)
        deaths, _ = ImGui.InputInt("Deaths", deaths, -2147483647, 2147483647)
        if ImGui.Button("Apply##KDetailed") then
            stats.set_int("MPPLY_KILLS_PLAYERS", kills)
            stats.set_int("MPPLY_DEATHS_PLAYER", deaths)
            kd = (kills / (deaths == 0 and 1 or deaths))
            gui.show_success("Updated Kill and Death Stats!")
        end

        ImGui.EndTabItem()
    end

    if ImGui.BeginTabItem("Cash Stats") then

       if ImGui.Button("Refresh##Cash") then
            for i, cashStat in ipairs(cash) do
                if cashStat.type == "float" then
                    cash[i].value = stats.get_float(cashStat.hash)
                else
                    cash[i].value = stats.get_int(cashStat.hash)
                end
            end
        end
        
        
        ImGui.SeparatorText("Cash (in $)")
        for i, cashStat in ipairs(cash) do
            cash[i].value, _ = ImGui.InputInt(cashStat.name, cash[i].value, 0, 2147483647)
        end

        if ImGui.Button("Apply##Cash") then
            for _, cashStat in ipairs(cash) do
                if cashStat.type == "float" then
                    stats.set_float(cashStat.hash, cashStat.value) 
                else
                    stats.set_int(cashStat.hash, cashStat.value)
                end
            end
            gui.show_success("Updated Cash Stats!")
        end


        ImGui.EndTabItem()
    end
        
    if ImGui.BeginTabItem("Distance Stats") then

        if ImGui.Button("Refresh##Distances") then
            for i, distanceStat in ipairs(distance) do
                distance[i].value = stats.get_float(distanceStat.hash)
            end
        end


        ImGui.SeparatorText("Travelled Distances (in meters)")
        for i, distanceStat in ipairs(distance) do
            distance[i].value, _ = ImGui.InputFloat(distanceStat.name, distance[i].value, 0, 2147483647)
        end

        if ImGui.Button("Apply##Distances") then
            for _, distanceStat in ipairs(distance) do
                stats.set_float(distanceStat.hash, distanceStat.value)
            end
            gui.show_success("Updated Distance Stats!")
        end


        ImGui.EndTabItem()
    end

    if ImGui.BeginTabItem("Time Stats") then

        if ImGui.Button("Refresh##Time") then
            for i, distanceStat in ipairs(time) do
                if distanceStat.type == "float" then
                    time[i].value = stats.get_float(distanceStat.hash) / time_multiplier
                else
                    time[i].value = stats.get_int(distanceStat.hash) / time_multiplier
                end
            end
        end


        ImGui.SeparatorText("Time (in hours)")
        for i, distanceStat in ipairs(time) do
            time[i].value, _ = ImGui.InputFloat(distanceStat.name, time[i].value, 0, 2147483647, "%.2f")
        end

        if ImGui.Button("Apply##Time") then
            for _, distanceStat in ipairs(time) do
                if distanceStat.type == "float" then
                    stats.set_float(distanceStat.hash, distanceStat.value * time_multiplier) 
                else
                    stats.set_int(distanceStat.hash, distanceStat.value * time_multiplier)
                end
            end
            gui.show_success("Updated Time Stats!")
        end


        ImGui.EndTabItem()
    end

    if ImGui.BeginTabItem("Other Stats") then


        ImGui.SeparatorText("Other Stats")

        sex_acts, _ = ImGui.InputInt("Sex Acts", sex_acts, 0, 2147483647)
        lapdances, _ = ImGui.InputInt("Lap Dances", lapdances, 0, 2147483647)
        if ImGui.Button("Apply##Other") then
            stats.set_int(MPX() .. "PROSTITUTES_FREQUENTED", sex_acts)
            stats.set_int(MPX() .. "LAP_DANCED_BOUGHT", lapdances)
            gui.show_success("Updated Stats!")
        end


        ImGui.EndTabItem()
    end



end)

local rp = require('includes.data.rp')

level = stats.get_int(MPX() .. "CHAR_RANK_FM")

crewLevel = {}

for i = 0, 4 do
    local cwRP = stats.get_int("MPPLY_CREW_LOCAL_XP_" .. i)
    local cwLevel = findClosestNumberIndex(rp, cwRP)
    table.insert(crewLevel, cwLevel)
end


local Level = Self:add_tab("Level Menu")
Level:add_imgui(function()
    ImGui.BeginTabBar("Level Editor")
    if ImGui.BeginTabItem("Character Level") then
        ImGui.SeparatorText("Level Editor")
        ImGui.BulletText("Current Level: " .. stats.get_int(MPX() .. "CHAR_RANK_FM"))
        level, _ = ImGui.InputInt("##Level", level, 0, 8000)
        ImGui.SameLine()
        if ImGui.Button("+##Level") then
            level = level + 1
            if level > 8000 then
                level = 0
            end
        end
        ImGui.SameLine()
        if ImGui.Button("-##Level") then
            level = level - 1
            if level < 0 then
                level = 8000
            end
        end

        if ImGui.Button("Apply##Level") then
            if level <= 0 or level > 8000 then
                gui.show_message("ERROR", "Your RP level " .. level ..
                    " cannot be set because it is outside the valid range (1-8000).")
            else
                stats.set_int(MPX() .. "CHAR_SET_RP_GIFT_ADMIN", rp[level] or 0)
                gui.show_success("Your Level was succesfully set to " .. level .. "!", "switch session to apply!")
            end
        end

        ImGui.EndTabItem()

    end

    if ImGui.BeginTabItem("Crew Level") then
        for i, value in pairs(crewLevel) do
            ImGui.SeparatorText("Crew " .. i)
            ImGui.BulletText("Crew " .. i .. " Level: " .. findClosestNumberIndex(rp, stats.get_int("MPPLY_CREW_LOCAL_XP_" .. i - 1)))
            crewLevel[i], _ = ImGui.InputInt("##CrewLevel" .. i, crewLevel[i], 0, 8000)
            ImGui.SameLine()
            if ImGui.Button("+##CrewLevel" .. i) then
                crewLevel[i] = crewLevel[i] + 1
                if crewLevel[i] > 8000 then
                    crewLevel[i] = 0
                end
            end
            ImGui.SameLine()
            if ImGui.Button("-##CrewLevel" .. i) then
                crewLevel[i] = crewLevel[i] - 1
                if crewLevel[i] < 0 then
                    crewLevel[i] = 8000
                end
            end
            if ImGui.Button("Apply##CrewLevel" .. i) then
                if crewLevel[i] <= 0 or crewLevel[i] > 8000 then
                    gui.show_message("ERROR", "Your Crew" .. i .. " level " .. crewLevel[i] ..
                        " cannot be set because it is outside the valid range (1-8000).")
                else
                    stats.set_int("MPPLY_CREW_LOCAL_XP_" .. i - 1, rp[crewLevel[i]] or 0)
                    gui.show_success(rp[crewLevel[i]])
                    -- gui.show_success("Your Crew ".. i .. " level has been set to " .. crewLevel[i] .. "!", "switch session to apply!")
                end
            end
        end
        ImGui.EndTabItem()
    end

    if ImGui.BeginTabItem("Car Meet Level") then

        ImGui.SeparatorText("Car Meet Reputation Level")

        if ImGui.Button("Car Meet LVL 1000") then
            stats.set_int(MPX() .. "CAR_CLUB_REP", 997430)
            gui.show_success("Succesfully unlocked car meet lvl 1000!", "re-enter the meet to apply!")
        end

        ImGui.Separator()
        ImGui.Text("1. Purchase the membership if needed on LSCM")
        ImGui.Text("2. Press on 'Set Level 1000 Car Meet'")
        ImGui.Text("3. Leave the Car Meet")
        ImGui.Text("4. Re-Enter the Car Meet")
        ImGui.Text("If everything went well, you should have level 1000")

        ImGui.EndTabItem()
    end

end)



-- RECOVERY --
local Recovery = Menu:add_tab("Recovery")
Recovery:add_imgui(function()
ImGui.SeparatorText("Recovery Menu Information")

ImGui.BulletText("Create Modded Apartment Heists")
ImGui.BulletText("Unlock all achievements")
ImGui.BulletText("Unlock all tunables")
ImGui.BulletText("Unlock all clothing")
ImGui.BulletText("Unlock all modifications")
ImGui.BulletText("Unlock all heists")

end)


-- HEIST --
local MenuS = Recovery:add_tab("Apartment Heist Editor (15 MIL)")
local MenuSGuide = MenuS:add_tab("---> HOW TO USE | GUIDE")
MenuSGuide:add_imgui(function()
    ImGui.SeparatorText("SKIPPING THE PREPS")
    ImGui.Text("1. Enable 'Complete all setup' & 'Skip Heists Cooldown'")
    ImGui.Text("2. Go to your apartment / Buy one")
    ImGui.Text("3. Press on 'Unlock all heists'")
    ImGui.Text("4. Rejoin Online if needed")
    ImGui.Text("5. Start any heist")
    ImGui.Text("6. Rejoin Online")

    ImGui.SeparatorText("FINISHING THE HEIST")
    ImGui.Text("1. Start the final heist")
    ImGui.Text("2. Skip the cutscene quickly by pressing enter")
    ImGui.Text("3. Press on 'Set the 15M CUT'")
    ImGui.Text("4. Force ready up if needed")
    ImGui.Text("5. Instant finish it")
    ImGui.Text("NOTE: DON'T TAKE MORE THAN A MINUTE ON THE FINAL PART, OR YOU WILL GET STUCK ON THE LOADING SCREEN! IF THAT HAPPENS, GO BACK TO STORY MODE AND RELAUNCH THE FINAL HEIST!")
end)
MenuS:add_imgui(function()
    ImGui.SeparatorText("Settings")
    completeAllSetup, _ = ImGui.Checkbox("Complete All Setup", completeAllSetup, true)
    widgetToolTip(false, "Skips the heist preps when enabled, launch a heist and rejoin online.")
    if completeAllSetup then
        stats.set_int(MPX() .. "HEIST_PLANNING_STAGE", -1)
    end
    ImGui.SameLine()
    skipHeistsCooldown, _ = ImGui.Checkbox("Skip Heists Cooldown", skipHeistsCooldown, true)
    widgetToolTip(false, "No cooldown wait to replay a completed heist.")
    if skipHeistsCooldown then
        globals.set_int(1877285 + 1 + (PLAYER.PLAYER_ID() * 77) + 76, -1) -- Thanks to @vithiam on Discord
    end

    ImGui.SeparatorText("Heist Setup")
    if ImGui.Button("Unlock all heists") then 
        stats.set_int(MPX() .. "HEIST_SAVED_STRAND_0", globals.get_int())
        stats.set_int(MPX() .. "HEIST_SAVED_STRAND_0_L", 5)
        stats.set_int(MPX() .. "HEIST_SAVED_STRAND_1", globals.get_int(AUAJg2))
        stats.set_int(MPX() .. "HEIST_SAVED_STRAND_1_L", 5)
        stats.set_int(MPX() .. "HEIST_SAVED_STRAND_2", globals.get_int(AUAJg3))
        stats.set_int(MPX() .. "HEIST_SAVED_STRAND_2_L", 5)
        stats.set_int(MPX() .. "HEIST_SAVED_STRAND_3", globals.get_int(AUAJg4))
        stats.set_int(MPX() .. "HEIST_SAVED_STRAND_3_L", 5)
        stats.set_int(MPX() .. "HEIST_SAVED_STRAND_4", globals.get_int(AUAJg5))
        stats.set_int(MPX() .. "HEIST_SAVED_STRAND_4_L", 5)
    end
    helpmarker(false, "Unlocks all the Apartment Heists (Flecca, Prison Break...)")
    if ImGui.Button("Allow you play alone") then
        if locals.get_int("fmmc_launcher", 19709 + 34) ~= nil then -- https://www.unknowncheats.me/forum/grand-theft-auto-v/463868-modest-menu-lua-scripting-megathread-239.html#google_vignette
            if locals.get_int("fmmc_launcher", 19709 + 34) ~= 0 then
                if locals.get_int("fmmc_launcher", 19709 + 15) > 1 then
                    locals.set_int("fmmc_launcher", 19709 + 15, 1)
                    globals.set_int(794744 + 4 + 1 + (locals.get_int("fmmc_launcher", 19709 + 34) * 89) + 69, 1)
                end

                globals.set_int(4718592 + 3526, 1)
                globals.set_int(4718592 + 3527, 1)
                globals.set_int(4718592 + 3529 + 1, 1)
                globals.set_int(4718592 + 176675 + 1, 0)
            end
        end

    end
    helpmarker(false, "Launch a heist without needing more players.\nNOTE: Only works on the Preps and Flecca Final Part")

    ImGui.SeparatorText("Heist Final")
    if ImGui.Button("Set the 15M CUT") then
        local Difficulty = globals.get_int(4718592 + 3251) -- //3251
        local HeistType = STATS.STAT_GET_STRING(joaat(MPX() .. "HEIST_MISSION_RCONT_ID_1"))

        if Difficulty == 0 and HeistType == "hK5OgJk1BkinXGGXghhTMg" then -- Difficulty Level: Easy; Heist: Fleeca Job
            globals.set_int(1928958 + 1 + 1, -29720)
            globals.set_int(1928958 + 1 + 2, 7453)
        elseif Difficulty == 1 and HeistType == "hK5OgJk1BkinXGGXghhTMg" then -- Difficulty Level: Normal; Heist: Fleeca Job
            globals.set_int(1928958 + 1 + 1, -14806)
            globals.set_int(1928958 + 1 + 2, 7453)
        elseif Difficulty == 2 and HeistType == "hK5OgJk1BkinXGGXghhTMg" then -- Difficulty Level: Hard; Heist: Fleeca Job
            globals.set_int(1928958 + 1 + 1, -11824)
            globals.set_int(1928958 + 1 + 2, 5962)
        elseif Difficulty == 0 and HeistType == "7-w96-PU4kSevhtG5YwUHQ" then -- Difficulty Level: Easy; Heist: Prison Break
            globals.set_int(1928958 + 1 + 1, -17040)
            globals.set_int(1928958 + 1 + 2, 2142)
            globals.set_int(1928958 + 1 + 3, 2142)
            globals.set_int(1928958 + 1 + 4, 2142)
        elseif Difficulty == 1 and HeistType == "7-w96-PU4kSevhtG5YwUHQ" then -- Difficulty Level: Normal; Heist: Prison Break
            globals.set_int(1928958 + 1 + 1, -8468)
            globals.set_int(1928958 + 1 + 2, 2142)
            globals.set_int(1928958 + 1 + 3, 2142)
            globals.set_int(1928958 + 1 + 4, 2142)
        elseif Difficulty == 2 and HeistType == "7-w96-PU4kSevhtG5YwUHQ" then -- Difficulty Level: Hard; Heist: Prison Break
            globals.set_int(1928958 + 1 + 1, -6756)
            globals.set_int(1928958 + 1 + 2, 1714)
            globals.set_int(1928958 + 1 + 3, 1714)
            globals.set_int(1928958 + 1 + 4, 1714)
        elseif Difficulty == 0 and HeistType == "BWsCWtmnvEWXBrprK9hDHA" then -- Difficulty Level: Easy; Heist: Humane Labs Raid
            globals.set_int(1928958 + 1 + 1, -12596)
            globals.set_int(1928958 + 1 + 2, 1587)
            globals.set_int(1928958 + 1 + 3, 1587)
            globals.set_int(1928958 + 1 + 4, 1587)
        elseif Difficulty == 1 and HeistType == "BWsCWtmnvEWXBrprK9hDHA" then -- Difficulty Level: Normal; Heist: Humane Labs Raid
            globals.set_int(1928958 + 1 + 1, -6248)
            globals.set_int(1928958 + 1 + 2, 1587)
            globals.set_int(1928958 + 1 + 3, 1587)
            globals.set_int(1928958 + 1 + 4, 1587)
        elseif Difficulty == 2 and HeistType == "BWsCWtmnvEWXBrprK9hDHA" then -- Difficulty Level: Hard; Heist: Humane Labs Raid
            globals.set_int(1928958 + 1 + 1, -4976)
            globals.set_int(1928958 + 1 + 2, 1269)
            globals.set_int(1928958 + 1 + 3, 1269)
            globals.set_int(1928958 + 1 + 4, 1269)
        elseif Difficulty == 0 and HeistType == "20Lu41Px20OJMPdZ6wXG3g" then -- Difficulty Level: Easy; Heist: Series A Funding
            globals.set_int(1928958 + 1 + 1, -16872)
            globals.set_int(1928958 + 1 + 2, 2121)
            globals.set_int(1928958 + 1 + 3, 2121)
            globals.set_int(1928958 + 1 + 4, 2121)
        elseif Difficulty == 1 and HeistType == "20Lu41Px20OJMPdZ6wXG3g" then -- Difficulty Level: Normal; Heist: Series A Funding
            globals.set_int(1928958 + 1 + 1, -8384)
            globals.set_int(1928958 + 1 + 2, 2121)
            globals.set_int(1928958 + 1 + 3, 2121)
            globals.set_int(1928958 + 1 + 4, 2121)
        elseif Difficulty == 2 and HeistType == "20Lu41Px20OJMPdZ6wXG3g" then -- Difficulty Level: Hard; Heist: Series A Funding
            globals.set_int(1928958 + 1 + 1, -6688)
            globals.set_int(1928958 + 1 + 2, 1697)
            globals.set_int(1928958 + 1 + 3, 1697)
            globals.set_int(1928958 + 1 + 4, 1697)
        elseif Difficulty == 0 and HeistType == "zCxFg29teE2ReKGnr0L4Bg" then -- Difficulty Level: Easy; Heist: Pacific Standard Job
            globals.set_int(1928958 + 1 + 1, -7900)
            globals.set_int(1928958 + 1 + 2, 1000)
            globals.set_int(1928958 + 1 + 3, 1000)
            globals.set_int(1928958 + 1 + 4, 1000)
        elseif Difficulty == 1 and HeistType == "zCxFg29teE2ReKGnr0L4Bg" then -- Difficulty Level: Normal; Heist: Pacific Standard Job
            globals.set_int(1928958 + 1 + 1, -3900)
            globals.set_int(1928958 + 1 + 2, 1000)
            globals.set_int(1928958 + 1 + 3, 1000)
            globals.set_int(1928958 + 1 + 4, 1000)
        elseif Difficulty == 2 and HeistType == "zCxFg29teE2ReKGnr0L4Bg" then -- Difficulty Level: Hard; Heist: Pacific Standard Job
            globals.set_int(1928958 + 1 + 1, -3096)
            globals.set_int(1928958 + 1 + 2, 799)
            globals.set_int(1928958 + 1 + 3, 799)
            globals.set_int(1928958 + 1 + 4, 799)
        end

        globals.set_int(1930926 + 3008 + 1, globals.get_int(1928958 + 1 + 2))

    end
    helpmarker(false, "Use on the cuts board\nWill make all players receive 15 million on the heist.")

    if ImGui.Button("Force Ready Up") then
        globals.set_int(2657971 + 1 + (1 * 465) + 267, 6) -- Thanks to @vithiam on Discord
        globals.set_int(2657971 + 1 + (2 * 465) + 267, 6)
        globals.set_int(2657971 + 1 + (3 * 465) + 267, 6)

    end
    helpmarker(false, "Use on the cuts board\nForce ready up all the players.")

    if ImGui.Button("Instant Finish") then
        locals.set_int("fm_mission_controller", 19746 + 1741, 80) -- Casino Aggressive Kills & Act 3
        locals.set_int("fm_mission_controller", 19746 + 2686, 10000000) -- How much did you take in the casino and pacific standard heist
        locals.set_int("fm_mission_controller", 27507 + 859, 99999) -- 'fm_mission_controller' instant finish variable?
        locals.set_int("fm_mission_controller", 31621 + 69, 99999) -- 'fm_mission_controller' instant finish variable?

    end
    helpmarker(false, "Instant finishes the heist\nNOTE: Wait 5-10 seconds before using.")

end)



local Unlocker = Recovery:add_tab("Unlocker")
Unlocker:add_imgui(function()
    ImGui.SeparatorText("Unlock Menu")
    if ImGui.Button("One Click Unlock Everything") then
        stats.set_bool(MPX() .. "AWD_TEEING_OFF", true)
        stats.set_bool(MPX() .. "AWD_PARTY_NIGHT", true)
        stats.set_bool(MPX() .. "AWD_BILLIONAIRE_GAMES", true)
        stats.set_bool(MPX() .. "AWD_HOOD_PASS", true)
        stats.set_bool(MPX() .. "AWD_STUDIO_TOUR", true)
        stats.set_bool(MPX() .. "AWD_DONT_MESS_DRE", true)
        stats.set_bool(MPX() .. "AWD_BACKUP", true)
        stats.set_bool(MPX() .. "AWD_SHORTFRANK_1", true)
        stats.set_bool(MPX() .. "AWD_SHORTFRANK_2", true)
        stats.set_bool(MPX() .. "AWD_SHORTFRANK_3", true)
        stats.set_bool(MPX() .. "AWD_CONTR_KILLER", true)
        stats.set_bool(MPX() .. "AWD_DOGS_BEST_FRIEND", true)
        stats.set_bool(MPX() .. "AWD_MUSIC_STUDIO", true)
        stats.set_bool(MPX() .. "AWD_SHORTLAMAR_1", true)
        stats.set_bool(MPX() .. "AWD_SHORTLAMAR_2", true)
        stats.set_bool(MPX() .. "AWD_SHORTLAMAR_3", true)
        stats.set_bool(MPX() .. "BS_FRANKLIN_DIALOGUE_0", true)
        stats.set_bool(MPX() .. "BS_FRANKLIN_DIALOGUE_1", true)
        stats.set_bool(MPX() .. "BS_FRANKLIN_DIALOGUE_2", true)
        stats.set_bool(MPX() .. "BS_IMANI_D_APP_SETUP", true)
        stats.set_bool(MPX() .. "BS_IMANI_D_APP_STRAND", true)
        stats.set_bool(MPX() .. "BS_IMANI_D_APP_PARTY", true)
        stats.set_bool(MPX() .. "BS_IMANI_D_APP_PARTY_2", true)
        stats.set_bool(MPX() .. "BS_IMANI_D_APP_PARTY_F", true)
        stats.set_bool(MPX() .. "BS_IMANI_D_APP_BILL", true)
        stats.set_bool(MPX() .. "BS_IMANI_D_APP_BILL_2", true)
        stats.set_bool(MPX() .. "BS_IMANI_D_APP_BILL_F", true)
        stats.set_bool(MPX() .. "BS_IMANI_D_APP_HOOD", true)
        stats.set_bool(MPX() .. "BS_IMANI_D_APP_HOOD_2", true)
        stats.set_bool(MPX() .. "BS_IMANI_D_APP_HOOD_F", true)
        stats.set_bool(MPX() .. "AWD_SCOPEOUT", true)
        stats.set_bool(MPX() .. "AWD_CREWEDUP", true)
        stats.set_bool(MPX() .. "AWD_MOVINGON", true)
        stats.set_bool(MPX() .. "AWD_PROMOCAMP", true)
        stats.set_bool(MPX() .. "AWD_GUNMAN", true)
        stats.set_bool(MPX() .. "AWD_SMASHNGRAB", true)
        stats.set_bool(MPX() .. "AWD_INPLAINSI", true)
        stats.set_bool(MPX() .. "AWD_UNDETECTED", true)
        stats.set_bool(MPX() .. "AWD_ALLROUND", true)
        stats.set_bool(MPX() .. "AWD_ELITETHEIF", true)
        stats.set_bool(MPX() .. "AWD_PRO", true)
        stats.set_bool(MPX() .. "AWD_SUPPORTACT", true)
        stats.set_bool(MPX() .. "AWD_SHAFTED", true)
        stats.set_bool(MPX() .. "AWD_COLLECTOR", true)
        stats.set_bool(MPX() .. "AWD_DEADEYE", true)
        stats.set_bool(MPX() .. "AWD_PISTOLSATDAWN", true)
        stats.set_bool(MPX() .. "AWD_TRAFFICAVOI", true)
        stats.set_bool(MPX() .. "AWD_CANTCATCHBRA", true)
        stats.set_bool(MPX() .. "AWD_WIZHARD", true)
        stats.set_bool(MPX() .. "AWD_APEESCAP", true)
        stats.set_bool(MPX() .. "AWD_MONKEYKIND", true)
        stats.set_bool(MPX() .. "AWD_AQUAAPE", true)
        stats.set_bool(MPX() .. "AWD_KEEPFAITH", true)
        stats.set_bool(MPX() .. "AWD_TRUELOVE", true)
        stats.set_bool(MPX() .. "AWD_NEMESIS", true)
        stats.set_bool(MPX() .. "AWD_FRIENDZONED", true)
        stats.set_bool(MPX() .. "IAP_CHALLENGE_0", true)
        stats.set_bool(MPX() .. "IAP_CHALLENGE_1", true)
        stats.set_bool(MPX() .. "IAP_CHALLENGE_2v", true)
        stats.set_bool(MPX() .. "IAP_CHALLENGE_3", true)
        stats.set_bool(MPX() .. "IAP_CHALLENGE_4v", true)
        stats.set_bool(MPX() .. "IAP_GOLD_TANK", true)
        stats.set_bool(MPX() .. "SCGW_WON_NO_DEATHS", true)
        stats.set_bool(MPX() .. "AWD_KINGOFQUB3D", true)
        stats.set_bool(MPX() .. "AWD_QUBISM", true)
        stats.set_bool(MPX() .. "AWD_QUIBITS", true)
        stats.set_bool(MPX() .. "AWD_GODOFQUB3D", true)
        stats.set_bool(MPX() .. "AWD_STRAIGHT_TO_VIDEO", true)
        stats.set_bool(MPX() .. "AWD_MONKEY_C_MONKEY_DO", true)
        stats.set_bool(MPX() .. "AWD_TRAINED_TO_KILL", true)
        stats.set_bool(MPX() .. "AWD_DIRECTOR", true)
        stats.set_bool(MPX() .. "VCM_FLOW_CS_RSC_SEEN", true)
        stats.set_bool(MPX() .. "VCM_FLOW_CS_BWL_SEEN", true)
        stats.set_bool(MPX() .. "VCM_FLOW_CS_MTG_SEEN", true)
        stats.set_bool(MPX() .. "VCM_FLOW_CS_OIL_SEEN", true)
        stats.set_bool(MPX() .. "VCM_FLOW_CS_DEF_SEEN", true)
        stats.set_bool(MPX() .. "VCM_FLOW_CS_FIN_SEEN", true)
        stats.set_bool(MPX() .. "WAS_CHAR_TRANSFERED", true)
        stats.set_bool(MPX() .. "CL_RACE_MODDED_CAR", true)
        stats.set_bool(MPX() .. "CL_DRIVE_RALLY", true)
        stats.set_bool(MPX() .. "CL_PLAY_GTA_RACE", true)
        stats.set_bool(MPX() .. "CL_PLAY_BOAT_RACE", true)
        stats.set_bool(MPX() .. "CL_PLAY_FOOT_RACE", true)
        stats.set_bool(MPX() .. "CL_PLAY_TEAM_DM", true)
        stats.set_bool(MPX() .. "CL_PLAY_VEHICLE_DM", true)
        stats.set_bool(MPX() .. "CL_PLAY_MISSION_CONTACT", true)
        stats.set_bool(MPX() .. "CL_PLAY_A_PLAYLIST", true)
        stats.set_bool(MPX() .. "CL_PLAY_POINT_TO_POINT", true)
        stats.set_bool(MPX() .. "CL_PLAY_ONE_ON_ONE_DM", true)
        stats.set_bool(MPX() .. "CL_PLAY_ONE_ON_ONE_RACE", true)
        stats.set_bool(MPX() .. "CL_SURV_A_BOUNTY", true)
        stats.set_bool(MPX() .. "CL_SET_WANTED_LVL_ON_PLAY", true)
        stats.set_bool(MPX() .. "CL_GANG_BACKUP_GANGS", true)
        stats.set_bool(MPX() .. "CL_GANG_BACKUP_LOST", true)
        stats.set_bool(MPX() .. "CL_GANG_BACKUP_VAGOS", true)
        stats.set_bool(MPX() .. "CL_CALL_MERCENARIES", true)
        stats.set_bool(MPX() .. "CL_PHONE_MECH_DROP_CAR", true)
        stats.set_bool(MPX() .. "CL_GONE_OFF_RADAR", true)
        stats.set_bool(MPX() .. "CL_FILL_TITAN", true)
        stats.set_bool(MPX() .. "CL_MOD_CAR_USING_APP", true)
        stats.set_bool(MPX() .. "CL_MOD_CAR_USING_APP", true)
        stats.set_bool(MPX() .. "CL_BUY_INSURANCE", true)
        stats.set_bool(MPX() .. "CL_BUY_GARAGE", true)
        stats.set_bool(MPX() .. "CL_ENTER_FRIENDS_HOUSE", true)
        stats.set_bool(MPX() .. "CL_CALL_STRIPPER_HOUSE", true)
        stats.set_bool(MPX() .. "CL_CALL_FRIEND", true)
        stats.set_bool(MPX() .. "CL_SEND_FRIEND_REQUEST", true)
        stats.set_bool(MPX() .. "CL_W_WANTED_PLAYER_TV", true)
        stats.set_bool(MPX() .. "PILOT_ASPASSEDLESSON_0", true)
        stats.set_bool(MPX() .. "PILOT_ASPASSEDLESSON_1", true)
        stats.set_bool(MPX() .. "PILOT_ASPASSEDLESSON_2", true)
        stats.set_bool(MPX() .. "PILOT_ASPASSEDLESSON_3", true)
        stats.set_bool(MPX() .. "PILOT_ASPASSEDLESSON_4", true)
        stats.set_bool(MPX() .. "PILOT_ASPASSEDLESSON_5", true)
        stats.set_bool(MPX() .. "PILOT_ASPASSEDLESSON_6", true)
        stats.set_bool(MPX() .. "PILOT_ASPASSEDLESSON_7", true)
        stats.set_bool(MPX() .. "PILOT_ASPASSEDLESSON_8", true)
        stats.set_bool(MPX() .. "PILOT_ASPASSEDLESSON_9", true)
        stats.set_bool(MPX() .. "AWD_FIRST_TIME1", true)
        stats.set_bool(MPX() .. "AWD_FIRST_TIME2", true)
        stats.set_bool(MPX() .. "AWD_FIRST_TIME3", true)
        stats.set_bool(MPX() .. "AWD_FIRST_TIME4", true)
        stats.set_bool(MPX() .. "AWD_FIRST_TIME5", true)
        stats.set_bool(MPX() .. "AWD_FIRST_TIME6", true)
        stats.set_bool(MPX() .. "AWD_ALL_IN_ORDER", true)
        stats.set_bool(MPX() .. "AWD_SUPPORTING_ROLE", true)
        stats.set_bool(MPX() .. "AWD_ACTIVATE_2_PERSON_KEY", true)
        stats.set_bool(MPX() .. "AWD_ALL_ROLES_HEIST", true)
        stats.set_bool(MPX() .. "AWD_LEADER", true)
        stats.set_bool(MPX() .. "AWD_SURVIVALIST", true)
        stats.set_bool(MPX() .. "AWD_BUY_EVERY_GUN", true)
        stats.set_bool(MPX() .. "AWD_DAILYOBJMONTHBONUS", true)
        stats.set_bool(MPX() .. "AWD_DAILYOBJWEEKBONUS", true)
        stats.set_bool(MPX() .. "AWD_DRIVELESTERCAR5MINS", true)
        stats.set_bool(MPX() .. "AWD_FINISH_HEIST_NO_DAMAGE", true)
        stats.set_bool(MPX() .. "AWD_FM25DIFFERENTDM", true)
        stats.set_bool(MPX() .. "AWD_FM25DIFFERENTRACES", true)
        stats.set_bool(MPX() .. "AWD_FM25DIFITEMSCLOTHES", true)
        stats.set_bool(MPX() .. "AWD_FMFURTHESTWHEELIE", true)
        stats.set_bool(MPX() .. "AWD_FM6DARTCHKOUT", true)
        stats.set_bool(MPX() .. "AWD_FM_GOLF_HOLE_IN_1", true)
        stats.set_bool(MPX() .. "AWD_FM_SHOOTRANG_GRAN_WON", true)
        stats.set_bool(MPX() .. "AWD_FM_TENNIS_5_SET_WINS", true)
        stats.set_bool(MPX() .. "AWD_FMATTGANGHQ", true)
        stats.set_bool(MPX() .. "AWD_FMFULLYMODDEDCAR", true)
        stats.set_bool(MPX() .. "AWD_FMKILL3ANDWINGTARACE", true)
        stats.set_bool(MPX() .. "AWD_FMKILLSTREAKSDM", true)
        stats.set_bool(MPX() .. "AWD_FMMOSTKILLSGANGHIDE", true)
        stats.set_bool(MPX() .. "AWD_FMMOSTKILLSSURVIVE", true)
        stats.set_bool(MPX() .. "AWD_FMPICKUPDLCCRATE1ST", true)
        stats.set_bool(MPX() .. "AWD_FMRACEWORLDRECHOLDER", true)
        stats.set_bool(MPX() .. "AWD_FMTATTOOALLBODYPARTS", true)
        stats.set_bool(MPX() .. "AWD_FMWINALLRACEMODES", true)
        stats.set_bool(MPX() .. "AWD_FMWINCUSTOMRACE", true)
        stats.set_bool(MPX() .. "AWD_FMWINEVERYGAMEMODE", true)
        stats.set_bool(MPX() .. "AWD_SPLIT_HEIST_TAKE_EVENLY", true)
        stats.set_bool(MPX() .. "AWD_STORE_20_CAR_IN_GARAGES", true)
        stats.set_bool(MPX() .. "SR_TIER_1_REWARD", true)
        stats.set_bool(MPX() .. "SR_TIER_3_REWARD", true)
        stats.set_bool(MPX() .. "SR_INCREASE_THROW_CAP", true)
        stats.set_bool(MPX() .. "AWD_CLUB_COORD", true)
        stats.set_bool(MPX() .. "AWD_CLUB_HOTSPOT", true)
        stats.set_bool(MPX() .. "AWD_CLUB_CLUBBER", true)
        stats.set_bool(MPX() .. "AWD_BEGINNER", true)
        stats.set_bool(MPX() .. "AWD_FIELD_FILLER", true)
        stats.set_bool(MPX() .. "AWD_ARMCHAIR_RACER", true)
        stats.set_bool(MPX() .. "AWD_LEARNER", true)
        stats.set_bool(MPX() .. "AWD_SUNDAY_DRIVER", true)
        stats.set_bool(MPX() .. "AWD_THE_ROOKIE", true)
        stats.set_bool(MPX() .. "AWD_BUMP_AND_RUN", true)
        stats.set_bool(MPX() .. "AWD_GEAR_HEAD", true)
        stats.set_bool(MPX() .. "AWD_DOOR_SLAMMER", true)
        stats.set_bool(MPX() .. "AWD_HOT_LAP", true)
        stats.set_bool(MPX() .. "AWD_ARENA_AMATEUR", true)
        stats.set_bool(MPX() .. "AWD_PAINT_TRADER", true)
        stats.set_bool(MPX() .. "AWD_SHUNTER", true)
        stats.set_bool(MPX() .. "AWD_JOCK", true)
        stats.set_bool(MPX() .. "AWD_WARRIOR", true)
        stats.set_bool(MPX() .. "AWD_T_BONE", true)
        stats.set_bool(MPX() .. "AWD_MAYHEM", true)
        stats.set_bool(MPX() .. "AWD_WRECKER", true)
        stats.set_bool(MPX() .. "AWD_CRASH_COURSE", true)
        stats.set_bool(MPX() .. "AWD_ARENA_LEGEND", true)
        stats.set_bool(MPX() .. "AWD_PEGASUS", true)
        stats.set_bool(MPX() .. "AWD_CONTACT_SPORT", true)
        stats.set_bool(MPX() .. "AWD_UNSTOPPABLE", true)
        stats.set_bool(MPX() .. "LOW_FLOW_CS_DRV_SEEN", true)
        stats.set_bool(MPX() .. "LOW_FLOW_CS_TRA_SEEN", true)
        stats.set_bool(MPX() .. "LOW_FLOW_CS_FUN_SEEN", true)
        stats.set_bool(MPX() .. "LOW_FLOW_CS_PHO_SEEN", true)
        stats.set_bool(MPX() .. "LOW_FLOW_CS_FIN_SEEN", true)
        stats.set_bool(MPX() .. "LOW_BEN_INTRO_CS_SEEN", true)
        stats.set_bool(MPX() .. "CASINOPSTAT_BOOL0", true)
        stats.set_bool(MPX() .. "CASINOPSTAT_BOOL1", true)
        stats.set_bool(MPX() .. "FILM4SHIRTUNLOCK", true)
        stats.set_bool(MPX() .. "FILM5SHIRTUNLOCK", true)
        stats.set_bool(MPX() .. "FILM6SHIRTUNLOCK", true)
        stats.set_bool(MPX() .. "FILM7SHIRTUNLOCK", true)
        stats.set_bool(MPX() .. "FILM8SHIRTUNLOCK", true)
        stats.set_bool(MPX() .. "FILM9SHIRTUNLOCK", true)
        stats.set_bool(MPX() .. "ACCOUNTANTSHIRTUNLOCK", true)
        stats.set_bool(MPX() .. "BAHAMAMAMASHIRTUNLOCK", true)
        stats.set_bool(MPX() .. "DRONESHIRTUNLOCK", true)
        stats.set_bool(MPX() .. "GROTTISHIRTUNLOCK", true)
        stats.set_bool(MPX() .. "GOLFSHIRTUNLOCK", true)
        stats.set_bool(MPX() .. "MAISONETTESHIRTUNLOCK", true)
        stats.set_bool(MPX() .. "MANOPAUSESHIRTUNLOCK", true)
        stats.set_bool(MPX() .. "MELTDOWNSHIRTUNLOCK", true)
        stats.set_bool(MPX() .. "PACIFICBLUFFSSHIRTUNLOCK", true)
        stats.set_bool(MPX() .. "PROLAPSSHIRTUNLOCK", true)
        stats.set_bool(MPX() .. "TENNISSHIRTUNLOCK", true)
        stats.set_bool(MPX() .. "TOESHOESSHIRTUNLOCK", true)
        stats.set_bool(MPX() .. "VANILLAUNICORNSHIRTUNLOCK", true)
        stats.set_bool(MPX() .. "MARLOWESHIRTUNLOCK", true)
        stats.set_bool(MPX() .. "CRESTSHIRTUNLOCK", true)
        stats.set_bool("MPPLY_AWD_GANGOPS_ALLINORDER", true)
        stats.set_bool("MPPLY_AWD_GANGOPS_SUPPORT", true)
        stats.set_bool("MPPLY_AWD_GANGOPS_LOYALTY2", true)
        stats.set_bool("MPPLY_AWD_GANGOPS_CRIMMASMD2", true)
        stats.set_bool("MPPLY_AWD_GANGOPS_LOYALTY3", true)
        stats.set_bool("MPPLY_AWD_GANGOPS_CRIMMASMD3", true)
        stats.set_bool("MPPLY_AWD_GANGOPS_LOYALTY", true)
        stats.set_bool("MPPLY_AWD_GANGOPS_CRIMMASMD", true)
        stats.set_bool("MPPLY_MELEECHLENGECOMPLETED", true)
        stats.set_bool("MPPLY_HEADSHOTCHLENGECOMPLETED", true)
        stats.set_bool("MPPLY_AWD_COMPLET_HEIST_MEM", true)
        stats.set_bool("MPPLY_AWD_COMPLET_HEIST_1STPER", true)
        stats.set_bool("MPPLY_AWD_FLEECA_FIN", true)
        stats.set_bool("MPPLY_AWD_HST_ORDER", true)
        stats.set_bool("MPPLY_AWD_HST_SAME_TEAM", true)
        stats.set_bool("MPPLY_AWD_HST_ULT_CHAL", true)
        stats.set_bool("MPPLY_AWD_HUMANE_FIN", true)
        stats.set_bool("MPPLY_AWD_PACIFIC_FIN", true)
        stats.set_bool("MPPLY_AWD_PRISON_FIN", true)
        stats.set_bool("MPPLY_AWD_SERIESA_FIN", true)
        stats.set_bool("MPPLY_AWD_GANGOPS_IAA", true)
        stats.set_bool("MPPLY_AWD_GANGOPS_SUBMARINE", true)
        stats.set_bool("MPPLY_AWD_GANGOPS_MISSILE", true)
        stats.set_masked_int(MPX() .. "DLC22022PSTAT_INT536", 10, 16, 8)
        stats.set_int(MPX() .. "AWD_TAXIDRIVER", 50)
        stats.set_masked_int(MPX() .. "BUSINESSBATPSTAT_INT379", 5, 5, 5) -- Pegassi Oppressor Mk II (Trade Price)

        unlock_packed_bools(110, 113) -- Red Check Pajamas, Green Check Pajamas, Black Check Pajamas, I Heart LC T-shirt
        unlock_packed_bools(115, 115) -- Roosevelt
        unlock_packed_bools(124, 124) -- Sanctus
        unlock_packed_bools(129, 129) -- Albany Hermes
        unlock_packed_bools(135, 137) -- Vapid Clique, Buzzard Attack Chopper, Insurgent Pick-Up
        unlock_packed_bools(3593, 3599) -- 'Statue Of Happiness' T-shirt, 'Pisswasser' Beer Hat, 'Benedict' Beer Hat, 'J Lager' Beer Hat, 'Patriot' Beer Hat, 'Blarneys' Beer Hat, 'Supa Wet' Beer Hat
        unlock_packed_bools(3604, 3605) -- Liberator, Sovereign
        unlock_packed_bools(3608, 3609) -- 'Elitas' T-shirt, High Flyer Parachute Bag
        unlock_packed_bools(3616, 3616) -- Please Stop Me Mask
        unlock_packed_bools(3750, 3750) -- Stocking
        unlock_packed_bools(3765, 3769) -- The Fleeca Job, The Prison Break, The Humane Labs Raid, Series A Funding, The Pacific Standard Job (Elite Challenges)
        unlock_packed_bools(3770, 3781) -- 'Death Defying' T-shirt, 'For Hire' T-shirt, 'Gimme That' T-shirt, 'Asshole' T-shirt, 'Can't Touch This' T-shirt, 'Decorated' T-shirt, 'Psycho Killer' T-shirt, 'One Man Army' T-shirt, 'Shot Caller' T-shirt, 'Showroom' T-shirt, 'Elite Challenge' T-Shirt, 'Elite Lousy' T-Shirt
        unlock_packed_bools(3783, 3802) -- Fake Dix White T-Shirt, Fake Dix Gold T-Shirt, Fake Didier Sachs T-Shirt, Fake Enema T-Shirt, Fake Le Chien No2 T-Shirt, Fake Le Chien Crew T-Shirt, Fake Santo Capra T-Shirt, Fake Vapid T-Shirt, Fake Perseus T-Shirt, Fake Sessanta Nove T-Shirt, 'Vinewood Zombie' T-shirt, 'Meltdown' T-shirt, 'I Married My Dad' T-shirt, 'Die Already 4' T-shirt, 'The Shoulder Of Orion II' T-shirt, 'Nelson In Naples' T-shirt, 'The Many Wives of Alfredo Smith' T-shirt, 'An American Divorce' T-shirt, 'The Loneliest Robot' T-shirt, 'Capolavoro' T-shirt
        unlock_packed_bools(4247, 4269) -- 'Magnetics Script' Hat, 'Magnetics Block' Hat, 'Low Santos' Hat, 'Boars' Hat, 'Benny's' Hat, 'Westside' Hat, 'Eastside' Hat, 'Strawberry' Hat, 'S.A.' Hat, 'Davis' Hat, 'Vinewood Zombie' T-shirt, 'Knife After Dark' T-shirt, 'The Simian' T-shirt, 'Zombie Liberals In The Midwest' T-shirt, 'Twilight Knife' T-shirt, 'Butchery and Other Hobbies' T-shirt, 'Cheerleader Massacre 3' T-shirt, 'Cannibal Clown' T-shirt, 'Hot Serial Killer Stepmom' T-shirt, 'Splatter And Shot' T-shirt, 'Meathook For Mommy' T-shirt, 'Psycho Swingers' T-shirt, 'Vampires On The Beach' T-shirt
        unlock_packed_bools(4300, 4327) -- Brown Corpse Bride Bobblehead, White Corpse Bride Bobblehead, Pink Corpse Bride Bobblehead, White Mask Slasher Bobblehead, Red Mask Slasher Bobblehead, Yellow Mask Slasher Bobblehead, Blue Zombie Bobblehead, Green Zombie Bobblehead, Pale Zombie Bobblehead, Possessed Urchin Bobblehead, Demonic Urchin Bobblehead, Gruesome Urchin Bobblehead, Tuxedo Frank Bobblehead, Purple Suit Frank Bobblehead, Stripped Suit Frank Bobblehead, Black Mummy Bobblehead, White Mummy Bobblehead, Brown Mummy Bobblehead, Pale Werewolf Bobblehead, Dark Werewolf Bobblehead, Gray Werewolf Bobblehead, Fleshy Vampire Bobblehead, Bloody Vampire Bobblehead, B&W Vampire Bobblehead, Halloween Loop 1, Halloween Loop 2, Franken Stange, Lurcher
        unlock_packed_bools(4333, 4335) -- Naughty Cap, Nice Cap, Abominable Snowman
        unlock_packed_bools(7467, 7495) -- 'Accountant' T-shirt, 'Bahama Mamas' T-shirt, 'Drone' T-shirt, 'Grotti' T-shirt, 'Golf' T-shirt, 'Maisonette' T-shirt, 'Manopause' T-shirt, 'Marlowe' T-shirt, 'Meltdown' T-shirt, 'Pacific Bluffs' T-shirt, 'Prolaps' T-shirt, 'Tennis' T-shirt, 'Toe Shoes' T-shirt, 'Crest' T-shirt, 'Vanilla Unicorn' T-shirt, Pastel Blue Pajamas, Pastel Yellow Pajamas, Pastel Pink Pajamas, Pastel Green Pajamas, Vibrant Check Pajamas, Blue Check Pajamas, Red Swirl Motif Pajamas, White Graphic Pajamas, Blue Swirl Pajamas, Yellow Swirl Pajamas, Red Swirl Pajamas, Navy Pinstripe Pajamas, Bold Pinstripe Pajamas, Orange Pinstripe Pajamas
        unlock_packed_bools(7515, 7528) -- Pastel Blue Smoking Jacket, Pastel Yellow Smoking Jacket, Pastel Pink Smoking Jacket, Pastel Green Smoking Jacket, Vibrant Check Smoking Jacket, Blue Check Smoking Jacket, Red Swirl Motif Smoking Jacket, White Graphic Smoking Jacket, Blue Swirl Smoking Jacket, Yellow Swirl Smoking Jacket, Red Swirl Smoking Jacket, Navy Pinstripe Smoking Jacket, Bold Pinstripe Smoking Jacket, Orange Pinstripe Smoking Jacket
        unlock_packed_bools(7551, 7551) -- DCTL T-Shirt
        unlock_packed_bools(7595, 7601) -- White Jock Cranley Suit, Red Jock Cranley Suit, Blue Jock Cranley Suit, Black Jock Cranley Suit, Pink Jock Cranley Suit, Gold Jock Cranley Suit, Silver Jock Cranley Suit
        unlock_packed_bools(9362, 9385) -- Western Brand White T-Shirt, Western Brand Black T-Shirt, Western Logo White T-Shirt, Western Logo Black T-Shirt, Steel Horse Solid Logo T-Shirt, Steel Horse Logo T-Shirt, Steel Horse Brand White T-Shirt, Steel Horse Brand Black T-Shirt, Nagasaki White T-Shirt, Nagasaki White and Red T-Shirt, Nagasaki Black T-Shirt, Purple Helmets Black T-Shirt, Principe Black T-Shirt, Black Steel Horse Hoodie, Steel Horse Brand White T-Shirt, Western Black Hoodie, Western Logo White T-Shirt, Nagasaki White Hoodie, Nagasaki White and Red Hoodie, Nagasaki Black Hoodie, Purple Helmets Black Hoodie, Principe Logo, Crosswalk T-Shirt, R* Crosswalk T-Shirt
        unlock_packed_bools(9426, 9440) -- Base5 T-Shirt, Bitch'n' Dog Food T-Shirt, BOBO T-Shirt, Bounce FM T-Shirt, Crocs Bar T-Shirt, Emotion 98.3 T-Shirt, Fever 105 T-Shirt, Flash T-Shirt, Homies Sharp T-Shirt, K-DST T-Shirt, KJAH Radio T-Shirt, K-ROSE T-Shirt, Victory Fist T-Shirt, Vinyl Countdown T-Shirt, Vivisection T-Shirt
        unlock_packed_bools(9443, 9443) -- Unicorn
        unlock_packed_bools(9461, 9481) -- Ballistic Equipment, LS UR T-Shirt, Non-Stop-Pop FM T-Shirt, Radio Los Santos T-Shirt, Los Santos Rock Radio T-Shirt, Blonded Los Santos 97.8 FM T-Shirt, West Coast Talk Radio T-Shirt, Radio Mirror Park T-Shirt, Rebel Radio T-Shirt, Channel X T-Shirt, Vinewood Boulevard Radio T-Shirt, FlyLo FM T-Shirt, Space 103.2 T-Shirt, West Coast Classics T-Shirt, East Los FM T-Shirt, The Lab T-Shirt, The Lowdown 91.1 T-Shirt, WorldWide FM T-Shirt, Soulwax FM T-Shirt, Blue Ark T-Shirt, Blaine County Radio T-Shirt
        unlock_packed_bools(15381, 15382) -- APC SAM Battery, Ballistic Equipment
        unlock_packed_bools(15388, 15423) -- Black Ammu-Nation Cap, Black Ammu-Nation Hoodie, Black Ammu-Nation T-Shirt, Black Coil Cap, Black Coil T-Shirt, Black Hawk & Little Hoodie, Black Hawk & Little Logo T-Shirt, Black Hawk & Little T-Shirt, Black Shrewsbury Hoodie, Black Vom Feuer Cap, Black Warstock Hoodie, Green Vom Feuer T-Shirt, Red Hawk & Little Cap, Warstock Cap, White Ammu-Nation T-Shirt, White Coil Hoodie, White Coil T-Shirt, White Hawk & Little Hoodie, White Hawk & Little T-Shirt, White Shrewsbury T-Shirt, White Shrewsbury Cap, White Shrewsbury Hoodie, White Shrewsbury Logo T-Shirt, White Vom Feuer Cap, White Vom Feuer Hoodie, Wine Coil Cap, Yellow Vom Feuer Logo T-Shirt, Yellow Vom Feuer T-Shirt, Yellow Warstock T-Shirt, Blue R* Class of '98, Red R* Class of '98, Noise Rockstar Logo T-Shirt, Noise T-Shirt, Razor T-Shirt, Black Rockstar Camo, White Rockstar Camo
        unlock_packed_bools(15425, 15439) -- Knuckleduster Pocket T-Shirt, Rockstar Logo Blacked Out T-Shirt, Rockstar Logo White Out T-Shirt, Half-track 20mm Quad Autocannon, Weaponized Tampa Dual Remote Minigun, Weaponized Tampa Rear-Firing Mortar, Weaponized Tampa Front Missile Launchers, Dune FAV 40mm Grenade Launcher, Dune FAV 7.62mm Minigun, Insurgent Pick-Up Custom .50 Cal Minigun, Insurgent Pick-Up Custom Heavy Armor Plating, Technical Custom 7.62mm Minigun, Technical Custom Ram-bar, Technical Custom Brute-bar, Technical Custom Heavy Chassis Armor
        unlock_packed_bools(15447, 15474) -- Oppressor Missiles, Fractal Livery Set, Digital Livery Set, Geometric Livery Set, Nature Reserve Livery, Naval Battle Livery, Anti-Aircraft Trailer Dual 20mm Flak, Anti-Aircraft Trailer Homing Missile Battery, Mobile Operations Center Rear Turrets, Incendiary Rounds, Hollow Point Rounds, Armor Piercing Rounds, Full Metal Jacket Rounds, Explosive Rounds, Pistol Mk II Mounted Scope, Pistol Mk II Compensator, SMG Mk II Holographic Sight, SMG Mk II Heavy Barrel, Heavy Sniper Mk II Night Vision Scope, Heavy Sniper Mk II Thermal Scope, Heavy Sniper Mk II Heavy Barrel, Combat MG Mk II Holographic Sight, Combat MG Mk II Heavy Barrel, Assault Rifle Mk II Holographic Sight, Assault Rifle Mk II Heavy Barrel, Carbine Rifle Mk II Holographic Sight, Carbine Rifle Mk II Heavy Barrel, Proximity Mines
        unlock_packed_bools(15491, 15499) -- Weaponized Tampa Heavy Chassis Armor, Brushstroke Camo Mk II Weapon Livery, Skull Mk II Weapon Livery, Sessanta Nove Mk II Weapon Livery, Perseus Mk II Weapon Livery, Leopard Mk II Weapon Livery, Zebra Mk II Weapon Livery, Geometric Mk II Weapon Livery, Boom! Mk II Weapon Livery
        unlock_packed_bools(15552, 15560) -- Bronze Greatest Dancer Trophy, Bronze Number One Nightclub Trophy, Bronze Battler Trophy, Silver Greatest Dancer Trophy, Silver Number One Nightclub Trophy, Silver Battler Trophy, Gold Greatest Dancer Trophy, Gold Number One Nightclub Trophy, Gold Battler Trophy
        unlock_packed_bools(18099, 18099) -- The Forest
        unlock_packed_bools(18116, 18118) -- The Data Breaches, The Bogdan Problem, The Doomsday Scenario (Elite Challenges)
        unlock_packed_bools(18121, 18125) -- Green Wireframe Bodysuit, Orange Wireframe Bodysuit, Blue Wireframe Bodysuit, Pink Wireframe Bodysuit, Yellow Wireframe Bodysuit
        unlock_packed_bools(18134, 18137) -- Hideous Krampus Mask, Fearsome Krampus Mask, Odious Krampus Mask, Heinous Krampus Mask
        unlock_packed_bools(22124, 22132) -- Maisonette Los Santos T-Shirt, Studio Los Santos T-Shirt, Galaxy T-Shirt, Gefängnis T-Shirt, Omega T-Shirt, Technologie T-Shirt, Paradise T-Shirt, The Palace T-Shirt, Tony's Fun House T-Shirt
        unlock_packed_bools(22137, 22139) -- Nightclub Hotspot Trophy
        unlock_packed_bools(24963, 25000) -- Apocalypse Cerberus, Future Shock Cerberus, Apocalypse Brutus, Nightmare Cerberus, Apocalypse ZR380, Future Shock Brutus, Impaler, Bolt Burger Hunger T-Shirt, Apocalypse Sasquatch - Livery set, Rat-Truck, Glendale, Slamvan, Dominator, Issi Classic, Spacesuit Alien T-Shirt set, Gargoyle, Future Shock Deathbike - Light Armor w/ Shield, Blue Lights, Electric Blue Lights, Mint Green Lights, Lime Green Lights, Yellow Lights, Golden Shower Lights, Orange Lights, Red Lights, Pony Pink Lights, Hot Pink Lights, Purple Lights, Blacklight Lights, Taxi Custom, Dozer, Clown Van, Trashmaster, Barracks Semi, Mixer, Space Docker, Tractor, Nebula Bodysuit set
        unlock_packed_bools(25002, 25002) -- Up-n-Atomizer
        unlock_packed_bools(25005, 25006) -- Epsilon Robes, Kifflom T-Shirt
        unlock_packed_bools(25008, 25009) -- The Rookie
        unlock_packed_bools(25018, 25099) -- Black & White Bones Festive Sweater, Slasher Festive Sweater, Black & Red Bones Festive Sweater, Red Bones Festive Sweater, Burger Shot Festive Sweater, Red Bleeder Festive Sweater, Blue Bleeder Festive Sweater, Blue Cluckin' Festive Sweater, Green Cluckin' Festive Sweater, Blue Slaying Festive Sweater, Green Slaying Festive Sweater, Hail Santa Festive Sweater, Merry Sprunkmas Festive Sweater, Ice Cold Sprunk Festive Sweater, Albany T-Shirt, Albany Vintage T-Shirt, Annis T-Shirt, Benefactor T-Shirt, BF T-Shirt, Bollokan T-Shirt, Bravado T-Shirt, Brute T-Shirt, Buckingham T-Shirt, Canis T-Shirt, Chariot T-Shirt, Cheval T-Shirt, Classique T-Shirt, Coil T-Shirt, Declasse T-Shirt, Dewbauchee T-Shirt, Dilettante T-Shirt, Dinka T-Shirt, Dundreary T-Shirt, Emperor T-Shirt, Enus T-Shirt, Fathom T-Shirt, Gallivanter T-Shirt, Grotti T-Shirt, Hijak T-Shirt, HVY T-Shirt, Imponte T-Shirt, Invetero T-Shirt, Jobuilt T-Shirt, Karin T-Shirt, Lampadati T-Shirt, Maibatsu T-Shirt, Mamba T-Shirt, Mammoth T-Shirt, MTL T-Shirt, Obey T-Shirt, Ocelot T-Shirt, Overflod T-Shirt, Pegassi T-Shirt, Pfister T-Shirt, Progen T-Shirt, Rune T-Shirt, Schyster T-Shirt, Shitzu T-Shirt, Truffade T-Shirt, Ubermacht T-Shirt, Vapid T-Shirt, Vulcar T-Shirt, Weeny T-Shirt, Willard T-Shirt, Albany Nostalgia T-Shirt, Albany USA T-Shirt, Albany Dealership T-Shirt, Annis JPN T-Shirt, BF Surfer T-Shirt, Bollokan Prairie T-Shirt, Bravado Stylized T-Shirt, Brute Impregnable T-Shirt, Brute Heavy Duty T-Shirt, Buckingham Luxe T-Shirt, Canis USA T-Shirt, Canis American Legend T-Shirt, Canis Wolf T-Shirt, Cheval Marshall T-Shirt, Coil USA T-Shirt, Coil Raiden T-Shirt, Declasse Logo T-Shirt, Declasse Girl T-Shirt
        unlock_packed_bools(25101, 25109) -- Nightmare Brutus, Apocalypse Scarab, Future Shock Scarab, Nightmare Scarab, Future Shock ZR380, Nightmare ZR380, Apocalypse Imperator, Future Shock Imperator, Nightmare Imperator
        unlock_packed_bools(25111, 25134) -- Future Shock Deathbike - Reinforced Armor w/ Shield, Future Shock Deathbike - Heavy Armor w/ Shield, Future Shock Sasquatch - Livery set, Nightmare Sasquatch - Livery set, Apocalypse Cerberus - Livery set, Future Shock Cerberus - Livery set, All variants of Sasquatch - Light Armor, All variants of Sasquatch - Reinforced Armor, All variants of Sasquatch - Heavy Armor, Nightmare Cerberus - Livery set, Apocalypse Bruiser - Livery set, Future Shock Bruiser - Livery set, Nightmare Bruiser - Livery set, Apocalypse Slamvan - Livery set, All variants of Cerberus - Body Spikes, Future Shock Slamvan - Livery set, All variants of Cerberus - Light Armor, All variants of Cerberus - Reinforced Armor, All variants of Cerberus - Heavy Armor, Nightmare Slamvan - Livery set, Apocalypse Brutus - Livery set, Future Shock Brutus - Livery set, Nightmare Brutus - Livery set, Apocalypse Scarab - Livery set
        unlock_packed_bools(25136, 25179) -- All variants of Bruiser - Body Spikes, Future Shock Scarab - Livery set, Nightmare Scarab - Livery set, All variants of Bruiser - Light Armor, All variants of Bruiser - Reinforced Armor, All variants of Bruiser - Heavy Armor, Apocalypse Dominator - Livery set, Future Shock Dominator - Livery set, Nightmare Dominator - Livery set, Apocalypse Impaler - Livery set, Future Shock Impaler - Livery set, Nightmare Impaler - Livery set, All variants of Slamvan - Body Spikes, Apocalypse Imperator - Livery set, Future Shock Imperator - Livery set, All variants of Slamvan - Light Armor, All variants of Slamvan - Reinforced Armor, All variants of Slamvan - Heavy Armor, Nightmare Imperator - Livery set, Apocalypse ZR380 - Livery set, Future Shock ZR380 - Livery set, Nightmare ZR380 - Livery set, Apocalypse Issi - Livery set, Future Shock Issi - Livery set, All variants of Brutus - Light Armor, All variants of Brutus - Reinforced Armor, All variants of Brutus - Heavy Armor, Nightmare Issi - Livery set, Apocalypse Deathbike - Livery set, Future Shock Deathbike - Livery set, Nightmare Deathbike - Livery set, All variants of Sasquatch - Heavy Armored Front, Apocalypse Scarab - Body Spikes set, Future Shock Scarab - Body Spikes set, Nightmare Scarab - Body Spikes set, All variants of Sasquatch - Heavy Armored Hood, All variants of Sasquatch - Mohawk Exhausts, All variants of Scarab - Light Armor, All variants of Scarab - Reinforced Armor, All variants of Scarab - Heavy Armor, All variants of Sasquatch - Dual Mohawk Exhausts, Apocalypse & Nightmare Sasquatch - Rear Spears Left, Optics Headset Mask set, All variants of Dominator - Body Spikes
        unlock_packed_bools(25181, 25237) -- Apocalypse & Nightmare Sasquatch - Rear Spears Right, Apocalypse & Nightmare Sasquatch - Skull Cross, All variants of Dominator - Light Armor, All variants of Dominator - Reinforced Armor, All variants of Dominator - Heavy Armor, Apocalypse & Nightmare Sasquatch - Ram Skull Cross, Apocalypse & Nightmare Sasquatch - Blonde Doll Cross, All variants of Impaler - Body Spikes, Apocalypse & Nightmare Sasquatch - Brunette Doll Cross, Apocalypse & Nightmare Cerberus - Bastioned Ram-bars, All variants of Impaler - Light Armor, All variants of Impaler - Reinforced Armor, All variants of Impaler - Heavy Armor, All variants of Cerberus - Bolstered Hood Cage, All variants of Cerberus - Reinforced Riot Hood, All variants of Cerberus - Juggernaut Hood, Apocalypse & Nightmare Cerberus - War Spearheads, All variants of Imperator - Body Spikes, Apocalypse & Nightmare Cerberus - War Spear Kit, Apocalypse & Nightmare Cerberus - Nade Spearheads, Apocalypse & Nightmare Cerberus - Nade Spear Kit, All variants of Imperator - Light Armor, All variants of Imperator - Reinforced Armor, All variants of Imperator - Heavy Armor, Apocalypse & Nightmare Cerberus - Skull Spearheads, Apocalypse & Nightmare Cerberus - Skull Spear Kit, Apocalypse & Nightmare Cerberus - Arrow Spearheads, Apocalypse & Nightmare Cerberus - Arrow Spear Kit, All variants of ZR380 - Body Spikes, Apocalypse & Nightmare Cerberus - Tridents, Apocalypse & Nightmare Cerberus - Wasteland Ritual, All variants of ZR380 - Light Armor, All variants of ZR380 - Reinforced Armor, All variants of ZR380 - Heavy Armor, Future Shock Cerberus - Panel Detail, Future Shock Cerberus - Crane Pipes, All variants of Issi - Body Spikes, Future Shock Cerberus - Hedgehog, Future Shock Cerberus - Hedgehog MK2, Future Shock Bruiser - Heavy Plated Armored Grille / Apocalypse & Nightmare Bruiser - Diamond Heavy Armor Grille, All variants of Issi - Light Armor, All variants of Issi - Reinforced Armor, All variants of Issi - Heavy Armor, All variants of Bruiser - Twin Oval Exhaust, Cluckin' Bell Mask, All variants of Bruiser - Long Triple Rear Exhausts, All variants of Bruiser - Front & Rear Triple Exhausts, All variants of Deathbike - Light Armor, All variants of Deathbike - Reinforced Armor, All variants of Deathbike - Heavy Armor, Kinetic Mines, Apocalypse Bruiser - Skull & Cross / Nightmare Bruiser - Painted Skull & Cross, Spike Mines, Slick Mines, Sticky Mines, EMP Mines, RC Bandito
        unlock_packed_bools(25244, 25400) -- Robot Bodysuit set, Hero Bodysuit set, Shapes Bodysuit set, Contours Bodysuit set, Martian Bodysuit set, Reptile Bodysuit set, Galaxy Bodysuit set, Space Creature Suits, Space Cyclops Suits, Space Horror Suits, Retro Spacesuits, Astronaut Suits, Space Traveler Suits, Character Suits: Pogo Space Monkey, Character Suits: Republican Space Ranger, Death Bird Mask set, Stalker Mask set, Raider Mask set, Marauder Mask set, Paco the Taco Mask, Burger Shot Mask, Space Rangers T-Shirt set, Space Ranger Logo T-Shirt set, Phases T-Shirt set, Rocket Splash T-Shirt set, Two Moons T-Shirt set, Freedom Isn't Free T-Shirt set, Apocalyptic Raider Top set, Apocalyptic Leather Feather Top set, Apocalyptic Mercenary Vest set, Benedict Light Beer Hoodie, Taco Bomb Hoodie, Cluckin' Bell Logo Bomb Hoodie, Patriot Beer Hoodie, Pisswasser Hoodie, Burger Shot Hoodie, Corn Dog Hoodie, Donut Hoodie, Lucky Plucker Hoodie, Logger Light Hoodie, Pizza Hoodie, Fries Hoodie, Mushrooms Hoodie, Redwood Hoodie, eCola Infectious Hoodie, Cluckin' Bell Logo Hoodie, Lemons Hoodie, Tacos Hoodie, Burger Shot Pattern Sweater, Burger Shot Logo Sweater, Burger Shot Sweater, Sprunk Sweater set, Wigwam Sweater, Taco Bomb Chili Sweater, Taco Bomb Sweater set, Cluckin' Bell Logo Bomb Sweater, Blue Cluckin' Bell Sweater, Black Cluckin' Bell Sweater, eCola Sweater set, MeTV Sweater set, Heat Sweater set, Degenatron Sweater, Pisswasser Sweater set, Bolt Burger Sweater, Lucky Plucker Logo Bomb Sweater, Lucky Plucker Sweater, Burger Shot Hockey Shirt set, Cluckin' Bell Hockey Shirt set, Wigwam Hockey Shirt, Redwood Hockey Shirt, Bean Machine Hockey Shirt, Red eCola Hockey Shirt, Black eCola Hockey Shirt, Phat Chips Hockey Shirt set, Sprunk Hockey Shirt set, Sprunk Classic Hockey Shirt, Burger Shot Black T-Shirt, Burger Shot Logo T-Shirt, Cluckin' Bell Logo T-Shirt, Cluckin' Bell Black T-Shirt, Cluckin' Bell Filled Logo T-Shirt, eCola Black T-Shirt, Lucky Plucker T-Shirt, Pisswasser T-Shirt, Sprunk T-Shirt, Taco Bomb Chili T-Shirt, Taco Bomb Black T-Shirt, Up-n-Atom Hamburgers T-Shirt, Up-n-Atom Logo T-Shirt, Wigwam T-Shirt, Degenatron ROYGBIV T-Shirt, CNT T-Shirt, Qub3d T-Shirt, Righteous Slaughter T-Shirt, Space Monkey Full T-Shirt, Space Monkey Pixel T-Shirt, Space Monkey Enemy T-Shirt, Burger Shot Bleeder T-Shirt, Heat Rises T-Shirt, Space Monkey Logo T-Shirt, Space Monkey Suit T-Shirt, Space Monkey Face T-Shirt, Space Monkey Mosaic T-Shirt, Bolt Burger Logo T-Shirt, Exsorbeo 720 T-Shirt, Heat Ball Logo T-Shirt set, Heat Logo T-Shirt set, Heat Pop Art Logo T-Shirt set, MeTV Logo T-Shirt set, MeTV 90s T-Shirt set, Burger Shot Target T-Shirt, eCola Infectious T-Shirt, Up-n-Atom White T-Shirt, Jock Cranley Patriot T-Shirt, CCC TV T-Shirt, Degenatron Logo T-Shirt, eCola White T-Shirt, eCola Pass It On T-Shirt, Tw@ T-Shirt, Chain Pants set, Chain Shorts set, Leather Stitch Pants set, Raider Pants set, Light Ups Shoes set, Flaming Skull Boots set, Skull Harness Boots set, Plated Boots set, Burger Shot Food Cap set, Apocalypse Bruiser - Double Cross Ram Skull / Nightmare Bruiser - Painted Ram Skull & Cross, Burger Shot Logo Cap, Burger Shot Bullseye Cap, Cluckin' Bell Logo Cap set, Apocalypse Bruiser - Cross & Skull Large Blade Kit / Nightmare Bruiser - Painted Skull Large Blade Kit, Cluckin' Bell Logos Cap, Hotdogs Cap set, Taco Bomb Cap set, Apocalypse Bruiser - Ram Skull Nade Kit / Nightmare Bruiser - Painted Ram Skull Nade Kit, Apocalypse Bruiser - Ram Skull Medieval Kit / Nightmare Bruiser - Painted Skull Medieval Kit, Lucky Plucker Cap set, Lucky Plucker Logos Cap set, Apocalypse Bruiser - Ram Skull Medieval Madness / Nightmare Bruiser - Painted Skull Medieval Madness, Apocalypse Bruiser - Barrels & Junk, Pisswasser Cap set, Apocalypse Bruiser - Skeleton Cage, Future Shock Bruiser - Light Cover, Future Shock Bruiser - Spare Tire, Taco Canvas Hat, Burger Shot Canvas Hat, Cluckin' Bell Canvas Hat, Hotdogs Canvas Hat, Shunt Boost, Boost Upgrade 20%, Boost Upgrade 60%, Boost Upgrade 100%, Jump Upgrade 20%, Jump Upgrade 60%, Jump Upgrade 100%
        unlock_packed_bools(25405, 25405) -- Festive tint (Up-n-Atomizer)
        unlock_packed_bools(25407, 25511) -- Future Shock Bruiser - Crates, Nightmare Bruiser - Large Burger, Nightmare Bruiser - Large Doughnuts, Nightmare Bruiser - Large eCola Cans, All variants of Slamvan - Rear Bumper Reinforced Armor, All variants of Slamvan - Rear Bumper Heavy Armor, Apocalypse Slamvan - Basic Spears, Apocalypse Slamvan - Battle Cross, Apocalypse Slamvan - War Cross, Apocalypse Slamvan - Battle Spears, Apocalypse Slamvan - War Spears, Nightmare Slamvan - Knife Spears, Nightmare Slamvan - Fork & Knife, Apocalypse & Nightmare Brutus - Gassed Up Bar, Apocalypse & Nightmare Brutus - Roadblock, Apocalypse & Nightmare Brutus - Junk Trunk, Apocalypse & Nightmare Brutus - Fire Spitters, Apocalypse & Nightmare Brutus - Hell Chambers, Apocalypse & Nightmare Brutus - Heavy Armored Arches, Apocalypse & Nightmare Brutus - Toothy, Apocalypse & Nightmare Brutus - Armored Spares, Apocalypse & Nightmare Brutus - Armored Supplies, Apocalypse & Nightmare Brutus - Eternally Chained, Apocalypse & Nightmare Brutus - Speared, Future Shock Scarab - Primary Full Armor, All variants of Scarab - Secondary Full Armor, All variants of Scarab - Carbon Full Armor, Future Shock Scarab - Heavy Duty Cooling / Apocalypse & Nightmare Scarab - Air Filtration Vents & Long Range Equipment, Apocalypse & Nightmare Scarab - Rusty Full Armor, Apocalypse & Nightmare Scarab - Rear War Poles, Apocalypse & Nightmare Scarab - Rear Spears, Apocalypse & Nightmare Scarab - Skull Cross, Apocalypse & Nightmare Scarab - Skull Cross w/ War Poles, Apocalypse & Nightmare Scarab - Skull Cross w/ Spears, Apocalypse & Nightmare Scarab - Load'a War Poles, Apocalypse & Nightmare Scarab - Load'a Spears, Apocalypse & Nightmare Scarab - Scarab Mega Cover set, Apocalypse & Nightmare Scarab - Armored Mega Cover set, Apocalypse & Nightmare Scarab - Cage, Apocalypse & Nightmare Scarab - Plated Cage, Future Shock Scarab - Livery Armor, Future Shock Scarab - Primary Full Armor, Future Shock Scarab - Livery Full Armor, Future Shock Scarab - Carbon Full Armor, Future Shock Scarab - Matte Full Armor, Future Shock Scarab - Futuristic Panel Armor, Future Shock Scarab - Plated Livery Full Armor, All variants of Dominator - Triple Front Exhausts, All variants of Dominator - Horn Exhausts, All variants of Dominator - Triple Rear Exhausts, Apocalypse & Nightmare Dominator - Rear Pointing War Poles, Apocalypse & Nightmare Dominator - Front Facing Axes, Apocalypse & Nightmare Dominator - Front Facing Spears, Apocalypse & Nightmare Dominator - Unholy Cross, Apocalypse & Nightmare Dominator - Brutal Unholy Cross, Apocalypse & Nightmare Dominator - Bunch of War Poles, Apocalypse & Nightmare Dominator - Front Pointing War Poles, Apocalypse & Nightmare Dominator - Skull Hood, Apocalypse & Nightmare Impaler - Got Pole?, Apocalypse & Nightmare Impaler - Getting Medieval, Apocalypse & Nightmare Impaler - Wasteland Peacock, Apocalypse & Nightmare Impaler - Shish-Kebbabed, Apocalypse & Nightmare Impaler - It's A Stick Up, Apocalypse & Nightmare Impaler - The Dark Ages, Apocalypse & Nightmare Impaler - Dolly Spearton, Apocalypse & Nightmare Impaler - War Poles, All variants of Imperator - Shakotan Exhaust, Apocalypse & Nightmare Imperator - Whole Lotta Pole, Apocalypse & Nightmare Imperator - Getting Medieval, Apocalypse & Nightmare Imperator - It's A Stick Up, Apocalypse & Nightmare Imperator - Boom On A Spear, Apocalypse & Nightmare Imperator - Village Justice, Apocalypse & Nightmare Imperator - Wasteland Peacock, Apocalypse & Nightmare Imperator - Shish-Kebbabed, Apocalypse & Nightmare Imperator - Junk Pipes, Apocalypse & Nightmare Imperator - Mega Zorst, Apocalypse & Nightmare Imperator - Ride 'Em Cowboy, Apocalypse & Nightmare Imperator - Cannibal Totem, All variants of ZR380 - Side Exhausts, All variants of ZR380 - Spike Exhausts, Apocalypse & Nightmare ZR380 - Mismatch, Future Shock ZR380 - Ray Gun Exhausts, Future Shock ZR380 - Sprint Car Wing, Future Shock ZR380 - Armor Plating Mk. 3, Future Shock ZR380 - Rear Phantom Covers, All variants of Issi - Heavy Duty Ram Bar, Apocalypse & Nightmare Issi - Spear, Apocalypse & Nightmare Issi - Left War Poles, Apocalypse & Nightmare Issi - Dolly Spearton, Apocalypse & Nightmare Issi - Right War Poles, Apocalypse & Nightmare Issi - Skull Cross, Apocalypse & Nightmare Issi - Dolly Spearton Set, Apocalypse & Nightmare Issi - Dual War Poles, Apocalypse & Nightmare Issi - Dolly Spearton W/ War Pole, Apocalypse & Nightmare Issi - Skull Cross W/ Spear, Apocalypse & Nightmare Issi - Skull Cross W/ War Pole, Apocalypse & Nightmare Issi - Skull Cross W/ Dolly, Apocalypse & Nightmare Issi - Left Spear, Apocalypse & Nightmare Issi - Right Spear, Apocalypse & Nightmare Issi - Left Skull Axe, Apocalypse & Nightmare Issi - Right Axe, Apocalypse & Nightmare Issi - Dual Spears, Apocalypse & Nightmare Issi - Spear & Axe, Apocalypse & Nightmare Issi - Axe & Spear, Apocalypse & Nightmare Issi - Dual Axes
        unlock_packed_bools(25516, 25516) -- RC Tank
        unlock_packed_bools(25520, 25521) -- Metal Detector
        unlock_packed_bools(26811, 26964) -- Action Figures, Playing Cards
        unlock_packed_bools(26968, 27088) -- Impotent Rage Outfit, High Roller, Tiger Scuba, Sprunk Racing Suit, Neon Bodysuit, Extreme Strike Vest, The Chimera (Outfit), White Racing Suit, The Reconnaissance (Outfit), Blue Jock Cranley Suit, Italian Biker Suit, The Hazard (Outfit), Mid Strike Vest, Splinter Gorka Suit, The Gunfighter (Outfit), Black Plate Carrier*, Hunter Leather Fur Jacket, Chamois Plate Carrier*, Black Heavy Utility Vest, The Puff (Outfit), Ox Blood Patched Cut, Color Geo PRB Leather, Blue Tactical Blouson, Orange Big Cat*, Color Geo Sweater, Vivid Gradient Puffer, Color Diamond Sweater, Classic SN Print Sweater, Power Motocross, The Buzz (Outfit), Pegassi Racing Jacket, Woodland Camo Parka, Le Chien Print Sweater, The Pincer (Outfit), Vibrant Gradient Shortsleeve, Urban Gradient Shortsleeve, White Chevron SC Track, Slalom Motocross, Blue Savanna Shortsleeve, Green Didier Sachs Field, Candy Motocross, Tutti Frutti Pattern Sweater, The Vespucci (Outfit), Contrast Camo Service Shirt, Tropical Pattern Sweater, Black Service Shirt, SecuroServ 1 (Outfit), Black Sports Blagueurs Hoodie, Gold Shiny T-Shirt, OJ Shortsleeve, Primary Squash Hoodie, Purple Camo Bigness Hoodie, Bold Abstract Bigness Hoodie, Pink SN Hoodie, Red Boating Blazer, Multicolor Leaves Shortsleeve, Neon Leaves Güffy Hoodie, Black Dotted Shortsleeve, Drive Motocross, Red Patterned Shortsleeve, Steel Horse Satin Jacket, Orange Squash Hoodie, Regal Loose Shirt, White Güffy Hoodie, Stealth Utility Vest, Red Floral Sweater, Black & Red Bigness Jersey, The Slick (Outfit), Splat Squash Sweater, Tan Hooded Jacket, Brushstroke Combat Shirt, White & Red Bigness Jersey, Black Combat Top, Lime Longline Hoodie, Red Bold Check, Bold Camo Sand Castle Sweater, Red Combat Shirt, Red Mist XI Dark, Cyan Manor Sweater, Flecktarn Sleeveless Shirt, Forest Camo Battle Vest, LS Jardineros Dark, Liberty Cocks Dark, Angelica T-Shirt, Hinterland Ship Sweater, Wine Sleeveless Shirt, Cobble Sleeveless, Black Dense Logo Sweater*, White Flying Bravo Hoodie, Cat T-Shirt*, Color Geo T-Shirt, Bold Abstract Bigness T-Shirt, Neon Leaves Güffy T-Shirt, Black Baggy Hoodie, White Manor Zigzag T-Shirt, Double P Baseball Shirt, Aqua Camo Rolled Tee, Dark Woodland T-Shirt, White Bigness T-Shirt, Black No Retreat Tank, White Benny's T-Shirt, Red Smuggler Tank, Angels of Death Vivid Tee, Blue Hit & Run Tank, Waves T-Shirt*, Beige Turtleneck, Hinterland Nugget T-Shirt, Mustard Güffy Tank, Nagasaki White and Red Hoodie, Grotti Tee, Western Logo Black Tee, Butchery and other Hobbies, Black Ammu-Nation Hoodie*, Fake Santo Capra T-Shirt, Death Defying T-Shirt, Bahama Mamas, Showroom T-Shirt, LS UR Tee, J Lager Beer Hat, Unicorn, Gingerbread
        unlock_packed_bools(27109, 27115) -- The Diamond Classic T-Shirt, The Diamond Vintage T-Shirt, Red The Diamond LS T-Shirt, Blue The Diamond Resort LS T-Shirt, Red The Diamond Resort T-Shirt, Blue D Casino T-Shirt, Red The Diamond Classic T-Shirt
        unlock_packed_bools(27120, 27145) -- White The Diamond Hoodie, Black The Diamond Hoodie, Ash The Diamond Hoodie, Gray The Diamond Hoodie, Red The Diamond Hoodie, Orange The Diamond Hoodie, Blue The Diamond Hoodie, Black The Diamond Silk Robe, White The Diamond Cap, Black The Diamond Cap, White LS Diamond Cap, Black LS Diamond Cap, Red The Diamond Cap, Orange The Diamond Cap, Blue LS Diamond Cap, Green The Diamond Cap, Orange LS Diamond Cap, Purple The Diamond Cap, Pink LS Diamond Cap, White The Diamond LS Tee*, Black The Diamond LS Tee, Black The Diamond Resort LS Tee, White The Diamond Resort Tee, Black The Diamond Resort Tee, Black LS Diamond Tee, Black D Casino Tee
        unlock_packed_bools(27147, 27182) -- I've Been Shamed Tee, Blue I've Been Shamed Tee, Fame or Shame Stars Tee, Red Fame or Shame Stars Tee, No Talent Required Tee, Red No Talent Required Tee, Team Tracey Tee, Blue Team Tracey Tee, Monkey Business Tee, Red Monkey Business Tee, Fame or Shame Logo Tee, Blue Fame or Shame Logo Tee, Stars Fame or Shame Robe, Black Fame or Shame Robe, Red Stars Fame or Shame Robe, Red Fame or Shame Robe, White Fame or Shame Robe, Black Fame or Shame Shades, Red Fame or Shame Shades, Blue Fame or Shame Shades, White Fame or Shame Shades, Gold Fame or Shame Mics, Silver Fame or Shame Mics, Red Fame or Shame Kronos, Green Fame or Shame Kronos, Blue Fame or Shame Kronos, Black Fame or Shame Kronos, America Loves You Tee, Blue America Loves You Tee, Fame or Shame No Evil Tee, You're So Original! Tee, Red You're So Original! Tee, Oh No He Didn't! Tee, Blue Oh No He Didn't! Tee, You're Awful Tee, Red You're Awful Tee
        unlock_packed_bools(27184, 27213) -- Invade and Persuade Enemies T-Shirt, Invade and Persuade Oil T-Shirt, Invade and Persuade Tour T-Shirt, Invade and Persuade Green T-Shirt, Invade and Persuade RON T-Shirt, Street Crimes Hoods T-Shirt, Street Crimes Punks T-Shirt, Street Crimes Yokels T-Shirt, Street Crimes Bikers T-Shirt, Street Crimes Action T-Shirt, Street Crimes Boxart T-Shirt, Street Crimes Logo T-Shirt, Claim What's Yours T-Shirt, Choose Your Side T-Shirt, Street Crimes Color Gangs T-Shirt, Street Crimes Red Gangs T-Shirt, White Street Crimes Icons T-Shirt, Black Street Crimes Icons T-Shirt, Invade and Persuade Logo T-Shirt, Mission I T-Shirt, Mission II T-Shirt, Mission IV T-Shirt, Mission III T-Shirt, Invade and Persuade Boxart T-Shirt, Invade and Persuade Invader T-Shirt, Invade and Persuade Suck T-Shirt, Invade and Persuade Jets T-Shirt, Invade and Persuade Gold T-Shirt, Invade and Persuade Hero T-Shirt, Invade and Persuade Barrels T-Shirt
        unlock_packed_bools(27247, 27247) -- Madam Nazar (Arcade Trophy)
        unlock_packed_bools(28099, 28148) -- Signal Jammers
        unlock_packed_bools(28158, 28158) -- Navy Revolver
        unlock_packed_bools(28171, 28191) -- Green Reindeer Lights Bodysuit, Ho-Ho-Ho Sweater, Traditional Festive Lights Bodysuit, Yellow Reindeer Lights Bodysuit, Neon Festive Lights Bodysuit, Plushie Grindy T-Shirt, Plushie Saki T-Shirt , Plushie Humpy T-Shirt, Plushie Smoker T-Shirt, Plushie Poopie T-Shirt, Plushie Muffy T-Shirt, Plushie Wasabi Kitty T-Shirt, Plushie Princess T-Shirt, Plushie Master T-Shirt, Pixel Pete's T-Shirt, Wonderama T-Shirt, Warehouse T-Shirt, Eight Bit T-Shirt, Insert Coin T-Shirt, Videogeddon T-Shirt, Nazar Speaks T-Shirt
        unlock_packed_bools(28194, 28196) -- Silent & Sneaky, The Big Con, Aggressive (Elite Challenges)
        unlock_packed_bools(28197, 28222) -- Badlands Revenge II Gunshot T-Shirt, Badlands Revenge II Eagle T-Shirt, Badlands Revenge II Pixtro T-Shirt, Badlands Revenge II Romance T-Shirt, Badlands Revenge II Bear T-Shirt, Badlands Revenge II Help Me T-Shirt & Badlands Revenge II Retro T-Shirt, Race and Chase Decor T-Shirt, Race and Chase Vehicles T-Shirt, Race and Chase Finish T-Shirt, Crotch Rockets T-Shirt, Street Legal T-Shirt & Get Truckin' T-Shirt, Wizard's Ruin Loot T-Shirt, The Wizard's Ruin Rescue T-Shirt, The Wizard's Ruin Vow T-Shirt, Thog Mighty Sword T-Shirt, Thog T-Shirt & Thog Bod T-Shirt, Space Monkey 3 T-Shirt, Space Monkey Space Crafts T-Shirt, Space Monkey Pixel T-Shirt, Space Monkey Boss Fights T-Shirt, Radioactive Space Monkey T-Shirt & Space Monkey Art T-Shirt, Monkey's Paradise T-Shirt, Retro Defender of the Faith T-Shirt, Penetrator T-Shirt, Defender of the Faith T-Shirt, Love Professor His T-Shirt & Love Professor Hers T-Shirt, Love Professor Nemesis T-Shirt, Love Professor Friendzoned T-Shirt, Love Professor Secrets T-Shirt & Love Professor Score T-Shirt, Shiny Wasabi Kitty Claw T-Shirt, Pixtro T-Shirt, Akedo T-Shirt & Arcade Trophy T-Shirt
        unlock_packed_bools(28224, 28227) -- White Dog With Cone T-Shirt, Yellow Dog With Cone T-Shirt, Dog With Cone Slip-Ons & Dog With Cone Chain, Refuse Collectors Outfit, Undertakers Outfit, Valet Outfit
        unlock_packed_bools(28229, 28249) -- Prison Guards, FIB Suits, Black Scuba, Gruppe Sechs Gear, Bugstars Uniforms, Maintenance Outfit, Yung Ancestors Outfit, Firefighter Outfit, Orderly Armor Outfit, Upscale Armor Outfit, Evening Armor Outfit, Reinforced: Padded Combat Outfit, Reinforced: Bulk Combat Outfit, Reinforced: Compact Combat Outfit, Balaclava Crook Outfit, Classic Crook Outfit, High-end Crook Outfit, Infiltration: Upgraded Tech Outfit, Infiltration: Advanced Tech Outfit, Infiltration: Modernized Tech Outfit, Degenatron Glitch T-Shirt
        unlock_packed_bools(28254, 28255) -- Get Metal T-Shirt / Axe of Fury T-Shirt, 11 11 T-Shirt / Axe of Fury T-Shirt
        unlock_packed_bools(30230, 30251) -- Movie Props, Space Interloper Outfit
        unlock_packed_bools(30254, 30295) -- King Of QUB3D T-Shirt, Qubism T-Shirt, God Of QUB3D T-Shirt, QUB3D Boxart T-Shirt, Qub3d Qub3s T-Shirt, Yacht Captain Outfit, BCTR Aged T-Shirt, BCTR T-Shirt, Cultstoppers Aged T-Shirt, Cultstoppers T-Shirt, Daily Globe Aged T-Shirt, Daily Globe T-Shirt, Eyefind Aged T-Shirt, Eyefind T-Shirt, Facade Aged T-Shirt, Facade T-Shirt, Fruit Aged T-Shirt, Fruit T-Shirt, LSHH Aged T-Shirt, LSHH T-Shirt, MyRoom Aged T-Shirt, MyRoom T-Shirt, Rebel Aged T-Shirt, Rebel T-Shirt, Six Figure Aged T-Shirt, Six Figure T-Shirt, Trash Or Treasure Aged T-Shirt, Trash Or Treasure T-Shirt, Tw@ Logo Aged T-Shirt, Tw@ Logo T-Shirt, Vapers Den Aged T-Shirt, Vapers Den T-Shirt, WingIt Aged T-Shirt, WingIt T-Shirt, ZiT Aged T-Shirt, ZiT T-Shirt, Green Dot Tech Mask, Orange Dot Tech Mask, Blue Dot Tech Mask, Pink Dot Tech Mask, Lemon Sports Track Pants, Lemon Sports Track Top
        unlock_packed_bools(30524, 30557) -- Grotti Aged T-Shirt, Lampadati Aged T-Shirt, Ocelot Aged T-Shirt, Overflod Aged T-Shirt, Pegassi Aged T-Shirt, Pfister Aged T-Shirt, Vapid Aged T-Shirt, Weeny Aged T-Shirt, Blue The Diamond Resort LS Aged T-Shirt, KJAH Radio Aged T-Shirt, K-Rose Aged T-Shirt, Emotion 98.3 Aged T-Shirt, KDST Aged T-Shirt, Bounce FM Aged T-Shirt, Fake Vapid Aged T-Shirt, I Married My Dad Aged T-Shirt, ToeShoes Aged T-Shirt, Vanilla Unicorn Aged T-Shirt, Steel Horse Solid Logo Aged T-Shirt, Black Western Logo Aged T-Shirt, White Nagasaki Aged T-Shirt, Black Principe Aged T-Shirt, Noise Aged T-Shirt, Noise Rockstar Logo Aged T-Shirt, Razor Aged T-Shirt, White Rockstar Camo Aged T-Shirt, LSUR Aged T-Shirt, Rebel Radio Aged T-Shirt, Channel X Aged T-Shirt, Albany Vintage Aged T-Shirt, Benefactor Aged T-Shirt, Bravado Aged T-Shirt, Declasse Aged T-Shirt, Dinka Aged T-Shirt
        unlock_packed_bools(30563, 30693) -- Panther Varsity Jacket Closed, Panther Tour Jacket, Broker Prolaps Basketball Top, Panic Prolaps Basketball Top, Gussét Frog T-Shirt, Warped Still Slipping T-Shirt, Yellow Still Slipping T-Shirt, Black Rockstar T-Shirt, Black Exsorbeo 720 Logo T-Shirt, Manor PRBG T-Shirt, Manor Tie-dye T-Shirt, Open Wheel Sponsor T-Shirt, Rockstar Yellow Pattern T-Shirt, Rockstar Gray Pattern T-Shirt, Rockstar Rolling T-Shirt, Santo Capra Patterns Sweater, Rockstar Studio Colors Sweater, Bigness Jackal Sweater, Bigness Tie-dye Sweater, Bigness Faces Sweater, Broker Prolaps Basketball Shorts, Panic Prolaps Basketball Shorts, Exsorbeo 720 Sports Shorts, Bigness Tie-dye Sports Pants, Enus Yeti Forwards Cap, 720 Forwards Cap, Exsorbeo 720 Forwards Cap, Güffy Double Logo Forwards Cap, Rockstar Forwards Cap, Blue Bangles (L), Red Bangles (L), Pink Bangles (L), Yellow Bangles (L), Orange Bangles (L), Green Bangles (L), Red & Blue Bangles (L), Yellow & Orange Bangles (L), Green & Pink Bangles (L), Rainbow Bangles (L), Sunset Bangles (L), Tropical Bangles (L), Blue & Pink Glow Shades, Red Glow Shades, Orange Glow Shades, Yellow Glow Shades, Green Glow Shades, Blue Glow Shades, Pink Glow Shades, Blue & Magenta Glow Shades, Purple & Yellow Glow Shades, Blue & Yellow Glow Shades, Pink & Yellow Glow Shades, Red & Yellow Glow Shades, Blue Glow Necklace, Red Glow Necklace, Pink Glow Necklace, Yellow Glow Necklace, Orange Glow Necklace, Green Glow Necklace, Festival Glow Necklace, Carnival Glow Necklace, Tropical Glow Necklace, Hot Glow Necklace, Neon Glow Necklace, Party Glow Necklace, Sunset Glow Necklace, Radiant Glow Necklace, Sunrise Glow Necklace, Session Glow Necklace, Combat Shotgun, Perico Pistol, White Keinemusik T-Shirt, Blue Keinemusik T-Shirt, Moodymann T-Shirt, Palms Trax T-Shirt, Midnight Tint Oversize Shades, Sunset Tint Oversize Shades, Black Tint Oversize Shades, Blue Tint Oversize Shades, Gold Tint Oversize Shades, Green Tint Oversize Shades, Orange Tint Oversize Shades, Red Tint Oversize Shades, Pink Tint Oversize Shades, Yellow Tint Oversize Shades, Lemon Tint Oversize Shades, Gold Rimmed Oversize Shades, White Checked Round Shades, Pink Checked Round Shades, Yellow Checked Round Shades, Red Checked Round Shades, White Round Shades, Black Round Shades, Pink Tinted Round Shades, Blue Tinted Round Shades, Green Checked Round Shades, Blue Checked Round Shades, Orange Checked Round Shades, Green Tinted Round Shades, Brown Square Shades, Yellow Square Shades, Black Square Shades, Tortoiseshell Square Shades, Green Square Shades, Red Square Shades, Pink Tinted Square Shades, Blue Tinted Square Shades, White Square Shades, Pink Square Shades, All White Square Shades, Mono Square Shades, Green Calavera Mask, Navy Calavera Mask, Cherry Calavera Mask, Orange Calavera Mask, Purple Calavera Mask, Dark Blue Calavera Mask, Lavender Calavera Mask, Yellow Calavera Mask, Pink Calavera Mask, Neon Stitch Emissive Mask, Vibrant Stitch Emissive Mask, Pink Stitch Emissive Mask, Blue Stitch Emissive Mask, Neon Skull Emissive Mask, Vibrant Skull Emissive Mask, Pink Skull Emissive Mask, Orange Skull Emissive Mask, Dark X-Ray Emissive Mask, Bright X-Ray Emissive Mask, Purple X-Ray Emissive Mask
        unlock_packed_bools(30699, 30704) -- Palms Trax LS T-Shirt, Moodymann Whatupdoe T-Shirt, Moodymann Big D T-Shirt, Keinemusik Cayo Perico T-Shirt, Still Slipping Blarneys T-Shirt, Still Slipping Friend T-Shirt
        unlock_packed_bools(31708, 31714) -- CircoLoco Records - Blue EP, CircoLoco Records - Green EP, CircoLoco Records - Violet EP, CircoLoco Records - Black EP, Moodymann - Kenny's Backyard Boogie, NEZ - You Wanna?, NEZ ft. Schoolboy Q - Let's Get It
        unlock_packed_bools(31736, 31736) -- The Frontier Outfit
        unlock_packed_bools(31755, 31755) -- Auto Shop Race 'n Chase
        unlock_packed_bools(31760, 31764) -- Faces of Death T-Shirt, Straight to Video T-Shirt, Monkey See Monkey Die T-Shirt, Trained to Kill T-Shirt, The Director T-Shirt
        unlock_packed_bools(31766, 31777) -- Sprunk Forwards Cap, eCola Forwards Cap, Black Banshee T-Shirt, Blue Banshee T-Shirt, LS Customs T-Shirt, Rockstar Games Typeface T-Shirt, Wasted! T-Shirt, Baseball Bat T-Shirt, Knuckleduster T-Shirt, Rampage T-Shirt, Penitentiary Coveralls, LS Customs Coveralls
        unlock_packed_bools(31779, 31796) -- The Ringleader Outfit, The Knuckles Outfit, The Breaker Outfit, The Dealer Outfit, Bearsy, Banshee Hoodie, eCola Varsity, Sprunk Varsity, LS Customs Varsity, LS Customs Tour Jacket, eCola Bodysuit, Sprunk Bodysuit, Sprunk Chute Bag, eCola Chute Bag, Halloween Chute Bag, Sprunk Chute, eCola Chute, Halloween Chute
        unlock_packed_bools(31805, 31808) -- The Old Hand Outfit, The Overworked Outfit, The Longshoreman Outfit, The Underpaid Outfit
        unlock_packed_bools(31810, 31824) -- Annis ZR350, Pfister Comet S2, Dinka Jester RR, Emperor Vectre, Ubermacht Cypher, Pfister Growler, Karin Calico GTF, Annis Remus, Vapid Dominator ASP, Karin Futo GTX, Dinka RT3000, Vulcar Warrener HKR, Karin Sultan RS Classic, Vapid Dominator GTT, Karin Previon
        unlock_packed_bools(31826, 31858) -- Emperor Forwards Cap / Emperor Backwards Cap, Beige Knit Sneakers, Gray Emperor Classic Hoodie, Pursuit Series (Gameplay), Cyan Check Sleeveless Puffer, Dinka SPL (Wheel Mod), Blue Hayes Retro Racing, White Emperor Motors T-Shirt, Quick Fix (Gameplay), Cyan Check Puffer, Euros - Speed Trail (Livery), Never Barcode Print Hoodie, Hayes Modern Racing, Diversion (Gameplay), Gray Leather Bomber, Futo GTX - Chokusen Dorifuto (Livery), Karin Forwards Cap / Karin Backwards Cap, Cream Knit Sneakers, Private Takeover (Gameplay), Yellow Pfister Hoodie, Retro Turbofan (Wheel Mod), Red Check Sleeveless Puffer, White Hayes Retro Racing, Setup (Gameplay), Navy Emperor Motors T-Shirt, RT3000 - Stance Andreas (Livery), Red Check Puffer, Never Triangle Print Hoodie, Wingman (Gameplay), LTD Modern Racing, Jester RR - 10 Minute Car (Livery), Green Crowex Pro Racing Suit, Mustard Tan Leather Bomber
        unlock_packed_bools(31860, 31863) -- Omnis Forwards Cap / Omnis Backwards Cap, Conical Turbofan (Wheel Mod), Black Knit Sneakers, Green Emperor Classic Hoodie
        unlock_packed_bools(31865, 31868) -- Green Geo Sleeveless Puffer, ZR350 - Atomic Drift Team (Livery), White Globe Oil Retro Racing, Yellow Annis Rally T-Shirt
        unlock_packed_bools(31870, 31928) -- Green Geo Puffer, Warrener HKR - Classic Vulcar (Livery), Life ZigZag Print Hoodie, Blue Dinka Modern Racing, Gray Benefactor Racing Suit, Orange Tan Leather Bomber, Ice Storm (Wheel Mod), Annis Forwards Cap / Annis Backwards Cap, Gray & Purple Knit Sneakers, Black Crowex Pro Racing Suit, Gray Pfister Hoodie, Calico GTF - Fukaru Rally (Livery), Black Geo Sleeveless Puffer, Green Crowex Retro Racing, Blue Xero Gas Racing Suit, Blue Annis Noise T-Shirt, Remus - Blue Lightning (Livery), Black Geo Puffer, Life Static Print Hoodie, Dark Benefactor Racing Suit, Red Dinka Modern Racing, Super Turbine (Wheel Mod), Chestnut Tan Leather Bomber, Vapid Forwards Cap / Vapid Backwards Cap, Red Xero Gas Racing Suit, Gray & Magenta Knit Sneakers, Dominator GTT - Oldschool Oval (Livery), Black Vapid Ellie Hoodie, Cream Bigness Sleeveless Puffer, Wildstyle Racing Suit, Red Globe Oil Retro Racing, Tailgater S - Crevis Race (Livery), Light Dinka T-Shirt, Cream Bigness Puffer, Modern Mesh (Wheel Mod), Never Crosshair Print Hoodie, Euros - Drift Tribe (Livery), Yellow Vapid Modern Racing, Dark Tan Leather Bomber, Forged Star (Wheel Mod), Light Dinka Forwards Cap / Light Dinka Backwards Cap, Futo GTX - Drift King (Livery), Gray & Aqua Knit Sneakers, Gray Karin Hoodie, Showflake (Wheel Mod), Purple Bigness Sleeveless Puffer, RT3000 - Atomic Motorsport (Livery), Black Crowex Retro Racing, Black Annis Noise T-Shirt, Giga Mesh (Wheel Mod), Purple Bigness Puffer, Jester RR - Yogarishima (Livery), Hiding Print Hoodie, Ubermacht Modern Racing, Mesh Meister (Wheel Mod), Ox Blood Leather Bomber, ZR350 - Kisama Chevrons (Livery), Dark Dinka Forwards Cap / Dark Dinka Backwards Cap, White & Pink Knit Sneakers
        unlock_packed_bools(31930, 31933) -- Navy Vapid Ellie Hoodie, Warrener HKR - Classic Vulcar Alt (Livery), Green Aztec Sleeveless Puffer, Calico GTF - Disruption Rally (Livery)
        unlock_packed_bools(31935, 31938) -- Blue Atomic Retro Racing, Remus - Annis Tech (Livery), Dark Dinka T-Shirt, Dominator GTT - Resto Mod Racer (Livery)
        unlock_packed_bools(31940, 31943) -- Green Aztec Puffer, Tailgater S - Redwood (Livery), Life Binary Print Hoodie, Euros - King Scorpion (Livery)
        unlock_packed_bools(31945, 31948) -- White Güffy Modern Racing, Futo GTX - Tandem Battle (Livery), Dark Nut Leather Bomber, RT3000 - Dinka Performance (Livery)
        unlock_packed_bools(31950, 31953) -- White Güffy Forwards Cap / White Güffy Backwards Cap, Jester RR - Fuque (Livery), Gray & Yellow Knit Sneakers, ZR350 - Winning is Winning (Livery)
        unlock_packed_bools(31955, 31958) -- Navy Karin Hoodie, Warrener HKR - Redwood Racing (Livery), Black Aztec Sleeveless Puffer, Calico GTF - Redwood Rally (Livery)
        unlock_packed_bools(31960, 31963) -- Yellow Atomic Retro Racing, Remus - Atomic Motorsport (Livery), Light Vapid Ellie T-Shirt, Dominator GTT - Flame On (Livery)
        unlock_packed_bools(31965, 31968) -- Black Aztec Puffer, Tailgater S - Disruption Logistics (Livery), Lucky Penny Print Hoodie, Euros - Sprunk Light (Livery)
        unlock_packed_bools(31970, 31973) -- Black Güffy Modern Racing, Futo GTX - Itasha Drift (Livery), Navy Blue Leather Bomber, RT3000 - Shiny Wasabi Kitty (Livery)
        unlock_packed_bools(31975, 31978) -- Black Güffy Forwards Cap / Black Güffy Backwards Cap, Jester RR - Xero Gas Rally (Livery), Grayscale Knit Sneakers, ZR350 - Annis Racing Tribal (Livery)
        unlock_packed_bools(31980, 31983) -- Light Obey Hoodie, Warrener HKR - Vulcar Turbo (Livery), Cream Splinter Sleeveless Puffer, Calico GTF - Prolaps Rally (Livery)
        unlock_packed_bools(31985, 31988) -- Blue Redwood Retro Racing, Remus - Shiny Wasabi Kitty (Livery), Dark Vapid Ellie T-Shirt, Dominator GTT - The Patriot (Livery)
        unlock_packed_bools(31990, 31993) -- Cream Splinter Puffer, Tailgater S - Colored Camo Livery (Livery), Light Dinka Modern Racing, Euros - Candybox Gold (Livery)
        unlock_packed_bools(31995, 31998) -- Dark Green Leather Bomber, Futo GTX - Stance Andreas (Livery), Hellion Forwards Cap / Hellion Backwards Cap, RT3000 - Total Fire (Livery)
        unlock_packed_bools(32000, 32003) -- Gray & Cyan Knit Sneakers, Jester RR - Split Siberia (Livery), Black Ubermacht Hoodie, ZR350 - Annis Racing Tribal Alt (Livery)
        unlock_packed_bools(32005, 32008) -- Dark Splinter Sleeveless Puffer, Warrener HKR - Vulcar Turbo Alt (Livery), White Logo Ruiner T-Shirt, Calico GTF - Xero Gas Rally (Livery)
        unlock_packed_bools(32010, 32013) -- Dark Splinter Puffer, Remus - Fukaru Motorsport (Livery), Dark Dinka Modern Racing, Dominator GTT - 70s Street Machine (Livery)
        unlock_packed_bools(32015, 32018) -- White Leather Bomber, Tailgater S - Army Camo Solid (Livery), Lampadati Forwards Cap / Lampadati Backwards Cap, Lilac Knit Sneakers
        unlock_packed_bools(32020, 32023) -- Dark Obey Hoodie, Green Latin Sleeveless Puffer, Gray Vapid Truck T-Shirt, Green Latin Puffer
        unlock_packed_bools(32025, 32028) -- Blue Bravado Modern Racing, Red Leather Bomber, White Knit Sneakers, Red Ubermacht Hoodie
        unlock_packed_bools(32030, 32033) -- Black Latin Sleeveless Puffer, White Obey Omnis T-Shirt, Black Latin Puffer, Black Bravado Modern Racing
        unlock_packed_bools(32035, 32038) -- Ice Knit Sneakers, Blue Annis Noise Hoodie, Orange Camo Sleeveless Puffer, Light Blue Vapid Truck T-Shirt
        unlock_packed_bools(32040, 32043) -- Orange Camo Puffer, Imponte Modern Racing, Aqua Sole Knit Sneakers, Green Emperor Modern Hoodie
        unlock_packed_bools(32045, 32048) -- Aqua Camo Sleeveless Puffer, Black Vapid USA T-Shirt, Aqua Camo Puffer, Xero Modern Racing
        unlock_packed_bools(32050, 32053) -- Smoky Knit Sneakers, Gray Annis Noise Hoodie, Gradient Sleeveless Puffer, Red Obey Omnis T-Shirt
        unlock_packed_bools(32055, 32058) -- Gradient Puffer, White & Gold Knit Sneakers, Dark Emperor Modern Hoodie, Red Logo Ruiner T-Shirt
        unlock_packed_bools(32060, 32063) -- Orange Knit Sneakers, Light Dinka Hoodie, Blue Bravado Gauntlet T-Shirt, Pink Vibrant Knit Sneakers
        unlock_packed_bools(32065, 32074) -- Gold Lampadati Hoodie, Black Bravado Gauntlet T-Shirt, Lime Highlight Knit Sneakers, Dark Dinka Hoodie, Pfister Pocket T-Shirt, Purple Fade Knit Sneakers, Karin 90s T-Shirt, Teal Knit Sneakers, Black & Lime Knit Sneakers, Cyan Fade Knit Sneakers
        unlock_packed_bools(32084, 32084) -- Red Highlight Knit Sneakers
        unlock_packed_bools(32094, 32094) -- Broker Forwards Cap / Broker Backwards Cap
        unlock_packed_bools(32104, 32104) -- Annis Hellion 4x4 T-Shirt
        unlock_packed_bools(32114, 32114) -- Pink Gradient Sleeveless Puffer
        unlock_packed_bools(32124, 32124) -- Fade Broker Modern Racing
        unlock_packed_bools(32134, 32134) -- Tricolor Lampadati Hoodie
        unlock_packed_bools(32144, 32144) -- Mono Leather Bomber
        unlock_packed_bools(32154, 32154) -- Pink Gradient Puffer
        unlock_packed_bools(32164, 32164) -- Red Redwood Retro Racing
        unlock_packed_bools(32174, 32174) -- Crash Out Print Hoodie
        unlock_packed_bools(32224, 32224) -- Tuned For Speed Racing Suit
        unlock_packed_bools(32319, 32323) -- police5 trade price
        unlock_packed_bools(34262, 34361) -- LD Organics
        unlock_packed_bools(32273, 32273) -- White Born x Raised T-Shirt
        unlock_packed_bools(32275, 32275) -- Circoloco T-Shirt
        unlock_packed_bools(32287, 32287) -- Dr. Dre
        unlock_packed_bools(32295, 32311) -- Orange Goldfish, Purple Goldfish, Bronze Goldfish, Clownfish, Juvenile Gull, Sooty Gull, Black-headed Gull, Herring Gull, Brown Sea Lion, Dark Sea Lion, Spotted Sea Lion, Gray Sea Lion, Green Festive T-Shirt, Red Festive T-Shirt, Orange DJ Pooh T-Shirt, White WCC DJ Pooh T-Shirt, Blue WCC DJ Pooh T-Shirt
        unlock_packed_bools(32315, 32316) -- Navy Coveralls, Gray Coveralls, Marathon Hoodie
        unlock_packed_bools(32366, 32366) -- Declasse Draugur (Trade Price)
        unlock_packed_bools(32407, 32408) -- Bottom Dollar Jacket, The Bottom Dollar
        unlock_packed_bools(34372, 34375) -- Horror Pumpkin, Dinka Kanjo SJ (Trade Price), Dinka Postlude (Trade Price), Black LD Organics Cap / White LD Organics T-Shirt
        unlock_packed_bools(34378, 34411) -- Junk Energy Chute Bag, Junk Energy Chute, Pumpkin T-Shirt, Pacific Standard Varsity, Pacific Standard Sweater, Cliffford Varsity, Cliffford Hoodie, The Diamond Casino Varsity, The Diamond Strike Vest, Strickler Hat, Sinsimito Cuban Shirt, CLO_E1M_O_MUM, Manor Geo Forwards Cap, Apricot Perseus Forwards Cap, Still Slipping Tie-dye Forwards Cap, Lemon Festive Beer Hat, Bigness Hand-drawn Dome, Grimy Stitched, Pale Stitched, Gray Cracked Puppet, Blushed Cracked Puppet, Green Emissive Lady Liberty, President, Gold Beat Off Earphones, White Spiked Gauntlet (L), Manor Geo Hoodie, Pumpkin Hoodie, LS Smoking Jacket, Hand-Drawn Biker Bomber, Have You Seen Me? Sweater, Still Slipping Tie-dye T-Shirt, Manor Geo Track Pants, Apricot Perseus Track Pants, Sasquatch
        unlock_packed_bools(34415, 34510) -- Green Vintage Frank, Brown Vintage Frank, Gray Vintage Frank, Pale Vintage Mummy, Green Vintage Mummy, Weathered Vintage Mummy, Conquest, Death, Famine, War, Black Tech Demon, Gray Tech Demon, White Tech Demon, Green Tech Demon, Orange Tech Demon, Purple Tech Demon, Pink Tech Demon, Red Detail Tech Demon, Blue Detail Tech Demon, Yellow Detail Tech Demon, Green Detail Tech Demon, Pink Detail Tech Demon, Orange & Gray Tech Demon, Red Tech Demon, Camo Tech Demon, Aqua Camo Tech Demon, Brown Digital Tech Demon, Gold Tech Demon, Orange & Cream Tech Demon, Green & Yellow Tech Demon, Pink Floral Tech Demon, Black & Green Tech Demon, White & Red Tech Demon, Carbon Tech Demon, Carbon Teal Tech Demon, Black & White Tech Demon, Painted Tiger, Gray Painted Tiger, Gold Painted Tiger, Ornate Painted Tiger, Gray Yeti Flat Cap, Woodland Yeti Flat Cap, Green FB Flat Cap, Blue FB Flat Cap, Gray Lézard Flat Cap, Green Lézard Flat Cap, Light Plaid Lézard Flat Cap, Dark Plaid Lézard Flat Cap, White Striped Lézard Flat Cap, Red Striped Lézard Flat Cap, Brown Crevis Flat Cap, Gray Crevis Flat Cap, Black Broker Flat Cap, Burgundy Broker Flat Cap, White Beat Off Earphones, Yellow Beat Off Earphones, Salmon Beat Off Earphones, Orange Beat Off Earphones, Purple Beat Off Earphones, Pink Beat Off Earphones, Turquoise Beat Off Earphones, Blue Beat Off Earphones, Black Beat Off Earphones, Gray Beat Off Earphones, Teal Beat Off Earphones, Red Beat Off Earphones, Wild Striped Pool Sliders, Neon Striped Pool Sliders, Black SC Coin Pool Sliders, White SC Coin Pool Sliders, Black SC Pattern Pool Sliders, Pink SC Pattern Pool Sliders, Blue SC Pattern Pool Sliders, Camo Yeti Pool Sliders, Gray Camo Yeti Pool Sliders, Black Bigness Pool Sliders, Purple Bigness Pool Sliders, Camo Bigness Pool Sliders, Black Blagueurs Pool Sliders, White Blagueurs Pool Sliders, Pink Blagueurs Pool Sliders, Gray Cimicino Pool Sliders, Rouge Cimicino Pool Sliders, Navy DS Pool Sliders, Red DS Pool Sliders, Floral Güffy Pool Sliders, Green Güffy Pool Sliders, White Güffy Pool Sliders, Blue Heat Pool Sliders, Red ProLaps Pool Sliders, Black LD Organics T-Shirt, Green UFO Boxer Shorts, White UFO Boxer Shorts, Gray Believe Backwards Cap, Black Believe Backwards Cap, Glow Believe Backwards Cap
        unlock_packed_bools(34703, 34705) -- White Vintage Vampire, Dark Green Vintage Vampire, Light Green Vintage Vampire
        unlock_packed_bools(34730, 34737) -- Green Festive Beer Hat, Red Snowflake Beer Hat, Blue Snowflake Beer Hat, Red Holly Beer Hat, Pisswasser Festive Beer Hat, Blarneys Festive Beer Hat, Red Reindeer Beer Hat, Borfmas Beer Hat
        unlock_packed_bools(34761, 34761) -- Gooch Outfit
        unlock_packed_bools(36630, 36654) -- Snowman
        unlock_packed_bools(36699, 36770) -- Ice Vinyl, Ice Vinyl Cut, Mustard Vinyl, Mustard Vinyl Cut, Dark Blue Vinyl, Dark Blue Vinyl Cut, Yellow SN Rooster Revere Collar, Red SC Dragon Revere Collar, Blue SC Dragon Revere Collar, Camo Roses Slab Denim, Orange Trickster Type Denim, Black VDG Cardigan, Blue DS Panthers Cardigan, Red DS Panthers Cardigan, Pink SC Baroque Cardigan, Downtown Cab Co. Revere Collar, Valentines Blazer, 420 Smoking Jacket, Yeti Year of the Rabbit T-Shirt, Gray Yeti Combat Shirt, Black Sprunk Festive, Dark Logger Festive, White Logger Festive, Green Logger Festive, Red Logger Festive, Blue Patriot Logo Festive, Black Patriot Logo Festive, Blue Patriot Festive, Red Patriot Festive, Red Pisswasser Festive, Gold Pisswasser Festive, Red Pisswasser Logo Festive, Gold Pisswasser Logo Festive, Green Pride Brew Festive, Yellow Pride Brew Festive, Yellow Holly Pride Festive, White Holly Pride Festive, Sprunk Snowflakes Festive, Broker Checkerboard T-Shirt, Yeti Ape Tucked T-Shirt, Black Bigness Ski, White Bigness Ski, Black Enema Flourish Ski, Teal Enema Flourish Ski, Magenta Enema Flourish Ski, Camo Roses Slab Forwards, Lime Leopard Slab Forwards, Red SC Dragon Embroidered, Classic DS Tiger Embroidered, Gray DS Tiger Embroidered, Black VDG Bandana Wide, Orange Trickster Type Wide, Gray Yeti Battle Pants, Broker Checkerboard Cargos, 420 Smoking Pants, Camo Roses Slab Canvas, Lime Leopard Slab Canvas, White Signs Squash Ugglies & Socks, Traditional Painted Rabbit, Twilight Painted Rabbit, Noh Painted Rabbit, Lime SC Coin Wraps, Pink SC Coin Wraps, Tan Bracelet Ensemble, Red Manor Round Brow Shades, Le Chien Whistle Necklace, Heartbreak Pendant, Rabbit, Budonk-adonk!, The Red-nosed, The Nutcracker, The GoPostal
        unlock_packed_bools(36774, 36788) -- Johnny On The Spot Polo, The Gooch Mask, Snowman Outfit, Gold New Year Glasses, Silver New Year Glasses, Rainbow New Year Glasses, Yellow Holly Beer Hat, Green Reindeer Beer Hat, Zebra Dome, Purple Snakeskin Spiked, Manor Surano Jacket, Pistol Mk II - Season's Greetings (Livery), Pump Shotgun - Dildodude Camo (Livery), Micro SMG - Dildodude Camo (Livery)
        unlock_packed_bools(36809, 36809) -- Nemesis T-Shirts
        unlock_packed_bools(41316, 41325) -- Ghosts Exposed
        unlock_packed_bools(41593, 41593) -- The Merryweather Outfit
        unlock_packed_bools(41656, 41659) -- Squaddie (Trade Price), Suede Bucks Finish, Employee of the Month Finish, Uncle T Finish
        unlock_packed_bools(41671, 41671) -- Manchez Scout (Trade Price)
        unlock_packed_bools(41802, 41802) -- Johnny On The Spot Polo
        unlock_packed_bools(41894, 41894) -- Hinterland Work T-Shirt
        unlock_packed_bools(41897, 41902) -- Love Fist T-Shirt, San Andreas Federal Reserve T-Shirt, Los Santos, San Andreas T-Shirt, Heist Mask T-Shirt, Los Santos Map T-Shirt, PRB T-Shirt
        unlock_packed_bools(41915, 41980) -- LS Pounders Cap, Vom Feuer Camo Cap, Western MC Cap, Red & White Ammu-Nation Cap, Santo Capra Cap, Alpine Hat, Alien Tracksuit Pants, Scarlet Vintage Devil Mask, Amber Vintage Devil Mask, Green Vintage Devil Mask, Green Vintage Witch Mask, Yellow Vintage Witch Mask, Orange Vintage Witch Mask, Green Vintage Skull Mask, White Vintage Skull Mask, Brown Vintage Skull Mask, Orange Vintage Werewolf Mask, Blue Vintage Werewolf Mask, Brown Vintage Werewolf Mask, Green Vintage Zombie Mask, Brown Vintage Zombie Mask, Teal Vintage Zombie Mask, Turkey Mask, Royal Calacas Mask, Maritime Calacas Mask, Romance Calacas Mask, Floral Calacas Mask, Stanier LE Cruiser (Trade Price), The Homie, The Retired Criminal, The Groupie, Black SC Ornate Mini Dress, Dark Manor Racing Suit, Bright Manor Racing Suit, Hinterland Bomber Jacket, Red Happy Moon T-Shirt, Black Happy Moon T-Shirt, White Happy Moon T-Shirt, Rockstar Says Relax Tucked T-Shirt, Trevor Heist Mask Tucked T-Shirt, Franklin Heist Mask Tucked T-Shirt, Michael Heist Mask Tucked T-Shirt, Bugstars Tucked T-Shirt, STD Contractors Tucked T-Shirt, Black Los Santos Tucked T-Shirt, San Andreas Republic Tucked T-Shirt, Go Go Space Monkey Tucked T-Shirt, Vom Feuer Camo Tucked T-Shirt, Black SC Ornate Tucked T-Shirt, Warstock Tucked T-Shirt, Western San Andreas Tucked T-Shirt, Ride or Die Tucked T-Shirt, Bourgeoix Tucked T-Shirt, Blêuter'd Tucked T-Shirt, Cherenkov Tucked T-Shirt, Moodymann Portrait Tucked T-Shirt, Rockstar Silver Jubilee Tucked T-Shirt, Rockstar NY Hoodie, Dollar Daggers Hoodie, Merryweather Hoodie, Go Go Space Monkey Hoodie, Rockstar Lion Crest T-Shirt, Ammu-Nation Baseball T-Shirt, Alien Hooded Tracksuit Top, Manor Benefactor Surano T-Shirt, LS Smoking Jacket
        unlock_packed_bools(41994, 41994) -- Junk Energy Racing Suit
        unlock_packed_bools(41996, 41996) -- ??? T-Shirt
        unlock_packed_bools(42054, 42054) -- Strapz Bandana
        unlock_packed_bools(42063, 42063) -- The LS Panic
        unlock_packed_bools(42068, 42069) -- Snowman Finish, Santa's Helper Finish
        unlock_packed_bools(42111, 42111) -- The Coast Guard
        unlock_packed_bools(42119, 42123) -- Yeti Outfit, Snowman Finish, Santa's Helper Finish, Skull Santa Finish, riot unlocked
        unlock_packed_bools(42125, 42125) -- riot trade price
        unlock_packed_bools(42128, 42146) -- eCola Festive Sweater, Sprunk Festive Sweater, 1 Party Hat, 2 Party Hat, 3 Party Hat, 4 Party Hat, 5 Party Hat, 6 Party Hat, 7 Party Hat, 8 Party Hat, 9 Party Hat, 10 Party Hat, 11 Party Hat, 12 Party Hat, 13 Party Hat, 14 Party Hat, 15 Party Hat, Bronze Party Outfit, Silver Party Outfit
        unlock_packed_bools(42148, 42149) -- Snowball Launcher, DâM-FunK - Even the Score
        unlock_packed_bools(42152, 42190) -- The LSDS, The McTony Security, Wooden Dragon Mask, Contrast Dragon Mask, Regal Dragon Mask, Midnight Dragon Mask, Pink Heart Shades, Red Heart Shades, Orange Heart Shades, Yellow Heart Shades, Green Heart Shades, Blue Heart Shades, Purple Heart Shades, Black Heart Shades, Fireworks Bucket Hat, Stars and Stripes Bucket Hat, Lady Liberty Bucket Hat, Green Festive Tree Hat, Red Festive Tree Hat, Brown Festive Reindeer Hat, White Festive Reindeer Hat, Bronze New Year's Hat, Gold New Year's Hat, Silver New Year's Hat, Sprunk x eCola Bodysuit, Rockstar Racing Suit, Rockstar Helmet, Coil Earth Day Tee, IR Earth Day Tee, White High Brass Tee, Black High Brass Tee, Black Lunar New Year Tee, Bigness Carnival Sports Tee, Green 420 Dress, Red Lunar New Year Dress, Carnival Sun Dress, Carnival Bandana, Bigness Carnival Bucket Hat, Black 420 Forwards Cap
        unlock_packed_bools(42217, 42217) -- Cluckin' Bell Forwards Cap
        unlock_packed_bools(42233, 42234) -- BOXVILLE6, BENSON2
        unlock_packed_bools(42239, 42242) -- CAVALCADE3, IMPALER5, POLGAUNTLET, DORADO
        unlock_packed_bools(42244, 42247) -- BALLER8, TERMINUS, BOXVILLE6, BENSON2
        unlock_packed_bools(42249, 42249) -- Candy Cane
        unlock_packed_bools(42280, 42284) -- Unlock pizzaboy, poldominator10, poldorado, polimpaler5, polimpaler6 trade price.
        unlock_packed_bools(42257, 42268) -- The Street Artist, Ghosts Exposed 2024, Ghosts Exposed Outfit
        unlock_packed_bools(42286, 42287) -- Ludendorff Survivor, Pizza This... Forwards Cap, Pizza This... Backwards Cap, Pizza This... Outfit
        unlock_packed_bools(51189, 51189) -- Spray Can
        unlock_packed_bools(51196, 51197) -- The Shocker, Bottom Dollar Bail Enforcement tint for Stungun
        unlock_packed_bools(51215, 51258) -- Alpine Outfit, Brown Alpine Hat, Pisswasser Good Time Tee, Gold Pisswasser Shorts, Mid Autumn Festival Shirt, Mid Autumn Festival Sundress (female), Día de Muertos Tee, Halloween Spooky Tee, Black Demon Goat Mask, Red Demon Goat Mask, Tan Demon Goat Mask, Black Creepy Cat Mask, Gray Creepy Cat Mask, Brown Creepy Cat Mask, Gray Hooded Skull Mask, Red Hooded Skull Mask, Blue Hooded Skull Mask, Red Flaming Skull Mask, Green Flaming Skull Mask, Orange Flaming Skull Mask, Orange Glow Skeleton Onesie, Purple Glow Skeleton Onesie, Green Glow Skeleton Onesie, Tan Turkey, Brown Turkey, Rockstar Red Logo Sweater, Silver Gun Necklace, Black Gun Necklace, Gold Gun Necklace, Rose Gun Necklace, Bronze Gun Necklace, Black Yeti Fall Sweater, White Yeti Fall Sweater, Red Yeti Fall Sweater, The Diamond Jackpot Tee, Cobalt Jackal Racing Jersey, Cobalt Jackal Racing Pants, Khaki 247 Chino Pants, Demon Biker Jacket, Purple Güffy Cardigan, SA Denim Biker Jacket, Green 247 Shirt, Barbed Wire Shirt, Ride or Die Gaiter, Pizza This... Tee
        if is_player_male then
            unlock_packed_bools(3483, 3492) -- Death Defying T-Shirt (Male), For Hire T-Shirt (Male), Gimme That T-Shirt (Male), Asshole T-Shirt (Male), Can't Touch This T-Shirt (Male), Decorated T-Shirt (Male), Psycho Killer T-Shirt (Male), One Man Army T-Shirt (Male), Shot Caller T-Shirt (Male), Showroom T-Shirt (Male)
            unlock_packed_bools(6082, 6083) -- Black Benny's T-Shirt, White Benny's T-Shirt
            unlock_packed_bools(6097, 6097) -- I Heart LC (T-Shirt) (Male)
            unlock_packed_bools(6169, 6169) -- DCTL T-Shirt (Male)
            unlock_packed_bools(6303, 6304) -- Crosswalk Tee (Male), R* Crosswalk Tee (Male)
            unlock_packed_bools(15708, 15708) -- Black The Black Madonna Emb. Tee (Male)
            unlock_packed_bools(15710, 15710) -- The Black Madonna Star Tee (Male)
            unlock_packed_bools(15717, 15717) -- White Dixon Repeated Logo Tee (Male)
            unlock_packed_bools(15720, 15720) -- Black Dixon Wilderness Tee (Male)
            unlock_packed_bools(15724, 15724) -- Tale Of Us Black Box Tee (Male)
            unlock_packed_bools(15728, 15728) -- Black Tale Of Us Emb. Tee (Male)
            unlock_packed_bools(15730, 15730) -- Black Solomun Yellow Logo Tee (Male)
            unlock_packed_bools(15732, 15732) -- White Solomun Tee (Male)
            unlock_packed_bools(15737, 15737) -- ??? (Tattoo) (Male)
            unlock_packed_bools(15887, 15887) -- Lucky 7s (Tattoo) (Male)
            unlock_packed_bools(15894, 15894) -- The Royals (Tattoo) (Male)
            unlock_packed_bools(28393, 28416) -- Badlands Revenge II Retro Tee (Male), Badlands Revenge II Pixtro Tee (Male), Degenatron Glitch Tee (Male), Degenatron Logo Tee (Male), The Wizard's Ruin Rescue Tee (Male), The Wizard's Ruin Vow Tee (Male), Space Monkey Art Tee (Male), Crotch Rockets Tee (Male), Street Legal Tee (Male), Get Truckin' Tee (Male), Arcade Trophy Tee (Male), Videogeddon Tee (Male), Insert Coin Tee (Male), Plushie Princess Tee (Male), Plushie Wasabi Kitty Tee (Male), Plushie Master Tee (Male), Plushie Muffy Tee (Male), Plushie Humpy Tee (Male), Plushie Saki Tee (Male), Plushie Grindy Tee (Male), Plushie Poopie Tee (Male), Plushie Smoker Tee (Male), Shiny Wasabi Kitty Claw Tee (Male), Nazar Speaks Tee (Male)
            unlock_packed_bools(28447, 28451) -- 11 11 Tee (Male), King Of QUB3D Tee (Male), Qubism Tee (Male), God Of QUB3D Tee (Male), QUB3D Boxart Tee (Male)
            unlock_packed_bools(28452, 28478) -- Channel X Aged Tee (Male), Rebel Radio Aged Tee (Male), LSUR Aged Tee (Male), Steel Horse Solid Logo Aged Tee (Male), Black Western Logo Aged Tee (Male), White Nagasaki Aged Tee (Male), Black Principe Aged Tee (Male), Albany Vintage Aged Tee (Male), Benefactor Aged Tee (Male), Bravado Aged Tee (Male), Declasse Aged Tee (Male), Dinka Aged Tee (Male), Grotti Aged Tee (Male), Lampadati Aged Tee (Male), Ocelot Aged Tee (Male), Overflod Aged Tee (Male), Pegassi Aged Tee (Male), Pfister Aged Tee (Male), Vapid Aged Tee (Male), Weeny Aged Tee (Male), Toe Shoes Aged T-Shirt (Male), Vanilla Unicorn Aged T-Shirt (Male), Fake Vapid Aged T-Shirt (Male), I Married My Dad Aged T-Shirt (Male), White Rockstar Camo Aged Tee (Male), Razor Aged T-Shirt (Male), Noise Rockstar Logo Aged Tee (Male)
            unlock_packed_bools(30355, 30361) -- Noise Aged Tee (Male), Emotion 98.3 Aged T-Shirt (Male), KDST Aged T-Shirt (Male), KJAH Radio Aged T-Shirt (Male), Bounce FM Aged T-Shirt (Male), K-Rose Aged T-Shirt (Male), Blue The Diamond Resort LS Aged Tee (Male)
            unlock_packed_bools(30407, 30410) -- White Keinemusik Tee (Male), Blue Keinemusik Tee (Male), Moodymann Tee (Male), Palms Trax Tee (Male)
            unlock_packed_bools(30418, 30422) -- Faces of Death Tee (Male), Straight to Video Tee (Male), Monkey See Monkey Die Tee (Male), Trained to Kill Tee (Male), The Director Tee (Male)
            unlock_packed_bools(41273, 41284) -- Monkey (Tattoo) (Male), Dragon (Tattoo) (Male), Snake (Tattoo) (Male), Goat (Tattoo) (Male), Rat (Tattoo) (Male), Rabbit (Tattoo) (Male), Ox (Tattoo) (Male), Pig (Tattoo) (Male), Rooster (Tattoo) (Male), Dog (Tattoo) (Male), Horse (Tattoo) (Male), Tiger (Tattoo) (Male)
            unlock_packed_bools(41293, 41293) -- Hinterland Work T-Shirt (Male)
        else
            unlock_packed_bools(3496, 3505) -- Death Defying Top (Female), For Hire Top (Female), Gimme That Top (Female), Asshole Top (Female), Can't Touch This Top (Female), Decorated Top (Female), Psycho Killer Top (Female), One Man Army Top (Female), Shot Caller Top (Female), Showroom Top (Female)
            unlock_packed_bools(6091, 6092) -- Black Benny's T-Shirt, White Benny's T-Shirt
            unlock_packed_bools(6106, 6106) -- I Heart LC (T-Shirt) (Female)
            unlock_packed_bools(6181, 6181) -- DCTL T-Shirt (Female)
            unlock_packed_bools(6316, 6317) -- Crosswalk Tee (Female), R* Crosswalk Tee (Female)
            unlock_packed_bools(15719, 15719) -- Black The Black Madonna Emb. Tee (Female)
            unlock_packed_bools(15721, 15721) -- The Black Madonna Star Tee (Female)
            unlock_packed_bools(15728, 15728) -- White Dixon Repeated Logo Tee (Female)
            unlock_packed_bools(15731, 15731) -- Black Dixon Wilderness Tee (Female)
            unlock_packed_bools(15735, 15735) -- Tale Of Us Black Box Tee (Female)
            unlock_packed_bools(15739, 15739) -- Black Tale Of Us Emb. Tee (Female)
            unlock_packed_bools(15741, 15741) -- Black Solomun Yellow Logo Tee (Female)
            unlock_packed_bools(15743, 15743) -- White Solomun Tee (Female)
            unlock_packed_bools(15748, 15748) -- ??? (Tattoo) (Female)
            unlock_packed_bools(15898, 15898) -- Lucky 7s (Tattoo) (Female)
            unlock_packed_bools(15905, 15905) -- The Royals (Tattoo) (Female)
            unlock_packed_bools(28404, 28427) -- Badlands Revenge II Retro Tee (Female), Badlands Revenge II Pixtro Tee (Female), Degenatron Glitch Tee (Female), Degenatron Logo Tee (Female), The Wizard's Ruin Rescue Tee (Female), The Wizard's Ruin Vow Tee (Female), Space Monkey Art Tee (Female), Crotch Rockets Tee (Female), Street Legal Tee (Female), Get Truckin' Tee (Female), Arcade Trophy Tee (Female), Videogeddon Tee (Female), Insert Coin Tee (Female), Plushie Princess Tee (Female), Plushie Wasabi Kitty Tee (Female), Plushie Master Tee (Female), Plushie Muffy Tee (Female), Plushie Humpy Tee (Female), Plushie Saki Tee (Female), Plushie Grindy Tee (Female), Plushie Poopie Tee (Female), Plushie Smoker Tee (Female), Shiny Wasabi Kitty Claw Tee (Female), Nazar Speaks Tee (Female)
            unlock_packed_bools(28458, 28462) -- 11 11 Tee (Female), King Of QUB3D Tee (Female), Qubism Tee (Female), God Of QUB3D Tee (Female), QUB3D Boxart Tee (Female)
            unlock_packed_bools(28463, 28478) -- Channel X Aged Tee (Female), Rebel Radio Aged Tee (Female), LSUR Aged Tee (Female), Steel Horse Solid Logo Aged Tee (Female), Black Western Logo Aged Tee (Female), White Nagasaki Aged Tee (Female), Black Principe Aged Tee (Female), Albany Vintage Aged Tee (Female), Benefactor Aged Tee (Female), Bravado Aged Tee (Female), Declasse Aged Tee (Female), Dinka Aged Tee (Female), Grotti Aged Tee (Female), Lampadati Aged Tee (Female), Ocelot Aged Tee (Female), Overflod Aged Tee (Female)
            unlock_packed_bools(30418, 30421) -- White Keinemusik Tee (Female), Blue Keinemusik Tee (Female), Moodymann Tee (Female), Palms Trax Tee (Female)
            unlock_packed_bools(30355, 30372) -- Pegassi Aged Tee (Female), Pfister Aged Tee (Female), Vapid Aged Tee (Female), Weeny Aged Tee (Female), Toe Shoes Aged T-Shirt (Female), Vanilla Unicorn Aged T-Shirt (Female), Fake Vapid Aged T-Shirt (Female), I Married My Dad Aged T-Shirt (Female), White Rockstar Camo Aged Tee (Female), Razor Aged T-Shirt (Female), Noise Rockstar Logo Aged Tee (Female), Noise Aged Tee (Female), Emotion 98.3 Aged T-Shirt (Female), KDST Aged T-Shirt (Female), KJAH Radio Aged T-Shirt (Female), Bounce FM Aged T-Shirt (Female), K-Rose Aged T-Shirt (Female), Blue The Diamond Resort LS Aged Tee (Female)
            unlock_packed_bools(30429, 30433) -- Faces of Death Tee (Female), Straight to Video Tee (Female), Monkey See Monkey Die Tee (Female), Trained to Kill Tee (Female), The Director Tee (Female)
            unlock_packed_bools(41285, 41296) -- Monkey (Tattoo) (Female), Dragon (Tattoo) (Female), Snake (Tattoo) (Female), Goat (Tattoo) (Female), Rat (Tattoo) (Female), Rabbit (Tattoo) (Female), Ox (Tattoo) (Female), Pig (Tattoo) (Female), Rooster (Tattoo) (Female), Dog (Tattoo) (Female), Horse (Tattoo) (Female), Tiger (Tattoo) (Female)
            unlock_packed_bools(41304, 41304) -- Hinterland Work T-Shirt (Female)
        end
        stats.set_int(MPX() .. "GANGOPS_FLOW_MISSION_PROG", 240)
        stats.set_int(MPX() .. "GANGOPS_HEIST_STATUS", 229378)
        stats.set_int(MPX() .. "GANGOPS_FLOW_NOTIFICATIONS", 1557)
        stats.set_int(MPX() .. "GANGOPS_FLOW_MISSION_PROG", 240)
        stats.set_int(MPX() .. "GANGOPS_HEIST_STATUS", 229378)
        stats.set_int(MPX() .. "GANGOPS_FLOW_NOTIFICATIONS", 1557)
        stats.set_int(MPX() .. "GANGOPS_FLOW_MISSION_PROG", 16368)
        stats.set_int(MPX() .. "GANGOPS_HEIST_STATUS", 229380)
        stats.set_int(MPX() .. "GANGOPS_FLOW_NOTIFICATIONS", 1557)
        stats.set_int(MPX() .. "FIXER_GENERAL_BS", -1)
        stats.set_int(MPX() .. "FIXER_COMPLETED_BS", -1)
        stats.set_int(MPX() .. "FIXER_STORY_BS", -1)
        stats.set_int(MPX() .. "FIXER_STORY_STRAND", -1)
        stats.set_int(MPX() .. "FIXER_STORY_COOLDOWN", -1)
        stats.set_int(MPX() .. "FIXER_SC_VEH_RECOVERED", 100)
        stats.set_int(MPX() .. "FIXER_SC_VAL_RECOVERED", 100)
        stats.set_int(MPX() .. "FIXER_SC_GANG_TERMINATED", 100)
        stats.set_int(MPX() .. "FIXER_SC_VIP_RESCUED", 100)
        stats.set_int(MPX() .. "FIXER_SC_ASSETS_PROTECTED", 100)
        stats.set_int(MPX() .. "FIXER_SC_EQ_DESTROYED", 100)
        stats.set_int(MPX() .. "FIXER_COUNT", 500)
        stats.set_int(MPX() .. "FIXER_EARNINGS", 26340756)
        stats.set_int(MPX() .. "PAYPHONE_BONUS_KILL_METHOD", -1)
        stats.set_int("MPPLY_XMASLIVERIES0", -1)
        stats.set_int("MPPLY_XMASLIVERIES1", -1)
        stats.set_int("MPPLY_XMASLIVERIES2", -1)
        stats.set_int("MPPLY_XMASLIVERIES3", -1)
        stats.set_int("MPPLY_XMASLIVERIES5", -1)
        stats.set_int("MPPLY_XMASLIVERIES6", -1)
        stats.set_int("MPPLY_XMASLIVERIES7", -1)
        stats.set_int("MPPLY_XMASLIVERIES8", -1)
        stats.set_int("MPPLY_XMASLIVERIES9", -1)
        stats.set_int("MPPLY_XMASLIVERIES10", -1)
        stats.set_int("MPPLY_XMASLIVERIES11", -1)
        stats.set_int("MPPLY_XMASLIVERIES12", -1)
        stats.set_int("MPPLY_XMASLIVERIES13", -1)
        stats.set_int("MPPLY_XMASLIVERIES14", -1)
        stats.set_int("MPPLY_XMASLIVERIES15", -1)
        stats.set_int("MPPLY_XMASLIVERIES16", -1)
        stats.set_int("MPPLY_XMASLIVERIES17", -1)
        stats.set_int("MPPLY_XMASLIVERIES18", -1)
        stats.set_int("MPPLY_XMASLIVERIES19", -1)
        stats.set_int("MPPLY_XMASLIVERIES20", -1)
        stats.set_int(MPX() .. "AWD_WATCH_YOUR_STEP", 15)
        stats.set_int(MPX() .. "AWD_TOWER_OFFENSE", 15)
        stats.set_int(MPX() .. "AWD_READY_FOR_WAR", 60)
        stats.set_int(MPX() .. "AWD_THROUGH_A_LENS", 60)
        stats.set_int(MPX() .. "AWD_SPINNER", 60)
        stats.set_int(MPX() .. "AWD_YOUMEANBOOBYTRAPS", 15)
        stats.set_int(MPX() .. "AWD_MASTER_BANDITO", 12)
        stats.set_int(MPX() .. "AWD_SITTING_DUCK", 60)
        stats.set_int(MPX() .. "AWD_CROWDPARTICIPATION", 60)
        stats.set_int(MPX() .. "AWD_KILL_OR_BE_KILLED", 60)
        stats.set_int(MPX() .. "AWD_MASSIVE_SHUNT", 60)
        stats.set_int(MPX() .. "AWD_YOURE_OUTTA_HERE", 110)
        stats.set_int(MPX() .. "AWD_WEVE_GOT_ONE", 52)
        stats.set_int(MPX() .. "AWD_TIME_SERVED", 110)
        stats.set_int(MPX() .. "AWD_CAREER_WINNER", 110)
        stats.set_int(MPX() .. "AWD_ARENA_WAGEWORKER", 1100000)
        stats.set_int(MPX() .. "CH_ARC_CAB_CLAW_TROPHY", -1)
        stats.set_int(MPX() .. "CH_ARC_CAB_LOVE_TROPHY", -1)
        stats.set_int(MPX() .. "AWD_PREPARATION", 40)
        stats.set_int(MPX() .. "AWD_ASLEEPONJOB", 20)
        stats.set_int(MPX() .. "AWD_DAICASHCRAB", 100000)
        stats.set_int(MPX() .. "AWD_BIGBRO", 40)
        stats.set_int(MPX() .. "AWD_SHARPSHOOTER", 40)
        stats.set_int(MPX() .. "AWD_RACECHAMP", 40)
        stats.set_int(MPX() .. "AWD_BATSWORD", 1000000)
        stats.set_int(MPX() .. "AWD_COINPURSE", 950000)
        stats.set_int(MPX() .. "AWD_ASTROCHIMP", 3000000)
        stats.set_int(MPX() .. "AWD_MASTERFUL", 40000)
        stats.set_int(MPX() .. "SCGW_NUM_WINS_GANG_0", 50)
        stats.set_int(MPX() .. "SCGW_NUM_WINS_GANG_1", 50)
        stats.set_int(MPX() .. "SCGW_NUM_WINS_GANG_2", 50)
        stats.set_int(MPX() .. "SCGW_NUM_WINS_GANG_3", 50)
        stats.set_int(MPX() .. "IAP_MA0_MOON_DIST", 2147483647)
        stats.set_int(MPX() .. "AWD_FACES_OF_DEATH", 50)
        stats.set_int(MPX() .. "HEIST_PLANNING_STAGE", -1)
        stats.set_int(MPX() .. "LIFETIME_BKR_SELL_EARNINGS5", 50000000)
        stats.set_int(MPX() .. "VCM_FLOW_PROGRESS", -1)
        stats.set_int(MPX() .. "VCM_STORY_PROGRESS", -1)
        stats.set_int(MPX() .. "MKRIFLE_MK2_KILLS", 500)
        stats.set_int(MPX() .. "MKRIFLE_MK2_DEATHS", 100)
        stats.set_int(MPX() .. "MKRIFLE_MK2_SHOTS", 500)
        stats.set_int(MPX() .. "MKRIFLE_MK2_HITS", 500)
        stats.set_int(MPX() .. "MKRIFLE_MK2_HEADSHOTS", 500)
        stats.set_int(MPX() .. "MKRIFLE_MK2_HELDTIME", 5963259)
        stats.set_int(MPX() .. "MKRIFLE_MK2_DB_HELDTIME", 5963259)
        stats.set_int(MPX() .. "MKRIFLE_MK2_ENEMY_KILLS", 500)
        stats.set_int(MPX() .. "AWD_ODD_JOBS", 52)
        stats.set_int(MPX() .. "AWD_PREPARATION", 50)
        stats.set_int(MPX() .. "AWD_ASLEEPONJOB", 20)
        stats.set_int(MPX() .. "AWD_DAICASHCRAB", 100000)
        stats.set_int(MPX() .. "AWD_BIGBRO", 40)
        stats.set_int(MPX() .. "HIGHEST_SKITTLES", 900)
        stats.set_int(MPX() .. "LAP_DANCED_BOUGHT", 100)
        stats.set_int(MPX() .. "CARS_EXPLODED", 500)
        stats.set_int(MPX() .. "CARS_COPS_EXPLODED", 300)
        stats.set_int(MPX() .. "BIKES_EXPLODED", 100)
        stats.set_int(MPX() .. "BOATS_EXPLODED", 168)
        stats.set_int(MPX() .. "HELIS_EXPLODED", 98)
        stats.set_int(MPX() .. "PLANES_EXPLODED", 138)
        stats.set_int(MPX() .. "QUADBIKE_EXPLODED", 50)
        stats.set_int(MPX() .. "BICYCLE_EXPLODED", 48)
        stats.set_int(MPX() .. "SUBMARINE_EXPLODED", 28)
        stats.set_int(MPX() .. "DEATHS", 499)
        stats.set_int(MPX() .. "DIED_IN_DROWNING", 833)
        stats.set_int(MPX() .. "DIED_IN_DROWNINGINVEHICLE", 833)
        stats.set_int(MPX() .. "DIED_IN_EXPLOSION", 833)
        stats.set_int(MPX() .. "DIED_IN_FALL", 833)
        stats.set_int(MPX() .. "DIED_IN_FIRE", 833)
        stats.set_int(MPX() .. "DIED_IN_ROAD", 833)
        stats.set_int(MPX() .. "NO_PHOTOS_TAKEN", 100)
        stats.set_int(MPX() .. "PROSTITUTES_FREQUENTED", 100)
        stats.set_int(MPX() .. "BOUNTSONU", 200)
        stats.set_int(MPX() .. "BOUNTPLACED", 500)
        stats.set_int(MPX() .. "PASS_DB_KILLS", 300)
        stats.set_int(MPX() .. "PASS_DB_PLAYER_KILLS", 300)
        stats.set_int(MPX() .. "PASS_DB_SHOTS", 300)
        stats.set_int(MPX() .. "PASS_DB_HITS", 300)
        stats.set_int(MPX() .. "PASS_DB_HITS_PEDS_VEHICLES", 300)
        stats.set_int(MPX() .. "PASS_DB_HEADSHOTS", 300)
        stats.set_int(MPX() .. "TIRES_POPPED_BY_GUNSHOT", 500)
        stats.set_int(MPX() .. "NUMBER_STOLEN_COP_VEHICLE", 300)
        stats.set_int(MPX() .. "NUMBER_STOLEN_CARS", 300)
        stats.set_int(MPX() .. "NUMBER_STOLEN_BIKES", 300)
        stats.set_int(MPX() .. "NUMBER_STOLEN_BOATS", 300)
        stats.set_int(MPX() .. "NUMBER_STOLEN_HELIS", 300)
        stats.set_int(MPX() .. "NUMBER_STOLEN_PLANES", 300)
        stats.set_int(MPX() .. "NUMBER_STOLEN_QUADBIKES", 300)
        stats.set_int(MPX() .. "NUMBER_STOLEN_BICYCLES", 300)
        stats.set_int(MPX() .. "FAVOUTFITBIKETIMECURRENT", 884483972)
        stats.set_int(MPX() .. "FAVOUTFITBIKETIME1ALLTIME", 884483972)
        stats.set_int(MPX() .. "FAVOUTFITBIKETYPECURRENT", 884483972)
        stats.set_int(MPX() .. "FAVOUTFITBIKETYPEALLTIME", 884483972)
        stats.set_int(MPX() .. "MC_CONTRIBUTION_POINTS", 1000)
        stats.set_int(MPX() .. "MEMBERSMARKEDFORDEATH", 700)
        stats.set_int(MPX() .. "MCKILLS", 500)
        stats.set_int(MPX() .. "MCDEATHS", 700)
        stats.set_int(MPX() .. "RIVALPRESIDENTKILLS", 700)
        stats.set_int(MPX() .. "RIVALCEOANDVIPKILLS", 700)
        stats.set_int(MPX() .. "MELEEKILLS", 700)
        stats.set_int(MPX() .. "CLUBHOUSECONTRACTSCOMPLETE", 700)
        stats.set_int(MPX() .. "CLUBHOUSECONTRACTEARNINGS", 32698547)
        stats.set_int(MPX() .. "CLUBCHALLENGESCOMPLETED", 700)
        stats.set_int(MPX() .. "MEMBERCHALLENGESCOMPLETED", 700)
        stats.set_int(MPX() .. "HITS", 100000)
        stats.set_int(MPX() .. "MKRIFLE_KILLS", 500)
        stats.set_int(MPX() .. "MKRIFLE_DEATHS", 100)
        stats.set_int(MPX() .. "MKRIFLE_SHOTS", 500)
        stats.set_int(MPX() .. "MKRIFLE_HITS", 500)
        stats.set_int(MPX() .. "MKRIFLE_HEADSHOTS", 500)
        stats.set_int(MPX() .. "MKRIFLE_HELDTIME", 5963259)
        stats.set_int(MPX() .. "MKRIFLE_DB_HELDTIME", 5963259)
        stats.set_int(MPX() .. "MKRIFLE_ENEMY_KILLS", 500)
        stats.set_int(MPX() .. "BETAMOUNT", 500)
        stats.set_int(MPX() .. "GHKILLS", 500)
        stats.set_int(MPX() .. "HORDELVL", 10)
        stats.set_int(MPX() .. "HORDKILLS", 500)
        stats.set_int(MPX() .. "UNIQUECRATES", 500)
        stats.set_int(MPX() .. "BJWINS", 500)
        stats.set_int(MPX() .. "HORDEWINS", 500)
        stats.set_int(MPX() .. "MCMWINS", 500)
        stats.set_int(MPX() .. "GANGHIDWINS", 500)
        stats.set_int(MPX() .. "KILLS", 800)
        stats.set_int(MPX() .. "HITS_PEDS_VEHICLES", 100)
        stats.set_int(MPX() .. "SHOTS", 1000)
        stats.set_int(MPX() .. "HEADSHOTS", 100)
        stats.set_int(MPX() .. "KILLS_ARMED", 650)
        stats.set_int(MPX() .. "SUCCESSFUL_COUNTERS", 100)
        stats.set_int(MPX() .. "KILLS_PLAYERS", 3593)
        stats.set_int(MPX() .. "DEATHS_PLAYER", 1002)
        stats.set_int(MPX() .. "KILLS_STEALTH", 100)
        stats.set_int(MPX() .. "KILLS_INNOCENTS", 500)
        stats.set_int(MPX() .. "KILLS_ENEMY_GANG_MEMBERS", 100)
        stats.set_int(MPX() .. "KILLS_FRIENDLY_GANG_MEMBERS", 100)
        stats.set_int(MPX() .. "KILLS_BY_OTHERS", 100)
        stats.set_int(MPX() .. "HITS", 600)
        stats.set_int(MPX() .. "BIGGEST_VICTIM_KILLS", 500)
        stats.set_int(MPX() .. "ARCHENEMY_KILLS", 500)
        stats.set_int(MPX() .. "CRARMWREST", 500)
        stats.set_int(MPX() .. "CRBASEJUMP", 500)
        stats.set_int(MPX() .. "CRDARTS", 500)
        stats.set_int(MPX() .. "CRDM", 500)
        stats.set_int(MPX() .. "CRGANGHIDE", 500)
        stats.set_int(MPX() .. "CRGOLF", 500)
        stats.set_int(MPX() .. "CRHORDE", 500)
        stats.set_int(MPX() .. "CRMISSION", 500)
        stats.set_int(MPX() .. "CRSHOOTRNG", 500)
        stats.set_int(MPX() .. "CRTENNIS", 500)
        stats.set_int(MPX() .. "TOTAL_TIME_CINEMA", 2147483647)
        stats.set_int(MPX() .. "NO_TIMES_CINEMA", 500)
        stats.set_int(MPX() .. "TIME_AS_A_PASSENGER", 2147483647)
        stats.set_int(MPX() .. "TIME_AS_A_DRIVER", 2147483647)
        stats.set_int(MPX() .. "TIME_SPENT_FLYING", 2147483647)
        stats.set_int(MPX() .. "TIME_IN_CAR", 2147483647)
        stats.set_int(MPX() .. "LIFETIME_BKR_SELL_UNDERTABC", 500)
        stats.set_int(MPX() .. "LIFETIME_BKR_SELL_COMPLETBC", 500)
        stats.set_int(MPX() .. "BKR_PROD_STOP_COUT_S1_0", 500)
        stats.set_int(MPX() .. "BKR_PROD_STOP_COUT_S2_0", 500)
        stats.set_int(MPX() .. "BKR_PROD_STOP_COUT_S3_0", 500)
        stats.set_int(MPX() .. "LFETIME_BIKER_BUY_UNDERTA1", 500)
        stats.set_int(MPX() .. "LFETIME_BIKER_BUY_COMPLET1", 500)
        stats.set_int(MPX() .. "LFETIME_BIKER_SELL_UNDERTA1", 500)
        stats.set_int(MPX() .. "LFETIME_BIKER_SELL_COMPLET1", 500)
        stats.set_int(MPX() .. "LIFETIME_BKR_SEL_UNDERTABC1", 500)
        stats.set_int(MPX() .. "LIFETIME_BKR_SEL_COMPLETBC1", 500)
        stats.set_int(MPX() .. "BKR_PROD_STOP_COUT_S1_1", 500)
        stats.set_int(MPX() .. "BKR_PROD_STOP_COUT_S2_1", 500)
        stats.set_int(MPX() .. "BKR_PROD_STOP_COUT_S3_1", 500)
        stats.set_int(MPX() .. "LFETIME_BIKER_BUY_UNDERTA2", 500)
        stats.set_int(MPX() .. "LFETIME_BIKER_BUY_COMPLET2", 500)
        stats.set_int(MPX() .. "LFETIME_BIKER_SELL_UNDERTA2", 500)
        stats.set_int(MPX() .. "LFETIME_BIKER_SELL_COMPLET2", 500)
        stats.set_int(MPX() .. "LIFETIME_BKR_SEL_UNDERTABC2", 500)
        stats.set_int(MPX() .. "LIFETIME_BKR_SEL_COMPLETBC2", 500)
        stats.set_int(MPX() .. "BKR_PROD_STOP_COUT_S1_2", 500)
        stats.set_int(MPX() .. "BKR_PROD_STOP_COUT_S2_2", 500)
        stats.set_int(MPX() .. "BKR_PROD_STOP_COUT_S3_2", 500)
        stats.set_int(MPX() .. "LFETIME_BIKER_BUY_UNDERTA3", 500)
        stats.set_int(MPX() .. "LFETIME_BIKER_BUY_COMPLET3", 500)
        stats.set_int(MPX() .. "LFETIME_BIKER_SELL_UNDERTA3", 500)
        stats.set_int(MPX() .. "LFETIME_BIKER_SELL_COMPLET3", 500)
        stats.set_int(MPX() .. "LIFETIME_BKR_SEL_UNDERTABC3", 500)
        stats.set_int(MPX() .. "LIFETIME_BKR_SEL_COMPLETBC3", 500)
        stats.set_int(MPX() .. "BKR_PROD_STOP_COUT_S1_3", 500)
        stats.set_int(MPX() .. "BKR_PROD_STOP_COUT_S2_3", 500)
        stats.set_int(MPX() .. "BKR_PROD_STOP_COUT_S3_3", 500)
        stats.set_int(MPX() .. "LFETIME_BIKER_BUY_UNDERTA4", 500)
        stats.set_int(MPX() .. "LFETIME_BIKER_BUY_COMPLET4", 500)
        stats.set_int(MPX() .. "LFETIME_BIKER_SELL_UNDERTA4", 500)
        stats.set_int(MPX() .. "LFETIME_BIKER_SELL_COMPLET4", 500)
        stats.set_int(MPX() .. "LIFETIME_BKR_SEL_UNDERTABC4", 500)
        stats.set_int(MPX() .. "LIFETIME_BKR_SEL_COMPLETBC4", 500)
        stats.set_int(MPX() .. "BKR_PROD_STOP_COUT_S1_4", 500)
        stats.set_int(MPX() .. "BKR_PROD_STOP_COUT_S2_4", 500)
        stats.set_int(MPX() .. "BKR_PROD_STOP_COUT_S3_4", 500)
        stats.set_int(MPX() .. "LFETIME_BIKER_BUY_UNDERTA5", 500)
        stats.set_int(MPX() .. "LFETIME_BIKER_BUY_COMPLET5", 500)
        stats.set_int(MPX() .. "LIFETIME_BKR_SEL_UNDERTABC5", 500)
        stats.set_int(MPX() .. "LIFETIME_BKR_SEL_COMPLETBC5", 500)
        stats.set_int(MPX() .. "LFETIME_BIKER_SELL_UNDERTA5", 500)
        stats.set_int(MPX() .. "LFETIME_BIKER_SELL_COMPLET5", 500)
        stats.set_int(MPX() .. "BUNKER_UNITS_MANUFAC", 500)
        stats.set_int(MPX() .. "LFETIME_HANGAR_BUY_UNDETAK", 500)
        stats.set_int(MPX() .. "LFETIME_HANGAR_BUY_COMPLET", 500)
        stats.set_int(MPX() .. "LFETIME_HANGAR_SEL_UNDETAK", 500)
        stats.set_int(MPX() .. "LFETIME_HANGAR_SEL_COMPLET", 500)
        stats.set_int(MPX() .. "LFETIME_HANGAR_EARNINGS", 29654123)
        stats.set_int(MPX() .. "LFETIME_HANGAR_EARN_BONUS", 15987456)
        stats.set_int(MPX() .. "RIVAL_HANGAR_CRATES_STOLEN", 500)
        stats.set_int(MPX() .. "LFETIME_IE_STEAL_STARTED", 500)
        stats.set_int(MPX() .. "LFETIME_IE_EXPORT_STARTED", 500)
        stats.set_int(MPX() .. "LFETIME_IE_EXPORT_COMPLETED", 500)
        stats.set_int(MPX() .. "LFETIME_IE_MISSION_EARNINGS", 59654897)
        stats.set_int(MPX() .. "AT_FLOW_IMPEXP_NUM", 500)
        stats.set_int(MPX() .. "CLUB_POPULARITY", 1000)
        stats.set_int(MPX() .. "NIGHTCLUB_VIP_APPEAR", 300)
        stats.set_int(MPX() .. "NIGHTCLUB_JOBS_DONE", 500)
        stats.set_int(MPX() .. "NIGHTCLUB_EARNINGS", 39856412)
        stats.set_int(MPX() .. "HUB_SALES_COMPLETED", 500)
        stats.set_int(MPX() .. "HUB_EARNINGS", 29865423)
        stats.set_int(MPX() .. "DANCE_COMBO_DURATION_MINS", 86400000)
        stats.set_int(MPX() .. "NIGHTCLUB_PLAYER_APPEAR", 500)
        stats.set_int(MPX() .. "LIFETIME_HUB_GOODS_SOLD", 500)
        stats.set_int(MPX() .. "LIFETIME_HUB_GOODS_MADE", 500)
        stats.set_int(MPX() .. "ADMIN_CLOTHES_GV_BS_1", -1)
        stats.set_int(MPX() .. "ADMIN_CLOTHES_GV_BS_10", -1)
        stats.set_int(MPX() .. "ADMIN_CLOTHES_GV_BS_11", -1)
        stats.set_int(MPX() .. "ADMIN_CLOTHES_GV_BS_12", -1)
        stats.set_int(MPX() .. "ADMIN_CLOTHES_GV_BS_2", -1)
        stats.set_int(MPX() .. "ADMIN_CLOTHES_GV_BS_3", -1)
        stats.set_int(MPX() .. "ADMIN_CLOTHES_GV_BS_4", -1)
        stats.set_int(MPX() .. "ADMIN_CLOTHES_GV_BS_5", -1)
        stats.set_int(MPX() .. "ADMIN_CLOTHES_GV_BS_6", -1)
        stats.set_int(MPX() .. "ADMIN_CLOTHES_GV_BS_7", -1)
        stats.set_int(MPX() .. "ADMIN_CLOTHES_GV_BS_8", -1)
        stats.set_int(MPX() .. "ADMIN_CLOTHES_GV_BS_9", -1)
        stats.set_int(MPX() .. "ADMIN_WEAPON_GV_BS_1", -1)
        stats.set_int(MPX() .. "AIR_LAUNCHES_OVER_40M", 25)
        stats.set_int(MPX() .. "AWD_5STAR_WANTED_AVOIDANCE", 50)
        stats.set_int(MPX() .. "AWD_CAR_BOMBS_ENEMY_KILLS", 25)
        stats.set_int(MPX() .. "AWD_CARS_EXPORTED", 50)
        stats.set_int(MPX() .. "AWD_CONTROL_CROWDS", 25)
        stats.set_int(MPX() .. "AWD_DAILYOBJCOMPLETED", 100)
        stats.set_int(MPX() .. "AWD_DO_HEIST_AS_MEMBER", 25)
        stats.set_int(MPX() .. "AWD_DO_HEIST_AS_THE_LEADER", 25)
        stats.set_int(MPX() .. "AWD_DROPOFF_CAP_PACKAGES", 100)
        stats.set_int(MPX() .. "AWD_FINISH_HEIST_SETUP_JOB", 50)
        stats.set_int(MPX() .. "AWD_FINISH_HEISTS", 50)
        stats.set_int(MPX() .. "AWD_FM_DM_3KILLSAMEGUY", 50)
        stats.set_int(MPX() .. "AWD_FM_DM_KILLSTREAK", 100)
        stats.set_int(MPX() .. "AWD_FM_DM_STOLENKILL", 50)
        stats.set_int(MPX() .. "AWD_FM_DM_TOTALKILLS", 500)
        stats.set_int(MPX() .. "AWD_FM_DM_WINS", 50)
        stats.set_int(MPX() .. "AWD_FM_GOLF_HOLE_IN_1", 300)
        stats.set_int(MPX() .. "AWD_FM_GOLF_BIRDIES", 25)
        stats.set_int(MPX() .. "AWD_FM_GOLF_WON", 25)
        stats.set_int(MPX() .. "AWD_FM_GTA_RACES_WON", 50)
        stats.set_int(MPX() .. "AWD_FM_RACE_LAST_FIRST", 25)
        stats.set_int(MPX() .. "AWD_FM_RACES_FASTEST_LAP", 50)
        stats.set_int(MPX() .. "AWD_FM_SHOOTRANG_CT_WON", 25)
        stats.set_int(MPX() .. "AWD_FM_SHOOTRANG_RT_WON", 25)
        stats.set_int(MPX() .. "AWD_FM_SHOOTRANG_TG_WON", 25)
        stats.set_int(MPX() .. "AWD_FM_TDM_MVP", 50)
        stats.set_int(MPX() .. "AWD_FM_TDM_WINS", 50)
        stats.set_int(MPX() .. "AWD_FM_TENNIS_ACE", 25)
        stats.set_int(MPX() .. "AWD_FM_TENNIS_WON", 25)
        stats.set_int(MPX() .. "AWD_FMBASEJMP", 25)
        stats.set_int(MPX() .. "AWD_FMBBETWIN", 50000)
        stats.set_int(MPX() .. "AWD_FMCRATEDROPS", 25)
        stats.set_int(MPX() .. "AWD_FMDRIVEWITHOUTCRASH", 30)
        stats.set_int(MPX() .. "AWD_FMHORDWAVESSURVIVE", 10)
        stats.set_int(MPX() .. "AWD_FMKILLBOUNTY", 25)
        stats.set_int(MPX() .. "AWD_FMRALLYWONDRIVE", 25)
        stats.set_int(MPX() .. "AWD_FMRALLYWONNAV", 25)
        stats.set_int(MPX() .. "AWD_FMREVENGEKILLSD", 50)
        stats.set_int(MPX() .. "AWD_FMSHOOTDOWNCOPHELI", 25)
        stats.set_int(MPX() .. "AWD_FMWINAIRRACE", 25)
        stats.set_int(MPX() .. "AWD_FMWINRACETOPOINTS", 25)
        stats.set_int(MPX() .. "AWD_FMWINSEARACE", 25)
        stats.set_int(MPX() .. "AWD_HOLD_UP_SHOPS", 20)
        stats.set_int(MPX() .. "AWD_KILL_CARRIER_CAPTURE", 100)
        stats.set_int(MPX() .. "AWD_KILL_PSYCHOPATHS", 100)
        stats.set_int(MPX() .. "AWD_KILL_TEAM_YOURSELF_LTS", 25)
        stats.set_int(MPX() .. "AWD_LAPDANCES", 25)
        stats.set_int(MPX() .. "AWD_LESTERDELIVERVEHICLES", 25)
        stats.set_int(MPX() .. "AWD_MENTALSTATE_TO_NORMAL", 50)
        stats.set_int(MPX() .. "AWD_NIGHTVISION_KILLS", 100)
        stats.set_int(MPX() .. "AWD_NO_HAIRCUTS", 25)
        stats.set_int(MPX() .. "AWD_ODISTRACTCOPSNOEATH", 25)
        stats.set_int(MPX() .. "AWD_ONLY_PLAYER_ALIVE_LTS", 50)
        stats.set_int(MPX() .. "AWD_PARACHUTE_JUMPS_20M", 25)
        stats.set_int(MPX() .. "AWD_PARACHUTE_JUMPS_50M", 25)
        stats.set_int(MPX() .. "AWD_PASSENGERTIME", 4)
        stats.set_int(MPX() .. "AWD_PICKUP_CAP_PACKAGES", 100)
        stats.set_int(MPX() .. "AWD_RACES_WON", 50)
        stats.set_int(MPX() .. "AWD_SECURITY_CARS_ROBBED", 25)
        stats.set_int(MPX() .. "AWD_TAKEDOWNSMUGPLANE", 50)
        stats.set_int(MPX() .. "AWD_TIME_IN_HELICOPTER", 4)
        stats.set_int(MPX() .. "AWD_TRADE_IN_YOUR_PROPERTY", 25)
        stats.set_int(MPX() .. "AWD_VEHICLES_JACKEDR", 500)
        stats.set_int(MPX() .. "AWD_WIN_AT_DARTS", 25)
        stats.set_int(MPX() .. "AWD_WIN_CAPTURE_DONT_DYING", 25)
        stats.set_int(MPX() .. "AWD_WIN_CAPTURES", 50)
        stats.set_int(MPX() .. "AWD_WIN_GOLD_MEDAL_HEISTS", 25)
        stats.set_int(MPX() .. "AWD_WIN_LAST_TEAM_STANDINGS", 50)
        stats.set_int(MPX() .. "BOTTLE_IN_POSSESSION", -1)
        stats.set_int(MPX() .. "CHAR_FM_CARMOD_1_UNLCK", -1)
        stats.set_int(MPX() .. "CHAR_FM_CARMOD_2_UNLCK", -1)
        stats.set_int(MPX() .. "CHAR_FM_CARMOD_3_UNLCK", -1)
        stats.set_int(MPX() .. "CHAR_FM_CARMOD_4_UNLCK", -1)
        stats.set_int(MPX() .. "CHAR_FM_CARMOD_5_UNLCK", -1)
        stats.set_int(MPX() .. "CHAR_FM_CARMOD_6_UNLCK", -1)
        stats.set_int(MPX() .. "CHAR_FM_CARMOD_7_UNLCK", -1)
        stats.set_int(MPX() .. "CHAR_FM_VEHICLE_1_UNLCK", -1)
        stats.set_int(MPX() .. "CHAR_FM_VEHICLE_2_UNLCK", -1)
        stats.set_int(MPX() .. "CHAR_FM_WEAP_ADDON_1_UNLCK", -1)
        stats.set_int(MPX() .. "CHAR_FM_WEAP_ADDON_2_UNLCK", -1)
        stats.set_int(MPX() .. "CHAR_FM_WEAP_ADDON_3_UNLCK", -1)
        stats.set_int(MPX() .. "CHAR_FM_WEAP_ADDON_4_UNLCK", -1)
        stats.set_int(MPX() .. "CHAR_FM_WEAP_ADDON_5_UNLCK", -1)
        stats.set_int(MPX() .. "CHAR_FM_WEAP_UNLOCKED", -1)
        stats.set_int(MPX() .. "CHAR_FM_WEAP_UNLOCKED2", -1)
        stats.set_int(MPX() .. "CHAR_KIT_1_FM_UNLCK", -1)
        stats.set_int(MPX() .. "CHAR_KIT_2_FM_UNLCK", -1)
        stats.set_int(MPX() .. "CHAR_KIT_3_FM_UNLCK", -1)
        stats.set_int(MPX() .. "CHAR_KIT_4_FM_UNLCK", -1)
        stats.set_int(MPX() .. "CHAR_KIT_5_FM_UNLCK", -1)
        stats.set_int(MPX() .. "CHAR_KIT_6_FM_UNLCK", -1)
        stats.set_int(MPX() .. "CHAR_KIT_7_FM_UNLCK", -1)
        stats.set_int(MPX() .. "CHAR_KIT_8_FM_UNLCK", -1)
        stats.set_int(MPX() .. "CHAR_KIT_9_FM_UNLCK", -1)
        stats.set_int(MPX() .. "CHAR_KIT_10_FM_UNLCK", -1)
        stats.set_int(MPX() .. "CHAR_KIT_11_FM_UNLCK", -1)
        stats.set_int(MPX() .. "CHAR_KIT_12_FM_UNLCK", -1)
        stats.set_int(MPX() .. "CHAR_KIT_13_FM_UNLCK", -1)
        stats.set_int(MPX() .. "CHAR_KIT_14_FM_UNLCK", -1)
        stats.set_int(MPX() .. "CHAR_KIT_15_FM_UNLCK", -1)
        stats.set_int(MPX() .. "CHAR_KIT_16_FM_UNLCK", -1)
        stats.set_int(MPX() .. "CHAR_KIT_17_FM_UNLCK", -1)
        stats.set_int(MPX() .. "CHAR_KIT_18_FM_UNLCK", -1)
        stats.set_int(MPX() .. "CHAR_KIT_19_FM_UNLCK", -1)
        stats.set_int(MPX() .. "CHAR_KIT_20_FM_UNLCK", -1)
        stats.set_int(MPX() .. "CHAR_KIT_21_FM_UNLCK", -1)
        stats.set_int(MPX() .. "CHAR_KIT_22_FM_UNLCK", -1)
        stats.set_int(MPX() .. "CHAR_KIT_23_FM_UNLCK", -1)
        stats.set_int(MPX() .. "CHAR_KIT_24_FM_UNLCK", -1)
        stats.set_int(MPX() .. "CHAR_KIT_25_FM_UNLCK", -1)
        stats.set_int(MPX() .. "CHAR_KIT_26_FM_UNLCK", -1)
        stats.set_int(MPX() .. "CHAR_KIT_27_FM_UNLCK", -1)
        stats.set_int(MPX() .. "CHAR_KIT_28_FM_UNLCK", -1)
        stats.set_int(MPX() .. "CHAR_KIT_29_FM_UNLCK", -1)
        stats.set_int(MPX() .. "CHAR_KIT_30_FM_UNLCK", -1)
        stats.set_int(MPX() .. "CHAR_KIT_30_FM_UNLCK", -1)
        stats.set_int(MPX() .. "CHAR_KIT_31_FM_UNLCK", -1)
        stats.set_int(MPX() .. "CHAR_KIT_32_FM_UNLCK", -1)
        stats.set_int(MPX() .. "CHAR_KIT_33_FM_UNLCK", -1)
        stats.set_int(MPX() .. "CHAR_KIT_34_FM_UNLCK", -1)
        stats.set_int(MPX() .. "CHAR_KIT_35_FM_UNLCK", -1)
        stats.set_int(MPX() .. "CHAR_KIT_36_FM_UNLCK", -1)
        stats.set_int(MPX() .. "CHAR_KIT_37_FM_UNLCK", -1)
        stats.set_int(MPX() .. "CHAR_KIT_38_FM_UNLCK", -1)
        stats.set_int(MPX() .. "CHAR_KIT_39_FM_UNLCK", -1)
        stats.set_int(MPX() .. "CHAR_KIT_40_FM_UNLCK", -1)
        stats.set_int(MPX() .. "CHAR_KIT_41_FM_UNLCK", -1)
        stats.set_int(MPX() .. "TATTOO_FM_UNLOCKS_0", -1)
        stats.set_int(MPX() .. "TATTOO_FM_UNLOCKS_1", -1)
        stats.set_int(MPX() .. "TATTOO_FM_UNLOCKS_2", -1)
        stats.set_int(MPX() .. "TATTOO_FM_UNLOCKS_3", -1)
        stats.set_int(MPX() .. "TATTOO_FM_UNLOCKS_4", -1)
        stats.set_int(MPX() .. "TATTOO_FM_UNLOCKS_5", -1)
        stats.set_int(MPX() .. "TATTOO_FM_UNLOCKS_6", -1)
        stats.set_int(MPX() .. "TATTOO_FM_UNLOCKS_7", -1)
        stats.set_int(MPX() .. "TATTOO_FM_UNLOCKS_8", -1)
        stats.set_int(MPX() .. "TATTOO_FM_UNLOCKS_9", -1)
        stats.set_int(MPX() .. "TATTOO_FM_UNLOCKS_10", -1)
        stats.set_int(MPX() .. "TATTOO_FM_UNLOCKS_11", -1)
        stats.set_int(MPX() .. "TATTOO_FM_UNLOCKS_12", -1)
        stats.set_int(MPX() .. "TATTOO_FM_UNLOCKS_13", -1)
        stats.set_int(MPX() .. "TATTOO_FM_UNLOCKS_14", -1)
        stats.set_int(MPX() .. "TATTOO_FM_UNLOCKS_15", -1)
        stats.set_int(MPX() .. "TATTOO_FM_UNLOCKS_16", -1)
        stats.set_int(MPX() .. "TATTOO_FM_UNLOCKS_17", -1)
        stats.set_int(MPX() .. "TATTOO_FM_UNLOCKS_18", -1)
        stats.set_int(MPX() .. "TATTOO_FM_UNLOCKS_19", -1)
        stats.set_int(MPX() .. "TATTOO_FM_UNLOCKS_20", -1)
        stats.set_int(MPX() .. "TATTOO_FM_UNLOCKS_21", -1)
        stats.set_int(MPX() .. "TATTOO_FM_UNLOCKS_22", -1)
        stats.set_int(MPX() .. "TATTOO_FM_UNLOCKS_23", -1)
        stats.set_int(MPX() .. "TATTOO_FM_UNLOCKS_24", -1)
        stats.set_int(MPX() .. "TATTOO_FM_UNLOCKS_25", -1)
        stats.set_int(MPX() .. "TATTOO_FM_UNLOCKS_26", -1)
        stats.set_int(MPX() .. "TATTOO_FM_UNLOCKS_27", -1)
        stats.set_int(MPX() .. "TATTOO_FM_UNLOCKS_28", -1)
        stats.set_int(MPX() .. "TATTOO_FM_UNLOCKS_29", -1)
        stats.set_int(MPX() .. "TATTOO_FM_UNLOCKS_30", -1)
        stats.set_int(MPX() .. "TATTOO_FM_UNLOCKS_31", -1)
        stats.set_int(MPX() .. "TATTOO_FM_UNLOCKS_32", -1)
        stats.set_int(MPX() .. "TATTOO_FM_UNLOCKS_33", -1)
        stats.set_int(MPX() .. "TATTOO_FM_UNLOCKS_34", -1)
        stats.set_int(MPX() .. "TATTOO_FM_UNLOCKS_35", -1)
        stats.set_int(MPX() .. "TATTOO_FM_UNLOCKS_36", -1)
        stats.set_int(MPX() .. "TATTOO_FM_UNLOCKS_37", -1)
        stats.set_int(MPX() .. "TATTOO_FM_UNLOCKS_38", -1)
        stats.set_int(MPX() .. "TATTOO_FM_UNLOCKS_39", -1)
        stats.set_int(MPX() .. "TATTOO_FM_UNLOCKS_40", -1)
        stats.set_int(MPX() .. "TATTOO_FM_UNLOCKS_41", -1)
        stats.set_int(MPX() .. "TATTOO_FM_UNLOCKS_42", -1)
        stats.set_int(MPX() .. "TATTOO_FM_UNLOCKS_43", -1)
        stats.set_int(MPX() .. "TATTOO_FM_UNLOCKS_44", -1)
        stats.set_int(MPX() .. "TATTOO_FM_UNLOCKS_45", -1)
        stats.set_int(MPX() .. "TATTOO_FM_UNLOCKS_46", -1)
        stats.set_int(MPX() .. "TATTOO_FM_UNLOCKS_47", -1)
        stats.set_int(MPX() .. "TATTOO_FM_UNLOCKS_48", -1)
        stats.set_int(MPX() .. "TATTOO_FM_UNLOCKS_49", -1)
        stats.set_int(MPX() .. "TATTOO_FM_UNLOCKS_50", -1)
        stats.set_int(MPX() .. "TATTOO_FM_UNLOCKS_51", -1)
        stats.set_int(MPX() .. "TATTOO_FM_UNLOCKS_52", -1)
        stats.set_int(MPX() .. "TATTOO_FM_UNLOCKS_53", -1)
        stats.set_int(MPX() .. "CHAR_KIT_FM_PURCHASE", -1)
        stats.set_int(MPX() .. "CHAR_KIT_FM_PURCHASE10", -1)
        stats.set_int(MPX() .. "CHAR_KIT_FM_PURCHASE11", -1)
        stats.set_int(MPX() .. "CHAR_KIT_FM_PURCHASE12", -1)
        stats.set_int(MPX() .. "CHAR_KIT_FM_PURCHASE2", -1)
        stats.set_int(MPX() .. "CHAR_KIT_FM_PURCHASE3", -1)
        stats.set_int(MPX() .. "CHAR_KIT_FM_PURCHASE4", -1)
        stats.set_int(MPX() .. "CHAR_KIT_FM_PURCHASE5", -1)
        stats.set_int(MPX() .. "CHAR_KIT_FM_PURCHASE6", -1)
        stats.set_int(MPX() .. "CHAR_KIT_FM_PURCHASE7", -1)
        stats.set_int(MPX() .. "CHAR_KIT_FM_PURCHASE8", -1)
        stats.set_int(MPX() .. "CHAR_KIT_FM_PURCHASE9", -1)
        stats.set_int(MPX() .. "CHAR_WANTED_LEVEL_TIME5STAR", -1)
        stats.set_int(MPX() .. "CHAR_WEAP_FM_PURCHASE", -1)
        stats.set_int(MPX() .. "CHAR_WEAP_FM_PURCHASE2", -1)
        stats.set_int(MPX() .. "CLTHS_ACQUIRED_BERD", -1)
        stats.set_int(MPX() .. "CLTHS_ACQUIRED_BERD_1", -1)
        stats.set_int(MPX() .. "CLTHS_ACQUIRED_BERD_2", -1)
        stats.set_int(MPX() .. "CLTHS_ACQUIRED_BERD_3", -1)
        stats.set_int(MPX() .. "CLTHS_ACQUIRED_BERD_4", -1)
        stats.set_int(MPX() .. "CLTHS_ACQUIRED_BERD_5", -1)
        stats.set_int(MPX() .. "CLTHS_ACQUIRED_BERD_6", -1)
        stats.set_int(MPX() .. "CLTHS_ACQUIRED_DECL", -1)
        stats.set_int(MPX() .. "CLTHS_ACQUIRED_FEET", -1)
        stats.set_int(MPX() .. "CLTHS_ACQUIRED_FEET_1", -1)
        stats.set_int(MPX() .. "CLTHS_ACQUIRED_FEET_2", -1)
        stats.set_int(MPX() .. "CLTHS_ACQUIRED_FEET_3", -1)
        stats.set_int(MPX() .. "CLTHS_ACQUIRED_FEET_4", -1)
        stats.set_int(MPX() .. "CLTHS_ACQUIRED_FEET_5", -1)
        stats.set_int(MPX() .. "CLTHS_ACQUIRED_FEET_6", -1)
        stats.set_int(MPX() .. "CLTHS_ACQUIRED_FEET_7", -1)
        stats.set_int(MPX() .. "CLTHS_ACQUIRED_JBIB", -1)
        stats.set_int(MPX() .. "CLTHS_ACQUIRED_JBIB_1", -1)
        stats.set_int(MPX() .. "CLTHS_ACQUIRED_JBIB_2", -1)
        stats.set_int(MPX() .. "CLTHS_ACQUIRED_JBIB_3", -1)
        stats.set_int(MPX() .. "CLTHS_ACQUIRED_JBIB_4", -1)
        stats.set_int(MPX() .. "CLTHS_ACQUIRED_JBIB_5", -1)
        stats.set_int(MPX() .. "CLTHS_ACQUIRED_JBIB_6", -1)
        stats.set_int(MPX() .. "CLTHS_ACQUIRED_JBIB_7", -1)
        stats.set_int(MPX() .. "CLTHS_ACQUIRED_LEGS", -1)
        stats.set_int(MPX() .. "CLTHS_ACQUIRED_LEGS_1", -1)
        stats.set_int(MPX() .. "CLTHS_ACQUIRED_LEGS_2", -1)
        stats.set_int(MPX() .. "CLTHS_ACQUIRED_LEGS_3", -1)
        stats.set_int(MPX() .. "CLTHS_ACQUIRED_LEGS_4", -1)
        stats.set_int(MPX() .. "CLTHS_ACQUIRED_LEGS_5", -1)
        stats.set_int(MPX() .. "CLTHS_ACQUIRED_LEGS_6", -1)
        stats.set_int(MPX() .. "CLTHS_ACQUIRED_LEGS_7", -1)
        stats.set_int(MPX() .. "CLTHS_ACQUIRED_OUTFIT", -1)
        stats.set_int(MPX() .. "CLTHS_ACQUIRED_PROPS", -1)
        stats.set_int(MPX() .. "CLTHS_ACQUIRED_PROPS_1", -1)
        stats.set_int(MPX() .. "CLTHS_ACQUIRED_PROPS_10", -1)
        stats.set_int(MPX() .. "CLTHS_ACQUIRED_PROPS_2", -1)
        stats.set_int(MPX() .. "CLTHS_ACQUIRED_PROPS_3", -1)
        stats.set_int(MPX() .. "CLTHS_ACQUIRED_PROPS_4", -1)
        stats.set_int(MPX() .. "CLTHS_ACQUIRED_PROPS_5", -1)
        stats.set_int(MPX() .. "CLTHS_ACQUIRED_PROPS_6", -1)
        stats.set_int(MPX() .. "CLTHS_ACQUIRED_PROPS_7", -1)
        stats.set_int(MPX() .. "CLTHS_ACQUIRED_PROPS_8", -1)
        stats.set_int(MPX() .. "CLTHS_ACQUIRED_PROPS_9", -1)
        stats.set_int(MPX() .. "CLTHS_ACQUIRED_SPECIAL", -1)
        stats.set_int(MPX() .. "CLTHS_ACQUIRED_SPECIAL2", -1)
        stats.set_int(MPX() .. "CLTHS_ACQUIRED_SPECIAL2_1", -1)
        stats.set_int(MPX() .. "CLTHS_ACQUIRED_SPECIAL_1", -1)
        stats.set_int(MPX() .. "CLTHS_ACQUIRED_SPECIAL_2", -1)
        stats.set_int(MPX() .. "CLTHS_ACQUIRED_SPECIAL_3", -1)
        stats.set_int(MPX() .. "CLTHS_ACQUIRED_SPECIAL_4", -1)
        stats.set_int(MPX() .. "CLTHS_ACQUIRED_SPECIAL_5", -1)
        stats.set_int(MPX() .. "CLTHS_ACQUIRED_SPECIAL_6", -1)
        stats.set_int(MPX() .. "CLTHS_ACQUIRED_SPECIAL_7", -1)
        stats.set_int(MPX() .. "CLTHS_ACQUIRED_TEETH", -1)
        stats.set_int(MPX() .. "CLTHS_ACQUIRED_TEETH_1", -1)
        stats.set_int(MPX() .. "CLTHS_ACQUIRED_TEETH_2", -1)
        stats.set_int(MPX() .. "CLTHS_ACQUIRED_TORSO", -1)
        stats.set_int(MPX() .. "CLTHS_AVAILABLE_BERD", -1)
        stats.set_int(MPX() .. "CLTHS_AVAILABLE_BERD_1", -1)
        stats.set_int(MPX() .. "CLTHS_AVAILABLE_BERD_2", -1)
        stats.set_int(MPX() .. "CLTHS_AVAILABLE_BERD_3", -1)
        stats.set_int(MPX() .. "CLTHS_AVAILABLE_BERD_4", -1)
        stats.set_int(MPX() .. "CLTHS_AVAILABLE_BERD_5", -1)
        stats.set_int(MPX() .. "CLTHS_AVAILABLE_BERD_6", -1)
        stats.set_int(MPX() .. "CLTHS_AVAILABLE_BERD_7", -1)
        stats.set_int(MPX() .. "CLTHS_AVAILABLE_DECL", -1)
        stats.set_int(MPX() .. "CLTHS_AVAILABLE_FEET", -1)
        stats.set_int(MPX() .. "CLTHS_AVAILABLE_FEET_1", -1)
        stats.set_int(MPX() .. "CLTHS_AVAILABLE_FEET_2", -1)
        stats.set_int(MPX() .. "CLTHS_AVAILABLE_FEET_3", -1)
        stats.set_int(MPX() .. "CLTHS_AVAILABLE_FEET_4", -1)
        stats.set_int(MPX() .. "CLTHS_AVAILABLE_FEET_5", -1)
        stats.set_int(MPX() .. "CLTHS_AVAILABLE_FEET_6", -1)
        stats.set_int(MPX() .. "CLTHS_AVAILABLE_FEET_7", -1)
        stats.set_int(MPX() .. "CLTHS_AVAILABLE_HAIR", -1)
        stats.set_int(MPX() .. "CLTHS_AVAILABLE_HAIR_1", -1)
        stats.set_int(MPX() .. "CLTHS_AVAILABLE_HAIR_2", -1)
        stats.set_int(MPX() .. "CLTHS_AVAILABLE_HAIR_3", -1)
        stats.set_int(MPX() .. "CLTHS_AVAILABLE_HAIR_4", -1)
        stats.set_int(MPX() .. "CLTHS_AVAILABLE_HAIR_5", -1)
        stats.set_int(MPX() .. "CLTHS_AVAILABLE_HAIR_6", -1)
        stats.set_int(MPX() .. "CLTHS_AVAILABLE_HAIR_7", -1)
        stats.set_int(MPX() .. "CLTHS_AVAILABLE_JBIB", -1)
        stats.set_int(MPX() .. "CLTHS_AVAILABLE_JBIB_1", -1)
        stats.set_int(MPX() .. "CLTHS_AVAILABLE_JBIB_2", -1)
        stats.set_int(MPX() .. "CLTHS_AVAILABLE_JBIB_3", -1)
        stats.set_int(MPX() .. "CLTHS_AVAILABLE_JBIB_4", -1)
        stats.set_int(MPX() .. "CLTHS_AVAILABLE_JBIB_5", -1)
        stats.set_int(MPX() .. "CLTHS_AVAILABLE_JBIB_6", -1)
        stats.set_int(MPX() .. "CLTHS_AVAILABLE_JBIB_7", -1)
        stats.set_int(MPX() .. "CLTHS_AVAILABLE_LEGS", -1)
        stats.set_int(MPX() .. "CLTHS_AVAILABLE_LEGS_1", -1)
        stats.set_int(MPX() .. "CLTHS_AVAILABLE_LEGS_2", -1)
        stats.set_int(MPX() .. "CHAR_CREWUNLOCK_1_FM_EQUIP", -1)
        stats.set_int(MPX() .. "CHAR_CREWUNLOCK_2_FM_EQUIP", -1)
        stats.set_int(MPX() .. "CHAR_CREWUNLOCK_3_FM_EQUIP", -1)
        stats.set_int(MPX() .. "CHAR_CREWUNLOCK_4_FM_EQUIP", -1)
        stats.set_int(MPX() .. "CHAR_CREWUNLOCK_5_FM_EQUIP", -1)
        stats.set_int(MPX() .. "CHAR_FM_CLOTHES_1_UNLCK", -1)
        stats.set_int(MPX() .. "CHAR_FM_CLOTHES_2_UNLCK", -1)
        stats.set_int(MPX() .. "CHAR_FM_CLOTHES_3_UNLCK", -1)
        stats.set_int(MPX() .. "CHAR_FM_CLOTHES_4_UNLCK", -1)
        stats.set_int(MPX() .. "CHAR_FM_CLOTHES_5_UNLCK", -1)
        stats.set_int(MPX() .. "CHAR_FM_CLOTHES_6_UNLCK", -1)
        stats.set_int(MPX() .. "CHAR_FM_CLOTHES_7_UNLCK", -1)
        stats.set_int(MPX() .. "CHAR_FM_CLOTHES_8_UNLCK", -1)
        stats.set_int(MPX() .. "CHAR_FM_CLOTHES_9_UNLCK", -1)
        stats.set_int(MPX() .. "CHAR_FM_CLOTHES_10_UNLCK", -1)
        stats.set_int(MPX() .. "CHAR_FM_CLOTHES_11_UNLCK", -1)
        stats.set_int(MPX() .. "SAVESTRA_MG_HELDTIME", 5963259)
        stats.set_int(MPX() .. "SAVESTRA_MG_ENEMY_KILLS", 500)
        stats.set_int(MPX() .. "STROMBERG_MG_KILLS", 500)
        stats.set_int(MPX() .. "STROMBERG_MG_DEATHS", 100)
        stats.set_int(MPX() .. "STROMBERG_MG_SHOTS", 500)
        stats.set_int(MPX() .. "STROMBERG_MG_HITS", 500)
        stats.set_int(MPX() .. "STROMBERG_MG_HEADSHOTS", 500)
        stats.set_int(MPX() .. "STROMBERG_MG_HELDTIME", 5963259)
        stats.set_int(MPX() .. "STROMBERG_MG_ENEMY_KILLS", 500)
        stats.set_int(MPX() .. "STROMBERG_MISS_KILLS", 500)
        stats.set_int(MPX() .. "STROMBERG_MISS_DEATHS", 100)
        stats.set_int(MPX() .. "STROMBERG_MISS_SHOTS", 500)
        stats.set_int(MPX() .. "STROMBERG_MISS_HITS", 500)
        stats.set_int(MPX() .. "STROMBERG_MISS_HELDTIME", 5963259)
        stats.set_int(MPX() .. "STROMBERG_MISS_ENEMY_KILLS", 500)
        stats.set_int(MPX() .. "STROMBERG_TORP_KILLS", 500)
        stats.set_int(MPX() .. "STROMBERG_TORP_DEATHS", 100)
        stats.set_int(MPX() .. "STROMBERG_TORP_SHOTS", 500)
        stats.set_int(MPX() .. "STROMBERG_TORP_HITS", 500)
        stats.set_int(MPX() .. "STROMBERG_TORP_HELDTIME", 5963259)
        stats.set_int(MPX() .. "STROMBERG_TORP_ENEMY_KILLS", 500)
        stats.set_int(MPX() .. "THRUSTER_MG_KILLS", 500)
        stats.set_int(MPX() .. "THRUSTER_MG_DEATHS", 100)
        stats.set_int(MPX() .. "THRUSTER_MG_SHOTS", 500)
        stats.set_int(MPX() .. "THRUSTER_MG_HITS", 500)
        stats.set_int(MPX() .. "THRUSTER_MG_HEADSHOTS", 500)
        stats.set_int(MPX() .. "THRUSTER_MG_HELDTIME", 5963259)
        stats.set_int(MPX() .. "THRUSTER_MG_ENEMY_KILLS", 500)
        stats.set_int(MPX() .. "THRUSTER_MISS_KILLS", 500)
        stats.set_int(MPX() .. "THRUSTER_MISS_DEATHS", 100)
        stats.set_int(MPX() .. "THRUSTER_MISS_SHOTS", 500)
        stats.set_int(MPX() .. "THRUSTER_MISS_HITS", 500)
        stats.set_int(MPX() .. "THRUSTER_MISS_HELDTIME", 5963259)
        stats.set_int(MPX() .. "THRUSTER_MISS_ENEMY_KILLS", 500)
        stats.set_int(MPX() .. "VISERIS_MG_KILLS", 500)
        stats.set_int(MPX() .. "VISERIS_MG_DEATHS", 100)
        stats.set_int(MPX() .. "VISERIS_MG_SHOTS", 500)
        stats.set_int(MPX() .. "VISERIS_MG_HITS", 500)
        stats.set_int(MPX() .. "VISERIS_MG_HEADSHOTS", 500)
        stats.set_int(MPX() .. "VISERIS_MG_HELDTIME", 5963259)
        stats.set_int(MPX() .. "VISERIS_MG_ENEMY_KILLS", 500)
        stats.set_int(MPX() .. "VOLATOL_MG_KILLS", 500)
        stats.set_int(MPX() .. "VOLATOL_MG_DEATHS", 100)
        stats.set_int(MPX() .. "VOLATOL_MG_SHOTS", 500)
        stats.set_int(MPX() .. "VOLATOL_MG_HITS", 500)
        stats.set_int(MPX() .. "VOLATOL_MG_HEADSHOTS", 500)
        stats.set_int(MPX() .. "VOLATOL_MG_HELDTIME", 5963259)
        stats.set_int(MPX() .. "VOLATOL_MG_ENEMY_KILLS", 500)
        stats.set_int(MPX() .. "MULE4_MG_KILLS", 500)
        stats.set_int(MPX() .. "MULE4_MG_DEATHS", 100)
        stats.set_int(MPX() .. "MULE4_MG_SHOTS", 500)
        stats.set_int(MPX() .. "MULE4_MG_HITS", 500)
        stats.set_int(MPX() .. "MULE4_MG_HEADSHOTS", 500)
        stats.set_int(MPX() .. "MULE4_MG_HELDTIME", 5963259)
        stats.set_int(MPX() .. "MULE4_MG_ENEMY_KILLS", 500)
        stats.set_int(MPX() .. "MULE4_MISS_KILLS", 500)
        stats.set_int(MPX() .. "MULE4_MISS_DEATHS", 100)
        stats.set_int(MPX() .. "MULE4_MISS_SHOTS", 500)
        stats.set_int(MPX() .. "MULE4_MISS_HITS", 500)
        stats.set_int(MPX() .. "MULE4_MISS_HELDTIME", 5963259)
        stats.set_int(MPX() .. "MULE4_MISS_ENEMY_KILLS", 500)
        stats.set_int(MPX() .. "MULE4_GL_KILLS", 500)
        stats.set_int(MPX() .. "MULE4_GL_DEATHS", 100)
        stats.set_int(MPX() .. "MULE4_GL_SHOTS", 500)
        stats.set_int(MPX() .. "MULE4_GL_HITS", 500)
        stats.set_int(MPX() .. "MULE4_GL_HELDTIME", 5963259)
        stats.set_int(MPX() .. "MULE4_GL_ENEMY_KILLS", 500)
        stats.set_int(MPX() .. "MENACER_MG_KILLS", 500)
        stats.set_int(MPX() .. "MENACER_MG_DEATHS", 100)
        stats.set_int(MPX() .. "MENACER_MG_SHOTS", 500)
        stats.set_int(MPX() .. "MENACER_MG_HITS", 500)
        stats.set_int(MPX() .. "MENACER_MG_HEADSHOTS", 500)
        stats.set_int(MPX() .. "MENACER_MG_HELDTIME", 5963259)
        stats.set_int(MPX() .. "MENACER_MG_ENEMY_KILLS", 500)
        stats.set_int(MPX() .. "MENACER_TURR_KILLS", 500)
        stats.set_int(MPX() .. "MENACER_TURR_DEATHS", 100)
        stats.set_int(MPX() .. "MENACER_TURR_SHOTS", 500)
        stats.set_int(MPX() .. "MENACER_TURR_HITS", 500)
        stats.set_int(MPX() .. "MENACER_TURR_HEADSHOTS", 500)
        stats.set_int(MPX() .. "MENACER_TURR_HELDTIME", 5963259)
        stats.set_int(MPX() .. "MENACER_TURR_ENEMY_KILLS", 500)
        stats.set_int(MPX() .. "MENACER_MINI_KILLS", 500)
        stats.set_int(MPX() .. "MENACER_MINI_DEATHS", 100)
        stats.set_int(MPX() .. "MENACER_MINI_SHOTS", 500)
        stats.set_int(MPX() .. "MENACER_MINI_HITS", 500)
        stats.set_int(MPX() .. "MENACER_MINI_HEADSHOTS", 500)
        stats.set_int(MPX() .. "MENACER_MINI_HELDTIME", 5963259)
        stats.set_int(MPX() .. "MENACER_MINI_ENEMY_KILLS", 500)
        stats.set_int(MPX() .. "OPPRESSOR2_MG_KILLS", 500)
        stats.set_int(MPX() .. "OPPRESSOR2_MG_DEATHS", 100)
        stats.set_int(MPX() .. "OPPRESSOR2_MG_SHOTS", 500)
        stats.set_int(MPX() .. "OPPRESSOR2_MG_HITS", 500)
        stats.set_int(MPX() .. "OPPRESSOR2_MG_HEADSHOTS", 500)
        stats.set_int(MPX() .. "OPPRESSOR2_MG_HELDTIME", 5963259)
        stats.set_int(MPX() .. "OPPRESSOR2_MG_ENEMY_KILLS", 500)
        stats.set_int(MPX() .. "OPPRESSOR2_CANN_KILLS", 500)
        stats.set_int(MPX() .. "OPPRESSOR2_CANN_DEATHS", 100)
        stats.set_int(MPX() .. "OPPRESSOR2_CANN_SHOTS", 500)
        stats.set_int(MPX() .. "OPPRESSOR2_CANN_HITS", 500)
        stats.set_int(MPX() .. "OPPRESSOR2_CANN_HELDTIME", 5963259)
        stats.set_int(MPX() .. "OPPRESSOR2_CANN_ENEMY_KILLS", 500)
        stats.set_int(MPX() .. "OPPRESSOR2_MISS_KILLS", 500)
        stats.set_int(MPX() .. "OPPRESSOR2_MISS_DEATHS", 100)
        stats.set_int(MPX() .. "OPPRESSOR2_MISS_SHOTS", 500)
        stats.set_int(MPX() .. "OPPRESSOR2_MISS_HITS", 500)
        stats.set_int(MPX() .. "OPPRESSOR2_MISS_HELDTIME", 5963259)
        stats.set_int(MPX() .. "OPPRESSOR2_MISS_ENEMY_KILLS", 500)
        stats.set_int(MPX() .. "BRUISER_MG50_KILLS", 500)
        stats.set_int(MPX() .. "BRUISER_MG50_DEATHS", 100)
        stats.set_int(MPX() .. "BRUISER_MG50_SHOTS", 500)
        stats.set_int(MPX() .. "BRUISER_MG50_HITS", 500)
        stats.set_int(MPX() .. "BRUISER_MG50_HEADSHOTS", 500)
        stats.set_int(MPX() .. "BRUISER_MG50_HELDTIME", 5963259)
        stats.set_int(MPX() .. "BRUISER_MG50_ENEMY_KILLS", 500)
        stats.set_int(MPX() .. "BRUISER2_MG50_KILLS", 500)
        stats.set_int(MPX() .. "BRUISER2_MG50_DEATHS", 100)
        stats.set_int(MPX() .. "BRUISER2_MG50_SHOTS", 500)
        stats.set_int(MPX() .. "BRUISER2_MG50_HITS", 500)
        stats.set_int(MPX() .. "BRUISER2_MG50_HEADSHOTS", 500)
        stats.set_int(MPX() .. "BRUISER2_MG50_HELDTIME", 5963259)
        stats.set_int(MPX() .. "BRUISER2_MG50_ENEMY_KILLS", 500)
        stats.set_int(MPX() .. "BRUISER2_LAS_KILLS", 500)
        stats.set_int(MPX() .. "BRUISER2_LAS_DEATHS", 100)
        stats.set_int(MPX() .. "BRUISER2_LAS_SHOTS", 500)
        stats.set_int(MPX() .. "BRUISER2_LAS_HITS", 500)
        stats.set_int(MPX() .. "BRUISER2_LAS_HEADSHOTS", 500)
        stats.set_int(MPX() .. "BRUISER2_LAS_HELDTIME", 5963259)
        stats.set_int(MPX() .. "BRUISER2_LAS_ENEMY_KILLS", 500)
        stats.set_int(MPX() .. "BRUISER3_MG50_KILLS", 500)
        stats.set_int(MPX() .. "BRUISER3_MG50_DEATHS", 100)
        stats.set_int(MPX() .. "BRUISER3_MG50_SHOTS", 500)
        stats.set_int(MPX() .. "BRUISER3_MG50_HITS", 500)
        stats.set_int(MPX() .. "BRUISER3_MG50_HEADSHOTS", 500)
        stats.set_int(MPX() .. "BRUISER3_MG50_HELDTIME", 5963259)
        stats.set_int(MPX() .. "BRUISER3_MG50_ENEMY_KILLS", 500)
        stats.set_int(MPX() .. "BRUTUS_MG50_KILLS", 500)
        stats.set_int(MPX() .. "BRUTUS_MG50_DEATHS", 100)
        stats.set_int(MPX() .. "BRUTUS_MG50_SHOTS", 500)
        stats.set_int(MPX() .. "BRUTUS_MG50_HITS", 500)
        stats.set_int(MPX() .. "BRUTUS_MG50_HEADSHOTS", 500)
        stats.set_int(MPX() .. "BRUTUS_MG50_ENEMY_KILLS", 500)
        stats.set_int(MPX() .. "BRUTUS2_MG50_KILLS", 500)
        stats.set_int(MPX() .. "BRUTUS2_MG50_DEATHS", 100)
        stats.set_int(MPX() .. "BRUTUS2_MG50_SHOTS", 500)
        stats.set_int(MPX() .. "BRUTUS2_MG50_HITS", 500)
        stats.set_int(MPX() .. "BRUTUS2_MG50_HEADSHOTS", 500)
        stats.set_int(MPX() .. "BRUTUS2_MG50_HELDTIME", 5963259)
        stats.set_int(MPX() .. "BRUTUS2_MG50_ENEMY_KILLS", 500)
        stats.set_int(MPX() .. "BRUTUS2_LAS_KILLS", 500)
        stats.set_int(MPX() .. "BRUTUS2_LAS_DEATHS", 100)
        stats.set_int(MPX() .. "BRUTUS2_LAS_SHOTS", 500)
        stats.set_int(MPX() .. "BRUTUS2_LAS_HITS", 500)
        stats.set_int(MPX() .. "BRUTUS2_LAS_HEADSHOTS", 500)
        stats.set_int(MPX() .. "BRUTUS2_LAS_HELDTIME", 5963259)
        stats.set_int(MPX() .. "BRUTUS2_LAS_ENEMY_KILLS", 500)
        stats.set_int(MPX() .. "BRUTUS3_MG50_KILLS", 500)
        stats.set_int(MPX() .. "BRUTUS3_MG50_DEATHS", 100)
        stats.set_int(MPX() .. "BRUTUS3_MG50_SHOTS", 500)
        stats.set_int(MPX() .. "BRUTUS3_MG50_HITS", 500)
        stats.set_int(MPX() .. "BRUTUS3_MG50_HEADSHOTS", 500)
        stats.set_int(MPX() .. "BRUTUS3_MG50_HELDTIME", 5963259)
        stats.set_int(MPX() .. "BRUTUS3_MG50_ENEMY_KILLS", 500)
        stats.set_int(MPX() .. "CERBERUS_FLAME_KILLS", 500)
        stats.set_int(MPX() .. "CERBERUS_FLAME_DEATHS", 100)
        stats.set_int(MPX() .. "CERBERUS_FLAME_SHOTS", 500)
        stats.set_int(MPX() .. "CERBERUS_FLAME_HITS", 500)
        stats.set_int(MPX() .. "CERBERUS_FLAME_HEADSHOTS", 500)
        stats.set_int(MPX() .. "CERBERUS_FLAME_HELDTIME", 5963259)
        stats.set_int(MPX() .. "CERBERUS_FLAME_ENEMY_KILLS", 500)
        stats.set_int(MPX() .. "CERBERUS2_FLAME_KILLS", 500)
        stats.set_int(MPX() .. "CERBERUS2_FLAME_DEATHS", 100)
        stats.set_int(MPX() .. "CERBERUS2_FLAME_SHOTS", 500)
        stats.set_int(MPX() .. "CERBERUS2_FLAME_HITS", 500)
        stats.set_int(MPX() .. "CERBERUS2_FLAME_HEADSHOTS", 500)
        stats.set_int(MPX() .. "CERBERUS2_FLAME_HELDTIME", 5963259)
        stats.set_int(MPX() .. "CERBERUS2_FLAME_ENEMY_KILLS", 500)
        stats.set_int(MPX() .. "CERBERUS3_FLAME_KILLS", 500)
        stats.set_int(MPX() .. "CERBERUS3_FLAME_DEATHS", 100)
        stats.set_int(MPX() .. "CERBERUS3_FLAME_SHOTS", 500)
        stats.set_int(MPX() .. "CERBERUS3_FLAME_HITS", 500)
        stats.set_int(MPX() .. "CERBERUS3_FLAME_HEADSHOTS", 500)
        stats.set_int(MPX() .. "CERBERUS3_FLAME_HELDTIME", 5963259)
        stats.set_int(MPX() .. "CERBERUS3_FLAME_ENEMY_KILLS", 500)
        stats.set_int(MPX() .. "DEATHBIKE_MINI_KILLS", 500)
        stats.set_int(MPX() .. "DEATHBIKE_MINI_DEATHS", 100)
        stats.set_int(MPX() .. "DEATHBIKE_MINI_SHOTS", 500)
        stats.set_int(MPX() .. "DEATHBIKE_MINI_HITS", 500)
        stats.set_int(MPX() .. "DEATHBIKE_MINI_HEADSHOTS", 500)
        stats.set_int(MPX() .. "DEATHBIKE_MINI_HELDTIME", 5963259)
        stats.set_int(MPX() .. "DEATHBIKE_MINI_ENEMY_KILLS", 500)
        stats.set_int(MPX() .. "DEATHBIKE2_LAS_KILLS", 500)
        stats.set_int(MPX() .. "DEATHBIKE2_LAS_DEATHS", 100)
        stats.set_int(MPX() .. "DEATHBIKE2_LAS_SHOTS", 500)
        stats.set_int(MPX() .. "DEATHBIKE2_LAS_HITS", 500)
        stats.set_int(MPX() .. "DEATHBIKE2_LAS_HEADSHOTS", 500)
        stats.set_int(MPX() .. "DEATHBIKE2_LAS_HELDTIME", 5963259)
        stats.set_int(MPX() .. "DEATHBIKE2_LAS_ENEMY_KILLS", 500)
        stats.set_int(MPX() .. "DEATHBIKE3_MINI_KILLS", 500)
        stats.set_int(MPX() .. "DEATHBIKE3_MINI_DEATHS", 100)
        stats.set_int(MPX() .. "DEATHBIKE3_MINI_SHOTS", 500)
        stats.set_int(MPX() .. "DEATHBIKE3_MINI_HITS", 500)
        stats.set_int(MPX() .. "DEATHBIKE3_MINI_HEADSHOTS", 500)
        stats.set_int(MPX() .. "DEATHBIKE3_MINI_HELDTIME", 5963259)
        stats.set_int(MPX() .. "DEATHBIKE3_MINI_ENEMY_KILLS", 500)
        stats.set_int(MPX() .. "DOMINATOR4_MG50_KILLS", 500)
        stats.set_int(MPX() .. "DOMINATOR4_MG50_DEATHS", 100)
        stats.set_int(MPX() .. "DOMINATOR4_MG50_SHOTS", 500)
        stats.set_int(MPX() .. "DOMINATOR4_MG50_HITS", 500)
        stats.set_int(MPX() .. "DOMINATOR4_MG50_HEADSHOTS", 500)
        stats.set_int(MPX() .. "DOMINATOR4_MG50_HELDTIME", 5963259)
        stats.set_int(MPX() .. "DOMINATOR4_MG50_ENEMY_KILLS", 500)
        stats.set_int(MPX() .. "DOMINATOR5_MG50_KILLS", 500)
        stats.set_int(MPX() .. "DOMINATOR5_MG50_DEATHS", 100)
        stats.set_int(MPX() .. "DOMINATOR5_MG50_SHOTS", 500)
        stats.set_int(MPX() .. "DOMINATOR5_MG50_HITS", 500)
        stats.set_int(MPX() .. "DOMINATOR5_MG50_HEADSHOTS", 500)
        stats.set_int(MPX() .. "DOMINATOR5_MG50_HELDTIME", 5963259)
        stats.set_int(MPX() .. "DOMINATOR5_MG50_ENEMY_KILLS", 500)
        stats.set_int(MPX() .. "DOMINATOR5_LAS_KILLS", 500)
        stats.set_int(MPX() .. "DOMINATOR5_LAS_DEATHS", 100)
        stats.set_int(MPX() .. "DOMINATOR5_LAS_SHOTS", 500)
        stats.set_int(MPX() .. "DOMINATOR5_LAS_HITS", 500)
        stats.set_int(MPX() .. "DOMINATOR5_LAS_HEADSHOTS", 500)
        stats.set_int(MPX() .. "DOMINATOR5_LAS_HELDTIME", 5963259)
        stats.set_int(MPX() .. "DOMINATOR5_LAS_ENEMY_KILLS", 500)
        stats.set_int(MPX() .. "DOMINATOR6_MG50_KILLS", 500)
        stats.set_int(MPX() .. "DOMINATOR6_MG50_DEATHS", 100)
        stats.set_int(MPX() .. "DOMINATOR6_MG50_SHOTS", 500)
        stats.set_int(MPX() .. "DOMINATOR6_MG50_HITS", 500)
        stats.set_int(MPX() .. "DOMINATOR6_MG50_HEADSHOTS", 500)
        stats.set_int(MPX() .. "DOMINATOR6_MG50_HELDTIME", 5963259)
        stats.set_int(MPX() .. "DOMINATOR6_MG50_ENEMY_KILLS", 500)
        stats.set_int(MPX() .. "IMPALER2_MG50_KILLS", 500)
        stats.set_int(MPX() .. "IMPALER2_MG50_DEATHS", 100)
        stats.set_int(MPX() .. "IMPALER2_MG50_SHOTS", 500)
        stats.set_int(MPX() .. "IMPALER2_MG50_HITS", 500)
        stats.set_int(MPX() .. "IMPALER2_MG50_HEADSHOTS", 500)
        stats.set_int(MPX() .. "IMPALER2_MG50_HELDTIME", 5963259)
        stats.set_int(MPX() .. "IMPALER2_MG50_ENEMY_KILLS", 500)
        stats.set_int(MPX() .. "IMPALER3_MG50_KILLS", 500)
        stats.set_int(MPX() .. "IMPALER3_MG50_DEATHS", 100)
        stats.set_int(MPX() .. "IMPALER3_MG50_SHOTS", 500)
        stats.set_int(MPX() .. "IMPALER3_MG50_HITS", 500)
        stats.set_int(MPX() .. "IMPALER3_MG50_HEADSHOTS", 500)
        stats.set_int(MPX() .. "IMPALER3_MG50_HELDTIME", 5963259)
        stats.set_int(MPX() .. "IMPALER3_MG50_ENEMY_KILLS", 500)
        stats.set_int(MPX() .. "IMPALER3_LAS_KILLS", 500)
        stats.set_int(MPX() .. "IMPALER3_LAS_DEATHS", 100)
        stats.set_int(MPX() .. "IMPALER3_LAS_SHOTS", 500)
        stats.set_int(MPX() .. "IMPALER3_LAS_HITS", 500)
        stats.set_int(MPX() .. "IMPALER3_LAS_HEADSHOTS", 500)
        stats.set_int(MPX() .. "IMPALER3_LAS_HELDTIME", 5963259)
        stats.set_int(MPX() .. "IMPALER3_LAS_ENEMY_KILLS", 500)
        stats.set_int(MPX() .. "IMPALER4_MG50_KILLS", 500)
        stats.set_int(MPX() .. "IMPALER4_MG50_DEATHS", 100)
        stats.set_int(MPX() .. "IMPALER4_MG50_SHOTS", 500)
        stats.set_int(MPX() .. "IMPALER4_MG50_HITS", 500)
        stats.set_int(MPX() .. "IMPALER4_MG50_HEADSHOTS", 500)
        stats.set_int(MPX() .. "IMPALER4_MG50_HELDTIME", 5963259)
        stats.set_int(MPX() .. "IMPALER4_MG50_ENEMY_KILLS", 500)
        stats.set_int(MPX() .. "IMPERATOR_MG50_KILLS", 500)
        stats.set_int(MPX() .. "IMPERATOR_MG50_DEATHS", 100)
        stats.set_int(MPX() .. "IMPERATOR_MG50_SHOTS", 500)
        stats.set_int(MPX() .. "IMPERATOR_MG50_HITS", 500)
        stats.set_int(MPX() .. "IMPERATOR_MG50_HEADSHOTS", 500)
        stats.set_int(MPX() .. "IMPERATOR_MG50_HELDTIME", 5963259)
        stats.set_int(MPX() .. "IMPERATOR_MG50_ENEMY_KILLS", 500)
        stats.set_int(MPX() .. "IMPERATOR_KIN_KILLS", 500)
        stats.set_int(MPX() .. "IMPERATOR_KIN_DEATHS", 100)
        stats.set_int(MPX() .. "IMPERATOR_KIN_SHOTS", 500)
        stats.set_int(MPX() .. "IMPERATOR_KIN_HITS", 500)
        stats.set_int(MPX() .. "IMPERATOR_KIN_HELDTIME", 5963259)
        stats.set_int(MPX() .. "IMPERATOR_KIN_ENEMY_KILLS", 500)
        stats.set_int(MPX() .. "IMPERATOR2_MG50_KILLS", 500)
        stats.set_int(MPX() .. "IMPERATOR2_MG50_DEATHS", 100)
        stats.set_int(MPX() .. "IMPERATOR2_MG50_SHOTS", 500)
        stats.set_int(MPX() .. "IMPERATOR2_MG50_HITS", 500)
        stats.set_int(MPX() .. "IMPERATOR2_MG50_HEADSHOTS", 500)
        stats.set_int(MPX() .. "IMPERATOR2_MG50_HELDTIME", 5963259)
        stats.set_int(MPX() .. "IMPERATOR2_MG50_ENEMY_KILLS", 500)
        stats.set_int(MPX() .. "IMPERATOR2_KIN_KILLS", 500)
        stats.set_int(MPX() .. "IMPERATOR2_KIN_DEATHS", 100)
        stats.set_int(MPX() .. "IMPERATOR2_KIN_SHOTS", 500)
        stats.set_int(MPX() .. "IMPERATOR2_KIN_HITS", 500)
        stats.set_int(MPX() .. "IMPERATOR2_KIN_HELDTIME", 5963259)
        stats.set_int(MPX() .. "IMPERATOR2_KIN_ENEMY_KILLS", 500)
        stats.set_int(MPX() .. "IMPERATOR2_LAS_KILLS", 500)
        stats.set_int(MPX() .. "IMPERATOR2_LAS_DEATHS", 100)
        stats.set_int(MPX() .. "IMPERATOR2_LAS_SHOTS", 500)
        stats.set_int(MPX() .. "IMPERATOR2_LAS_HITS", 500)
        stats.set_int(MPX() .. "IMPERATOR2_LAS_HEADSHOTS", 500)
        stats.set_int(MPX() .. "IMPERATOR2_LAS_HELDTIME", 5963259)
        stats.set_int(MPX() .. "IMPERATOR2_LAS_ENEMY_KILLS", 500)
        stats.set_int(MPX() .. "IMPERATOR3_MG50_KILLS", 500)
        stats.set_int(MPX() .. "IMPERATOR3_MG50_DEATHS", 100)
        stats.set_int(MPX() .. "IMPERATOR3_MG50_SHOTS", 500)
        stats.set_int(MPX() .. "IMPERATOR3_MG50_HITS", 500)
        stats.set_int(MPX() .. "IMPERATOR3_MG50_HEADSHOTS", 500)
        stats.set_int(MPX() .. "IMPERATOR3_MG50_HELDTIME", 5963259)
        stats.set_int(MPX() .. "IMPERATOR3_MG50_ENEMY_KILLS", 500)
        stats.set_int(MPX() .. "IMPERATOR3_KIN_KILLS", 500)
        stats.set_int(MPX() .. "IMPERATOR3_KIN_DEATHS", 100)
        stats.set_int(MPX() .. "IMPERATOR3_KIN_SHOTS", 500)
        stats.set_int(MPX() .. "IMPERATOR3_KIN_HITS", 500)
        stats.set_int(MPX() .. "IMPERATOR3_KIN_HELDTIME", 5963259)
        stats.set_int(MPX() .. "IMPERATOR3_KIN_ENEMY_KILLS", 500)
        stats.set_int(MPX() .. "VALKYRIE_CANNON_KILLS", 500)
        stats.set_int(MPX() .. "VALKYRIE_CANNON_DEATHS", 100)
        stats.set_int(MPX() .. "VALKYRIE_CANNON_SHOTS", 500)
        stats.set_int(MPX() .. "VALKYRIE_CANNON_HITS", 500)
        stats.set_int(MPX() .. "VALKYRIE_CANNON_HEADSHOTS", 500)
        stats.set_int(MPX() .. "VALKYRIE_CANNON_HELDTIME", 5963259)
        stats.set_int(MPX() .. "VALKYRIE_CANNON_ENEMY_KILLS", 500)
        stats.set_int(MPX() .. "VALKYRIE_TURR_KILLS", 500)
        stats.set_int(MPX() .. "VALKYRIE_TURR_DEATHS", 100)
        stats.set_int(MPX() .. "VALKYRIE_TURR_SHOTS", 500)
        stats.set_int(MPX() .. "VALKYRIE_TURR_HITS", 500)
        stats.set_int(MPX() .. "VALKYRIE_TURR_HEADSHOTS", 500)
        stats.set_int(MPX() .. "VALKYRIE_TURR_HELDTIME", 5963259)
        stats.set_int(MPX() .. "VALKYRIE_TURR_ENEMY_KILLS", 500)
        stats.set_int(MPX() .. "JB7002_MG_KILLS", 500)
        stats.set_int(MPX() .. "JB7002_MG_DEATHS", 100)
        stats.set_int(MPX() .. "JB7002_MG_SHOTS", 500)
        stats.set_int(MPX() .. "JB7002_MG_HITS", 500)
        stats.set_int(MPX() .. "JB7002_MG_HEADSHOTS", 500)
        stats.set_int(MPX() .. "JB7002_MG_HELDTIME", 5963259)
        stats.set_int(MPX() .. "JB7002_MG_ENEMY_KILLS", 500)
        stats.set_int(MPX() .. "MINITANK_MG_KILLS", 500)
        stats.set_int(MPX() .. "MINITANK_MG_DEATHS", 100)
        stats.set_int(MPX() .. "MINITANK_MG_SHOTS", 500)
        stats.set_int(MPX() .. "MINITANK_MG_HITS", 500)
        stats.set_int(MPX() .. "MINITANK_MG_HEADSHOTS", 500)
        stats.set_int(MPX() .. "MINITANK_MG_HELDTIME", 5963259)
        stats.set_int(MPX() .. "MINITANK_MG_ENEMY_KILLS", 500)
        stats.set_int(MPX() .. "MINITANK_FL_KILLS", 500)
        stats.set_int(MPX() .. "MINITANK_FL_DEATHS", 100)
        stats.set_int(MPX() .. "MINITANK_FL_SHOTS", 500)
        stats.set_int(MPX() .. "MINITANK_FL_HITS", 500)
        stats.set_int(MPX() .. "MINITANK_FL_HELDTIME", 5963259)
        stats.set_int(MPX() .. "MINITANK_FL_ENEMY_KILLS", 500)
        stats.set_int(MPX() .. "MINITANK_RK_KILLS", 500)
        stats.set_int(MPX() .. "MINITANK_RK_DEATHS", 100)
        stats.set_int(MPX() .. "MINITANK_RK_SHOTS", 500)
        stats.set_int(MPX() .. "MINITANK_RK_HITS", 500)
        stats.set_int(MPX() .. "MINITANK_RK_HELDTIME", 5963259)
        stats.set_int(MPX() .. "MINITANK_RK_ENEMY_KILLS", 500)
        stats.set_int(MPX() .. "MINITANK_LZ_KILLS", 500)
        stats.set_int(MPX() .. "MINITANK_LZ_DEATHS", 100)
        stats.set_int(MPX() .. "MINITANK_LZ_SHOTS", 500)
        stats.set_int(MPX() .. "MINITANK_LZ_HITS", 500)
        stats.set_int(MPX() .. "MINITANK_LZ_HEADSHOTS", 500)
        stats.set_int(MPX() .. "MINITANK_LZ_HELDTIME", 5963259)
        stats.set_int(MPX() .. "MINITANK_LZ_ENEMY_KILLS", 500)
        stats.set_int(MPX() .. "FLAREGUN_KILLS", 500)
        stats.set_int(MPX() .. "FLAREGUN_DEATHS", 100)
        stats.set_int(MPX() .. "FLAREGUN_SHOTS", 500)
        stats.set_int(MPX() .. "FLAREGUN_HITS", 500)
        stats.set_int(MPX() .. "FLAREGUN_HEADSHOTS", 500)
        stats.set_int(MPX() .. "FLAREGUN_HELDTIME", 5963259)
        stats.set_int(MPX() .. "FLAREGUN_DB_HELDTIME", 5963259)
        stats.set_int(MPX() .. "FLAREGUN_ENEMY_KILLS", 500)
        stats.set_int(MPX() .. "INSURGENT_TURR_KILLS", 500)
        stats.set_int(MPX() .. "INSURGENT_TURR_DEATHS", 100)
        stats.set_int(MPX() .. "INSURGENT_TURR_SHOTS", 500)
        stats.set_int(MPX() .. "INSURGENT_TURR_HITS", 500)
        stats.set_int(MPX() .. "INSURGENT_TURR_HEADSHOTS", 500)
        stats.set_int(MPX() .. "INSURGENT_TURR_HELDTIME", 5963259)
        stats.set_int(MPX() .. "INSURGENT_TURR_ENEMY_KILLS", 500)
        stats.set_int(MPX() .. "SAVAGE_ROCKET_KILLS", 500)
        stats.set_int(MPX() .. "SAVAGE_ROCKET_DEATHS", 100)
        stats.set_int(MPX() .. "SAVAGE_ROCKET_SHOTS", 500)
        stats.set_int(MPX() .. "SAVAGE_ROCKET_HITS", 500)
        stats.set_int(MPX() .. "SAVAGE_ROCKET_HELDTIME", 5963259)
        stats.set_int(MPX() .. "SAVAGE_ROCKET_ENEMY_KILLS", 500)
        stats.set_int(MPX() .. "SAVAGE_BULLET_KILLS", 500)
        stats.set_int(MPX() .. "SAVAGE_BULLET_DEATHS", 100)
        stats.set_int(MPX() .. "SAVAGE_BULLET_SHOTS", 500)
        stats.set_int(MPX() .. "SAVAGE_BULLET_HITS", 500)
        stats.set_int(MPX() .. "SAVAGE_BULLET_HEADSHOTS", 500)
        stats.set_int(MPX() .. "SAVAGE_BULLET_HELDTIME", 5963259)
        stats.set_int(MPX() .. "SAVAGE_BULLET_ENEMY_KILLS", 500)
        stats.set_int(MPX() .. "TECHNICAL_TURR_KILLS", 500)
        stats.set_int(MPX() .. "TECHNICAL_TURR_DEATHS", 100)
        stats.set_int(MPX() .. "TECHNICAL_TURR_SHOTS", 500)
        stats.set_int(MPX() .. "TECHNICAL_TURR_HITS", 500)
        stats.set_int(MPX() .. "TECHNICAL_TURR_HEADSHOTS", 500)
        stats.set_int(MPX() .. "TECHNICAL_TURR_HELDTIME", 5963259)
        stats.set_int(MPX() .. "TECHNICAL_TURR_ENEMY_KILLS", 500)
        stats.set_int(MPX() .. "VEHBOMB_KILLS", 500)
        stats.set_int(MPX() .. "VEHBOMB_DEATHS", 100)
        stats.set_int(MPX() .. "VEHBOMB_SHOTS", 500)
        stats.set_int(MPX() .. "VEHBOMB_HITS", 500)
        stats.set_int(MPX() .. "VEHBOMB_ENEMY_KILLS", 500)
        stats.set_int(MPX() .. "VEHBOMB_C_KILLS", 500)
        stats.set_int(MPX() .. "VEHBOMB_C_DEATHS", 100)
        stats.set_int(MPX() .. "VEHBOMB_C_SHOTS", 500)
        stats.set_int(MPX() .. "VEHBOMB_C_HITS", 500)
        stats.set_int(MPX() .. "VEHBOMB_C_ENEMY_KILLS", 500)
        stats.set_int(MPX() .. "VEHBOMB_G_KILLS", 500)
        stats.set_int(MPX() .. "VEHBOMB_G_DEATHS", 100)
        stats.set_int(MPX() .. "VEHBOMB_G_SHOTS", 500)
        stats.set_int(MPX() .. "VEHBOMB_G_HITS", 500)
        stats.set_int(MPX() .. "VEHBOMB_G_ENEMY_KILLS", 500)
        stats.set_int(MPX() .. "VEHBOMB_I_KILLS", 500)
        stats.set_int(MPX() .. "VEHBOMB_I_DEATHS", 100)
        stats.set_int(MPX() .. "VEHBOMB_I_SHOTS", 500)
        stats.set_int(MPX() .. "VEHBOMB_I_HITS", 500)
        stats.set_int(MPX() .. "VEHBOMB_I_ENEMY_KILLS", 500)
        stats.set_int(MPX() .. "BOMBUSHKA_CANN_KILLS", 500)
        stats.set_int(MPX() .. "BOMBUSHKA_CANN_DEATHS", 100)
        stats.set_int(MPX() .. "BOMBUSHKA_CANN_SHOTS", 500)
        stats.set_int(MPX() .. "BOMBUSHKA_CANN_HITS", 500)
        stats.set_int(MPX() .. "BOMBUSHKA_CANN_HELDTIME", 5963259)
        stats.set_int(MPX() .. "BOMBUSHKA_CANN_ENEMY_KILLS", 500)
        stats.set_int(MPX() .. "BOMBUSHKA_DUAL_KILLS", 500)
        stats.set_int(MPX() .. "BOMBUSHKA_DUAL_DEATHS", 100)
        stats.set_int(MPX() .. "BOMBUSHKA_DUAL_SHOTS", 500)
        stats.set_int(MPX() .. "BOMBUSHKA_DUAL_HITS", 500)
        stats.set_int(MPX() .. "BOMBUSHKA_DUAL_HEADSHOTS", 500)
        stats.set_int(MPX() .. "BOMBUSHKA_DUAL_HELDTIME", 5963259)
        stats.set_int(MPX() .. "BOMBUSHKA_DUAL_ENEMY_KILLS", 500)
        stats.set_int(MPX() .. "HAVOK_MINI_KILLS", 500)
        stats.set_int(MPX() .. "HAVOK_MINI_DEATHS", 100)
        stats.set_int(MPX() .. "HAVOK_MINI_SHOTS", 500)
        stats.set_int(MPX() .. "HAVOK_MINI_HITS", 500)
        stats.set_int(MPX() .. "HAVOK_MINI_HEADSHOTS", 500)
        stats.set_int(MPX() .. "HAVOK_MINI_HELDTIME", 5963259)
        stats.set_int(MPX() .. "HAVOK_MINI_ENEMY_KILLS", 500)
        stats.set_int(MPX() .. "HUNTER_BARR_KILLS", 500)
        stats.set_int(MPX() .. "HUNTER_BARR_DEATHS", 100)
        stats.set_int(MPX() .. "HUNTER_BARR_SHOTS", 500)
        stats.set_int(MPX() .. "HUNTER_BARR_HITS", 500)
        stats.set_int(MPX() .. "HUNTER_BARR_HELDTIME", 5963259)
        stats.set_int(MPX() .. "HUNTER_BARR_ENEMY_KILLS", 500)
        stats.set_int(MPX() .. "HUNTER_CANNON_KILLS", 500)
        stats.set_int(MPX() .. "HUNTER_CANNON_DEATHS", 100)
        stats.set_int(MPX() .. "HUNTER_CANNON_SHOTS", 500)
        stats.set_int(MPX() .. "HUNTER_CANNON_HITS", 500)
        stats.set_int(MPX() .. "HUNTER_CANNON_HELDTIME", 5963259)
        stats.set_int(MPX() .. "HUNTER_CANNON_ENEMY_KILLS", 500)
        stats.set_int(MPX() .. "MICROLIGHT_MG_KILLS", 500)
        stats.set_int(MPX() .. "MICROLIGHT_MG_DEATHS", 100)
        stats.set_int(MPX() .. "MICROLIGHT_MG_SHOTS", 500)
        stats.set_int(MPX() .. "MICROLIGHT_MG_HITS", 500)
        stats.set_int(MPX() .. "MICROLIGHT_MG_HEADSHOTS", 500)
        stats.set_int(MPX() .. "MICROLIGHT_MG_HELDTIME", 5963259)
        stats.set_int(MPX() .. "MICROLIGHT_MG_ENEMY_KILLS", 500)
        stats.set_int(MPX() .. "MOGUL_NOSE_KILLS", 500)
        stats.set_int(MPX() .. "MOGUL_NOSE_DEATHS", 100)
        stats.set_int(MPX() .. "MOGUL_NOSE_SHOTS", 500)
        stats.set_int(MPX() .. "MOGUL_NOSE_HITS", 500)
        stats.set_int(MPX() .. "MOGUL_NOSE_HEADSHOTS", 500)
        stats.set_int(MPX() .. "MOGUL_NOSE_HELDTIME", 5963259)
        stats.set_int(MPX() .. "MOGUL_NOSE_ENEMY_KILLS", 500)
        stats.set_int(MPX() .. "MOGUL_DNOSE_KILLS", 500)
        stats.set_int(MPX() .. "MOGUL_DNOSE_DEATHS", 100)
        stats.set_int(MPX() .. "MOGUL_DNOSE_SHOTS", 500)
        stats.set_int(MPX() .. "MOGUL_DNOSE_HITS", 500)
        stats.set_int(MPX() .. "MOGUL_DNOSE_HEADSHOTS", 500)
        stats.set_int(MPX() .. "MOGUL_DNOSE_HELDTIME", 5963259)
        stats.set_int(MPX() .. "MOGUL_DNOSE_ENEMY_KILLS", 500)
        stats.set_int(MPX() .. "MOGUL_TURR_KILLS", 500)
        stats.set_int(MPX() .. "MOGUL_TURR_DEATHS", 100)
        stats.set_int(MPX() .. "MOGUL_TURR_SHOTS", 500)
        stats.set_int(MPX() .. "MOGUL_TURR_HITS", 500)
        stats.set_int(MPX() .. "MOGUL_TURR_HEADSHOTS", 500)
        stats.set_int(MPX() .. "MOGUL_TURR_HELDTIME", 5963259)
        stats.set_int(MPX() .. "MOGUL_TURR_ENEMY_KILLS", 500)
        stats.set_int(MPX() .. "MOGUL_DTURR_KILLS", 500)
        stats.set_int(MPX() .. "MOGUL_DTURR_DEATHS", 100)
        stats.set_int(MPX() .. "MOGUL_DTURR_SHOTS", 500)
        stats.set_int(MPX() .. "MOGUL_DTURR_HITS", 500)
        stats.set_int(MPX() .. "MOGUL_DTURR_HEADSHOTS", 500)
        stats.set_int(MPX() .. "MOGUL_DTURR_HELDTIME", 5963259)
        stats.set_int(MPX() .. "MOGUL_DTURR_ENEMY_KILLS", 500)
        stats.set_int(MPX() .. "MOLOTOK_MG_KILLS", 500)
        stats.set_int(MPX() .. "MOLOTOK_MG_DEATHS", 100)
        stats.set_int(MPX() .. "MOLOTOK_MG_SHOTS", 500)
        stats.set_int(MPX() .. "MOLOTOK_MG_HITS", 500)
        stats.set_int(MPX() .. "MOLOTOK_MG_HEADSHOTS", 500)
        stats.set_int(MPX() .. "MOLOTOK_MG_HELDTIME", 5963259)
        stats.set_int(MPX() .. "MOLOTOK_MG_ENEMY_KILLS", 500)
        stats.set_int(MPX() .. "MOLOTOK_MISS_KILLS", 500)
        stats.set_int(MPX() .. "MOLOTOK_MISS_DEATHS", 100)
        stats.set_int(MPX() .. "MOLOTOK_MISS_SHOTS", 500)
        stats.set_int(MPX() .. "MOLOTOK_MISS_HITS", 500)
        stats.set_int(MPX() .. "MOLOTOK_MISS_HELDTIME", 5963259)
        stats.set_int(MPX() .. "MOLOTOK_MISS_ENEMY_KILLS", 500)
        stats.set_int(MPX() .. "NOKOTA_MG_KILLS", 500)
        stats.set_int(MPX() .. "NOKOTA_MG_DEATHS", 100)
        stats.set_int(MPX() .. "NOKOTA_MG_SHOTS", 500)
        stats.set_int(MPX() .. "NOKOTA_MG_HITS", 500)
        stats.set_int(MPX() .. "NOKOTA_MG_HEADSHOTS", 500)
        stats.set_int(MPX() .. "NOKOTA_MG_HELDTIME", 5963259)
        stats.set_int(MPX() .. "NOKOTA_MG_ENEMY_KILLS", 500)
        stats.set_int(MPX() .. "NOKOTA_MISS_KILLS", 500)
        stats.set_int(MPX() .. "NOKOTA_MISS_DEATHS", 100)
        stats.set_int(MPX() .. "NOKOTA_MISS_SHOTS", 500)
        stats.set_int(MPX() .. "NOKOTA_MISS_HITS", 500)
        stats.set_int(MPX() .. "NOKOTA_MISS_HELDTIME", 5963259)
        stats.set_int(MPX() .. "NOKOTA_MISS_ENEMY_KILLS", 500)
        stats.set_int(MPX() .. "PYRO_MG_KILLS", 500)
        stats.set_int(MPX() .. "PYRO_MG_DEATHS", 100)
        stats.set_int(MPX() .. "PYRO_MG_SHOTS", 500)
        stats.set_int(MPX() .. "PYRO_MG_HITS", 500)
        stats.set_int(MPX() .. "PYRO_MG_HEADSHOTS", 500)
        stats.set_int(MPX() .. "PYRO_MG_HELDTIME", 5963259)
        stats.set_int(MPX() .. "PYRO_MG_ENEMY_KILLS", 500)
        stats.set_int(MPX() .. "PYRO_MISS_KILLS", 500)
        stats.set_int(MPX() .. "PYRO_MISS_DEATHS", 100)
        stats.set_int(MPX() .. "PYRO_MISS_SHOTS", 500)
        stats.set_int(MPX() .. "PYRO_MISS_HITS", 500)
        stats.set_int(MPX() .. "PYRO_MISS_HELDTIME", 5963259)
        stats.set_int(MPX() .. "PYRO_MISS_ENEMY_KILLS", 500)
        stats.set_int(MPX() .. "ROGUE_MG_KILLS", 500)
        stats.set_int(MPX() .. "ROGUE_MG_DEATHS", 100)
        stats.set_int(MPX() .. "ROGUE_MG_SHOTS", 500)
        stats.set_int(MPX() .. "ROGUE_MG_HITS", 500)
        stats.set_int(MPX() .. "ROGUE_MG_HEADSHOTS", 500)
        stats.set_int(MPX() .. "ROGUE_MG_HELDTIME", 5963259)
        stats.set_int(MPX() .. "ROGUE_MG_ENEMY_KILLS", 500)
        stats.set_int(MPX() .. "ROGUE_CANN_KILLS", 500)
        stats.set_int(MPX() .. "ROGUE_CANN_DEATHS", 100)
        stats.set_int(MPX() .. "ROGUE_CANN_SHOTS", 500)
        stats.set_int(MPX() .. "ROGUE_CANN_HITS", 500)
        stats.set_int(MPX() .. "ROGUE_CANN_HELDTIME", 5963259)
        stats.set_int(MPX() .. "ROGUE_CANN_ENEMY_KILLS", 500)
        stats.set_int(MPX() .. "ROGUE_MISS_KILLS", 500)
        stats.set_int(MPX() .. "ROGUE_MISS_DEATHS", 100)
        stats.set_int(MPX() .. "ROGUE_MISS_SHOTS", 500)
        stats.set_int(MPX() .. "ROGUE_MISS_HITS", 500)
        stats.set_int(MPX() .. "ROGUE_MISS_HELDTIME", 5963259)
        stats.set_int(MPX() .. "ROGUE_MISS_ENEMY_KILLS", 500)
        stats.set_int(MPX() .. "STARLING_MG_KILLS", 500)
        stats.set_int(MPX() .. "STARLING_MG_DEATHS", 100)
        stats.set_int(MPX() .. "STARLING_MG_SHOTS", 500)
        stats.set_int(MPX() .. "STARLING_MG_HITS", 500)
        stats.set_int(MPX() .. "STARLING_MG_HEADSHOTS", 500)
        stats.set_int(MPX() .. "STARLING_MG_HELDTIME", 5963259)
        stats.set_int(MPX() .. "STARLING_MG_ENEMY_KILLS", 500)
        stats.set_int(MPX() .. "STARLING_MISS_KILLS", 500)
        stats.set_int(MPX() .. "STARLING_MISS_DEATHS", 100)
        stats.set_int(MPX() .. "STARLING_MISS_SHOTS", 500)
        stats.set_int(MPX() .. "STARLING_MISS_HITS", 500)
        stats.set_int(MPX() .. "STARLING_MISS_HELDTIME", 5963259)
        stats.set_int(MPX() .. "STARLING_MISS_ENEMY_KILLS", 500)
        stats.set_int(MPX() .. "SEABREEZE_MG_KILLS", 500)
        stats.set_int(MPX() .. "SEABREEZE_MG_DEATHS", 100)
        stats.set_int(MPX() .. "SEABREEZE_MG_SHOTS", 500)
        stats.set_int(MPX() .. "SEABREEZE_MG_HITS", 500)
        stats.set_int(MPX() .. "SEABREEZE_MG_HEADSHOTS", 500)
        stats.set_int(MPX() .. "SEABREEZE_MG_HELDTIME", 5963259)
        stats.set_int(MPX() .. "SEABREEZE_MG_ENEMY_KILLS", 500)
        stats.set_int(MPX() .. "TULA_MG_KILLS", 500)
        stats.set_int(MPX() .. "TULA_MG_DEATHS", 100)
        stats.set_int(MPX() .. "TULA_MG_SHOTS", 500)
        stats.set_int(MPX() .. "TULA_MG_HITS", 500)
        stats.set_int(MPX() .. "TULA_MG_HEADSHOTS", 500)
        stats.set_int(MPX() .. "TULA_MG_HELDTIME", 5963259)
        stats.set_int(MPX() .. "TULA_MG_ENEMY_KILLS", 500)
        stats.set_int(MPX() .. "TULA_SINGLEMG_KILLS", 500)
        stats.set_int(MPX() .. "TULA_SINGLEMG_DEATHS", 100)
        stats.set_int(MPX() .. "TULA_SINGLEMG_SHOTS", 500)
        stats.set_int(MPX() .. "TULA_SINGLEMG_HITS", 500)
        stats.set_int(MPX() .. "TULA_SINGLEMG_HEADSHOTS", 500)
        stats.set_int(MPX() .. "TULA_SINGLEMG_HELDTIME", 5963259)
        stats.set_int(MPX() .. "TULA_SINGLEMG_ENEMY_KILLS", 500)
        stats.set_int(MPX() .. "TULA_DUALMG_KILLS", 500)
        stats.set_int(MPX() .. "TULA_DUALMG_DEATHS", 100)
        stats.set_int(MPX() .. "TULA_DUALMG_SHOTS", 500)
        stats.set_int(MPX() .. "TULA_DUALMG_HITS", 500)
        stats.set_int(MPX() .. "TULA_DUALMG_HEADSHOTS", 500)
        stats.set_int(MPX() .. "TULA_DUALMG_HELDTIME", 5963259)
        stats.set_int(MPX() .. "TULA_DUALMG_ENEMY_KILLS", 500)
        stats.set_int(MPX() .. "TULA_MINI_KILLS", 500)
        stats.set_int(MPX() .. "TULA_MINI_DEATHS", 100)
        stats.set_int(MPX() .. "TULA_MINI_SHOTS", 500)
        stats.set_int(MPX() .. "TULA_MINI_HITS", 500)
        stats.set_int(MPX() .. "TULA_MINI_HEADSHOTS", 500)
        stats.set_int(MPX() .. "TULA_MINI_HELDTIME", 5963259)
        stats.set_int(MPX() .. "TULA_MINI_ENEMY_KILLS", 500)
        stats.set_int(MPX() .. "VIGILANTE_MG_KILLS", 500)
        stats.set_int(MPX() .. "VIGILANTE_MG_DEATHS", 100)
        stats.set_int(MPX() .. "VIGILANTE_MG_SHOTS", 500)
        stats.set_int(MPX() .. "VIGILANTE_MG_HITS", 500)
        stats.set_int(MPX() .. "VIGILANTE_MG_HEADSHOTS", 500)
        stats.set_int(MPX() .. "VIGILANTE_MG_HELDTIME", 5963259)
        stats.set_int(MPX() .. "VIGILANTE_MG_ENEMY_KILLS", 500)
        stats.set_int(MPX() .. "VIGILANTE_MISS_KILLS", 500)
        stats.set_int(MPX() .. "VIGILANTE_MISS_DEATHS", 100)
        stats.set_int(MPX() .. "VIGILANTE_MISS_SHOTS", 500)
        stats.set_int(MPX() .. "VIGILANTE_MISS_HITS", 500)
        stats.set_int(MPX() .. "VIGILANTE_MISS_HELDTIME", 5963259)
        stats.set_int(MPX() .. "VIGILANTE_MISS_ENEMY_KILLS", 500)
        stats.set_int(MPX() .. "BOXVILLE5_TURR_KILLS", 500)
        stats.set_int(MPX() .. "BOXVILLE5_TURR_DEATHS", 100)
        stats.set_int(MPX() .. "BOXVILLE5_TURR_SHOTS", 500)
        stats.set_int(MPX() .. "BOXVILLE5_TURR_HITS", 500)
        stats.set_int(MPX() .. "BOXVILLE5_TURR_HEADSHOTS", 500)
        stats.set_int(MPX() .. "BOXVILLE5_TURR_HELDTIME", 5963259)
        stats.set_int(MPX() .. "BOXVILLE5_TURR_ENEMY_KILLS", 500)
        stats.set_int(MPX() .. "BLAZER5_CANNON_KILLS", 500)
        stats.set_int(MPX() .. "BLAZER5_CANNON_DEATHS", 100)
        stats.set_int(MPX() .. "BLAZER5_CANNON_SHOTS", 500)
        stats.set_int(MPX() .. "BLAZER5_CANNON_HITS", 500)
        stats.set_int(MPX() .. "BLAZER5_CANNON_HEADSHOTS", 500)
        stats.set_int(MPX() .. "BLAZER5_CANNON_HELDTIME", 5963259)
        stats.set_int(MPX() .. "BLAZER5_CANNON_ENEMY_KILLS", 500)
        stats.set_int(MPX() .. "RUINER2_BULLET_KILLS", 500)
        stats.set_int(MPX() .. "RUINER2_BULLET_DEATHS", 100)
        stats.set_int(MPX() .. "RUINER2_BULLET_SHOTS", 500)
        stats.set_int(MPX() .. "RUINER2_BULLET_HITS", 500)
        stats.set_int(MPX() .. "RUINER2_BULLET_HEADSHOTS", 500)
        stats.set_int(MPX() .. "RUINER2_BULLET_HELDTIME", 5963259)
        stats.set_int(MPX() .. "RUINER2_BULLET_ENEMY_KILLS", 500)
        stats.set_int(MPX() .. "RUINER2_ROCKET_KILLS", 500)
        stats.set_int(MPX() .. "RUINER2_ROCKET_DEATHS", 100)
        stats.set_int(MPX() .. "RUINER2_ROCKET_SHOTS", 500)
        stats.set_int(MPX() .. "RUINER2_ROCKET_HITS", 500)
        stats.set_int(MPX() .. "RUINER2_ROCKET_HEADSHOTS", 500)
        stats.set_int(MPX() .. "RUINER2_ROCKET_HELDTIME", 5963259)
        stats.set_int(MPX() .. "RUINER2_ROCKET_ENEMY_KILLS", 500)
        stats.set_int(MPX() .. "TECHNICAL2_TURR_KILLS", 500)
        stats.set_int(MPX() .. "TECHNICAL2_TURR_DEATHS", 100)
        stats.set_int(MPX() .. "TECHNICAL2_TURR_SHOTS", 500)
        stats.set_int(MPX() .. "TECHNICAL2_TURR_HITS", 500)
        stats.set_int(MPX() .. "TECHNICAL2_TURR_HEADSHOTS", 500)
        stats.set_int(MPX() .. "TECHNICAL2_TURR_HELDTIME", 5963259)
        stats.set_int(MPX() .. "TECHNICAL2_TURR_ENEMY_KILLS", 500)
        stats.set_int(MPX() .. "CRARMWREST", 500)
        stats.set_int(MPX() .. "CRBASEJUMP", 500)
        stats.set_int(MPX() .. "CRDARTS", 500)
        stats.set_int(MPX() .. "CRDM", 500)
        stats.set_int(MPX() .. "CRGANGHIDE", 500)
        stats.set_int(MPX() .. "CRGOLF", 500)
        stats.set_int(MPX() .. "CRHORDE", 500)
        stats.set_int(MPX() .. "CRMISSION", 500)
        stats.set_int(MPX() .. "CRSHOOTRNG", 500)
        stats.set_int(MPX() .. "CRTENNIS", 500)
        stats.set_int(MPX() .. "NO_TIMES_CINEMA", 500)
        stats.set_int(MPX() .. "AWD_CONTRACTOR", 50)
        stats.set_int(MPX() .. "AWD_COLD_CALLER", 50)
        stats.set_int(MPX() .. "AWD_PRODUCER", 60)
        stats.set_int(MPX() .. "FIXERTELEPHONEHITSCOMPL", 10)
        stats.set_int(MPX() .. "PAYPHONE_BONUS_KILL_METHOD", -1)
        stats.set_int(MPX() .. "TWR_INITIALS_0", 69644)
        stats.set_int(MPX() .. "TWR_INITIALS_1", 69644)
        stats.set_int(MPX() .. "TWR_INITIALS_2", 69644)
        stats.set_int(MPX() .. "TWR_INITIALS_3", 69644)
        stats.set_int(MPX() .. "TWR_INITIALS_4", 69644)
        stats.set_int(MPX() .. "TWR_INITIALS_5", 69644)
        stats.set_int(MPX() .. "TWR_INITIALS_6", 69644)
        stats.set_int(MPX() .. "TWR_INITIALS_7", 69644)
        stats.set_int(MPX() .. "TWR_INITIALS_8", 69644)
        stats.set_int(MPX() .. "TWR_INITIALS_9", 69644)
        stats.set_int(MPX() .. "TWR_SCORE_0", 50)
        stats.set_int(MPX() .. "TWR_SCORE_1", 50)
        stats.set_int(MPX() .. "TWR_SCORE_2", 50)
        stats.set_int(MPX() .. "TWR_SCORE_3", 50)
        stats.set_int(MPX() .. "TWR_SCORE_4", 50)
        stats.set_int(MPX() .. "TWR_SCORE_5", 50)
        stats.set_int(MPX() .. "TWR_SCORE_6", 50)
        stats.set_int(MPX() .. "TWR_SCORE_7", 50)
        stats.set_int(MPX() .. "TWR_SCORE_8", 50)
        stats.set_int(MPX() .. "TWR_SCORE_9", 50)
        stats.set_int(MPX() .. "GGSM_INITIALS_0", 69644)
        stats.set_int(MPX() .. "GGSM_INITIALS_1", 69644)
        stats.set_int(MPX() .. "GGSM_INITIALS_2", 69644)
        stats.set_int(MPX() .. "GGSM_INITIALS_3", 69644)
        stats.set_int(MPX() .. "GGSM_INITIALS_4", 69644)
        stats.set_int(MPX() .. "GGSM_INITIALS_5", 69644)
        stats.set_int(MPX() .. "GGSM_INITIALS_6", 69644)
        stats.set_int(MPX() .. "GGSM_INITIALS_7", 69644)
        stats.set_int(MPX() .. "GGSM_INITIALS_8", 69644)
        stats.set_int(MPX() .. "GGSM_INITIALS_9", 69644)
        stats.set_int(MPX() .. "GGSM_SCORE_0", 50)
        stats.set_int(MPX() .. "GGSM_SCORE_1", 50)
        stats.set_int(MPX() .. "GGSM_SCORE_2", 50)
        stats.set_int(MPX() .. "GGSM_SCORE_3", 50)
        stats.set_int(MPX() .. "GGSM_SCORE_4", 50)
        stats.set_int(MPX() .. "GGSM_SCORE_5", 50)
        stats.set_int(MPX() .. "GGSM_SCORE_6", 50)
        stats.set_int(MPX() .. "GGSM_SCORE_7", 50)
        stats.set_int(MPX() .. "GGSM_SCORE_8", 50)
        stats.set_int(MPX() .. "GGSM_SCORE_9", 50)
        stats.set_int(MPX() .. "DG_PENETRATOR_INITIALS_0", 69644)
        stats.set_int(MPX() .. "DG_PENETRATOR_INITIALS_1", 69644)
        stats.set_int(MPX() .. "DG_PENETRATOR_INITIALS_2", 69644)
        stats.set_int(MPX() .. "DG_PENETRATOR_INITIALS_3", 69644)
        stats.set_int(MPX() .. "DG_PENETRATOR_INITIALS_4", 69644)
        stats.set_int(MPX() .. "DG_PENETRATOR_INITIALS_5", 69644)
        stats.set_int(MPX() .. "DG_PENETRATOR_INITIALS_6", 69644)
        stats.set_int(MPX() .. "DG_PENETRATOR_INITIALS_7", 69644)
        stats.set_int(MPX() .. "DG_PENETRATOR_INITIALS_8", 69644)
        stats.set_int(MPX() .. "DG_PENETRATOR_INITIALS_9", 69644)
        stats.set_int(MPX() .. "DG_PENETRATOR_SCORE_0", 50)
        stats.set_int(MPX() .. "DG_PENETRATOR_SCORE_1", 50)
        stats.set_int(MPX() .. "DG_PENETRATOR_SCORE_2", 50)
        stats.set_int(MPX() .. "DG_PENETRATOR_SCORE_3", 50)
        stats.set_int(MPX() .. "DG_PENETRATOR_SCORE_4", 50)
        stats.set_int(MPX() .. "DG_PENETRATOR_SCORE_5", 50)
        stats.set_int(MPX() .. "DG_PENETRATOR_SCORE_6", 50)
        stats.set_int(MPX() .. "DG_PENETRATOR_SCORE_7", 50)
        stats.set_int(MPX() .. "DG_PENETRATOR_SCORE_8", 50)
        stats.set_int(MPX() .. "DG_PENETRATOR_SCORE_9", 50)
        stats.set_int(MPX() .. "DG_MONKEY_INITIALS_0", 69644)
        stats.set_int(MPX() .. "DG_MONKEY_INITIALS_1", 69644)
        stats.set_int(MPX() .. "DG_MONKEY_INITIALS_2", 69644)
        stats.set_int(MPX() .. "DG_MONKEY_INITIALS_3", 69644)
        stats.set_int(MPX() .. "DG_MONKEY_INITIALS_4", 69644)
        stats.set_int(MPX() .. "DG_MONKEY_INITIALS_5", 69644)
        stats.set_int(MPX() .. "DG_MONKEY_INITIALS_6", 69644)
        stats.set_int(MPX() .. "DG_MONKEY_INITIALS_7", 69644)
        stats.set_int(MPX() .. "DG_MONKEY_INITIALS_8", 69644)
        stats.set_int(MPX() .. "DG_MONKEY_INITIALS_9", 69644)
        stats.set_int(MPX() .. "DG_MONKEY_SCORE_0", 50)
        stats.set_int(MPX() .. "DG_MONKEY_SCORE_1", 50)
        stats.set_int(MPX() .. "DG_MONKEY_SCORE_2", 50)
        stats.set_int(MPX() .. "DG_MONKEY_SCORE_3", 50)
        stats.set_int(MPX() .. "DG_MONKEY_SCORE_4", 50)
        stats.set_int(MPX() .. "DG_MONKEY_SCORE_5", 50)
        stats.set_int(MPX() .. "DG_MONKEY_SCORE_6", 50)
        stats.set_int(MPX() .. "DG_MONKEY_SCORE_7", 50)
        stats.set_int(MPX() .. "DG_MONKEY_SCORE_8", 50)
        stats.set_int(MPX() .. "DG_MONKEY_SCORE_9", 50)
        stats.set_int(MPX() .. "IAP_MA0_MOON_DIST", 2147483647)
        stats.set_int(MPX() .. "AWD_FACES_OF_DEATH", 47)
        stats.set_int(MPX() .. "IAP_INITIALS_0", 50)
        stats.set_int(MPX() .. "IAP_INITIALS_1", 50)
        stats.set_int(MPX() .. "IAP_INITIALS_2", 50)
        stats.set_int(MPX() .. "IAP_INITIALS_3", 50)
        stats.set_int(MPX() .. "IAP_INITIALS_4", 50)
        stats.set_int(MPX() .. "IAP_INITIALS_5", 50)
        stats.set_int(MPX() .. "IAP_INITIALS_6", 50)
        stats.set_int(MPX() .. "IAP_INITIALS_7", 50)
        stats.set_int(MPX() .. "IAP_INITIALS_8", 50)
        stats.set_int(MPX() .. "IAP_INITIALS_9", 50)
        stats.set_int(MPX() .. "IAP_SCORE_0", 69644)
        stats.set_int(MPX() .. "IAP_SCORE_1", 50333)
        stats.set_int(MPX() .. "IAP_SCORE_2", 63512)
        stats.set_int(MPX() .. "IAP_SCORE_3", 46136)
        stats.set_int(MPX() .. "IAP_SCORE_4", 21638)
        stats.set_int(MPX() .. "IAP_SCORE_5", 2133)
        stats.set_int(MPX() .. "IAP_SCORE_6", 1215)
        stats.set_int(MPX() .. "IAP_SCORE_7", 2444)
        stats.set_int(MPX() .. "IAP_SCORE_8", 38023)
        stats.set_int(MPX() .. "IAP_SCORE_9", 2233)
        stats.set_int(MPX() .. "SCGW_SCORE_1", 50)
        stats.set_int(MPX() .. "SCGW_SCORE_2", 50)
        stats.set_int(MPX() .. "SCGW_SCORE_3", 50)
        stats.set_int(MPX() .. "SCGW_SCORE_4", 50)
        stats.set_int(MPX() .. "SCGW_SCORE_5", 50)
        stats.set_int(MPX() .. "SCGW_SCORE_6", 50)
        stats.set_int(MPX() .. "SCGW_SCORE_7", 50)
        stats.set_int(MPX() .. "SCGW_SCORE_8", 50)
        stats.set_int(MPX() .. "SCGW_SCORE_9", 50)
        stats.set_int(MPX() .. "DG_DEFENDER_INITIALS_0", 69644)
        stats.set_int(MPX() .. "DG_DEFENDER_INITIALS_1", 69644)
        stats.set_int(MPX() .. "DG_DEFENDER_INITIALS_2", 69644)
        stats.set_int(MPX() .. "DG_DEFENDER_INITIALS_3", 69644)
        stats.set_int(MPX() .. "DG_DEFENDER_INITIALS_4", 69644)
        stats.set_int(MPX() .. "DG_DEFENDER_INITIALS_5", 69644)
        stats.set_int(MPX() .. "DG_DEFENDER_INITIALS_6", 69644)
        stats.set_int(MPX() .. "DG_DEFENDER_INITIALS_7", 69644)
        stats.set_int(MPX() .. "DG_DEFENDER_INITIALS_8", 69644)
        stats.set_int(MPX() .. "DG_DEFENDER_INITIALS_9", 69644)
        stats.set_int(MPX() .. "DG_DEFENDER_SCORE_0", 50)
        stats.set_int(MPX() .. "DG_DEFENDER_SCORE_1", 50)
        stats.set_int(MPX() .. "DG_DEFENDER_SCORE_2", 50)
        stats.set_int(MPX() .. "DG_DEFENDER_SCORE_3", 50)
        stats.set_int(MPX() .. "DG_DEFENDER_SCORE_4", 50)
        stats.set_int(MPX() .. "DG_DEFENDER_SCORE_5", 50)
        stats.set_int(MPX() .. "DG_DEFENDER_SCORE_6", 50)
        stats.set_int(MPX() .. "DG_DEFENDER_SCORE_7", 50)
        stats.set_int(MPX() .. "DG_DEFENDER_SCORE_8", 50)
        stats.set_int(MPX() .. "DG_DEFENDER_SCORE_9", 50)
        stats.set_int(MPX() .. "AWD_CAR_CLUB_MEM", 100)
        stats.set_int(MPX() .. "AWD_SPRINTRACER", 50)
        stats.set_int(MPX() .. "AWD_STREETRACER", 50)
        stats.set_int(MPX() .. "AWD_PURSUITRACER", 50)
        stats.set_int(MPX() .. "AWD_TEST_CAR", 240)
        stats.set_int(MPX() .. "AWD_AUTO_SHOP", 50)
        stats.set_int(MPX() .. "AWD_CAR_EXPORT", 100)
        stats.set_int(MPX() .. "AWD_GROUNDWORK", 40)
        stats.set_int(MPX() .. "AWD_ROBBERY_CONTRACT", 100)
        stats.set_int(MPX() .. "AWD_FACES_OF_DEATH", 100)
        stats.set_int(MPX() .. "CLTHS_AVAILABLE_LEGS_3", -1)
        stats.set_int(MPX() .. "CLTHS_AVAILABLE_LEGS_4", -1)
        stats.set_int(MPX() .. "CLTHS_AVAILABLE_LEGS_5", -1)
        stats.set_int(MPX() .. "CLTHS_AVAILABLE_LEGS_6", -1)
        stats.set_int(MPX() .. "CLTHS_AVAILABLE_LEGS_7", -1)
        stats.set_int(MPX() .. "CLTHS_AVAILABLE_OUTFIT", -1)
        stats.set_int(MPX() .. "CLTHS_AVAILABLE_PROPS", -1)
        stats.set_int(MPX() .. "CLTHS_AVAILABLE_PROPS_1", -1)
        stats.set_int(MPX() .. "CLTHS_AVAILABLE_PROPS_10", -1)
        stats.set_int(MPX() .. "CLTHS_AVAILABLE_PROPS_2", -1)
        stats.set_int(MPX() .. "CLTHS_AVAILABLE_PROPS_3", -1)
        stats.set_int(MPX() .. "CLTHS_AVAILABLE_PROPS_4", -1)
        stats.set_int(MPX() .. "CLTHS_AVAILABLE_PROPS_5", -1)
        stats.set_int(MPX() .. "CLTHS_AVAILABLE_PROPS_6", -1)
        stats.set_int(MPX() .. "CLTHS_AVAILABLE_PROPS_7", -1)
        stats.set_int(MPX() .. "CLTHS_AVAILABLE_PROPS_8", -1)
        stats.set_int(MPX() .. "CLTHS_AVAILABLE_PROPS_9", -1)
        stats.set_int(MPX() .. "CLTHS_AVAILABLE_SPECIAL", -1)
        stats.set_int(MPX() .. "CLTHS_AVAILABLE_SPECIAL2", -1)
        stats.set_int(MPX() .. "CLTHS_AVAILABLE_SPECIAL2_1", -1)
        stats.set_int(MPX() .. "CLTHS_AVAILABLE_SPECIAL_1", -1)
        stats.set_int(MPX() .. "CLTHS_AVAILABLE_SPECIAL_2", -1)
        stats.set_int(MPX() .. "CLTHS_AVAILABLE_SPECIAL_3", -1)
        stats.set_int(MPX() .. "CLTHS_AVAILABLE_SPECIAL_4", -1)
        stats.set_int(MPX() .. "CLTHS_AVAILABLE_SPECIAL_5", -1)
        stats.set_int(MPX() .. "CLTHS_AVAILABLE_SPECIAL_6", -1)
        stats.set_int(MPX() .. "CLTHS_AVAILABLE_SPECIAL_7", -1)
        stats.set_int(MPX() .. "CLTHS_AVAILABLE_TEETH", -1)
        stats.set_int(MPX() .. "CLTHS_AVAILABLE_TEETH_1", -1)
        stats.set_int(MPX() .. "CLTHS_AVAILABLE_TEETH_2", -1)
        stats.set_int(MPX() .. "CLTHS_AVAILABLE_TORSO", -1)
        stats.set_int(MPX() .. "DLC_APPAREL_ACQUIRED_0", -1)
        stats.set_int(MPX() .. "DLC_APPAREL_ACQUIRED_1", -1)
        stats.set_int(MPX() .. "DLC_APPAREL_ACQUIRED_10", -1)
        stats.set_int(MPX() .. "DLC_APPAREL_ACQUIRED_11", -1)
        stats.set_int(MPX() .. "DLC_APPAREL_ACQUIRED_12", -1)
        stats.set_int(MPX() .. "DLC_APPAREL_ACQUIRED_13", -1)
        stats.set_int(MPX() .. "DLC_APPAREL_ACQUIRED_14", -1)
        stats.set_int(MPX() .. "DLC_APPAREL_ACQUIRED_15", -1)
        stats.set_int(MPX() .. "DLC_APPAREL_ACQUIRED_16", -1)
        stats.set_int(MPX() .. "DLC_APPAREL_ACQUIRED_17", -1)
        stats.set_int(MPX() .. "DLC_APPAREL_ACQUIRED_18", -1)
        stats.set_int(MPX() .. "DLC_APPAREL_ACQUIRED_19", -1)
        stats.set_int(MPX() .. "DLC_APPAREL_ACQUIRED_2", -1)
        stats.set_int(MPX() .. "DLC_APPAREL_ACQUIRED_20", -1)
        stats.set_int(MPX() .. "DLC_APPAREL_ACQUIRED_21", -1)
        stats.set_int(MPX() .. "DLC_APPAREL_ACQUIRED_22", -1)
        stats.set_int(MPX() .. "DLC_APPAREL_ACQUIRED_23", -1)
        stats.set_int(MPX() .. "DLC_APPAREL_ACQUIRED_24", -1)
        stats.set_int(MPX() .. "DLC_APPAREL_ACQUIRED_25", -1)
        stats.set_int(MPX() .. "DLC_APPAREL_ACQUIRED_26", -1)
        stats.set_int(MPX() .. "DLC_APPAREL_ACQUIRED_27", -1)
        stats.set_int(MPX() .. "DLC_APPAREL_ACQUIRED_28", -1)
        stats.set_int(MPX() .. "DLC_APPAREL_ACQUIRED_29", -1)
        stats.set_int(MPX() .. "DLC_APPAREL_ACQUIRED_3", -1)
        stats.set_int(MPX() .. "DLC_APPAREL_ACQUIRED_30", -1)
        stats.set_int(MPX() .. "DLC_APPAREL_ACQUIRED_31", -1)
        stats.set_int(MPX() .. "DLC_APPAREL_ACQUIRED_32", -1)
        stats.set_int(MPX() .. "DLC_APPAREL_ACQUIRED_33", -1)
        stats.set_int(MPX() .. "DLC_APPAREL_ACQUIRED_34", -1)
        stats.set_int(MPX() .. "DLC_APPAREL_ACQUIRED_35", -1)
        stats.set_int(MPX() .. "DLC_APPAREL_ACQUIRED_36", -1)
        stats.set_int(MPX() .. "DLC_APPAREL_ACQUIRED_37", -1)
        stats.set_int(MPX() .. "DLC_APPAREL_ACQUIRED_38", -1)
        stats.set_int(MPX() .. "DLC_APPAREL_ACQUIRED_39", -1)
        stats.set_int(MPX() .. "DLC_APPAREL_ACQUIRED_4", -1)
        stats.set_int(MPX() .. "DLC_APPAREL_ACQUIRED_40", -1)
        stats.set_int(MPX() .. "DLC_APPAREL_ACQUIRED_5", -1)
        stats.set_int(MPX() .. "DLC_APPAREL_ACQUIRED_6", -1)
        stats.set_int(MPX() .. "DLC_APPAREL_ACQUIRED_7", -1)
        stats.set_int(MPX() .. "DLC_APPAREL_ACQUIRED_8", -1)
        stats.set_int(MPX() .. "DLC_APPAREL_ACQUIRED_9", -1)
        stats.set_int(MPX() .. "GRENADE_ENEMY_KILLS", 50)
        stats.set_int(MPX() .. "MICROSMG_ENEMY_KILLS", 500)
        stats.set_int(MPX() .. "SMG_ENEMY_KILLS", 500)
        stats.set_int(MPX() .. "ASLTSMG_ENEMY_KILLS", 500)
        stats.set_int(MPX() .. "ASLTRIFLE_ENEMY_KILLS", 500)
        stats.set_int(MPX() .. "CRBNRIFLE_ENEMY_KILLS", 500)
        stats.set_int(MPX() .. "ADVRIFLE_ENEMY_KILLS", 500)
        stats.set_int(MPX() .. "MG_ENEMY_KILLS", 500)
        stats.set_int(MPX() .. "CMBTMG_ENEMY_KILLS", 500)
        stats.set_int(MPX() .. "ASLTMG_ENEMY_KILLS", 500)
        stats.set_int(MPX() .. "RPG_ENEMY_KILLS", 500)
        stats.set_int(MPX() .. "LONGEST_WHEELIE_DIST", 1000)
        stats.set_int(MPX() .. "MOST_ARM_WRESTLING_WINS", 25)
        stats.set_int(MPX() .. "NO_CARS_REPAIR", 1000)
        stats.set_int(MPX() .. "VEHICLES_SPRAYED", 500)
        stats.set_int(MPX() .. "NUMBER_NEAR_MISS_NOCRASH", 500)
        stats.set_int(MPX() .. "USJS_FOUND", 50)
        stats.set_int(MPX() .. "USJS_FOUND_MASK", 50)
        stats.set_int(MPX() .. "USJS_COMPLETED", 50)
        stats.set_int(MPX() .. "USJS_TOTAL_COMPLETED", 50)
        stats.set_int(MPX() .. "USJS_COMPLETED_MASK", 50)
        stats.set_int(MPX() .. "MOST_FLIPS_IN_ONE_JUMP", 5)
        stats.set_int(MPX() .. "MOST_SPINS_IN_ONE_JUMP", 5)
        stats.set_int(MPX() .. "NUMBER_SLIPSTREAMS_IN_RACE", 100)
        stats.set_int(MPX() .. "NUMBER_TURBO_STARTS_IN_RACE", 50)
        stats.set_int(MPX() .. "PASS_DB_PLAYER_KILLS", 100)
        stats.set_int(MPX() .. "PISTOL_ENEMY_KILLS", 500)
        stats.set_int(MPX() .. "PLAYER_HEADSHOTS", 500)
        stats.set_int(MPX() .. "RACES_WON", 50)
        stats.set_int(MPX() .. "SAWNOFF_ENEMY_KILLS", 500)
        stats.set_int(MPX() .. "SCRIPT_INCREASE_DRIV", 100)
        stats.set_int(MPX() .. "SCRIPT_INCREASE_FLY", 100)
        stats.set_int(MPX() .. "SCRIPT_INCREASE_LUNG", 100)
        stats.set_int(MPX() .. "SCRIPT_INCREASE_MECH", 100)
        stats.set_int(MPX() .. "SCRIPT_INCREASE_SHO", 100)
        stats.set_int(MPX() .. "SCRIPT_INCREASE_STAM", 100)
        stats.set_int(MPX() .. "SCRIPT_INCREASE_STL", 100)
        stats.set_int(MPX() .. "SCRIPT_INCREASE_STRN", 100)
        stats.set_int(MPX() .. "STKYBMB_ENEMY_KILLS", 50)
        stats.set_int(MPX() .. "UNARMED_ENEMY_KILLS", 50)
        stats.set_int(MPX() .. "USJS_COMPLETED", 50)
        stats.set_int(MPX() .. "WEAP_FM_ADDON_PURCH", -1)
        stats.set_int(MPX() .. "WEAP_FM_ADDON_PURCH2", -1)
        stats.set_int(MPX() .. "WEAP_FM_ADDON_PURCH3", -1)
        stats.set_int(MPX() .. "WEAP_FM_ADDON_PURCH4", -1)
        stats.set_int(MPX() .. "WEAP_FM_ADDON_PURCH5", -1)
        stats.set_int(MPX() .. "CRDEADLINE", 5)
        stats.set_int(MPX() .. "CHAR_FM_ABILITY_1_UNLCK", -1)
        stats.set_int(MPX() .. "CHAR_FM_ABILITY_2_UNLCK", -1)
        stats.set_int(MPX() .. "CHAR_FM_ABILITY_3_UNLCK", -1)
        stats.set_int(MPX() .. "CHAR_ABILITY_1_UNLCK", -1)
        stats.set_int(MPX() .. "CHAR_ABILITY_2_UNLCK", -1)
        stats.set_int(MPX() .. "CHAR_ABILITY_3_UNLCK", -1)
        stats.set_int(MPX() .. "LIFETIME_BIKER_BUY_COMPLET", 1000)
        stats.set_int(MPX() .. "LIFETIME_BIKER_BUY_UNDERTA", 1000)
        stats.set_int(MPX() .. "LIFETIME_BIKER_SELL_COMPLET", 1000)
        stats.set_int(MPX() .. "LIFETIME_BIKER_SELL_UNDERTA", 1000)
        stats.set_int(MPX() .. "LIFETIME_BIKER_BUY_COMPLET1", 1000)
        stats.set_int(MPX() .. "LIFETIME_BIKER_BUY_UNDERTA1", 1000)
        stats.set_int(MPX() .. "LIFETIME_BIKER_SELL_COMPLET1", 1000)
        stats.set_int(MPX() .. "LIFETIME_BIKER_SELL_UNDERTA1", 1000)
        stats.set_int(MPX() .. "LIFETIME_BIKER_BUY_COMPLET2", 1000)
        stats.set_int(MPX() .. "LIFETIME_BIKER_BUY_UNDERTA2", 1000)
        stats.set_int(MPX() .. "LIFETIME_BIKER_SELL_COMPLET2", 1000)
        stats.set_int(MPX() .. "LIFETIME_BIKER_SELL_UNDERTA2", 1000)
        stats.set_int(MPX() .. "LIFETIME_BIKER_BUY_COMPLET3", 1000)
        stats.set_int(MPX() .. "LIFETIME_BIKER_BUY_UNDERTA3", 1000)
        stats.set_int(MPX() .. "LIFETIME_BIKER_SELL_COMPLET3", 1000)
        stats.set_int(MPX() .. "LIFETIME_BIKER_SELL_UNDERTA3", 1000)
        stats.set_int(MPX() .. "LIFETIME_BIKER_BUY_COMPLET4", 1000)
        stats.set_int(MPX() .. "LIFETIME_BIKER_BUY_UNDERTA4", 1000)
        stats.set_int(MPX() .. "LIFETIME_BIKER_SELL_COMPLET4", 1000)
        stats.set_int(MPX() .. "LIFETIME_BIKER_SELL_UNDERTA4", 1000)
        stats.set_int(MPX() .. "LIFETIME_BIKER_BUY_COMPLET5", 1000)
        stats.set_int(MPX() .. "LIFETIME_BIKER_BUY_UNDERTA5", 1000)
        stats.set_int(MPX() .. "LIFETIME_BIKER_SELL_COMPLET5", 1000)
        stats.set_int(MPX() .. "LIFETIME_BIKER_SELL_UNDERTA5", 1000)
        stats.set_int(MPX() .. "LIFETIME_BKR_SELL_EARNINGS0", 20000000)
        stats.set_int(MPX() .. "LIFETIME_BKR_SELL_EARNINGS1", 20000000)
        stats.set_int(MPX() .. "LIFETIME_BKR_SELL_EARNINGS2", 20000000)
        stats.set_int(MPX() .. "LIFETIME_BKR_SELL_EARNINGS3", 20000000)
        stats.set_int(MPX() .. "LIFETIME_BKR_SELL_EARNINGS4", 20000000)
        stats.set_int(MPX() .. "LFETIME_BIKER_BUY_COMPLET6", 10) -- Allow buying of Stank Breath acid name.
        stats.set_int(MPX() .. "LFETIME_BIKER_SELL_COMPLET6", 10) -- Allow buying of Squatch Bait acid name.
        stats.set_packed_stat_int(41241, 5) -- Allow buying of Chair Shot acid name.
        stats.set_int(MPX() .. "LIFETIME_BKR_SELL_EARNINGS6", 1000000) -- Allow buying of Fck Your Sleep acid name.
        stats.set_packed_stat_int(7666, 25) -- Fill CEO office with money
        unlock_packed_bools(7553, 7594) -- Fill CEO office with junk
        stats.set_packed_stat_int(9357, 4) -- Fill Clubhouse with money
        unlock_packed_bools(9400, 9414) -- Fill Clubhouse with junk
        stats.set_int(MPX() .. "XMAS2023_ADV_MODE_WINS", 6) -- Unlock Christmas 2023 liveries.
        stats.set_int("MPPLY_XMAS23_PLATES0", 3) -- ECola & Sprunk Plates
        stats.set_int(MPX() .. "COUNT_HOTRING_RACE", 20) -- Liveries for hotring
        stats.set_int(MPX() .. "FINISHED_SASS_RACE_TOP_3", 20) -- Trade price for hotring/everon2
        stats.set_int(MPX() .. "AWD_DISPATCHWORK", 5) -- Trade price for polgreenwood.
        stats.set_packed_stat_int(7671, 100) -- Plant on Desk, Plaque Trophy, Shield Trophy
        stats.set_int(MPX() .. "PROG_HUB_BOUNTIES_ALIVE_BS", -1) -- Cuff Trophy
        stats.set_int(MPX() .. "LFETIME_IE_EXPORT_COMPLETED", 1000)
        stats.set_int(MPX() .. "LFETIME_IE_MISSION_EARNINGS", 20000000)
        stats.set_int(MPX() .. "LFETIME_HANGAR_SEL_UNDETAK", 1000)
        stats.set_int(MPX() .. "LFETIME_HANGAR_SEL_COMPLET", 1000)
        stats.set_int(MPX() .. "LFETIME_HANGAR_EARNINGS", 20000000)
        stats.set_int(MPX() .. "SR_HIGHSCORE_1", 690)
        stats.set_int(MPX() .. "SR_HIGHSCORE_2", 1860)
        stats.set_int(MPX() .. "SR_HIGHSCORE_3", 2690)
        stats.set_int(MPX() .. "SR_HIGHSCORE_4", 2660)
        stats.set_int(MPX() .. "SR_HIGHSCORE_5", 2650)
        stats.set_int(MPX() .. "SR_HIGHSCORE_6", 450)
        stats.set_int(MPX() .. "SR_TARGETS_HIT", 269)
        stats.set_int(MPX() .. "SR_WEAPON_BIT_SET", -1)
        stats.set_int(MPX() .. "GANGOPS_HEIST_STATUS", 9999)
        stats.set_int(MPX() .. "NO_BOUGHT_YUM_SNACKS", 1000)
        stats.set_int(MPX() .. "AWD_DANCE_TO_SOLOMUN", 100)
        stats.set_int(MPX() .. "AWD_DANCE_TO_TALEOFUS", 100)
        stats.set_int(MPX() .. "AWD_DANCE_TO_DIXON", 100)
        stats.set_int(MPX() .. "AWD_DANCE_TO_BLKMAD", 100)
        stats.set_int(MPX() .. "AWD_CLUB_DRUNK", 200)
        stats.set_int(MPX() .. "NUMUNIQUEPLYSINCLUB", 100)
        stats.set_int(MPX() .. "DANCETODIFFDJS", 4)
        stats.set_int(MPX() .. "DANCEPERFECTOWNCLUB", 100)
        stats.set_int(MPX() .. "NIGHTCLUB_HOTSPOT_TIME_MS", 3600000)
        stats.set_int(MPX() .. "ARENAWARS_SKILL_LEVEL", 20)
        stats.set_int(MPX() .. "ARENAWARS_AP_TIER", 1000)
        stats.set_int(MPX() .. "ARENAWARS_AP_LIFETIME", 47551850)
        stats.set_int(MPX() .. "ARN_W_THEME_SCIFI", 1000)
        stats.set_int(MPX() .. "ARN_W_THEME_APOC", 1000)
        stats.set_int(MPX() .. "ARN_W_THEME_CONS", 1000)
        stats.set_int(MPX() .. "ARN_W_PASS_THE_BOMB", 1000)
        stats.set_int(MPX() .. "ARN_W_DETONATION", 1000)
        stats.set_int(MPX() .. "ARN_W_ARCADE_RACE", 1000)
        stats.set_int(MPX() .. "ARN_W_CTF", 1000)
        stats.set_int(MPX() .. "ARN_W_TAG_TEAM", 1000)
        stats.set_int(MPX() .. "ARN_W_DESTR_DERBY", 1000)
        stats.set_int(MPX() .. "ARN_W_CARNAGE", 1000)
        stats.set_int(MPX() .. "ARN_W_MONSTER_JAM", 1000)
        stats.set_int(MPX() .. "ARN_W_GAMES_MASTERS", 1000)
        stats.set_int(MPX() .. "ARN_L_PASS_THE_BOMB", 500)
        stats.set_int(MPX() .. "ARN_L_DETONATION", 500)
        stats.set_int(MPX() .. "ARN_L_ARCADE_RACE", 500)
        stats.set_int(MPX() .. "ARN_L_CTF", 500)
        stats.set_int(MPX() .. "ARN_L_TAG_TEAM", 500)
        stats.set_int(MPX() .. "ARN_L_DESTR_DERBY", 500)
        stats.set_int(MPX() .. "ARN_L_CARNAGE", 500)
        stats.set_int(MPX() .. "ARN_L_MONSTER_JAM", 500)
        stats.set_int(MPX() .. "ARN_L_GAMES_MASTERS", 500)
        stats.set_int(MPX() .. "NUMBER_OF_CHAMP_BOUGHT", 1000)
        stats.set_int(MPX() .. "ARN_SPECTATOR_KILLS", 1000)
        stats.set_int(MPX() .. "ARN_LIFETIME_KILLS", 1000)
        stats.set_int(MPX() .. "ARN_LIFETIME_DEATHS", 500)
        stats.set_int(MPX() .. "ARENAWARS_CARRER_WINS", 1000)
        stats.set_int(MPX() .. "ARENAWARS_CARRER_WINT", 1000)
        stats.set_int(MPX() .. "ARENAWARS_MATCHES_PLYD", 1000)
        stats.set_int(MPX() .. "ARENAWARS_MATCHES_PLYDT", 1000)
        stats.set_int(MPX() .. "ARN_SPECTATOR_DRONE", 1000)
        stats.set_int(MPX() .. "ARN_SPECTATOR_CAMS", 1000)
        stats.set_int(MPX() .. "ARN_SMOKE", 1000)
        stats.set_int(MPX() .. "ARN_DRINK", 1000)
        stats.set_int(MPX() .. "ARN_VEH_MONSTER3", 1000)
        stats.set_int(MPX() .. "ARN_VEH_MONSTER4", 1000)
        stats.set_int(MPX() .. "ARN_VEH_MONSTER5", 1000)
        stats.set_int(MPX() .. "ARN_VEH_CERBERUS", 1000)
        stats.set_int(MPX() .. "ARN_VEH_CERBERUS2", 1000)
        stats.set_int(MPX() .. "ARN_VEH_CERBERUS3", 1000)
        stats.set_int(MPX() .. "ARN_VEH_BRUISER", 1000)
        stats.set_int(MPX() .. "ARN_VEH_BRUISER2", 1000)
        stats.set_int(MPX() .. "ARN_VEH_BRUISER3", 1000)
        stats.set_int(MPX() .. "ARN_VEH_SLAMVAN4", 1000)
        stats.set_int(MPX() .. "ARN_VEH_SLAMVAN5", 1000)
        stats.set_int(MPX() .. "ARN_VEH_SLAMVAN6", 1000)
        stats.set_int(MPX() .. "ARN_VEH_BRUTUS", 1000)
        stats.set_int(MPX() .. "ARN_VEH_BRUTUS2", 1000)
        stats.set_int(MPX() .. "ARN_VEH_BRUTUS3", 1000)
        stats.set_int(MPX() .. "ARN_VEH_SCARAB", 1000)
        stats.set_int(MPX() .. "ARN_VEH_SCARAB2", 1000)
        stats.set_int(MPX() .. "ARN_VEH_SCARAB3", 1000)
        stats.set_int(MPX() .. "ARN_VEH_DOMINATOR4", 1000)
        stats.set_int(MPX() .. "ARN_VEH_DOMINATOR5", 1000)
        stats.set_int(MPX() .. "ARN_VEH_DOMINATOR6", 1000)
        stats.set_int(MPX() .. "ARN_VEH_IMPALER2", 1000)
        stats.set_int(MPX() .. "ARN_VEH_IMPALER3", 1000)
        stats.set_int(MPX() .. "ARN_VEH_IMPALER4", 1000)
        stats.set_int(MPX() .. "ARN_VEH_ISSI4", 1000)
        stats.set_int(MPX() .. "ARN_VEH_ISSI5", 1000)
        stats.set_int(MPX() .. "ARN_VEH_ISSI6", 1000)
        stats.set_int(MPX() .. "ARN_VEH_IMPERATOR", 1000)
        stats.set_int(MPX() .. "ARN_VEH_IMPERATOR2", 1000)
        stats.set_int(MPX() .. "ARN_VEH_IMPERATOR3", 1000)
        stats.set_int(MPX() .. "ARN_VEH_ZR380", 1000)
        stats.set_int(MPX() .. "ARN_VEH_ZR3802", 1000)
        stats.set_int(MPX() .. "ARN_VEH_ZR3803", 1000)
        stats.set_int(MPX() .. "ARN_VEH_DEATHBIKE", 1000)
        stats.set_int(MPX() .. "ARN_VEH_DEATHBIKE2", 1000)
        stats.set_int(MPX() .. "ARN_VEH_DEATHBIKE3", 1000)
        stats.set_int(MPX() .. "NO_BOUGHT_HEALTH_SNACKS", 1000)
        stats.set_int(MPX() .. "NO_BOUGHT_EPIC_SNACKS", 1000)
        stats.set_int(MPX() .. "NUMBER_OF_ORANGE_BOUGHT", 1000)
        stats.set_int(MPX() .. "MP_CHAR_ARMOUR_1_COUNT", 1000)
        stats.set_int(MPX() .. "MP_CHAR_ARMOUR_2_COUNT", 1000)
        stats.set_int(MPX() .. "MP_CHAR_ARMOUR_3_COUNT", 1000)
        stats.set_int(MPX() .. "MP_CHAR_ARMOUR_4_COUNT", 1000)
        stats.set_int(MPX() .. "MP_CHAR_ARMOUR_5_COUNT", 1000)
        stats.set_int(MPX() .. "NUMBER_OF_BOURGE_BOUGHT", 1000)
        stats.set_int(MPX() .. "CIGARETTES_BOUGHT", 1000)
        stats.set_int(MPX() .. "FIREWORK_TYPE_1_WHITE", 1000)
        stats.set_int(MPX() .. "FIREWORK_TYPE_1_RED", 1000)
        stats.set_int(MPX() .. "FIREWORK_TYPE_1_BLUE", 1000)
        stats.set_int(MPX() .. "FIREWORK_TYPE_2_WHITE", 1000)
        stats.set_int(MPX() .. "FIREWORK_TYPE_2_RED", 1000)
        stats.set_int(MPX() .. "FIREWORK_TYPE_2_BLUE", 1000)
        stats.set_int(MPX() .. "FIREWORK_TYPE_3_WHITE", 1000)
        stats.set_int(MPX() .. "FIREWORK_TYPE_3_RED", 1000)
        stats.set_int(MPX() .. "FIREWORK_TYPE_3_BLUE", 1000)
        stats.set_int(MPX() .. "FIREWORK_TYPE_4_WHITE", 1000)
        stats.set_int(MPX() .. "FIREWORK_TYPE_4_RED", 1000)
        stats.set_int(MPX() .. "FIREWORK_TYPE_4_BLUE", 1000)
        stats.set_int(MPX() .. "FM_ACT_PHN", -1)
        stats.set_int(MPX() .. "FM_ACT_PH2", -1)
        stats.set_int(MPX() .. "FM_ACT_PH3", -1)
        stats.set_int(MPX() .. "FM_ACT_PH4", -1)
        stats.set_int(MPX() .. "FM_ACT_PH5", -1)
        stats.set_int(MPX() .. "FM_VEH_TX1", -1)
        stats.set_int(MPX() .. "FM_ACT_PH6", -1)
        stats.set_int(MPX() .. "FM_ACT_PH7", -1)
        stats.set_int(MPX() .. "FM_ACT_PH8", -1)
        stats.set_int(MPX() .. "FM_ACT_PH9", -1)
        stats.set_int(MPX() .. "LOWRIDER_FLOW_COMPLETE", 3)
        stats.set_int(MPX() .. "LOW_FLOW_CURRENT_PROG", 9)
        stats.set_int(MPX() .. "LOW_FLOW_CURRENT_CALL", 9)
        stats.set_int(MPX() .. "CR_GANGOP_MORGUE", 10)
        stats.set_int(MPX() .. "CR_GANGOP_DELUXO", 10)
        stats.set_int(MPX() .. "CR_GANGOP_SERVERFARM", 10)
        stats.set_int(MPX() .. "CR_GANGOP_IAABASE_FIN", 10)
        stats.set_int(MPX() .. "CR_GANGOP_STEALOSPREY", 10)
        stats.set_int(MPX() .. "CR_GANGOP_FOUNDRY", 10)
        stats.set_int(MPX() .. "CR_GANGOP_RIOTVAN", 10)
        stats.set_int(MPX() .. "CR_GANGOP_SUBMARINECAR", 10)
        stats.set_int(MPX() .. "CR_GANGOP_SUBMARINE_FIN", 10)
        stats.set_int(MPX() .. "CR_GANGOP_PREDATOR", 10)
        stats.set_int(MPX() .. "CR_GANGOP_BMLAUNCHER", 10)
        stats.set_int(MPX() .. "CR_GANGOP_BCCUSTOM", 10)
        stats.set_int(MPX() .. "CR_GANGOP_STEALTHTANKS", 10)
        stats.set_int(MPX() .. "CR_GANGOP_SPYPLANE", 10)
        stats.set_int(MPX() .. "CR_GANGOP_FINALE", 10)
        stats.set_int(MPX() .. "CR_GANGOP_FINALE_P2", 10)
        stats.set_int(MPX() .. "CR_GANGOP_FINALE_P3", 10)
        stats.set_int(MPX() .. "SNIPERRFL_ENEMY_KILLS", 500)
        stats.set_int(MPX() .. "HVYSNIPER_ENEMY_KILLS", 500)
        stats.set_int(MPX() .. "KILLS_COP", 4500)
        stats.set_int(MPX() .. "KILLS_SWAT", 500)
        stats.set_int(MPX() .. "CHAR_WANTED_LEVEL_TIME", 5000)
        stats.set_int(MPX() .. "NUMBER_STOLEN_COP_VEHICLE", 200)
        stats.set_int(MPX() .. "NUMBER_STOLEN_CARS", 200)
        stats.set_int(MPX() .. "NUMBER_STOLEN_BIKES", 200)
        stats.set_int(MPX() .. "NUMBER_STOLEN_BOATS", 200)
        stats.set_int(MPX() .. "NUMBER_STOLEN_HELIS", 200)
        stats.set_int(MPX() .. "NUMBER_STOLEN_PLANES", 200)
        stats.set_int(MPX() .. "NUMBER_STOLEN_QUADBIKES", 200)
        stats.set_int(MPX() .. "NUMBER_STOLEN_BICYCLES", 200)
        stats.set_int(MPX() .. "STARS_ATTAINED", 5000)
        stats.set_int(MPX() .. "STARS_EVADED", 4000)
        stats.set_int(MPX() .. "VEHEXPORTED", 500)
        stats.set_int(MPX() .. "TOTAL_NO_SHOPS_HELD_UP", 100)
        stats.set_int(MPX() .. "KILLS_ENEMY_GANG_MEMBERS", 500)
        stats.set_int(MPX() .. "KILLS_FRIENDLY_GANG_MEMBERS", 500)
        stats.set_int(MPX() .. "CR_GANGATTACK_CITY", 500)
        stats.set_int(MPX() .. "CR_GANGATTACK_COUNTRY", 500)
        stats.set_int(MPX() .. "CR_GANGATTACK_LOST", 500)
        stats.set_int(MPX() .. "CR_GANGATTACK_VAGOS", 500)
        stats.set_int(MPX() .. "HORDKILLS", 500)
        stats.set_int(MPX() .. "GHKILLS", 500)
        stats.set_int(MPX() .. "NO_NON_CONTRACT_RACE_WIN", 500)
        stats.set_int(MPX() .. "DB_SHOTTIME", 596)
        stats.set_int(MPX() .. "DB_KILLS", 500)
        stats.set_int(MPX() .. "DB_PLAYER_KILLS", 500)
        stats.set_int(MPX() .. "DB_SHOTS", 500)
        stats.set_int(MPX() .. "DB_HITS", 500)
        stats.set_int(MPX() .. "DB_HITS_PEDS_VEHICLES", 500)
        stats.set_int(MPX() .. "DB_HEADSHOTS", 500)
        stats.set_int(MPX() .. "USJS_COMPLETED", 25)
        stats.set_int(MPX() .. "AWD_FM_RACES_FASTEST_LAP", 50)
        stats.set_int(MPX() .. "NUMBER_SLIPSTREAMS_IN_RACE", 1000)
        stats.set_int(MPX() .. "AWD_WIN_CAPTURES", 500)
        stats.set_int(MPX() .. "AWD_DROPOFF_CAP_PACKAGES", 100)
        stats.set_int(MPX() .. "AWD_KILL_CARRIER_CAPTURE", 100)
        stats.set_int(MPX() .. "AWD_FINISH_HEISTS", 50)
        stats.set_int(MPX() .. "AWD_FINISH_HEIST_SETUP_JOB", 50)
        stats.set_int(MPX() .. "AWD_NIGHTVISION_KILLS", 100)
        stats.set_int(MPX() .. "AWD_WIN_LAST_TEAM_STANDINGS", 50)
        stats.set_int(MPX() .. "AWD_ONLY_PLAYER_ALIVE_LTS", 50)
        stats.set_int(MPX() .. "AWD_FMRALLYWONDRIVE", 25)
        stats.set_int(MPX() .. "AWD_FMRALLYWONNAV", 25)
        stats.set_int(MPX() .. "AWD_FMWINAIRRACE", 25)
        stats.set_int(MPX() .. "AWD_FMWINSEARACE", 25)
        stats.set_int(MPX() .. "RACES_WON", 50)
        stats.set_int(MPX() .. "FAVOUTFITBIKETIMECURRENT", 884483972)
        stats.set_int(MPX() .. "FAVOUTFITBIKETIME1ALLTIME", 884483972)
        stats.set_int(MPX() .. "FAVOUTFITBIKETYPECURRENT", 884483972)
        stats.set_int(MPX() .. "FAVOUTFITBIKETYPEALLTIME", 884483972)
        stats.set_int(MPX() .. "LIFETIME_BUY_COMPLETE", 1000)
        stats.set_int(MPX() .. "LIFETIME_BUY_UNDERTAKEN", 1000)
        stats.set_int(MPX() .. "LIFETIME_SELL_COMPLETE", 1000)
        stats.set_int(MPX() .. "LIFETIME_SELL_UNDERTAKEN", 1000)
        stats.set_int(MPX() .. "LIFETIME_CONTRA_EARNINGS", 30000000)
        stats.set_int(MPX() .. "TATTOO_FM_CURRENT_32", 32768)
        stats.set_int(MPX() .. "TATTOO_FM_CURRENT_32", 67108864)
        stats.set_int(MPX() .. "DELUXO_BULLET_HITS", 500)
        stats.set_int(MPX() .. "DELUXO_BULLET_HEADSHOTS", 500)
        stats.set_int(MPX() .. "DELUXO_BULLET_HELDTIME", 5963259)
        stats.set_int(MPX() .. "DELUXO_BULLET_ENEMY_KILLS", 500)
        stats.set_int(MPX() .. "DELUXO_ROCKET_KILLS", 500)
        stats.set_int(MPX() .. "DELUXO_ROCKET_DEATHS", 100)
        stats.set_int(MPX() .. "DELUXO_ROCKET_SHOTS", 500)
        stats.set_int(MPX() .. "DELUXO_ROCKET_HITS", 500)
        stats.set_int(MPX() .. "DELUXO_ROCKET_HELDTIME", 5963259)
        stats.set_int(MPX() .. "DELUXO_ROCKET_ENEMY_KILLS", 500)
        stats.set_int(MPX() .. "DELUXO_BULLET_KILLS", 500)
        stats.set_int(MPX() .. "DELUXO_BULLET_DEATHS", 100)
        stats.set_int(MPX() .. "DELUXO_BULLET_SHOTS", 500)
        stats.set_int(MPX() .. "COMET4_MG_KILLS", 500)
        stats.set_int(MPX() .. "COMET4_MG_DEATHS", 100)
        stats.set_int(MPX() .. "COMET4_MG_SHOTS", 500)
        stats.set_int(MPX() .. "COMET4_MG_HITS", 500)
        stats.set_int(MPX() .. "COMET4_MG_HEADSHOTS", 500)
        stats.set_int(MPX() .. "COMET4_MG_HELDTIME", 5963259)
        stats.set_int(MPX() .. "COMET4_MG_ENEMY_KILLS", 500)
        stats.set_int(MPX() .. "CHERNOBOG_MISS_KILLS", 500)
        stats.set_int(MPX() .. "CHERNOBOG_MISS_DEATHS", 100)
        stats.set_int(MPX() .. "CHERNOBOG_MISS_SHOTS", 500)
        stats.set_int(MPX() .. "CHERNOBOG_MISS_HITS", 500)
        stats.set_int(MPX() .. "CHERNOBOG_MISS_HELDTIME", 5963259)
        stats.set_int(MPX() .. "CHERNOBOG_MISS_ENEMY_KILLS", 500)
        stats.set_int(MPX() .. "BARRAGE_R_MG_KILLS", 500)
        stats.set_int(MPX() .. "BARRAGE_R_MG_DEATHS", 100)
        stats.set_int(MPX() .. "BARRAGE_R_MG_SHOTS", 500)
        stats.set_int(MPX() .. "BARRAGE_R_MG_HITS", 500)
        stats.set_int(MPX() .. "BARRAGE_R_MG_HEADSHOTS", 500)
        stats.set_int(MPX() .. "BARRAGE_R_MG_HELDTIME", 5963259)
        stats.set_int(MPX() .. "BARRAGE_R_MG_ENEMY_KILLS", 500)
        stats.set_int(MPX() .. "BARRAGE_R_MINI_KILLS", 500)
        stats.set_int(MPX() .. "BARRAGE_R_MINI_DEATHS", 100)
        stats.set_int(MPX() .. "BARRAGE_R_MINI_SHOTS", 500)
        stats.set_int(MPX() .. "BARRAGE_R_MINI_HITS", 500)
        stats.set_int(MPX() .. "BARRAGE_R_MINI_HEADSHOTS", 500)
        stats.set_int(MPX() .. "BARRAGE_R_MINI_HELDTIME", 5963259)
        stats.set_int(MPX() .. "BARRAGE_R_MINI_ENEMY_KILLS", 500)
        stats.set_int(MPX() .. "BARRAGE_R_GL_KILLS", 500)
        stats.set_int(MPX() .. "BARRAGE_R_GL_DEATHS", 100)
        stats.set_int(MPX() .. "BARRAGE_R_GL_SHOTS", 500)
        stats.set_int(MPX() .. "BARRAGE_R_GL_HITS", 500)
        stats.set_int(MPX() .. "BARRAGE_R_GL_HELDTIME", 5963259)
        stats.set_int(MPX() .. "BARRAGE_R_GL_ENEMY_KILLS", 500)
        stats.set_int(MPX() .. "BARRAGE_T_MG_KILLS", 500)
        stats.set_int(MPX() .. "BARRAGE_T_MG_DEATHS", 100)
        stats.set_int(MPX() .. "BARRAGE_T_MG_SHOTS", 500)
        stats.set_int(MPX() .. "BARRAGE_T_MG_HITS", 500)
        stats.set_int(MPX() .. "BARRAGE_T_MG_HEADSHOTS", 500)
        stats.set_int(MPX() .. "BARRAGE_T_MG_HELDTIME", 5963259)
        stats.set_int(MPX() .. "BARRAGE_T_MG_ENEMY_KILLS", 500)
        stats.set_int(MPX() .. "BARRAGE_T_MINI_KILLS", 500)
        stats.set_int(MPX() .. "BARRAGE_T_MINI_DEATHS", 100)
        stats.set_int(MPX() .. "BARRAGE_T_MINI_SHOTS", 500)
        stats.set_int(MPX() .. "BARRAGE_T_MINI_HITS", 500)
        stats.set_int(MPX() .. "BARRAGE_T_MINI_HEADSHOTS", 500)
        stats.set_int(MPX() .. "BARRAGE_T_MINI_HELDTIME", 5963259)
        stats.set_int(MPX() .. "BARRAGE_T_MINI_ENEMY_KILLS", 500)
        stats.set_int(MPX() .. "AVENGER_CANNON_KILLS", 500)
        stats.set_int(MPX() .. "AVENGER_CANNON_DEATHS", 100)
        stats.set_int(MPX() .. "AVENGER_CANNON_SHOTS", 500)
        stats.set_int(MPX() .. "AVENGER_CANNON_HITS", 500)
        stats.set_int(MPX() .. "AVENGER_CANNON_HELDTIME", 5963259)
        stats.set_int(MPX() .. "AVENGER_CANNON_ENEMY_KILLS", 500)
        stats.set_int(MPX() .. "AKULA_TURR_KILLS", 500)
        stats.set_int(MPX() .. "AKULA_TURR_DEATHS", 100)
        stats.set_int(MPX() .. "AKULA_TURR_SHOTS", 500)
        stats.set_int(MPX() .. "AKULA_TURR_HITS", 500)
        stats.set_int(MPX() .. "AKULA_TURR_HEADSHOTS", 500)
        stats.set_int(MPX() .. "AKULA_TURR_HELDTIME", 5963259)
        stats.set_int(MPX() .. "AKULA_TURR_ENEMY_KILLS", 500)
        stats.set_int(MPX() .. "AKULA_DTURR_KILLS", 500)
        stats.set_int(MPX() .. "AKULA_DTURR_DEATHS", 100)
        stats.set_int(MPX() .. "AKULA_DTURR_SHOTS", 500)
        stats.set_int(MPX() .. "AKULA_DTURR_HITS", 500)
        stats.set_int(MPX() .. "AKULA_DTURR_HEADSHOTS", 500)
        stats.set_int(MPX() .. "AKULA_DTURR_HELDTIME", 5963259)
        stats.set_int(MPX() .. "AKULA_DTURR_ENEMY_KILLS", 500)
        stats.set_int(MPX() .. "AKULA_MINI_KILLS", 500)
        stats.set_int(MPX() .. "AKULA_MINI_DEATHS", 100)
        stats.set_int(MPX() .. "AKULA_MINI_SHOTS", 500)
        stats.set_int(MPX() .. "AKULA_MINI_HITS", 500)
        stats.set_int(MPX() .. "AKULA_MINI_HEADSHOTS", 500)
        stats.set_int(MPX() .. "AKULA_MINI_HELDTIME", 5963259)
        stats.set_int(MPX() .. "AKULA_MINI_ENEMY_KILLS", 500)
        stats.set_int(MPX() .. "AKULA_BARR_KILLS", 500)
        stats.set_int(MPX() .. "AKULA_BARR_DEATHS", 100)
        stats.set_int(MPX() .. "AKULA_BARR_SHOTS", 500)
        stats.set_int(MPX() .. "AKULA_BARR_HITS", 500)
        stats.set_int(MPX() .. "AKULA_BARR_HELDTIME", 5963259)
        stats.set_int(MPX() .. "AKULA_BARR_ENEMY_KILLS", 500)
        stats.set_int(MPX() .. "AKULA_ROCKET_KILLS", 500)
        stats.set_int(MPX() .. "AKULA_ROCKET_DEATHS", 100)
        stats.set_int(MPX() .. "AKULA_ROCKET_SHOTS", 500)
        stats.set_int(MPX() .. "AKULA_ROCKET_HITS", 500)
        stats.set_int(MPX() .. "AKULA_ROCKET_HELDTIME", 5963259)
        stats.set_int(MPX() .. "AKULA_ROCKET_ENEMY_KILLS", 500)
        stats.set_int(MPX() .. "ARENA_MG_KILLS", 500)
        stats.set_int(MPX() .. "ARENA_MG_DEATHS", 100)
        stats.set_int(MPX() .. "ARENA_MG_SHOTS", 500)
        stats.set_int(MPX() .. "ARENA_MG_HITS", 500)
        stats.set_int(MPX() .. "ARENA_MG_HEADSHOTS", 500)
        stats.set_int(MPX() .. "ARENA_MG_HELDTIME", 5963259)
        stats.set_int(MPX() .. "ARENA_MG_ENEMY_KILLS", 500)
        stats.set_int(MPX() .. "ARENA_HM_KILLS", 500)
        stats.set_int(MPX() .. "ARENA_HM_DEATHS", 100)
        stats.set_int(MPX() .. "ARENA_HM_SHOTS", 500)
        stats.set_int(MPX() .. "ARENA_HM_HITS", 500)
        stats.set_int(MPX() .. "ARENA_HM_HELDTIME", 5963259)
        stats.set_int(MPX() .. "RCMINE_KIN_KILLS", 500)
        stats.set_int(MPX() .. "RCMINE_KIN_DEATHS", 100)
        stats.set_int(MPX() .. "RCMINE_KIN_SHOTS", 500)
        stats.set_int(MPX() .. "RCMINE_KIN_HITS", 500)
        stats.set_int(MPX() .. "RCMINE_KIN_ENEMY_KILLS", 500)
        stats.set_int(MPX() .. "RCMINE_EMP_KILLS", 500)
        stats.set_int(MPX() .. "RCMINE_EMP_DEATHS", 100)
        stats.set_int(MPX() .. "RCMINE_EMP_SHOTS", 500)
        stats.set_int(MPX() .. "RCMINE_EMP_HITS", 500)
        stats.set_int(MPX() .. "RCMINE_EMP_ENEMY_KILLS", 500)
        stats.set_int(MPX() .. "RCMINE_SPI_KILLS", 500)
        stats.set_int(MPX() .. "RCMINE_SPI_DEATHS", 100)
        stats.set_int(MPX() .. "RCMINE_SPI_SHOTS", 500)
        stats.set_int(MPX() .. "RCMINE_SPI_HITS", 500)
        stats.set_int(MPX() .. "RCMINE_SPI_ENEMY_KILLS", 500)
        stats.set_int(MPX() .. "RCMINE_SLI_KILLS", 500)
        stats.set_int(MPX() .. "RCMINE_SLI_DEATHS", 100)
        stats.set_int(MPX() .. "RCMINE_SLI_SHOTS", 500)
        stats.set_int(MPX() .. "RCMINE_SLI_HITS", 500)
        stats.set_int(MPX() .. "RCMINE_SLI_ENEMY_KILLS", 500)
        stats.set_int(MPX() .. "RCMINE_TAR_KILLS", 500)
        stats.set_int(MPX() .. "RCMINE_TAR_DEATHS", 100)
        stats.set_int(MPX() .. "RCMINE_TAR_SHOTS", 500)
        stats.set_int(MPX() .. "RCMINE_TAR_HITS", 500)
        stats.set_int(MPX() .. "RCMINE_TAR_ENEMY_KILLS", 500)
        stats.set_int(MPX() .. "VEHMINE_KILLS", 500)
        stats.set_int(MPX() .. "VEHMINE_DEATHS", 100)
        stats.set_int(MPX() .. "VEHMINE_SHOTS", 500)
        stats.set_int(MPX() .. "VEHMINE_HITS", 500)
        stats.set_int(MPX() .. "VEHMINE_ENEMY_KILLS", 500)
        stats.set_int(MPX() .. "VEHMINE_KIN_KILLS", 500)
        stats.set_int(MPX() .. "VEHMINE_KIN_DEATHS", 100)
        stats.set_int(MPX() .. "VEHMINE_KIN_SHOTS", 500)
        stats.set_int(MPX() .. "VEHMINE_KIN_HITS", 500)
        stats.set_int(MPX() .. "VEHMINE_KIN_ENEMY_KILLS", 500)
        stats.set_int(MPX() .. "VEHMINE_EMP_KILLS", 500)
        stats.set_int(MPX() .. "VEHMINE_EMP_DEATHS", 100)
        stats.set_int(MPX() .. "VEHMINE_EMP_SHOTS", 500)
        stats.set_int(MPX() .. "VEHMINE_EMP_HITS", 500)
        stats.set_int(MPX() .. "VEHMINE_EMP_ENEMY_KILLS", 500)
        stats.set_int(MPX() .. "VEHMINE_SPI_KILLS", 500)
        stats.set_int(MPX() .. "VEHMINE_SPI_DEATHS", 100)
        stats.set_int(MPX() .. "VEHMINE_SPI_SHOTS", 500)
        stats.set_int(MPX() .. "VEHMINE_SPI_HITS", 500)
        stats.set_int(MPX() .. "VEHMINE_SPI_ENEMY_KILLS", 500)
        stats.set_int(MPX() .. "VEHMINE_SLI_KILLS", 500)
        stats.set_int(MPX() .. "VEHMINE_SLI_DEATHS", 100)
        stats.set_int(MPX() .. "VEHMINE_SLI_SHOTS", 500)
        stats.set_int(MPX() .. "VEHMINE_SLI_HITS", 500)
        stats.set_int(MPX() .. "VEHMINE_SLI_ENEMY_KILLS", 500)
        stats.set_int(MPX() .. "VEHMINE_TAR_KILLS", 500)
        stats.set_int(MPX() .. "VEHMINE_TAR_DEATHS", 100)
        stats.set_int(MPX() .. "VEHMINE_TAR_SHOTS", 500)
        stats.set_int(MPX() .. "VEHMINE_TAR_HITS", 500)
        stats.set_int(MPX() .. "VEHMINE_TAR_ENEMY_KILLS", 500)
        stats.set_int(MPX() .. "ZR3803_MG50_KILLS", 500)
        stats.set_int(MPX() .. "ZR3803_MG50_DEATHS", 100)
        stats.set_int(MPX() .. "ZR3803_MG50_SHOTS", 500)
        stats.set_int(MPX() .. "ZR3803_MG50_HITS", 500)
        stats.set_int(MPX() .. "ZR3803_MG50_HEADSHOTS", 500)
        stats.set_int(MPX() .. "ZR3803_MG50_HELDTIME", 5963259)
        stats.set_int(MPX() .. "ZR3803_MG50_ENEMY_KILLS", 500)
        stats.set_int(MPX() .. "ZR3802_MG50_KILLS", 500)
        stats.set_int(MPX() .. "ZR3802_MG50_DEATHS", 100)
        stats.set_int(MPX() .. "ZR3802_MG50_SHOTS", 500)
        stats.set_int(MPX() .. "ZR3802_MG50_HITS", 500)
        stats.set_int(MPX() .. "ZR3802_MG50_HEADSHOTS", 500)
        stats.set_int(MPX() .. "ZR3802_MG50_HELDTIME", 5963259)
        stats.set_int(MPX() .. "ZR3802_MG50_ENEMY_KILLS", 500)
        stats.set_int(MPX() .. "ZR3802_LAS_KILLS", 500)
        stats.set_int(MPX() .. "ZR3802_LAS_DEATHS", 100)
        stats.set_int(MPX() .. "ZR3802_LAS_SHOTS", 500)
        stats.set_int(MPX() .. "ZR3802_LAS_HITS", 500)
        stats.set_int(MPX() .. "ZR3802_LAS_HEADSHOTS", 500)
        stats.set_int(MPX() .. "ZR3802_LAS_HELDTIME", 5963259)
        stats.set_int(MPX() .. "ZR3802_LAS_ENEMY_KILLS", 500)
        stats.set_int(MPX() .. "ZR380_MG50_KILLS", 500)
        stats.set_int(MPX() .. "ZR380_MG50_DEATHS", 100)
        stats.set_int(MPX() .. "ZR380_MG50_SHOTS", 500)
        stats.set_int(MPX() .. "ZR380_MG50_HITS", 500)
        stats.set_int(MPX() .. "ZR380_MG50_HEADSHOTS", 500)
        stats.set_int(MPX() .. "ZR380_MG50_HELDTIME", 5963259)
        stats.set_int(MPX() .. "ZR380_MG50_ENEMY_KILLS", 500)
        stats.set_int(MPX() .. "SLAMVAN4_MG50_KILLS", 500)
        stats.set_int(MPX() .. "SLAMVAN4_MG50_DEATHS", 100)
        stats.set_int(MPX() .. "SLAMVAN4_MG50_SHOTS", 500)
        stats.set_int(MPX() .. "SLAMVAN4_MG50_HITS", 500)
        stats.set_int(MPX() .. "SLAMVAN4_MG50_HEADSHOTS", 500)
        stats.set_int(MPX() .. "SLAMVAN4_MG50_HELDTIME", 5963259)
        stats.set_int(MPX() .. "SLAMVAN4_MG50_ENEMY_KILLS", 500)
        stats.set_int(MPX() .. "SLAMVAN5_MG50_KILLS", 500)
        stats.set_int(MPX() .. "SLAMVAN5_MG50_DEATHS", 100)
        stats.set_int(MPX() .. "SLAMVAN5_MG50_SHOTS", 500)
        stats.set_int(MPX() .. "SLAMVAN5_MG50_HITS", 500)
        stats.set_int(MPX() .. "SLAMVAN5_MG50_HEADSHOTS", 500)
        stats.set_int(MPX() .. "SLAMVAN5_MG50_HELDTIME", 5963259)
        stats.set_int(MPX() .. "SLAMVAN5_MG50_ENEMY_KILLS", 500)
        stats.set_int(MPX() .. "SLAMVAN5_LAS_KILLS", 500)
        stats.set_int(MPX() .. "SLAMVAN5_LAS_DEATHS", 100)
        stats.set_int(MPX() .. "SLAMVAN5_LAS_SHOTS", 500)
        stats.set_int(MPX() .. "SLAMVAN5_LAS_HITS", 500)
        stats.set_int(MPX() .. "SLAMVAN5_LAS_HEADSHOTS", 500)
        stats.set_int(MPX() .. "SLAMVAN5_LAS_HELDTIME", 5963259)
        stats.set_int(MPX() .. "SLAMVAN5_LAS_ENEMY_KILLS", 500)
        stats.set_int(MPX() .. "SLAMVAN6_MG50_KILLS", 500)
        stats.set_int(MPX() .. "SLAMVAN6_MG50_DEATHS", 100)
        stats.set_int(MPX() .. "SLAMVAN6_MG50_SHOTS", 500)
        stats.set_int(MPX() .. "SLAMVAN6_MG50_HITS", 500)
        stats.set_int(MPX() .. "SLAMVAN6_MG50_HEADSHOTS", 500)
        stats.set_int(MPX() .. "SLAMVAN6_MG50_HELDTIME", 5963259)
        stats.set_int(MPX() .. "SLAMVAN6_MG50_ENEMY_KILLS", 500)
        stats.set_int(MPX() .. "SCARAB_MG50_KILLS", 500)
        stats.set_int(MPX() .. "SCARAB_MG50_DEATHS", 100)
        stats.set_int(MPX() .. "SCARAB_MG50_SHOTS", 500)
        stats.set_int(MPX() .. "SCARAB_MG50_HITS", 500)
        stats.set_int(MPX() .. "SCARAB_MG50_HEADSHOTS", 500)
        stats.set_int(MPX() .. "SCARAB_MG50_HELDTIME", 5963259)
        stats.set_int(MPX() .. "SCARAB_MG50_ENEMY_KILLS", 500)
        stats.set_int(MPX() .. "SCARAB2_MG50_KILLS", 500)
        stats.set_int(MPX() .. "SCARAB2_MG50_DEATHS", 100)
        stats.set_int(MPX() .. "SCARAB2_MG50_SHOTS", 500)
        stats.set_int(MPX() .. "SCARAB2_MG50_HITS", 500)
        stats.set_int(MPX() .. "SCARAB2_MG50_HEADSHOTS", 500)
        stats.set_int(MPX() .. "SCARAB2_MG50_HELDTIME", 5963259)
        stats.set_int(MPX() .. "SCARAB2_MG50_ENEMY_KILLS", 500)
        stats.set_int(MPX() .. "SCARAB2_LAS_KILLS", 500)
        stats.set_int(MPX() .. "SCARAB2_LAS_DEATHS", 100)
        stats.set_int(MPX() .. "SCARAB2_LAS_SHOTS", 500)
        stats.set_int(MPX() .. "SCARAB2_LAS_HITS", 500)
        stats.set_int(MPX() .. "SCARAB2_LAS_HEADSHOTS", 500)
        stats.set_int(MPX() .. "SCARAB2_LAS_HELDTIME", 5963259)
        stats.set_int(MPX() .. "SCARAB2_LAS_ENEMY_KILLS", 500)
        stats.set_int(MPX() .. "SCARAB3_MG50_KILLS", 500)
        stats.set_int(MPX() .. "SCARAB3_MG50_DEATHS", 100)
        stats.set_int(MPX() .. "SCARAB3_MG50_SHOTS", 500)
        stats.set_int(MPX() .. "SCARAB3_MG50_HITS", 500)
        stats.set_int(MPX() .. "SCARAB3_MG50_HEADSHOTS", 500)
        stats.set_int(MPX() .. "SCARAB3_MG50_HELDTIME", 5963259)
        stats.set_int(MPX() .. "SCARAB3_MG50_ENEMY_KILLS", 500)
        stats.set_int(MPX() .. "MONSTER3_KIN_KILLS", 500)
        stats.set_int(MPX() .. "MONSTER3_KIN_DEATHS", 100)
        stats.set_int(MPX() .. "MONSTER3_KIN_SHOTS", 500)
        stats.set_int(MPX() .. "MONSTER3_KIN_HITS", 500)
        stats.set_int(MPX() .. "MONSTER3_KIN_HELDTIME", 5963259)
        stats.set_int(MPX() .. "MONSTER3_KIN_ENEMY_KILL", 500)
        stats.set_int(MPX() .. "MONSTER4_KIN_KILLS", 500)
        stats.set_int(MPX() .. "MONSTER4_KIN_DEATHS", 100)
        stats.set_int(MPX() .. "MONSTER4_KIN_SHOTS", 500)
        stats.set_int(MPX() .. "MONSTER4_KIN_HITS", 500)
        stats.set_int(MPX() .. "MONSTER4_KIN_HELDTIME", 5963259)
        stats.set_int(MPX() .. "MONSTER4_KIN_ENEMY_KILLS", 500)
        stats.set_int(MPX() .. "MONSTER5_KIN_KILLS", 500)
        stats.set_int(MPX() .. "MONSTER5_KIN_DEATHS", 100)
        stats.set_int(MPX() .. "MONSTER5_KIN_SHOTS", 500)
        stats.set_int(MPX() .. "MONSTER5_KIN_HITS", 500)
        stats.set_int(MPX() .. "MONSTER5_KIN_HELDTIME", 5963259)
        stats.set_int(MPX() .. "MONSTER5_KIN_ENEMY_KILLS", 500)
        stats.set_int(MPX() .. "ISSI4_MG50_KILLS", 500)
        stats.set_int(MPX() .. "ISSI4_MG50_DEATHS", 100)
        stats.set_int(MPX() .. "ISSI4_MG50_SHOTS", 500)
        stats.set_int(MPX() .. "ISSI4_MG50_HITS", 500)
        stats.set_int(MPX() .. "ISSI4_MG50_HEADSHOTS", 500)
        stats.set_int(MPX() .. "ISSI4_MG50_HELDTIME", 5963259)
        stats.set_int(MPX() .. "ISSI4_MG50_ENEMY_KILLS", 500)
        stats.set_int(MPX() .. "ISSI4_KIN_KILLS", 500)
        stats.set_int(MPX() .. "ISSI4_KIN_DEATHS", 100)
        stats.set_int(MPX() .. "ISSI4_KIN_SHOTS", 500)
        stats.set_int(MPX() .. "ISSI4_KIN_HITS", 500)
        stats.set_int(MPX() .. "ISSI4_KIN_HELDTIME", 5963259)
        stats.set_int(MPX() .. "ISSI4_KIN_ENEMY_KILLS", 500)
        stats.set_int(MPX() .. "ISSI5_MG50_KILLS", 500)
        stats.set_int(MPX() .. "ISSI5_MG50_DEATHS", 100)
        stats.set_int(MPX() .. "ISSI5_MG50_SHOTS", 500)
        stats.set_int(MPX() .. "ISSI5_MG50_HITS", 500)
        stats.set_int(MPX() .. "ISSI5_MG50_HEADSHOTS", 500)
        stats.set_int(MPX() .. "ISSI5_MG50_HELDTIME", 5963259)
        stats.set_int(MPX() .. "ISSI5_MG50_ENEMY_KILLS", 500)
        stats.set_int(MPX() .. "ISSI5_LAS_KILLS", 500)
        stats.set_int(MPX() .. "ISSI5_LAS_DEATHS", 100)
        stats.set_int(MPX() .. "ISSI5_LAS_SHOTS", 500)
        stats.set_int(MPX() .. "ISSI5_LAS_HITS", 500)
        stats.set_int(MPX() .. "ISSI5_LAS_HEADSHOTS", 500)
        stats.set_int(MPX() .. "ISSI5_LAS_HELDTIME", 5963259)
        stats.set_int(MPX() .. "ISSI5_LAS_ENEMY_KILLS", 500)
        stats.set_int(MPX() .. "ISSI5_KIN_KILLS", 500)
        stats.set_int(MPX() .. "ISSI5_KIN_DEATHS", 100)
        stats.set_int(MPX() .. "ISSI5_KIN_SHOTS", 500)
        stats.set_int(MPX() .. "ISSI5_KIN_HITS", 500)
        stats.set_int(MPX() .. "ISSI5_KIN_HELDTIME", 5963259)
        stats.set_int(MPX() .. "ISSI5_KIN_ENEMY_KILLS", 500)
        stats.set_int(MPX() .. "ISSI6_MG50_KILLS", 500)
        stats.set_int(MPX() .. "ISSI6_MG50_DEATHS", 100)
        stats.set_int(MPX() .. "ISSI6_MG50_SHOTS", 500)
        stats.set_int(MPX() .. "ISSI6_MG50_HITS", 500)
        stats.set_int(MPX() .. "ISSI6_MG50_HEADSHOTS", 500)
        stats.set_int(MPX() .. "ISSI6_MG50_HELDTIME", 5963259)
        stats.set_int(MPX() .. "ISSI6_MG50_ENEMY_KILLS", 500)
        stats.set_int(MPX() .. "ISSI6_KIN_KILLS", 500)
        stats.set_int(MPX() .. "ISSI6_KIN_DEATHS", 100)
        stats.set_int(MPX() .. "ISSI6_KIN_SHOTS", 500)
        stats.set_int(MPX() .. "ISSI6_KIN_HITS", 500)
        stats.set_int(MPX() .. "ISSI6_KIN_HELDTIME", 5963259)
        stats.set_int(MPX() .. "ISSI6_KIN_ENEMY_KILLS", 500)
        stats.set_int(MPX() .. "ARN_SPECTATOR_KILLS", 500)
        stats.set_int(MPX() .. "ARN_LIFETIME_KILLS", 500)
        stats.set_int(MPX() .. "ARN_LIFETIME_DEATHS", 100)
        stats.set_int(MPX() .. "TRSMALL2_QUAD_KILLS", 500)
        stats.set_int(MPX() .. "TRSMALL2_QUAD_DEATHS", 100)
        stats.set_int(MPX() .. "TRSMALL2_QUAD_SHOTS", 500)
        stats.set_int(MPX() .. "TRSMALL2_QUAD_HITS", 500)
        stats.set_int(MPX() .. "TRSMALL2_QUAD_HEADSHOTS", 500)
        stats.set_int(MPX() .. "TRSMALL2_QUAD_HELDTIME", 5963259)
        stats.set_int(MPX() .. "TRSMALL2_QUAD_ENEMY_KILLS", 500)
        stats.set_int(MPX() .. "TRSMALL2_DUAL_KILLS", 500)
        stats.set_int(MPX() .. "TRSMALL2_DUAL_DEATHS", 100)
        stats.set_int(MPX() .. "TRSMALL2_DUAL_SHOTS", 500)
        stats.set_int(MPX() .. "TRSMALL2_DUAL_HITS", 500)
        stats.set_int(MPX() .. "TRSMALL2_DUAL_HELDTIME", 5963259)
        stats.set_int(MPX() .. "TRSMALL2_DUAL_ENEMY_KILLS", 500)
        stats.set_int(MPX() .. "TRSMALL2_MISS_KILLS", 500)
        stats.set_int(MPX() .. "TRSMALL2_MISS_DEATHS", 100)
        stats.set_int(MPX() .. "TRSMALL2_MISS_SHOTS", 500)
        stats.set_int(MPX() .. "TRSMALL2_MISS_HITS", 500)
        stats.set_int(MPX() .. "TRSMALL2_MISS_HELDTIME", 5963259)
        stats.set_int(MPX() .. "TRSMALL2_MISS_ENEMY_KILLS", 500)
        stats.set_int(MPX() .. "TRLARGE_CANNON_KILLS", 500)
        stats.set_int(MPX() .. "TRLARGE_CANNON_DEATHS", 100)
        stats.set_int(MPX() .. "TRLARGE_CANNON_SHOTS", 500)
        stats.set_int(MPX() .. "TRLARGE_CANNON_HITS", 500)
        stats.set_int(MPX() .. "TRLARGE_CANNON_HELDTIME", 5963259)
        stats.set_int(MPX() .. "TRLARGE_CANNON_ENEMY_KILLS", 500)
        stats.set_int(MPX() .. "POUNDER2_MINI_KILLS", 500)
        stats.set_int(MPX() .. "POUNDER2_MINI_DEATHS", 100)
        stats.set_int(MPX() .. "POUNDER2_MINI_SHOTS", 500)
        stats.set_int(MPX() .. "POUNDER2_MINI_HITS", 500)
        stats.set_int(MPX() .. "POUNDER2_MINI_HEADSHOTS", 500)
        stats.set_int(MPX() .. "POUNDER2_MINI_HELDTIME", 5963259)
        stats.set_int(MPX() .. "POUNDER2_MINI_ENEMY_KILLS", 500)
        stats.set_int(MPX() .. "POUNDER2_MISS_KILLS", 500)
        stats.set_int(MPX() .. "POUNDER2_MISS_DEATHS", 100)
        stats.set_int(MPX() .. "POUNDER2_MISS_SHOTS", 500)
        stats.set_int(MPX() .. "POUNDER2_MISS_HITS", 500)
        stats.set_int(MPX() .. "POUNDER2_MISS_HEADSHOTS", 500)
        stats.set_int(MPX() .. "POUNDER2_MISS_HELDTIME", 5963259)
        stats.set_int(MPX() .. "POUNDER2_MISS_ENEMY_KILLS", 500)
        stats.set_int(MPX() .. "POUNDER2_BARR_KILLS", 500)
        stats.set_int(MPX() .. "POUNDER2_BARR_DEATHS", 100)
        stats.set_int(MPX() .. "POUNDER2_BARR_SHOTS", 500)
        stats.set_int(MPX() .. "POUNDER2_BARR_HITS", 500)
        stats.set_int(MPX() .. "POUNDER2_BARR_HELDTIME", 5963259)
        stats.set_int(MPX() .. "POUNDER2_BARR_ENEMY_KILLS", 500)
        stats.set_int(MPX() .. "POUNDER2_GL_KILLS", 500)
        stats.set_int(MPX() .. "POUNDER2_GL_DEATHS", 100)
        stats.set_int(MPX() .. "POUNDER2_GL_SHOTS", 500)
        stats.set_int(MPX() .. "POUNDER2_GL_HITS", 500)
        stats.set_int(MPX() .. "POUNDER2_GL_HELDTIME", 5963259)
        stats.set_int(MPX() .. "POUNDER2_GL_ENEMY_KILLS", 500)
        stats.set_int(MPX() .. "SCRAMJET_MG_KILLS", 500)
        stats.set_int(MPX() .. "SCRAMJET_MG_DEATHS", 100)
        stats.set_int(MPX() .. "SCRAMJET_MG_SHOTS", 500)
        stats.set_int(MPX() .. "SCRAMJET_MG_HITS", 500)
        stats.set_int(MPX() .. "SCRAMJET_MG_HEADSHOTS", 500)
        stats.set_int(MPX() .. "SCRAMJET_MG_HELDTIME", 5963259)
        stats.set_int(MPX() .. "SCRAMJET_MG_ENEMY_KILLS", 500)
        stats.set_int(MPX() .. "SCRAMJET_MISS_KILLS", 500)
        stats.set_int(MPX() .. "SCRAMJET_MISS_DEATHS", 100)
        stats.set_int(MPX() .. "SCRAMJET_MISS_SHOTS", 500)
        stats.set_int(MPX() .. "SCRAMJET_MISS_HITS", 500)
        stats.set_int(MPX() .. "SCRAMJET_MISS_HELDTIME", 5963259)
        stats.set_int(MPX() .. "SCRAMJET_MISS_ENEMY_KILLS", 500)
        stats.set_int(MPX() .. "SPEEDO4_MG_KILLS", 500)
        stats.set_int(MPX() .. "SPEEDO4_MG_DEATHS", 100)
        stats.set_int(MPX() .. "SPEEDO4_MG_SHOTS", 500)
        stats.set_int(MPX() .. "SPEEDO4_MG_HITS", 500)
        stats.set_int(MPX() .. "SPEEDO4_MG_HEADSHOTS", 500)
        stats.set_int(MPX() .. "SPEEDO4_MG_HELDTIME", 5963259)
        stats.set_int(MPX() .. "SPEEDO4_MG_ENEMY_KILLS", 500)
        stats.set_int(MPX() .. "SPEEDO4_TURR_KILLS", 500)
        stats.set_int(MPX() .. "SPEEDO4_TURR_DEATHS", 100)
        stats.set_int(MPX() .. "SPEEDO4_TURR_SHOTS", 500)
        stats.set_int(MPX() .. "SPEEDO4_TURR_HITS", 500)
        stats.set_int(MPX() .. "SPEEDO4_TURR_HEADSHOTS", 500)
        stats.set_int(MPX() .. "SPEEDO4_TURR_HELDTIME", 5963259)
        stats.set_int(MPX() .. "SPEEDO4_TURR_ENEMY_KILLS", 500)
        stats.set_int(MPX() .. "SPEEDO4_MINI_KILLS", 500)
        stats.set_int(MPX() .. "SPEEDO4_MINI_DEATHS", 100)
        stats.set_int(MPX() .. "SPEEDO4_MINI_SHOTS", 500)
        stats.set_int(MPX() .. "SPEEDO4_MINI_HITS", 500)
        stats.set_int(MPX() .. "SPEEDO4_MINI_HEADSHOTS", 500)
        stats.set_int(MPX() .. "SPEEDO4_MINI_HELDTIME", 5963259)
        stats.set_int(MPX() .. "SPEEDO4_MINI_ENEMY_KILLS", 500)
        stats.set_int(MPX() .. "STRIKEFORCE_BAR_KILLS", 500)
        stats.set_int(MPX() .. "STRIKEFORCE_BAR_DEATHS", 100)
        stats.set_int(MPX() .. "STRIKEFORCE_BAR_SHOTS", 500)
        stats.set_int(MPX() .. "STRIKEFORCE_BAR_HITS", 500)
        stats.set_int(MPX() .. "STRIKEFORCE_BAR_HELDTIME", 5963259)
        stats.set_int(MPX() .. "STRIKEFORCE_BAR_ENEMY_KILLS", 500)
        stats.set_int(MPX() .. "STRIKEFORCE_CAN_KILLS", 500)
        stats.set_int(MPX() .. "STRIKEFORCE_CAN_DEATHS", 100)
        stats.set_int(MPX() .. "STRIKEFORCE_CAN_SHOTS", 500)
        stats.set_int(MPX() .. "STRIKEFORCE_CAN_HITS", 500)
        stats.set_int(MPX() .. "STRIKEFORCE_CAN_HELDTIME", 5963259)
        stats.set_int(MPX() .. "STRIKEFORCE_CAN_ENEMY_KILLS", 500)
        stats.set_int(MPX() .. "STRIKEFORCE_MIS_KILLS", 500)
        stats.set_int(MPX() .. "STRIKEFORCE_MIS_DEATHS", 100)
        stats.set_int(MPX() .. "STRIKEFORCE_MIS_SHOTS", 500)
        stats.set_int(MPX() .. "STRIKEFORCE_MIS_HITS", 500)
        stats.set_int(MPX() .. "STRIKEFORCE_MIS_HELDTIME", 5963259)
        stats.set_int(MPX() .. "STRIKEFORCE_MIS_ENEMY_KILLS", 500)
        stats.set_int(MPX() .. "TERBYTE_MISS_KILLS", 500)
        stats.set_int(MPX() .. "TERBYTE_MISS_DEATHS", 100)
        stats.set_int(MPX() .. "TERBYTE_MISS_SHOTS", 500)
        stats.set_int(MPX() .. "TERBYTE_MISS_HITS", 500)
        stats.set_int(MPX() .. "TERBYTE_MISS_HELDTIME", 5963259)
        stats.set_int(MPX() .. "TERBYTE_MISS_ENEMY_KILLS", 500)
        stats.set_int(MPX() .. "TERBYTE_HMISS_KILLS", 500)
        stats.set_int(MPX() .. "TERBYTE_HMISS_DEATHS", 100)
        stats.set_int(MPX() .. "TERBYTE_HMISS_SHOTS", 500)
        stats.set_int(MPX() .. "TERBYTE_HMISS_HITS", 500)
        stats.set_int(MPX() .. "TERBYTE_HMISS_HELDTIME", 5963259)
        stats.set_int(MPX() .. "TERBYTE_HMISS_ENEMY_KILLS", 500)
        stats.set_int(MPX() .. "CARACARA_MINI_KILLS", 500)
        stats.set_int(MPX() .. "CARACARA_MINI_DEATHS", 100)
        stats.set_int(MPX() .. "CARACARA_MINI_SHOTS", 500)
        stats.set_int(MPX() .. "CARACARA_MINI_HITS", 500)
        stats.set_int(MPX() .. "CARACARA_MINI_HEADSHOTS", 500)
        stats.set_int(MPX() .. "CARACARA_MINI_HELDTIME", 5963259)
        stats.set_int(MPX() .. "CARACARA_MINI_ENEMY_KILLS", 500)
        stats.set_int(MPX() .. "CARACARA_TURR_KILLS", 500)
        stats.set_int(MPX() .. "CARACARA_TURR_DEATHS", 100)
        stats.set_int(MPX() .. "CARACARA_TURR_SHOTS", 500)
        stats.set_int(MPX() .. "CARACARA_TURR_HITS", 500)
        stats.set_int(MPX() .. "CARACARA_TURR_HEADSHOTS", 500)
        stats.set_int(MPX() .. "CARACARA_TURR_HELDTIME", 5963259)
        stats.set_int(MPX() .. "CARACARA_TURR_ENEMY_KILLS", 500)
        stats.set_int(MPX() .. "SPARROW_MINI_KILLS", 500)
        stats.set_int(MPX() .. "SPARROW_MINI_DEATHS", 100)
        stats.set_int(MPX() .. "SPARROW_MINI_SHOTS", 500)
        stats.set_int(MPX() .. "SPARROW_MINI_HITS", 500)
        stats.set_int(MPX() .. "SPARROW_MINI_HEADSHOTS", 500)
        stats.set_int(MPX() .. "SPARROW_MINI_HELDTIME", 5963259)
        stats.set_int(MPX() .. "SPARROW_MINI_ENEMY_KILLS", 500)
        stats.set_int(MPX() .. "SPARROW_ROCKET_KILLS", 500)
        stats.set_int(MPX() .. "SPARROW_ROCKET_DEATHS", 100)
        stats.set_int(MPX() .. "SPARROW_ROCKET_SHOTS", 500)
        stats.set_int(MPX() .. "SPARROW_ROCKET_HITS", 500)
        stats.set_int(MPX() .. "SPARROW_ROCKET_HELDTIME", 5963259)
        stats.set_int(MPX() .. "SPARROW_ROCKET_ENEMY_KILLS", 500)
        stats.set_int(MPX() .. "APC_CANN_KILLS", 500)
        stats.set_int(MPX() .. "APC_CANN_DEATHS", 100)
        stats.set_int(MPX() .. "APC_CANN_SHOTS", 500)
        stats.set_int(MPX() .. "APC_CANN_HITS", 500)
        stats.set_int(MPX() .. "APC_CANN_HELDTIME", 5963259)
        stats.set_int(MPX() .. "APC_CANN_ENEMY_KILLS", 500)
        stats.set_int(MPX() .. "APC_MISS_KILLS", 500)
        stats.set_int(MPX() .. "APC_MISS_DEATHS", 100)
        stats.set_int(MPX() .. "APC_MISS_SHOTS", 500)
        stats.set_int(MPX() .. "APC_MISS_HITS", 500)
        stats.set_int(MPX() .. "APC_MISS_HELDTIME", 5963259)
        stats.set_int(MPX() .. "APC_MISS_ENEMY_KILLS", 500)
        stats.set_int(MPX() .. "APC_MG_KILLS", 500)
        stats.set_int(MPX() .. "APC_MG_DEATHS", 100)
        stats.set_int(MPX() .. "APC_MG_SHOTS", 500)
        stats.set_int(MPX() .. "APC_MG_HITS", 500)
        stats.set_int(MPX() .. "APC_MG_HEADSHOTS", 500)
        stats.set_int(MPX() .. "APC_MG_HELDTIME", 5963259)
        stats.set_int(MPX() .. "APC_MG_ENEMY_KILLS", 500)
        stats.set_int(MPX() .. "ARDENT_MG_KILLS", 500)
        stats.set_int(MPX() .. "ARDENT_MG_DEATHS", 100)
        stats.set_int(MPX() .. "ARDENT_MG_SHOTS", 500)
        stats.set_int(MPX() .. "ARDENT_MG_HITS", 500)
        stats.set_int(MPX() .. "ARDENT_MG_HEADSHOTS", 500)
        stats.set_int(MPX() .. "ARDENT_MG_HELDTIME", 5963259)
        stats.set_int(MPX() .. "ARDENT_MG_ENEMY_KILLS", 500)
        stats.set_int(MPX() .. "DUNE3_MG_KILLS", 500)
        stats.set_int(MPX() .. "DUNE3_MG_DEATHS", 100)
        stats.set_int(MPX() .. "DUNE3_MG_SHOTS", 500)
        stats.set_int(MPX() .. "DUNE3_MG_HITS", 500)
        stats.set_int(MPX() .. "DUNE3_MG_HEADSHOTS", 500)
        stats.set_int(MPX() .. "DUNE3_MG_HELDTIME", 5963259)
        stats.set_int(MPX() .. "DUNE3_MG_ENEMY_KILLS", 500)
        stats.set_int(MPX() .. "DUNE3_GL_KILLS", 500)
        stats.set_int(MPX() .. "DUNE3_GL_DEATHS", 100)
        stats.set_int(MPX() .. "DUNE3_GL_SHOTS", 500)
        stats.set_int(MPX() .. "DUNE3_GL_HITS", 500)
        stats.set_int(MPX() .. "DUNE3_GL_HELDTIME", 5963259)
        stats.set_int(MPX() .. "DUNE3_GL_ENEMY_KILLS", 500)
        stats.set_int(MPX() .. "DUNE3_MINI_KILLS", 500)
        stats.set_int(MPX() .. "DUNE3_MINI_DEATHS", 100)
        stats.set_int(MPX() .. "DUNE3_MINI_SHOTS", 500)
        stats.set_int(MPX() .. "DUNE3_MINI_HITS", 500)
        stats.set_int(MPX() .. "DUNE3_MINI_HEADSHOTS", 500)
        stats.set_int(MPX() .. "DUNE3_MINI_HELDTIME", 5963259)
        stats.set_int(MPX() .. "DUNE3_MINI_ENEMY_KILLS", 500)
        stats.set_int(MPX() .. "HALFTRACK_DUAL_KILLS", 500)
        stats.set_int(MPX() .. "HALFTRACK_DUAL_DEATHS", 100)
        stats.set_int(MPX() .. "HALFTRACK_DUAL_SHOTS", 500)
        stats.set_int(MPX() .. "HALFTRACK_DUAL_HITS", 500)
        stats.set_int(MPX() .. "HALFTRACK_DUAL_HEADSHOTS", 500)
        stats.set_int(MPX() .. "HALFTRACK_DUAL_HELDTIME", 5963259)
        stats.set_int(MPX() .. "HALFTRACK_DUAL_ENEMY_KILLS", 500)
        stats.set_int(MPX() .. "HALFTRACK_QUAD_KILLS", 500)
        stats.set_int(MPX() .. "HALFTRACK_QUAD_DEATHS", 100)
        stats.set_int(MPX() .. "HALFTRACK_QUAD_SHOTS", 500)
        stats.set_int(MPX() .. "HALFTRACK_QUAD_HITS", 500)
        stats.set_int(MPX() .. "HALFTRACK_QUAD_HEADSHOTS", 500)
        stats.set_int(MPX() .. "HALFTRACK_QUAD_HELDTIME", 5963259)
        stats.set_int(MPX() .. "HALFTRACK_QUAD_ENEMY_KILLS", 500)
        stats.set_int(MPX() .. "INSURGENT3_MINI_KILLS", 500)
        stats.set_int(MPX() .. "INSURGENT3_MINI_DEATHS", 100)
        stats.set_int(MPX() .. "INSURGENT3_MINI_SHOTS", 500)
        stats.set_int(MPX() .. "INSURGENT3_MINI_HITS", 500)
        stats.set_int(MPX() .. "INSURGENT3_MINI_HEADSHOTS", 500)
        stats.set_int(MPX() .. "INSURGENT3_MINI_HELDTIME", 5963259)
        stats.set_int(MPX() .. "INSURGENT3_MINI_ENEMY_KILLS", 500)
        stats.set_int(MPX() .. "INSURGENT3_TURR_KILLS", 500)
        stats.set_int(MPX() .. "INSURGENT3_TURR_DEATHS", 100)
        stats.set_int(MPX() .. "INSURGENT3_TURR_SHOTS", 500)
        stats.set_int(MPX() .. "INSURGENT3_TURR_HITS", 500)
        stats.set_int(MPX() .. "INSURGENT3_TURR_HEADSHOTS", 500)
        stats.set_int(MPX() .. "INSURGENT3_TURR_HELDTIME", 5963259)
        stats.set_int(MPX() .. "INSURGENT3_TURR_ENEMY_KILLS", 500)
        stats.set_int(MPX() .. "NIGHTSHARK_MG_KILLS", 500)
        stats.set_int(MPX() .. "NIGHTSHARK_MG_DEATHS", 100)
        stats.set_int(MPX() .. "NIGHTSHARK_MG_SHOTS", 500)
        stats.set_int(MPX() .. "NIGHTSHARK_MG_HITS", 500)
        stats.set_int(MPX() .. "NIGHTSHARK_MG_HEADSHOTS", 500)
        stats.set_int(MPX() .. "NIGHTSHARK_MG_HELDTIME", 5963259)
        stats.set_int(MPX() .. "NIGHTSHARK_MG_ENEMY_KILLS", 500)
        stats.set_int(MPX() .. "OPPRESSOR_MG_KILLS", 500)
        stats.set_int(MPX() .. "OPPRESSOR_MG_DEATHS", 100)
        stats.set_int(MPX() .. "OPPRESSOR_MG_SHOTS", 500)
        stats.set_int(MPX() .. "OPPRESSOR_MG_HITS", 500)
        stats.set_int(MPX() .. "OPPRESSOR_MG_HEADSHOTS", 500)
        stats.set_int(MPX() .. "OPPRESSOR_MG_HELDTIME", 5963259)
        stats.set_int(MPX() .. "OPPRESSOR_MG_ENEMY_KILLS", 500)
        stats.set_int(MPX() .. "OPPRESSOR_MISS_KILLS", 500)
        stats.set_int(MPX() .. "OPPRESSOR_MISS_DEATHS", 100)
        stats.set_int(MPX() .. "OPPRESSOR_MISS_SHOTS", 500)
        stats.set_int(MPX() .. "OPPRESSOR_MISS_HITS", 500)
        stats.set_int(MPX() .. "OPPRESSOR_MISS_HELDTIME", 5963259)
        stats.set_int(MPX() .. "OPPRESSOR_MISS_ENEMY_KILLS", 500)
        stats.set_int(MPX() .. "TAMPA3_MISS_KILLS", 500)
        stats.set_int(MPX() .. "TAMPA3_MISS_DEATHS", 100)
        stats.set_int(MPX() .. "TAMPA3_MISS_SHOTS", 500)
        stats.set_int(MPX() .. "TAMPA3_MISS_HITS", 500)
        stats.set_int(MPX() .. "TAMPA3_MISS_HELDTIME", 5963259)
        stats.set_int(MPX() .. "TAMPA3_MISS_ENEMY_KILLS", 500)
        stats.set_int(MPX() .. "TAMPA3_MORT_KILLS", 500)
        stats.set_int(MPX() .. "TAMPA3_MORT_DEATHS", 100)
        stats.set_int(MPX() .. "TAMPA3_MORT_SHOTS", 500)
        stats.set_int(MPX() .. "TAMPA3_MORT_HITS", 500)
        stats.set_int(MPX() .. "TAMPA3_MORT_HELDTIME", 5963259)
        stats.set_int(MPX() .. "TAMPA3_MORT_ENEMY_KILLS", 500)
        stats.set_int(MPX() .. "TAMPA3_FMINI_KILLS", 500)
        stats.set_int(MPX() .. "TAMPA3_FMINI_DEATHS", 100)
        stats.set_int(MPX() .. "TAMPA3_FMINI_SHOTS", 500)
        stats.set_int(MPX() .. "TAMPA3_FMINI_HITS", 500)
        stats.set_int(MPX() .. "TAMPA3_FMINI_HEADSHOTS", 500)
        stats.set_int(MPX() .. "TAMPA3_FMINI_HELDTIME", 5963259)
        stats.set_int(MPX() .. "TAMPA3_FMINI_ENEMY_KILLS", 500)
        stats.set_int(MPX() .. "TAMPA3_DMINI_KILLS", 500)
        stats.set_int(MPX() .. "TAMPA3_DMINI_DEATHS", 100)
        stats.set_int(MPX() .. "TAMPA3_DMINI_SHOTS", 500)
        stats.set_int(MPX() .. "TAMPA3_DMINI_HITS", 500)
        stats.set_int(MPX() .. "TAMPA3_DMINI_HEADSHOTS", 500)
        stats.set_int(MPX() .. "TAMPA3_DMINI_HELDTIME", 5963259)
        stats.set_int(MPX() .. "TAMPA3_DMINI_ENEMY_KILLS", 500)
        stats.set_int(MPX() .. "TECHNICAL3_MINI_KILLS", 500)
        stats.set_int(MPX() .. "TECHNICAL3_MINI_DEATHS", 100)
        stats.set_int(MPX() .. "TECHNICAL3_MINI_SHOTS", 500)
        stats.set_int(MPX() .. "TECHNICAL3_MINI_HITS", 500)
        stats.set_int(MPX() .. "TECHNICAL3_MINI_HEADSHOTS", 500)
        stats.set_int(MPX() .. "TECHNICAL3_MINI_HELDTIME", 5963259)
        stats.set_int(MPX() .. "TECHNICAL3_MINI_ENEMY_KILLS", 500)
        stats.set_int(MPX() .. "TECHNICAL3_TURR_KILLS", 500)
        stats.set_int(MPX() .. "TECHNICAL3_TURR_DEATHS", 100)
        stats.set_int(MPX() .. "TECHNICAL3_TURR_SHOTS", 500)
        stats.set_int(MPX() .. "TECHNICAL3_TURR_HITS", 500)
        stats.set_int(MPX() .. "TECHNICAL3_TURR_HEADSHOTS", 500)
        stats.set_int(MPX() .. "TECHNICAL3_TURR_HELDTIME", 5963259)
        stats.set_int(MPX() .. "TECHNICAL3_TURR_ENEMY_KILLS", 500)
        stats.set_int(MPX() .. "KHANJALI_ROCKET_KILLS", 500)
        stats.set_int(MPX() .. "KHANJALI_ROCKET_DEATHS", 100)
        stats.set_int(MPX() .. "KHANJALI_ROCKET_SHOTS", 500)
        stats.set_int(MPX() .. "KHANJALI_ROCKET_HITS", 500)
        stats.set_int(MPX() .. "KHANJALI_ROCKET_HELDTIME", 5963259)
        stats.set_int(MPX() .. "KHANJALI_ROCKET_ENEMY_KILLS", 500)
        stats.set_int(MPX() .. "KHANJALI_HCANN_KILLS", 500)
        stats.set_int(MPX() .. "KHANJALI_HCANN_DEATHS", 100)
        stats.set_int(MPX() .. "KHANJALI_HCANN_SHOTS", 500)
        stats.set_int(MPX() .. "KHANJALI_HCANN_HITS", 500)
        stats.set_int(MPX() .. "KHANJALI_HCANN_HELDTIME", 5963259)
        stats.set_int(MPX() .. "KHANJALI_HCANN_ENEMY_KILLS", 500)
        stats.set_int(MPX() .. "KHANJALI_MG_KILLS", 500)
        stats.set_int(MPX() .. "KHANJALI_MG_DEATHS", 100)
        stats.set_int(MPX() .. "KHANJALI_MG_SHOTS", 500)
        stats.set_int(MPX() .. "KHANJALI_MG_HITS", 500)
        stats.set_int(MPX() .. "KHANJALI_MG_HEADSHOTS", 500)
        stats.set_int(MPX() .. "KHANJALI_MG_HELDTIME", 5963259)
        stats.set_int(MPX() .. "KHANJALI_MG_ENEMY_KILLS", 500)
        stats.set_int(MPX() .. "KHANJALI_GL_KILLS", 500)
        stats.set_int(MPX() .. "KHANJALI_GL_DEATHS", 100)
        stats.set_int(MPX() .. "KHANJALI_GL_SHOTS", 500)
        stats.set_int(MPX() .. "KHANJALI_GL_HITS", 500)
        stats.set_int(MPX() .. "KHANJALI_GL_HELDTIME", 5963259)
        stats.set_int(MPX() .. "KHANJALI_GL_ENEMY_KILLS", 500)
        stats.set_int(MPX() .. "REVOLTER_MG_KILLS", 500)
        stats.set_int(MPX() .. "REVOLTER_MG_DEATHS", 100)
        stats.set_int(MPX() .. "REVOLTER_MG_SHOTS", 500)
        stats.set_int(MPX() .. "REVOLTER_MG_HITS", 500)
        stats.set_int(MPX() .. "REVOLTER_MG_HEADSHOTS", 500)
        stats.set_int(MPX() .. "REVOLTER_MG_HELDTIME", 5963259)
        stats.set_int(MPX() .. "REVOLTER_MG_ENEMY_KILLS", 500)
        stats.set_int(MPX() .. "SAVESTRA_MG_KILLS", 500)
        stats.set_int(MPX() .. "SAVESTRA_MG_DEATHS", 100)
        stats.set_int(MPX() .. "SAVESTRA_MG_SHOTS", 500)
        stats.set_int(MPX() .. "SAVESTRA_MG_HITS", 500)
        stats.set_int(MPX() .. "SAVESTRA_MG_HEADSHOTS", 500)
        stats.set_int("MPPLY_NUM_CAPTURES_CREATED", 100)
        stats.set_int("MPPLY_PILOT_SCHOOL_MEDAL_0", -1)
        stats.set_int("MPPLY_PILOT_SCHOOL_MEDAL_1", -1)
        stats.set_int("MPPLY_PILOT_SCHOOL_MEDAL_2", -1)
        stats.set_int("MPPLY_PILOT_SCHOOL_MEDAL_3", -1)
        stats.set_int("MPPLY_PILOT_SCHOOL_MEDAL_4", -1)
        stats.set_int("MPPLY_PILOT_SCHOOL_MEDAL_5", -1)
        stats.set_int("MPPLY_PILOT_SCHOOL_MEDAL_6", -1)
        stats.set_int("MPPLY_PILOT_SCHOOL_MEDAL_7", -1)
        stats.set_int("MPPLY_PILOT_SCHOOL_MEDAL_8", -1)
        stats.set_int("MPPLY_PILOT_SCHOOL_MEDAL_9", -1)
        stats.set_int("MPPLY_HEIST_ACH_TRACKER", -1)
        stats.set_int("MPPLY_GANGOPS_ALLINORDER", 100)
        stats.set_int("MPPLY_GANGOPS_LOYALTY", 100)
        stats.set_int("MPPLY_GANGOPS_CRIMMASMD", 100)
        stats.set_int("MPPLY_GANGOPS_LOYALTY2", 100)
        stats.set_int("MPPLY_GANGOPS_LOYALTY3", 100)
        stats.set_int("MPPLY_GANGOPS_CRIMMASMD2", 100)
        stats.set_int("MPPLY_GANGOPS_CRIMMASMD3", 100)
        stats.set_int("MPPLY_GANGOPS_SUPPORT", 100)
        stats.set_int("MPPLY_AWD_FM_CR_DM_MADE", 600)
        stats.set_int("MPPLY_AWD_FM_CR_RACES_MADE", 1000)
        stats.set_int("MPPLY_AWD_FM_CR_MISSION_SCORE", 100)
        stats.set_int("MPPLY_TOTAL_RACES_WON", 500)
        stats.set_int("MPPLY_TOTAL_RACES_LOST", 250)
        stats.set_int("MPPLY_TOTAL_CUSTOM_RACES_WON", 500)
        stats.set_int("MPPLY_TOTAL_DEATHMATCH_LOST", 250)
        stats.set_int("MPPLY_TOTAL_DEATHMATCH_WON", 500)
        stats.set_int("MPPLY_TOTAL_TDEATHMATCH_LOST", 250)
        stats.set_int("MPPLY_TOTAL_TDEATHMATCH_WON", 500)
        stats.set_int("MPPLY_SHOOTINGRANGE_WINS", 500)
        stats.set_int("MPPLY_SHOOTINGRANGE_LOSSES", 250)
        stats.set_int("MPPLY_TENNIS_MATCHES_WON", 500)
        stats.set_int("MPPLY_TENNIS_MATCHES_LOST", 250)
        stats.set_int("MPPLY_GOLF_WINS", 500)
        stats.set_int("MPPLY_GOLF_LOSSES", 250)
        stats.set_int("MPPLY_DARTS_TOTAL_WINS", 500)
        stats.set_int("MPPLY_DARTS_TOTAL_MATCHES", 750)
        stats.set_int("MPPLY_SHOOTINGRANGE_TOTAL_MATCH", 800)
        stats.set_int("MPPLY_BJ_WINS", 500)
        stats.set_int("MPPLY_BJ_LOST", 250)
        stats.set_int("MPPLY_RACE_2_POINT_WINS", 500)
        stats.set_int("MPPLY_RACE_2_POINT_LOST", 250)
        stats.set_int("MPPLY_KILLS_PLAYERS", 3593)
        stats.set_int("MPPLY_DEATHS_PLAYER", 1002)
        stats.set_int("MPPLY_MISSIONS_CREATED", 500)
        stats.set_int("MPPLY_LTS_CREATED", 500)
        stats.set_int("MPPLY_AWD_FM_CR_PLAYED_BY_PEEP", 1598)
        stats.set_int("MPPLY_FM_MISSION_LIKES", 1500)
        stats.set_packed_stat_int(7315, 6) -- WEAPON_STONE_HATCHET
        stats.set_packed_stat_int(18981, 4) -- WEAPON_DOUBLEACTION
        stats.set_packed_stat_int(18982, 3) -- Parts of the TM-02 Khanjali (tracks, remote grenade launcher and turret end/muzzle brake)
        stats.set_packed_stat_int(18983, 3) -- Parts of the RCV (plow, door and water hose)
        stats.set_packed_stat_int(18984, 3) -- Parts of the Chernobog (door, dual headlight set and wheels)
        stats.set_packed_stat_int(18985, 3) -- Parts of the Thruster (exhaust, small rotors and handlebars/joysticks)
        stats.set_packed_stat_int(18986, 3) -- Parts of the Avenger (wing, nose camera and rotor blade)
        stats.set_packed_stat_int(22050, 5) -- Oppressor MK2 Trade Price
        stats.set_packed_stat_int(22051, 50) -- Carved Wooden Box (Nightclub)
        stats.set_packed_stat_int(22052, 100) -- Ammo Box
        stats.set_packed_stat_int(22053, 20) -- Meth
        stats.set_packed_stat_int(22054, 80) -- Weed
        stats.set_packed_stat_int(22055, 60) -- Passports
        stats.set_packed_stat_int(22056, 40) -- Crumpled Cash
        stats.set_packed_stat_int(22057, 10) -- Impotent Rage Statue
        stats.set_packed_stat_int(22058, 20) -- Gold Business Battle Trophy (Nightclub)
        stats.set_packed_stat_int(22063, 20) -- Dinka Go Go Monkey Blista
        stats.set_packed_stat_int(41237, 10) -- Taxi Livery
        stats.set_int(MPX() .. "HOLDUPS_BITSET", -1)
        stats.set_int(MPX() .. "CHAR_WEAP_UNLOCKED", -1)
        stats.set_int(MPX() .. "CHAR_WEAP_UNLOCKED2", -1)
        stats.set_int(MPX() .. "CHAR_WEAP_ADDON_1_UNLCK", -1)
        stats.set_int(MPX() .. "CHAR_WEAP_ADDON_2_UNLCK", -1)
        stats.set_int(MPX() .. "CHAR_WEAP_ADDON_3_UNLCK", -1)
        stats.set_int(MPX() .. "CHAR_WEAP_ADDON_4_UNLCK", -1)
        stats.set_int(MPX() .. "CHAR_FM_WEAP_UNLOCKED", -1)
        stats.set_int(MPX() .. "CHAR_FM_WEAP_UNLOCKED2", -1)
        stats.set_int(MPX() .. "CHAR_FM_WEAP_UNLOCKED3", -1)
        stats.set_int(MPX() .. "CHAR_FM_WEAP_UNLOCKED4", -1)
        stats.set_int(MPX() .. "CHAR_FM_WEAP_UNLOCKED5", -1)
        stats.set_int(MPX() .. "CHAR_FM_WEAP_UNLOCKED6", -1)
        stats.set_int(MPX() .. "CHAR_FM_WEAP_ADDON_1_UNLCK", -1)
        stats.set_int(MPX() .. "CHAR_FM_WEAP_ADDON_2_UNLCK", -1)
        stats.set_int(MPX() .. "CHAR_FM_WEAP_ADDON_3_UNLCK", -1)
        stats.set_int(MPX() .. "CHAR_FM_WEAP_ADDON_4_UNLCK", -1)
        stats.set_int(MPX() .. "CHAR_FM_WEAP_ADDON_5_UNLCK", -1)
        stats.set_int(MPX() .. "CHAR_FM_WEAP_ADDON_6_UNLCK", -1)
        stats.set_int(MPX() .. "CHAR_FM_WEAP_ADDON_7_UNLCK", -1)
        stats.set_int(MPX() .. "CHAR_FM_WEAP_ADDON_8_UNLCK", -1)
        stats.set_int(MPX() .. "CHAR_FM_WEAP_ADDON_9_UNLCK", -1)
        stats.set_int(MPX() .. "CHAR_FM_WEAP_ADDON_10_UNLCK", -1)
        stats.set_int(MPX() .. "CHAR_FM_WEAP_ADDON_11_UNLCK", -1)
        stats.set_int(MPX() .. "CHAR_FM_WEAP_ADDON_12_UNLCK", -1)
        stats.set_int(MPX() .. "CHAR_FM_WEAP_ADDON_13_UNLCK", -1)
        stats.set_int(MPX() .. "CHAR_FM_WEAP_ADDON_14_UNLCK", -1)
        stats.set_int(MPX() .. "CHAR_FM_WEAP_ADDON_15_UNLCK", -1)
        stats.set_int(MPX() .. "CHAR_FM_WEAP_ADDON_16_UNLCK", -1)
        stats.set_int(MPX() .. "CHAR_FM_WEAP_ADDON_17_UNLCK", -1)
        stats.set_int(MPX() .. "CHAR_FM_WEAP_ADDON_18_UNLCK", -1)
        stats.set_int(MPX() .. "CHAR_FM_WEAP_ADDON_19_UNLCK", -1)
        stats.set_int(MPX() .. "CHAR_FM_WEAP_ADDON_20_UNLCK", -1)
        stats.set_int(MPX() .. "CHAR_FM_HAIRCUT_1_UNLCK", -1)
        stats.set_int(MPX() .. "CHAR_HAIR_UNLCK1", -1)
        stats.set_int(MPX() .. "CHAR_HAIR_UNLCK2", -1)
        stats.set_int(MPX() .. "CHAR_HAIR_UNLCK3", -1)
        stats.set_int(MPX() .. "CHAR_HAIR_UNLCK4", -1)
        stats.set_int(MPX() .. "CHAR_HAIR_UNLCK5", -1)
        stats.set_int(MPX() .. "CHAR_HAIR_UNLCK6", -1)
        stats.set_int(MPX() .. "CHAR_HAIR_UNLCK7", -1)
        stats.set_int(MPX() .. "CHAR_HAIR_UNLCK8", -1)
        stats.set_int(MPX() .. "CHAR_HAIR_UNLCK9", -1)
        stats.set_int(MPX() .. "CHAR_HAIR_UNLCK10", -1)
        stats.set_int(MPX() .. "CHAR_HAIR_UNLCK11", -1)
        stats.set_int(MPX() .. "CHAR_HAIR_UNLCK12", -1)
        stats.set_int(MPX() .. "CHAR_HAIR_UNLCK13", -1)
        stats.set_int(MPX() .. "CHAR_HAIR_UNLCK14", -1)
        stats.set_int(MPX() .. "CHAR_HAIR_UNLCK15", -1)
        stats.set_int(MPX() .. "CHAR_HAIR_UNLCK16", -1)
        stats.set_int(MPX() .. "CHAR_HAIR_UNLCK17", -1)
        stats.set_int(MPX() .. "CHAR_FM_HEALTH_1_UNLCK", -1)
        stats.set_int(MPX() .. "CHAR_FM_HEALTH_2_UNLCK", -1)
        stats.set_int(MPX() .. "RANKAP_UNLK_0", -1)
        stats.set_int(MPX() .. "RANKAP_UNLK_1", -1)
        stats.set_int(MPX() .. "RANKAP_UNLK_2", -1)
        stats.set_int(MPX() .. "RANKAP_UNLK_3", -1)
        stats.set_int(MPX() .. "CHAR_CREWUNLOCK_1_UNLCK", -1)
        stats.set_int(MPX() .. "PISTOL_ENEMY_KILLS", 600) -- Weapon Tints for Pistol
        stats.set_int(MPX() .. "CMBTPISTOL_ENEMY_KILLS", 600) -- Weapon Tints for Combat Pistol
        stats.set_int(MPX() .. "APPISTOL_ENEMY_KILLS", 600) -- Weapon Tints for AP Pistol
        stats.set_int(MPX() .. "MICROSMG_ENEMY_KILLS", 600) -- Weapon Tints for Micro SMG
        stats.set_int(MPX() .. "SMG_ENEMY_KILLS", 600) -- Weapon Tints for SMG
        stats.set_int(MPX() .. "ASLTSMG_ENEMY_KILLS", 600) -- Weapon Tints for Assault SMG
        stats.set_int(MPX() .. "ASLTRIFLE_ENEMY_KILLS", 600) -- Weapon Tints for Assault Rifle
        stats.set_int(MPX() .. "CRBNRIFLE_ENEMY_KILLS", 600) -- Weapon Tints for Carbine Rifle
        stats.set_int(MPX() .. "ADVRIFLE_ENEMY_KILLS", 600) -- Weapon Tints for Advanced Rifle
        stats.set_int(MPX() .. "MG_ENEMY_KILLS", 600) -- Weapon Tints for MG
        stats.set_int(MPX() .. "CMBTMG_ENEMY_KILLS", 600) -- Weapon Tints for Combat MG
        stats.set_int(MPX() .. "PUMP_ENEMY_KILLS", 600) -- Weapon Tints for Pump Shotgun
        stats.set_int(MPX() .. "SAWNOFF_ENEMY_KILLS", 600) -- Weapon Tints for Sawed-Off Shotgun
        stats.set_int(MPX() .. "ASLTSHTGN_ENEMY_KILLS", 600) -- Weapon Tints for Assault Shotgun
        stats.set_int(MPX() .. "SNIPERRFL_ENEMY_KILLS", 600) -- Weapon Tints for Sniper Rifle
        stats.set_int(MPX() .. "HVYSNIPER_ENEMY_KILLS", 600) -- Weapon Tints for Heavy Sniper
        stats.set_int(MPX() .. "GRNLAUNCH_ENEMY_KILLS", 600) -- Weapon Tints for Grenade Launcher
        stats.set_int(MPX() .. "RPG_ENEMY_KILLS", 600) -- Weapon Tints for Rocket Launcher
        stats.set_int(MPX() .. "MINIGUNS_ENEMY_KILLS", 600) -- Weapon Tints for Minigun
        unlock_packed_bools(25010, 25010) -- Skip arena wall help.
        unlock_packed_bools(25014, 25014) -- Skip arena wall tutorial.
        stats.set_int(MPX() .. "FIXER_HQ_OWNED", 1) -- Trade Price for buffalo4
        unlock_packed_bools(32312, 32312)
        stats.set_int(MPX() .. "REV_NV_KILLS", 50) -- Navy Revolver Kills
        stats.set_int(MPX() .. "XM22_FLOW", -1) -- Acid Lab Unlock
        stats.set_int(MPX() .. "XM22_MISSIONS", -1) -- Acid Lab Unlock
        stats.set_int(MPX() .. "AWD_CALLME", tunables.get_int(654710993)) -- Acid Lab Equipment Unlock
        stats.set_int(MPX() .. "H3_VEHICLESUSED", -1) -- Trade Price for Diamond Casino Heist Finale.
        stats.set_int(MPX() .. "H4_H4_DJ_MISSIONS", -1) -- Trade Price for weevil
        stats.set_int(MPX() .. "H4_PROGRESS", -1) -- Trade Price for winky
        stats.set_int(MPX() .. "TUNER_GEN_BS", -1) -- Trade Price for tailgater2
        stats.set_int(MPX() .. "ULP_MISSION_PROGRESS", -1) -- Trade Price greenwood/conada
        stats.set_int(MPX() .. "SUM23_AVOP_PROGRESS", -1) -- Trade Price Raiju
        stats.set_int(MPX() .. "GANGOPS_FLOW_BITSET_MISS0", -1) -- Trade Price for deluxo/akula/riot2/stromberg/chernobog/barrage/khanjali/volatol/thruster
        stats.set_bool(MPX() .. "AWD_TAXISTAR", true) -- Trade Price for taxi
        stats.set_bool("MPPLY_AWD_HST_ORDER", true)
        stats.set_bool("MPPLY_AWD_HST_SAME_TEAM", true)
        stats.set_bool("MPPLY_AWD_HST_ULT_CHAL", true)
        stats.set_int(MPX() .. "AT_FLOW_VEHICLE_BS", -1) -- Trade price for dune4/dune5/wastelander/blazer5/phantom2/voltic2/technical2/boxville5/ruiner2
        stats.set_int(MPX() .. "LFETIME_HANGAR_BUY_COMPLET", 50) -- Trade price for microlight/rogue/alphaz1/havok/starling/molotok/tula/bombushka/howard/mogul/pyro/seabreeze/nokota/hunter
        stats.set_int(MPX() .. "SALV23_GEN_BS", -1) -- polgauntlet trade price
        stats.set_int(MPX() .. "SALV23_SCOPE_BS", -1) -- police5 trade price
        stats.set_int(MPX() .. "MOST_TIME_ON_3_PLUS_STARS", 300000) -- police4 trade price

    end

    if ImGui.Button("One Click All Achievements") then
        script.run_in_fiber(function(script)
            for i = 0, 77 do
                script:sleep(200)
                globals.set_int(AG, i)
                if i == 77 then
                    gui.show_message("Achivements", "Unlocked 77 Achivements")
                end
            end
        end)
    end

    ImGui.SeparatorText("Car Meet Unlock")
    if ImGui.Button("Unlock Car Meet Prize Ride") then
        stats.set_bool(MPX() .. "CARMEET_PV_CHLLGE_CMPLT", true)
    end
end)

local loops = {{
    name = "$15.000.000 / 30 MINS",
    amount = 15000000,
    hash = "SERVICE_EARN_JOB_BONUS",
    cooldown = 1800000
}, {
    name = "$15.000.000 / 30 MINS V2",
    amount = 15000000,
    hash = "SERVICE_EARN_BEND_JOB",
    cooldown = 1800000
}, {
    name = "$3.600.000 / 20 MINS",
    amount = 3600000,
    hash = "SERVICE_EARN_CASINO_HEIST_FINALE",
    cooldown = 120000
}, {
    name = "$2.550.000 / 20 MINS",
    amount = 2550000,
    hash = "SERVICE_EARN_ISLAND_HEIST_FINALE",
    cooldown = 120000
}, {
    name = "$2.550.000 / 20 MINS V2",
    amount = 2550000,
    hash = "SERVICE_EARN_GANGOPS_FINALE",
    cooldown = 120000
}}


local MoneyLoops = Recovery:add_tab("[RISK] AFK MONEY LOOP")
MoneyLoops:add_imgui(function()
    ImGui.SeparatorText("Information")
    ImGui.Text("These methods are not detected and won't get you banned, but they are considered risky as they can get detected after any update!")
    ImGui.BulletText("Use at your own risk!")
    ImGui.SeparatorText("BLOCK TRANSACTION ERRORS")
    blockTransactionErrors, _ = ImGui.Checkbox("Block Transaction Errors", blockTransactionErrors, true)
    helpmarker(false, "Avoid all the Transaction Error Screens to keep the gameplay smooth.")
    if blockTransactionErrors then
        globals.set_int(4537456, 0)
        globals.set_int(4537457, 0)
        globals.set_int(4537458, 0)
    end

ImGui.SeparatorText("LOOPS")

end)
for _, method in ipairs(loops) do
    local checkbox = MoneyLoops:add_checkbox(method.name, function()
    end)

    script.register_looped(method.name, function(script)
        if (checkbox:is_enabled()) then
            trigger_transaction(joaat(method.hash), method.amount)
            script:sleep(method.cooldown)
        end
    end)

end

script.register_looped("selfmenu", function(script)
    -- Online Phone Animations
    if NETWORK.NETWORK_IS_SESSION_ACTIVE() then
        if phoneAnim and not ENTITY.IS_ENTITY_DEAD(self.get_ped(), false) then
            if not is_playing_anim and not is_playing_scenario and not ped_grabbed and not vehicle_grabbed and
                not is_handsUp and not is_sitting and PED.COUNT_PEDS_IN_COMBAT_WITH_TARGET(self.get_ped()) == 0 then
                if PED.GET_PED_CONFIG_FLAG(self.get_ped(), 242, true) then
                    PED.SET_PED_CONFIG_FLAG(self.get_ped(), 242, false)
                end
                if PED.GET_PED_CONFIG_FLAG(self.get_ped(), 243, true) then
                    PED.SET_PED_CONFIG_FLAG(self.get_ped(), 243, false)
                end
                if PED.GET_PED_CONFIG_FLAG(self.get_ped(), 244, true) then
                    PED.SET_PED_CONFIG_FLAG(self.get_ped(), 244, false)
                end
                if not PED.GET_PED_CONFIG_FLAG(self.get_ped(), 243, true) and AUDIO.IS_MOBILE_PHONE_CALL_ONGOING() then
                    if not STREAMING.HAS_ANIM_DICT_LOADED("anim@scripted@freemode@ig19_mobile_phone@male@") then
                        STREAMING.REQUEST_ANIM_DICT("anim@scripted@freemode@ig19_mobile_phone@male@")
                        return
                    end
                    TASK.TASK_PLAY_PHONE_GESTURE_ANIMATION(self.get_ped(),
                        "anim@scripted@freemode@ig19_mobile_phone@male@", "base", "BONEMASK_HEAD_NECK_AND_R_ARM", 0.25,
                        0.25, true, false)
                    repeat
                        script:sleep(10)
                    until AUDIO.IS_MOBILE_PHONE_CALL_ONGOING() == false
                    TASK.TASK_STOP_PHONE_GESTURE_ANIMATION(self.get_ped(), 0.25)
                end
            else
                PED.SET_PED_CONFIG_FLAG(self.get_ped(), 242, true)
                PED.SET_PED_CONFIG_FLAG(self.get_ped(), 243, true)
                PED.SET_PED_CONFIG_FLAG(self.get_ped(), 244, true)
            end
        else
            PED.SET_PED_CONFIG_FLAG(self.get_ped(), 242, true)
            PED.SET_PED_CONFIG_FLAG(self.get_ped(), 243, true)
            PED.SET_PED_CONFIG_FLAG(self.get_ped(), 244, true)
        end
    else
        if PED.GET_PED_CONFIG_FLAG(self.get_ped(), 242, true) and PED.GET_PED_CONFIG_FLAG(self.get_ped(), 243, true) and
            PED.GET_PED_CONFIG_FLAG(self.get_ped(), 244, true) then
            PED.SET_PED_CONFIG_FLAG(self.get_ped(), 242, false)
            PED.SET_PED_CONFIG_FLAG(self.get_ped(), 243, false)
            PED.SET_PED_CONFIG_FLAG(self.get_ped(), 244, false)
        end
    end

end)
