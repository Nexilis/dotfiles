-- maki config (~/.config/maki/init.lua)
-- Auth: export OPENROUTER_API_KEY in your shell (do not hardcode it here).

maki.setup({
	provider = {
		default_model = "openrouter/@preset/my-fav-model-preset",
	},
})
