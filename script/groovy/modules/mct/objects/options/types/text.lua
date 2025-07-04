--- MCT text type. A block of text across the whole row. Holds no setting.
--- Set the text with `set_text`. The game's colour tags work, like `[[col:yellow]]Gold[[/col]]`.

local mct = get_mct()
local log,logf,err,errf = get_vlog("[mct]")

-- option types load in no set order, so load the dummy directly. GLib caches it by path, so the type loader reuses this copy.
---@type MCT.Option.Dummy
local Dummy = GLib.LoadModule("dummy", GLib.ThisPath(...))

---@class MCT.Option.Text
local defaults = {
    ---@type number The row layout: full width with no label, so the row fits the text.
    _control_dock_point = 5,
}

---@class MCT.Option.Text : MCT.Option.Dummy A block of text in the Settings list view. No setting is associated.
---@field __new fun():MCT.Option.Text
local Text = Dummy:extend("MCT.Option.Text", defaults)

--- Create the text across the row's content, wrapping long text. The row's height is set by `ui_layout_row`.
---@param dummy_parent UIC The option row.
---@return UIC #The text.
function Text:ui_create_option(dummy_parent)
    local text = self:get_text()
    local width = self:ui_get_content_width(dummy_parent)

    local text_uic = core:get_or_create_component("mct_text", "ui/groovy/text/fe_default", dummy_parent)
    text_uic:SetCanResizeWidth(true) text_uic:SetCanResizeHeight(true)
    text_uic:Resize(width, text_uic:Height())
    text_uic:SetTextHAlign("left")
    text_uic:SetTextVAlign("top")
    text_uic:SetTextXOffset(0, 0)
    text_uic:SetTextYOffset(0, 0)

    -- measured at the final width, so wrapped lines are counted
    local _, text_h = text_uic:TextDimensionsForText(text)
    text_uic:Resize(width, text_h)
    text_uic:SetCanResizeWidth(false) text_uic:SetCanResizeHeight(false)
    text_uic:SetStateText(text)
    text_uic:SetInteractive(false)

    self:set_uic_with_key("option", text_uic, true)
    return text_uic
end

return Text
