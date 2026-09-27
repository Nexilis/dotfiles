// Marks a working omp session so Hammerspoon keeps the Mac awake; the omp side
// of config/hammerspoon/claude-busy.sh, sharing its marker dir.
import type { ExtensionAPI } from "@oh-my-pi/pi-coding-agent";
import * as fs from "node:fs";
import * as os from "node:os";
import * as path from "node:path";

const dir = path.join(os.homedir(), ".cache", "claude-busy");

function markerPath(ctx: any): string | undefined {
    // Subagents share the main session's turn; only the main agent marks.
    if (ctx.agent?.kind === "sub") return undefined;
    const id = ctx.sessionManager?.getSessionId?.();
    if (typeof id !== "string" || !/^[A-Za-z0-9_-]+$/.test(id)) return undefined;
    return path.join(dir, `omp-${id}`);
}

function busy(ctx: any): void {
    const p = markerPath(ctx);
    if (!p) return;
    try {
        fs.mkdirSync(dir, { recursive: true });
        fs.writeFileSync(p, "");
    } catch {}
}

function idle(ctx: any): void {
    const p = markerPath(ctx);
    if (!p) return;
    try {
        fs.rmSync(p, { force: true });
    } catch {}
}

export default function keepAwake(pi: ExtensionAPI) {
    pi.on("agent_start", (_e, ctx) => busy(ctx));
    // Returning nothing matters: a returned object would patch the tool result.
    pi.on("tool_result", (_e, ctx) => {
        busy(ctx);
    });
    // willContinue: an auto-retry follows, so the turn is not over yet.
    pi.on("agent_end", (e, ctx) => {
        if (!e.willContinue) idle(ctx);
    });
    pi.on("session_shutdown", (_e, ctx) => idle(ctx));
}
