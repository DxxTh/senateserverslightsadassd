DarkSabers = DarkSabers or {}
DarkSabers._warned = DarkSabers._warned or {}

local cvarFlags = FCVAR_ARCHIVE
if SERVER then
	cvarFlags = bit.bor(cvarFlags, FCVAR_REPLICATED)
end

DarkSabers.DebugConVar = DarkSabers.DebugConVar or CreateConVar("dark_sabers_debug", "0", cvarFlags, "Enable dark_sabers debug logging")

function DarkSabers.IsDebugEnabled()
	local cv = DarkSabers.DebugConVar or GetConVar("dark_sabers_debug")
	return cv and cv:GetBool() or false
end

function DarkSabers.Debug(msg, ...)
	if not DarkSabers.IsDebugEnabled() then return end

	local text = tostring(msg)
	if select("#", ...) > 0 then
		text = string.format(text, ...)
	end

	MsgC(Color(180, 120, 255), "[dark_sabers] ", color_white, text .. "\n")
end

function DarkSabers.WarnOnce(id, msg, ...)
	if DarkSabers._warned[id] then return end
	DarkSabers._warned[id] = true

	local text = tostring(msg)
	if select("#", ...) > 0 then
		text = string.format(text, ...)
	end

	MsgC(Color(255, 120, 120), "[dark_sabers] ", color_white, text .. "\n")
end

function DarkSabers.GetFallbackForm()
	return {
		idles = {
			up = "wos_judge_b_idle",
			left = "wos_judge_r_idle",
			right = "wos_judge_h_idle"
		},
		runs = {
			up = "wos_judge_b_run",
			left = "wos_judge_r_run",
			right = "run_melee2"
		}
	}
end

function DarkSabers.GetForms()
	lts = lts or {}

	if not istable(lts.forms) then
		lts.forms = {}
		DarkSabers.WarnOnce("missing_forms_table", "Missing forms table (lts.forms). Falling back to safe default form data.")
	end

	return lts.forms
end

function DarkSabers.ResolveForm(formID)
	local forms = DarkSabers.GetForms()
	local resolvedID = formID or "Untrained"
	local form = forms[resolvedID] or forms["Form I: Shii-Cho"] or forms["Untrained"]

	if not istable(form) then
		DarkSabers.WarnOnce("missing_form_data", "No valid form data found for '%s'. Using internal fallback animations.", tostring(resolvedID))
		return DarkSabers.GetFallbackForm(), resolvedID
	end

	if not istable(form.idles) or not istable(form.runs) then
		DarkSabers.WarnOnce("invalid_form_data_" .. tostring(resolvedID), "Form '%s' is missing idles/runs tables. Using internal fallback animations.", tostring(resolvedID))
		return DarkSabers.GetFallbackForm(), resolvedID
	end

	return form, resolvedID
end
