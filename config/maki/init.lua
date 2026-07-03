-- maki config (~/.config/maki/init.lua)
--
-- Model: DeepSeek V4 Flash via OpenRouter, but NOT served by DeepSeek's own
-- first-party provider (DeepSeek trains on prompts). The exclusion is enforced
-- by an OpenRouter *preset* named "deepseek-flash-private", because maki forwards
-- only the model slug and cannot pass provider-routing options itself.
--
-- Create that preset once in the OpenRouter dashboard (Settings -> Presets) with:
--   model:    deepseek/deepseek-v4-flash
--   provider: { "ignore": ["deepseek"], "data_collection": "deny" }
-- Docs: https://openrouter.ai/docs/guides/features/presets
--
-- Auth: export OPENROUTER_API_KEY in your shell (do not hardcode it here).

maki.setup({
    provider = {
        default_model = "openrouter/@preset/deepseek-flash-private",
    },
})
