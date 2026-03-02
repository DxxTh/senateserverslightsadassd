local meta = FindMetaTable("Player")
local npc = FindMetaTable("NPC")

function meta:sound(soundPath)
    if not self.sounds then
        self.sounds = {}
    end

    local duration = SoundDuration(soundPath)
    if duration <= 0 then return end

    local endTime = self.sounds[soundPath] or 0
    if CurTime() < endTime then return end

    self:EmitSound(soundPath)
    self.sounds[soundPath] = CurTime() + duration
end

function meta:stopSound(soundPath)
    self:StopSound(soundPath)
    if self.sounds then
        self.sounds[soundPath] = nil
    end
end

function npc:sound(soundPath)
    if not self.sounds then
        self.sounds = {}
    end

    local duration = SoundDuration(soundPath)
    if duration <= 0 then return end

    local endTime = self.sounds[soundPath] or 0
    if CurTime() < endTime then return end

    self:EmitSound(soundPath)
    self.sounds[soundPath] = CurTime() + duration
end

function npc:stopSound(soundPath)
    self:StopSound(soundPath)
    if self.sounds then
        self.sounds[soundPath] = nil
    end
end