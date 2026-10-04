---
name: gh-attach
description: Attach local images or videos to GitHub issues, pull requests, or comments with GitHub CLI. Use when creating or editing an issue or PR, commenting, or embedding local media in GitHub Markdown.
---

# Attach media with GitHub CLI

Use `gh`'s `--attach` flag to upload local image or video files and embed their GitHub-hosted URLs in issue and pull request bodies or comments.

## Workflow

1. Identify the target command (`gh issue create|edit|comment` or `gh pr create|edit|comment`) and local media files.
2. If the body should place media at a specific location, include a Markdown reference to the local file in the body and attach that same path. For an image, preserve useful alt text:

   ```markdown
   ![Sign-in error](./signin-error.png)
   ```

   For a video player, put `![](./recording.mp4)` alone in its paragraph.

3. Pass `--attach <path>` for each file, along with `--body`, `--body-file`, or the command's normal body input. Use `--attach 'path#alt text'` to set alt text for an image when it is appended rather than referenced in Markdown.
4. Verify the command's result and report the created or updated GitHub URL.

Example:

```sh
gh issue comment 123 \
  --body-file ./comment.md \
  --attach ./signin-error.png
```

## Upload behavior

- A matching local path in the body is rewritten to the uploaded URL in place; Markdown alt text is retained. This works with body text, body files, standard input, and the editor.
- Attached files not referenced in the body are appended in flag order. Do not attach the same file twice.
- Image `#alt text` is used for appended images; for a body reference, its Markdown alt text wins. Video alt text is unsupported.

## Boundaries

- Supported commands: `gh issue create`, `gh issue edit`, `gh issue comment`, `gh pr create`, `gh pr edit`, and `gh pr comment`.
- GitHub CLI supports image and media files only. Check GitHub's current supported file types if the extension is uncertain.
- The user needs push access to the repository for uploads. If access or upload fails, explain the blocker; don't claim the file was attached.
