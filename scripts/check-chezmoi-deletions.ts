#!/usr/bin/env bun
import { existsSync, readFileSync } from "node:fs";
import { spawnSync } from "node:child_process";

const CHEZMOIIGNORE = "home/.chezmoiignore";

const CHEZMOI_PREFIXES = [
  "private_dot_",
  "executable_dot_",
  "symlink_dot_",
  "readonly_dot_",
  "private_",
  "executable_",
  "symlink_",
  "readonly_",
  "empty_",
  "once_",
  "onchange_",
  "run_",
];

function chezmoiToTarget(sourcePath: string): string {
  return sourcePath
    .replace(/^home\//, "")
    .split("/")
    .map((part) => {
      part = part.replace(/\.tmpl$/, "");
      const prefix = CHEZMOI_PREFIXES.find((p) => part.startsWith(p));
      if (prefix) {
        part = (prefix.endsWith("dot_") ? "." : "") + part.slice(prefix.length);
      } else if (part.startsWith("dot_")) {
        part = "." + part.slice(4);
      }
      return part;
    })
    .join("/");
}

function isInChezmoiIgnore(target: string): boolean {
  if (!existsSync(CHEZMOIIGNORE)) return false;
  return readFileSync(CHEZMOIIGNORE, "utf-8")
    .split("\n")
    .filter((line) => line.trim() && !line.startsWith("#"))
    .some((pattern) => {
      // Simple glob: * matches anything within a segment
      const regex = new RegExp(`^${pattern.replace(/\*/g, "[^/]*")}$`);
      return regex.test(target);
    });
}

function gitOutput(args: string[]): string {
  return spawnSync("git", args, { encoding: "utf-8" }).stdout ?? "";
}

const deleted = gitOutput(["diff", "--cached", "--diff-filter=D", "--name-only"]);
const renamedOld = gitOutput(["diff", "--cached", "--diff-filter=R", "--name-status"])
  .split("\n")
  .filter((l) => l.startsWith("R"))
  .map((l) => l.split("\t")[1]);

const warnings = [...deleted.split("\n"), ...renamedOld]
  .filter((f) => f.startsWith("home/"))
  .map((f) => ({ source: f, target: chezmoiToTarget(f) }))
  .filter(({ target }) => !isInChezmoiIgnore(target))
  .map(({ source, target }) => `  ${source}  →  ~/${target}`);

if (warnings.length > 0) {
  console.log(`
⚠️  Warning: 以下の chezmoi 管理ファイルが削除/移動されましたが、home/.chezmoiignore に記載されていません:

${warnings.join("\n")}

  対処方法:
    - ターゲットファイルをそのまま残す場合 → home/.chezmoiignore にパターンを追加
    - ターゲットファイルも削除する場合     → home/.chezmoiremove にパターンを追加

  チェックをスキップする場合: git commit --no-verify
`);
  process.exit(1);
}
