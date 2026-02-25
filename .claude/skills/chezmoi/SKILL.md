---
name: chezmoi
description: Manage dotfiles with chezmoi. Use when working with dotfiles, chezmoi templates, machine-specific configuration, syncing configs across machines, or when the user mentions chezmoi, dotfiles, or configuration management.
allowed-tools:
  - Read
  - Edit
  - Write
  - Glob
  - Grep
  - Bash(chezmoi *)
origin: https://github.com/cosgroveb/chezmoi-skill
---

# Chezmoi Dotfiles Management

## Action Guidance

When the user asks about dotfiles or chezmoi operations, **implement the changes directly** using chezmoi commands rather than only suggesting them. If the user says "make this work on macOS only" or "add my bashrc to chezmoi", proceed with implementation.

Always preview significant changes with `chezmoi diff` or `chezmoi cat <file>` before applying.

## Commands

```bash
chezmoi add <file>           # Add file to chezmoi
chezmoi apply --refresh-externals # Apply changes (always use --refresh-externals)
chezmoi diff                 # Preview what would change
chezmoi cat <file>           # Preview rendered template output
chezmoi data                 # Show available template variables
chezmoi edit <file>          # Edit source file
chezmoi edit ~/.local/share/chezmoi/.chezmoiremove  # Edit removal list
```

## File Naming

| Prefix/Suffix | Effect |
|---------------|--------|
| `dot_` | Installed as `.` (`dot_gitconfig` → `~/.gitconfig`) |
| `private_` | Restrictive permissions (600) |
| `executable_` | Executable permissions (755) |
| `.tmpl` | Processed as Go template |
| `symlink_` | Creates symlink |

## Machine-Specific Templates

Convert a static file to a template by renaming with `.tmpl` suffix, then use conditionals:

### By OS
```
{{- if eq .chezmoi.os "darwin" }}
# macOS config
{{- end }}

{{- if eq .chezmoi.os "linux" }}
# Linux config
{{- end }}
```

### By hostname
```
{{- if hasPrefix .chezmoi.hostname "work-" }}
# work machine config
{{- end }}
```

### By environment variable
```
{{- if env "WORK_ENV" }}
# when WORK_ENV is set
{{- end }}
```

### Combined conditions
```
{{- if or (eq .chezmoi.os "darwin") (env "WORK_ENV") }}
# macOS or when WORK_ENV is set
{{- end }}
```

## Escaping Nested Templates

When the target file itself uses `{{ }}` syntax (like mise, Jinja2, or Tera templates), escape the braces so chezmoi doesn't process them as Go template syntax:

```
SOME_VAR = "{{ "{{" }}env.OTHER_VAR{{ "}}" }}"
```

This renders as `SOME_VAR = "{{env.OTHER_VAR}}"` in the output. The `{{ "{{" }}` and `{{ "}}" }}` are Go template expressions that output literal brace characters.

## Removing Files

Use `.chezmoiremove` to clean up dotfiles that chezmoi should remove from your system:

```bash
# Create .chezmoiremove file listing targets to remove
cat > ~/.local/share/chezmoi/.chezmoiremove << 'EOF'
~/.old-config
~/.deprecated-rc
EOF

# Preview what would be removed
chezmoi diff

# Apply to remove the files
chezmoi apply --refresh-externals --force
```

### Template-based removal (`.chezmoiremove.tmpl`)

Conditionally remove files based on system variables:

```
{{- if eq .chezmoi.os "darwin" }}
~/.linux-only-config
{{- end }}

{{- if not (env "WORK_ENV") }}
~/.work-config
{{- end }}
```

The file is always processed as a template, even without the `.tmpl` extension.

## External Dependencies

Manage external git repos in `.chezmoiexternal.toml`:

```toml
[".zsh/plugins/some-plugin"]
    type = "git-repo"
    url = "https://github.com/user/some-plugin.git"
    refreshPeriod = "168h"
```

## Workflow: Converting Static File to Template

When converting a static config to machine-specific template:

1. Read the current file to understand its contents
2. Identify machine-specific values (paths, hostnames, environment-specific settings)
3. Run `chezmoi add --template <file>` to add as template
4. Edit the template source to add conditionals (see "Machine-Specific Templates")
5. Preview with `chezmoi cat <file>` to verify rendering on this machine
6. Apply with `chezmoi apply --refresh-externals --force`

## Gotchas

1. **Removing managed files**: Use `.chezmoiremove` to clean up files (see "Removing Files" section)
2. **Always preview**: Run `chezmoi cat <file>` before applying templates
3. **Always use `--refresh-externals --force` flags**: Critical because `--refresh-externals` ensures external git repos and archives update, and `--force` prevents interactive TTY prompts that would block execution (Claude cannot respond to interactive prompts)
4. **Template errors**: Use `chezmoi execute-template '{{ .chezmoi.os }}'` to test template snippets

## Troubleshooting

**Template syntax errors**: Test small snippets with `chezmoi execute-template '{{ .chezmoi.os }}'`

**File not applying**: Check `chezmoi status` and `chezmoi diff` to see what changes are pending

**External not refreshing**: The refresh period might not have elapsed; use `--refresh-externals` flag to force refresh

**Permission errors**: Verify file has correct prefix (`private_` for 600, `executable_` for 755)
