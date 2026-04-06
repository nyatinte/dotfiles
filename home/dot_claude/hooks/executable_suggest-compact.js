#!/usr/bin/env node
/**
 * Strategic Compact Suggester
 *
 * PreToolUse (Edit|Write) で実行し、ツール呼び出し回数が閾値に達したら
 * 手動 /compact を提案する。自動 compaction は任意の地点で発生するため、
 * フェーズ境界での戦略的 compaction を促す。
 *
 * ref: https://github.com/affaan-m/everything-claude-code#strategic-compaction
 */

const fs = require("fs");
const path = require("path");
const os = require("os");

const sessionId = process.env.CLAUDE_SESSION_ID || "default";
const counterFile = path.join(os.tmpdir(), `claude-tool-count-${sessionId}`);
const rawThreshold = parseInt(process.env.COMPACT_THRESHOLD || "50", 10);
const threshold =
  Number.isFinite(rawThreshold) && rawThreshold > 0 && rawThreshold <= 10000 ? rawThreshold : 50;

let count = 1;

try {
  const fd = fs.openSync(counterFile, "a+");
  try {
    const buf = Buffer.alloc(64);
    const bytesRead = fs.readSync(fd, buf, 0, 64, 0);
    if (bytesRead > 0) {
      const parsed = parseInt(buf.toString("utf8", 0, bytesRead).trim(), 10);
      count = Number.isFinite(parsed) && parsed > 0 && parsed <= 1000000 ? parsed + 1 : 1;
    }
    fs.ftruncateSync(fd, 0);
    fs.writeSync(fd, String(count), 0);
  } finally {
    fs.closeSync(fd);
  }
} catch {
  try {
    fs.writeFileSync(counterFile, String(count), "utf8");
  } catch {
    /* ignore */
  }
}

if (count === threshold) {
  console.error(
    `[StrategicCompact] ${threshold} tool calls reached - フェーズ移行なら /compact を検討`,
  );
}

if (count > threshold && (count - threshold) % 25 === 0) {
  console.error(
    `[StrategicCompact] ${count} tool calls - コンテキストが古くなっていれば /compact のタイミング`,
  );
}

process.exit(0);
