#!/usr/bin/env node
/**
 * PreCompact Hook - compaction 前の状態保存
 *
 * Claude がコンテキストを compaction する直前に実行される。
 * いつ compaction が発生したかをセッションログに記録する。
 *
 * ref: https://github.com/affaan-m/everything-claude-code#strategic-compaction
 */

import fs from 'fs';
import path from 'path';
import os from 'os';

const sessionsDir = path.join(os.homedir(), '.claude', 'sessions');
const compactionLog = path.join(sessionsDir, 'compaction-log.txt');

function ensureDir(dir) {
  if (!fs.existsSync(dir)) {
    fs.mkdirSync(dir, { recursive: true });
  }
}

function getDateTimeString() {
  const now = new Date();
  const pad = (n) => String(n).padStart(2, '0');
  return `${now.getFullYear()}-${pad(now.getMonth() + 1)}-${pad(now.getDate())} ${pad(now.getHours())}:${pad(now.getMinutes())}:${pad(now.getSeconds())}`;
}

function getTimeString() {
  const now = new Date();
  const pad = (n) => String(n).padStart(2, '0');
  return `${pad(now.getHours())}:${pad(now.getMinutes())}`;
}

ensureDir(sessionsDir);

const timestamp = getDateTimeString();
fs.appendFileSync(compactionLog, `[${timestamp}] Context compaction triggered\n`, 'utf8');

// アクティブなセッションファイルがあれば compaction の発生を記録
try {
  const entries = fs.readdirSync(sessionsDir);
  const sessionFiles = entries.filter(e => e.endsWith('-session.tmp'));
  if (sessionFiles.length > 0) {
    const activeSession = path.join(sessionsDir, sessionFiles[0]);
    const timeStr = getTimeString();
    fs.appendFileSync(activeSession, `\n---\n**[Compaction occurred at ${timeStr}]** - Context was summarized\n`, 'utf8');
  }
} catch { /* セッションファイルがなければ無視 */ }

console.error('[PreCompact] State saved before compaction');
process.exit(0);
