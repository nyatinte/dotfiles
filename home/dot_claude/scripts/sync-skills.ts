import { select, checkbox, confirm } from "@inquirer/prompts";
import { cpSync, existsSync, readdirSync } from "fs";
import { resolve, join, basename } from "path";
import { homedir } from "os";
import pc from "picocolors";

const SYNC_TARGETS = [
  "create-draft-pull-request",
  "git-commit",
] as const satisfies readonly string[];

type SyncDirection = "global-to-project" | "project-to-global";

type SkillInfo = {
  name: string;
  srcDir: string;
  destDir: string;
  destExists: boolean;
  fileCount: number;
};

const GLOBAL_SKILLS_DIR = resolve(homedir(), ".claude/skills");

const resolveProjectSkillsDir = (projectPath: string): string =>
  resolve(projectPath, ".claude/skills");

const countFiles = (dir: string): number => {
  if (!existsSync(dir)) return 0;
  let count = 0;
  const walk = (current: string) => {
    for (const entry of readdirSync(current, { withFileTypes: true })) {
      if (entry.isDirectory()) {
        walk(join(current, entry.name));
      } else {
        count++;
      }
    }
  };
  walk(dir);
  return count;
};

const formatDirection = (dir: SyncDirection): string =>
  dir === "global-to-project"
    ? `${pc.cyan("Global")} → ${pc.green("Project")}`
    : `${pc.green("Project")} → ${pc.cyan("Global")}`;

const resolveDirs = (
  name: string,
  direction: SyncDirection,
  globalDir: string,
  projectDir: string,
): { srcDir: string; destDir: string } =>
  direction === "global-to-project"
    ? { srcDir: join(globalDir, name), destDir: join(projectDir, name) }
    : { srcDir: join(projectDir, name), destDir: join(globalDir, name) };

const main = async () => {
  const targetPath = process.argv[2];

  if (!targetPath) {
    console.error(pc.red("Usage: pnpm exec tsx scripts/sync-skills.ts <project-path>"));
    console.error(pc.dim("  例: pnpm exec tsx scripts/sync-skills.ts ~/projects/my-app"));
    process.exit(1);
  }

  const resolvedTarget = resolve(targetPath);
  const projectSkillsDir = resolveProjectSkillsDir(resolvedTarget);

  if (!existsSync(GLOBAL_SKILLS_DIR)) {
    console.error(pc.red(`Global skills ディレクトリが見つかりません: ${GLOBAL_SKILLS_DIR}`));
    process.exit(1);
  }
  if (!existsSync(projectSkillsDir)) {
    console.error(pc.red(`Project skills ディレクトリが見つかりません: ${projectSkillsDir}`));
    process.exit(1);
  }

  console.log(pc.bold("\nSkill Sync"));
  console.log(pc.dim(`  Global:  ${GLOBAL_SKILLS_DIR}`));
  console.log(pc.dim(`  Project: ${projectSkillsDir}`));
  console.log();

  const direction = await select<SyncDirection>({
    message: "同期の方向を選択してください",
    choices: [
      {
        name: `Global → Project (${basename(resolvedTarget)})`,
        value: "global-to-project" as const,
      },
      {
        name: `Project (${basename(resolvedTarget)}) → Global`,
        value: "project-to-global" as const,
      },
    ],
  });

  const availableSkills: SkillInfo[] = SYNC_TARGETS
    .map((name) => {
      const { srcDir, destDir } = resolveDirs(name, direction, GLOBAL_SKILLS_DIR, projectSkillsDir);
      return {
        name,
        srcDir,
        destDir,
        destExists: existsSync(destDir),
        fileCount: countFiles(srcDir),
      };
    })
    .filter((skill) => existsSync(skill.srcDir));

  if (availableSkills.length === 0) {
    console.log(pc.yellow("同期可能なスキルがありません"));
    process.exit(0);
  }

  const selectedSkills = await checkbox({
    message: "同期するスキルを選択してください",
    choices: availableSkills.map((skill) => {
      const status = skill.destExists ? pc.yellow("上書き") : pc.green("新規作成");
      return {
        name: `${skill.name} (${skill.fileCount} files) [${status}]`,
        value: skill,
        checked: true,
      };
    }),
  });

  if (selectedSkills.length === 0) {
    console.log(pc.yellow("スキルが選択されませんでした"));
    process.exit(0);
  }

  console.log();
  console.log(pc.bold("同期内容:"));
  console.log(`  方向: ${formatDirection(direction)}`);
  for (const skill of selectedSkills) {
    console.log(`  - ${skill.name} (${skill.fileCount} files)`);
  }
  console.log();

  const confirmed = await confirm({
    message: "実行しますか？",
    default: true,
  });

  if (!confirmed) {
    console.log(pc.dim("キャンセルしました"));
    process.exit(0);
  }

  console.log();
  for (const skill of selectedSkills) {
    console.log(`${pc.cyan("→")} ${skill.name}`);
    console.log(pc.dim(`  ${skill.srcDir}`));
    console.log(pc.dim(`  → ${skill.destDir}`));
    cpSync(skill.srcDir, skill.destDir, { recursive: true });
    console.log(`  ${pc.green("✓")} 完了`);
  }

  console.log();
  console.log(pc.green(pc.bold(`${selectedSkills.length}個のスキルを同期しました`)));
};

main().catch((err) => {
  if (err instanceof Error && err.name === "ExitPromptError") {
    process.exit(0);
  }
  console.error(pc.red(String(err)));
  process.exit(1);
});
