---
description: Fetch active Azure DevOps PR review comments and address them, with review-before-push guardrails
---

You are addressing review feedback on an Azure DevOps pull request.

## Input

The user invoked: `/address-pr $ARGUMENTS`

- `$ARGUMENTS` should contain the PR id (e.g. `1234`). It may also contain a
  repository name. If the PR id is missing, ask for it before doing anything.
- Org/project context: Azure DevOps org `Ryder-Whiplash`, project
  `Whiplash Platform`. Use the ADO MCP tools (the `azure-devops_*` tools), NOT
  the `gh` CLI — this is Azure DevOps, not GitHub.

## Resolve the PR

1. Determine the repository:
   - If the user named a repo, use it.
   - Otherwise infer from the current git remote (`git remote -v`) — the ADO
     repo name is usually the last path segment of the remote URL.
   - If you still can't tell, list repos in the project and ask the user which
     one.
2. Fetch the PR with `azure-devops_repo_pull_request` (action `get`,
   `includeChangedFiles: true`) to learn the source/target branches and the
   files in play.

## Read the review threads

3. List comment threads with `azure-devops_repo_pull_request_thread` (action
   `list`). Focus on threads whose status is `Active` or `Pending`. Ignore
   threads already `Fixed`, `Closed`, `WontFix`, or `ByDesign` unless the user
   asks otherwise.
4. For each active thread, read the full comment chain
   (`action: list_comments`) and the code it references (use `Read` on the file
   at the thread's line, on the PR source branch).

## Triage with judgment

5. For each thread, classify it:
   - **Actionable** — clear, valid feedback you can implement.
   - **Needs discussion** — ambiguous, or you disagree; do NOT silently comply.
   - **Nit / optional** — style preferences; note them but don't over-engineer.
6. Do not blindly obey every comment. If a suggestion is wrong or risky, plan a
   respectful reply explaining why rather than making the change.

## Present a plan BEFORE touching anything

7. Show the user a summary table with columns:
   `Thread | File:Line | Comment (short) | Verdict | Planned action`.
   Then STOP and wait for the user's go-ahead. Do not edit code, push, reply to
   threads, or resolve threads before the user confirms.

## After confirmation

8. Make the approved code changes on the PR's **source branch**. Keep each
   change tightly scoped to its thread.
9. Run the project's build/tests if you can identify them, and report results.
10. For each addressed thread, prepare a concise reply summarizing what you did
    (or why you deferred). Show the user the batch of replies and get a second
    confirmation before posting them with
    `azure-devops_repo_pull_request_thread_write`.
11. Only after the user explicitly asks should you resolve threads
    (`update_status`) or push commits. Default to leaving that to the user.

## Guardrails (non-negotiable)

- Never push commits or resolve threads without an explicit, separate
  confirmation.
- Never invent file paths or line numbers — anchor everything to real thread
  data.
- If anything is ambiguous, ask rather than guess.
- Keep replies professional and brief; this PR is visible to your team.
