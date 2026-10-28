---
title: Releasing
description: Test your own work first, review a release together on staging, ship it to production as a tagged version, and keep next in step
keywords: release candidate staging production hotfix revert tag next main merge-back review attention removable depends
---

# Releasing

This flow is built around attention. You test your own work as thoroughly as
you like before anyone else spends time on it. Reviewers aren't pinged by
every PR; they're asked once per release, when the PRs are running together
on staging and a person's judgment is what's needed. Production only ever
runs a release someone checked, tagged so you can roll back to it.

<svg viewBox="0 0 800 280" width="100%" class="hidden md:block" role="img" aria-label="The release flow. You check a PR yourself on your branch, on your own machine. It merges into next, which deploys nowhere and collects PRs that CI checked one at a time. bin/release cut binds next into release/&lt;name&gt;, which deploys to staging, where reviewers check the PRs together. bin/release ship merges it into main, which deploys to production as a tagged release. main then merges back into next." fill="none" stroke="currentColor" font-family="ui-sans-serif, system-ui, sans-serif">
  <defs>
    <marker id="arrow-release" markerWidth="9" markerHeight="9" refX="6.5" refY="3" orient="auto">
      <path d="M0,0 L8,3 L0,6 z" fill="currentColor" stroke="none"/>
    </marker>
  </defs>
  <text x="80" y="22" text-anchor="middle" fill="currentColor" stroke="none" font-size="14.5" font-weight="700">The draft</text>
  <text x="80" y="40" text-anchor="middle" fill="currentColor" stroke="none" font-size="12" font-family="ui-monospace, monospace">your branch</text>
  <rect x="35" y="56" width="90" height="112" rx="6" stroke-width="1.5"/>
  <rect x="62" y="50" width="36" height="12" rx="3" stroke-width="1.5"/>
  <rect x="43" y="68" width="74" height="92" rx="1" stroke-width="1"/>
  <text x="50" y="84" fill="currentColor" stroke="none" font-size="10" font-family="ui-monospace, monospace">#1487</text>
  <line x1="50" y1="98" x2="108" y2="98" stroke-width="1" opacity="0.5"/>
  <line x1="50" y1="110" x2="100" y2="110" stroke-width="1" opacity="0.5"/>
  <line x1="50" y1="122" x2="92" y2="122" stroke-width="1" opacity="0.5"/>
  <path class="text-accent" d="M52 140 L58 146 L70 132" stroke-width="2.25" stroke-linecap="round" stroke-linejoin="round"/>
  <text x="80" y="192" text-anchor="middle" fill="currentColor" stroke="none" font-size="11">your machine</text>
  <text x="80" y="208" text-anchor="middle" fill="currentColor" stroke="none" font-size="12">checked by you</text>
  <line class="text-accent" x1="144" y1="112" x2="206" y2="112" stroke-width="2" marker-end="url(#arrow-release)"/>
  <text x="176" y="102" text-anchor="middle" fill="currentColor" stroke="none" font-size="12">merge</text>
  <text x="270" y="22" text-anchor="middle" fill="currentColor" stroke="none" font-size="14.5" font-weight="700">The pile</text>
  <text x="270" y="40" text-anchor="middle" fill="currentColor" stroke="none" font-size="12" font-family="ui-monospace, monospace">next</text>
  <rect x="220" y="64" width="100" height="16" rx="1" stroke-width="1.25" transform="rotate(-1 270 72)"/>
  <rect x="220" y="84" width="100" height="16" rx="1" stroke-width="1.25" transform="rotate(1 270 92)"/>
  <rect x="220" y="104" width="100" height="16" rx="1" stroke-width="1.25" transform="rotate(-1 270 112)"/>
  <rect x="220" y="124" width="100" height="16" rx="1" stroke-width="1.25" transform="rotate(1 270 132)"/>
  <rect x="220" y="144" width="100" height="16" rx="1" stroke-width="1.25" transform="rotate(-1 270 152)"/>
  <path class="text-accent" d="M300 72 L303 75 L309 68 M300 92 L303 95 L309 88 M300 112 L303 115 L309 108 M300 132 L303 135 L309 128 M300 152 L303 155 L309 148" stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round"/>
  <text x="270" y="192" text-anchor="middle" fill="currentColor" stroke="none" font-size="11">deploys nowhere</text>
  <text x="270" y="208" text-anchor="middle" fill="currentColor" stroke="none" font-size="12">checked by CI, one at a time</text>
  <line class="text-accent" x1="330" y1="112" x2="406" y2="112" stroke-width="2" marker-end="url(#arrow-release)"/>
  <text x="368" y="90" text-anchor="middle" fill="currentColor" stroke="none" font-size="10.5" font-family="ui-monospace, monospace">bin/release</text>
  <text x="368" y="103" text-anchor="middle" fill="currentColor" stroke="none" font-size="10.5" font-weight="700" font-family="ui-monospace, monospace">cut</text>
  <g transform="translate(20 0)">
  <text x="465" y="22" text-anchor="middle" fill="currentColor" stroke="none" font-size="14.5" font-weight="700">The book</text>
  <text x="465" y="40" text-anchor="middle" fill="currentColor" stroke="none" font-size="12" font-family="ui-monospace, monospace">release/&lt;name&gt;</text>
  <path d="M400 70 Q432 62 465 72 L465 162 Q432 152 400 160 Z" stroke-width="1.5"/>
  <path d="M465 72 Q498 62 530 70 L530 160 Q498 152 465 162 Z" stroke-width="1.5"/>
  <line x1="410" y1="88" x2="444" y2="88" stroke-width="1" opacity="0.5"/>
  <line x1="410" y1="100" x2="444" y2="100" stroke-width="1" opacity="0.5"/>
  <line x1="410" y1="112" x2="444" y2="112" stroke-width="1" opacity="0.5"/>
  <line x1="410" y1="124" x2="444" y2="124" stroke-width="1" opacity="0.5"/>
  <line x1="410" y1="136" x2="444" y2="136" stroke-width="1" opacity="0.5"/>
  <path class="text-accent" d="M448 87 L450 90 L455 84 M448 99 L450 102 L455 96 M448 111 L450 114 L455 108" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"/>
  <line x1="476" y1="88" x2="520" y2="88" stroke-width="1" opacity="0.5"/>
  <line x1="476" y1="100" x2="516" y2="100" stroke-width="1" opacity="0.5"/>
  <line x1="476" y1="112" x2="520" y2="112" stroke-width="1" opacity="0.5"/>
  <line x1="476" y1="124" x2="508" y2="124" stroke-width="1" opacity="0.5"/>
  <rect class="text-accent" x="531" y="78" width="7" height="11" rx="1.5" stroke-width="1.25"/>
  <rect class="text-accent" x="531" y="93" width="7" height="11" rx="1.5" stroke-width="1.25"/>
  <rect class="text-accent" x="531" y="108" width="7" height="11" rx="1.5" stroke-width="1.25"/>
  <rect class="text-accent" x="531" y="123" width="7" height="11" rx="1.5" stroke-width="1.25"/>
  <rect class="text-accent" x="531" y="138" width="7" height="11" rx="1.5" stroke-width="1.25"/>
  <text x="465" y="192" text-anchor="middle" fill="currentColor" stroke="none" font-size="11">deploys to staging</text>
  <text x="465" y="208" text-anchor="middle" fill="currentColor" stroke="none" font-size="12">checked together</text>
  </g>
  <line class="text-accent" x1="566" y1="112" x2="642" y2="112" stroke-width="2" marker-end="url(#arrow-release)"/>
  <text x="604" y="90" text-anchor="middle" fill="currentColor" stroke="none" font-size="10.5" font-family="ui-monospace, monospace">bin/release</text>
  <text x="604" y="103" text-anchor="middle" fill="currentColor" stroke="none" font-size="10.5" font-weight="700" font-family="ui-monospace, monospace">ship</text>
  <g transform="translate(40 0)">
  <text x="675" y="22" text-anchor="middle" fill="currentColor" stroke="none" font-size="14.5" font-weight="700">Published</text>
  <text x="675" y="40" text-anchor="middle" fill="currentColor" stroke="none" font-size="12" font-family="ui-monospace, monospace">main</text>
  <rect class="text-accent" x="618" y="66" width="56" height="80" rx="2" fill="currentColor" stroke="none" opacity="0.3"/>
  <rect class="text-accent" x="618" y="66" width="56" height="80" rx="2" stroke-width="2"/>
  <line class="text-accent" x1="628" y1="84" x2="664" y2="84" stroke-width="2"/>
  <line class="text-accent" x1="628" y1="94" x2="654" y2="94" stroke-width="1.5"/>
  <line class="text-accent" x1="610" y1="150" x2="682" y2="150" stroke-width="3"/>
  <path d="M692 128 L692 96 L740 96 L740 128 M697 128 L697 106 L735 106 L735 128 M702 128 L702 116 L730 116 L730 128" stroke-width="1"/>
  <rect x="688" y="128" width="56" height="38" rx="2" stroke-width="1.5"/>
  <text x="716" y="152" text-anchor="middle" fill="currentColor" stroke="none" font-size="10">archive</text>
  <text x="675" y="192" text-anchor="middle" fill="currentColor" stroke="none" font-size="11">deploys to production</text>
  <text x="675" y="208" text-anchor="middle" fill="currentColor" stroke="none" font-size="12">earlier versions archived</text>
  </g>
  <path d="M715 222 L715 246 L270 246 L270 226" stroke-width="1.5" stroke-dasharray="5 4" opacity="0.8" marker-end="url(#arrow-release)"/>
  <text x="492" y="268" text-anchor="middle" fill="currentColor" stroke="none" font-size="11">merge-back: the next release starts from what production runs</text>
</svg>

<svg viewBox="0 0 340 692" width="100%" class="md:hidden max-w-xs mx-auto" role="img" aria-label="The release flow. You check a PR yourself on your branch, on your own machine. It merges into next, which deploys nowhere and collects PRs that CI checked one at a time. bin/release cut binds next into release/&lt;name&gt;, which deploys to staging, where reviewers check the PRs together. bin/release ship merges it into main, which deploys to production as a tagged release. main then merges back into next." fill="none" stroke="currentColor" font-family="ui-sans-serif, system-ui, sans-serif">
  <defs>
    <marker id="arrow-release-narrow" markerWidth="9" markerHeight="9" refX="6.5" refY="3" orient="auto">
      <path d="M0,0 L8,3 L0,6 z" fill="currentColor" stroke="none"/>
    </marker>
  </defs>
  <g transform="translate(8 -9.75) scale(0.75)">
  <rect x="35" y="56" width="90" height="112" rx="6" stroke-width="1.5"/>
  <rect x="62" y="50" width="36" height="12" rx="3" stroke-width="1.5"/>
  <rect x="43" y="68" width="74" height="92" rx="1" stroke-width="1"/>
  <line x1="50" y1="98" x2="108" y2="98" stroke-width="1" opacity="0.5"/>
  <line x1="50" y1="110" x2="100" y2="110" stroke-width="1" opacity="0.5"/>
  <line x1="50" y1="122" x2="92" y2="122" stroke-width="1" opacity="0.5"/>
  <path class="text-accent" d="M52 140 L58 146 L70 132" stroke-width="2.25" stroke-linecap="round" stroke-linejoin="round"/>
  </g>
  <text x="140" y="42" fill="currentColor" stroke="none" font-size="19" font-weight="700">The draft</text>
  <text x="140" y="66" fill="currentColor" stroke="none" font-size="16" font-family="ui-monospace, monospace">your branch</text>
  <text x="140" y="94" fill="currentColor" stroke="none" font-size="16">your machine</text>
  <text x="140" y="116" fill="currentColor" stroke="none" font-size="16">checked by you</text>
  <line class="text-accent" x1="68" y1="124" x2="68" y2="188" stroke-width="2" marker-end="url(#arrow-release-narrow)"/>
  <text x="84" y="162" fill="currentColor" stroke="none" font-size="16">merge</text>
  <g transform="translate(-134.5 148) scale(0.75)">
  <rect x="220" y="64" width="100" height="16" rx="1" stroke-width="1.25" transform="rotate(-1 270 72)"/>
  <rect x="220" y="84" width="100" height="16" rx="1" stroke-width="1.25" transform="rotate(1 270 92)"/>
  <rect x="220" y="104" width="100" height="16" rx="1" stroke-width="1.25" transform="rotate(-1 270 112)"/>
  <rect x="220" y="124" width="100" height="16" rx="1" stroke-width="1.25" transform="rotate(1 270 132)"/>
  <rect x="220" y="144" width="100" height="16" rx="1" stroke-width="1.25" transform="rotate(-1 270 152)"/>
  <path class="text-accent" d="M300 72 L303 75 L309 68 M300 92 L303 95 L309 88 M300 112 L303 115 L309 108 M300 132 L303 135 L309 128 M300 152 L303 155 L309 148" stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round"/>
  </g>
  <text x="140" y="202" fill="currentColor" stroke="none" font-size="19" font-weight="700">The pile</text>
  <text x="140" y="226" fill="currentColor" stroke="none" font-size="16" font-family="ui-monospace, monospace">next</text>
  <text x="140" y="254" fill="currentColor" stroke="none" font-size="16">deploys nowhere</text>
  <text x="140" y="276" fill="currentColor" stroke="none" font-size="16">checked by CI,</text>
  <text x="140" y="298" fill="currentColor" stroke="none" font-size="16">one at a time</text>
  <line class="text-accent" x1="68" y1="280" x2="68" y2="348" stroke-width="2" marker-end="url(#arrow-release-narrow)"/>
  <text x="84" y="322" fill="currentColor" stroke="none" font-size="16" font-family="ui-monospace, monospace">bin/release <tspan font-weight="700">cut</tspan></text>
  <g transform="translate(-283.75 308) scale(0.75)">
  <path d="M400 70 Q432 62 465 72 L465 162 Q432 152 400 160 Z" stroke-width="1.5"/>
  <path d="M465 72 Q498 62 530 70 L530 160 Q498 152 465 162 Z" stroke-width="1.5"/>
  <line x1="410" y1="88" x2="444" y2="88" stroke-width="1" opacity="0.5"/>
  <line x1="410" y1="100" x2="444" y2="100" stroke-width="1" opacity="0.5"/>
  <line x1="410" y1="112" x2="444" y2="112" stroke-width="1" opacity="0.5"/>
  <line x1="410" y1="124" x2="444" y2="124" stroke-width="1" opacity="0.5"/>
  <line x1="410" y1="136" x2="444" y2="136" stroke-width="1" opacity="0.5"/>
  <path class="text-accent" d="M448 87 L450 90 L455 84 M448 99 L450 102 L455 96 M448 111 L450 114 L455 108" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"/>
  <line x1="476" y1="88" x2="520" y2="88" stroke-width="1" opacity="0.5"/>
  <line x1="476" y1="100" x2="516" y2="100" stroke-width="1" opacity="0.5"/>
  <line x1="476" y1="112" x2="520" y2="112" stroke-width="1" opacity="0.5"/>
  <line x1="476" y1="124" x2="508" y2="124" stroke-width="1" opacity="0.5"/>
  <rect class="text-accent" x="531" y="78" width="7" height="11" rx="1.5" stroke-width="1.25"/>
  <rect class="text-accent" x="531" y="93" width="7" height="11" rx="1.5" stroke-width="1.25"/>
  <rect class="text-accent" x="531" y="108" width="7" height="11" rx="1.5" stroke-width="1.25"/>
  <rect class="text-accent" x="531" y="123" width="7" height="11" rx="1.5" stroke-width="1.25"/>
  <rect class="text-accent" x="531" y="138" width="7" height="11" rx="1.5" stroke-width="1.25"/>
  </g>
  <text x="140" y="362" fill="currentColor" stroke="none" font-size="19" font-weight="700">The book</text>
  <text x="140" y="386" fill="currentColor" stroke="none" font-size="16" font-family="ui-monospace, monospace">release/&lt;name&gt;</text>
  <text x="140" y="414" fill="currentColor" stroke="none" font-size="16">deploys to staging</text>
  <text x="140" y="436" fill="currentColor" stroke="none" font-size="16">checked together</text>
  <line class="text-accent" x1="68" y1="440" x2="68" y2="508" stroke-width="2" marker-end="url(#arrow-release-narrow)"/>
  <text x="84" y="478" fill="currentColor" stroke="none" font-size="16" font-family="ui-monospace, monospace">bin/release <tspan font-weight="700">ship</tspan></text>
  <g transform="translate(-439.75 465) scale(0.75)">
  <rect class="text-accent" x="618" y="66" width="56" height="80" rx="2" fill="currentColor" stroke="none" opacity="0.3"/>
  <rect class="text-accent" x="618" y="66" width="56" height="80" rx="2" stroke-width="2"/>
  <line class="text-accent" x1="628" y1="84" x2="664" y2="84" stroke-width="2"/>
  <line class="text-accent" x1="628" y1="94" x2="654" y2="94" stroke-width="1.5"/>
  <line class="text-accent" x1="610" y1="150" x2="682" y2="150" stroke-width="3"/>
  <path d="M692 128 L692 96 L740 96 L740 128 M697 128 L697 106 L735 106 L735 128 M702 128 L702 116 L730 116 L730 128" stroke-width="1"/>
  <rect x="688" y="128" width="56" height="38" rx="2" stroke-width="1.5"/>
  </g>
  <text x="140" y="522" fill="currentColor" stroke="none" font-size="19" font-weight="700">Published</text>
  <text x="140" y="546" fill="currentColor" stroke="none" font-size="16" font-family="ui-monospace, monospace">main</text>
  <text x="140" y="574" fill="currentColor" stroke="none" font-size="16">deploys to production</text>
  <text x="140" y="596" fill="currentColor" stroke="none" font-size="16">earlier versions</text>
  <text x="140" y="618" fill="currentColor" stroke="none" font-size="16">archived</text>
  <path d="M16 545 L6 545 L6 232 L26 232" stroke-width="1.5" stroke-dasharray="5 4" opacity="0.8" marker-end="url(#arrow-release-narrow)"/>
  <text x="6" y="646" fill="currentColor" stroke="none" font-size="16">merge-back: the next release</text>
  <text x="6" y="668" fill="currentColor" stroke="none" font-size="16">starts from what production runs</text>
</svg>

Every PR is a story. On your branch it's a draft only you have read. Merged
into `next`, it joins a pile of stories that CI checked one at a time.
`bin/release cut` binds the pile into a book on staging, where people read
the stories together for the first time, and `bin/release ship` publishes
it. The version it replaces goes to the archive, tagged, ready to republish
if you need to roll back. [Forking](forking#protect-the-branches) sets up the branch
rules with `bin/branch-rules`, and [Deployment](deployment#5-deploy-from-ci)
switches on the deploys.

| Branch | Deploys to | Checked by | Takes changes from |
| --- | --- | --- | --- |
| your PR's branch | your machine | you, or the agent writing it | your commits |
| `next` | nowhere | CI on every PR, plus a reviewer's approval on a team | feature PRs |
| `release/<name>` | staging | reviewers, working through each PR's notes | its cut from `next`, then fix and revert PRs |
| `main` | production | nothing new: it runs the commit staging ran | release and hotfix PRs |

Working alone, the flow is the same with fewer people in it. `bin/branch-rules
--solo` drops the required approval, staging is optional (leave
`DEPLOY_STAGING` unset), and each release still gets its changelog section,
its tag and a commit to roll back to.

`bin/release` runs each step. Every command takes `--dry-run`.

| Step | Command |
| --- | --- |
| Name the release in the changelog | `bin/release prepare` |
| Cut the candidate | `bin/release cut` |
| Ship the reviewed commit | `bin/release ship <PR> <commit>` |
| Merge `main` back after a hotfix | `bin/release merge-back` |

## Before it merges

Test your own work before you ask for anyone else's time. The specs cover
what they can, and CI runs them on every PR. What they can't cover is how a
change looks, reads and feels, so run your branch with `bin/dev` and click
through it. The onboarding flow you just built is easiest to judge now, while
it's the only thing that changed, not on staging next to someone else's
sign-in rewrite.

The PR template asks for two things the release depends on:

- **What the specs can't show.** The checks you made by hand, written as
  numbered steps someone else can repeat: where to go, what to do, what to
  expect. A reviewer works through them on staging, and an agent with a
  browser can follow them as written. If a step could be a system spec,
  write the spec instead: it then runs on every PR without anyone's time.
- **Depends on.** Any unreleased PR this one needs, so both stay in a release
  or come out of it together.

An agent writing a PR takes the same path: run the suite, run the app, walk
the steps, then write them into the PR. Steps a person can follow are steps an
agent can follow, and the other way round, so write them once for both.

### Keep each PR removable

> **One story per PR.** A PR is easiest to check, to review and to pull out
> when it does one thing. Keep a refactor apart from the behavior change it
> makes easy, and send it first. Leave the drive-by fix you noticed on the way
> for its own PR. When a PR turns out to hold two stories, split it before
> anyone reviews it. An agent widens a PR as it works unless asked not to, so
> ask it for the one change and read its diff for anything else.

A PR may have to come out of a release ([Partial
approval](#partial-approval)). That's cheap only when it comes out cleanly:

1. It needs no other unreleased PR, or it names that PR under "Depends on".
2. Its migrations only add. Add the new column here, stop reading the old one,
   and drop it in a later release. A reverted PR's migration has already run
   on staging, and an added column left behind breaks nothing.
3. Its backfills and one-off jobs are safe to run twice. A backfill can run on
   staging, come out with its PR, and run again when the PR comes back.

None of this needs tooling of its own, and the template ships none. A fork
that wants it enforced can add strong_migrations (it refuses destructive
migrations), maintenance_tasks (resumable backfills) or a feature flag gem such
as Flipper, which switches a PR's feature off instead of reverting it.

## Prepare the changelog

```bash
bin/release prepare
```

PRs add their lines under `## [Unreleased]` in `CHANGELOG.md`. `prepare`
opens a PR into `next` that renames that section to the release, such as
`## v2026.10.27`, and folds its repeated `### Added` / `### Fixed` / ...
subsections into one each. It then starts a fresh, empty `[Unreleased]`
above it, drops subsections with no entries, and turns on auto-merge, so the
PR lands once its checks pass and any approval the rules require is given. It
commits through a temporary index, so your checkout is never touched. It
refuses while a release it named earlier hasn't shipped yet.

The rename happens on `next`, before the cut, so that work merged during
review lands under the new `[Unreleased]`. Renaming on the release branch
instead would collide with those lines at the merge-back.

**A release is named for the day.** A second one the same day becomes
`2026.10.27-2`, then `-3`. The script skips any name already used by a tag or
a release branch. Only one release is open at a time (see below), so the
second one starts after the first has shipped.

## Cut a release

```bash
bin/release cut
```

Run it once the changelog PR has merged. It pushes `next` as
`release/<name>`, which deploys to staging, and opens the release PR into
`main` from the release template. The PR body names the branch, and its "What
ships" section is that release's changelog section.

**One release at a time.** `cut` refuses while another `release/*` branch is
open, because staging runs one build and a second candidate would replace the
one under review. It also refuses until `main` is in `next`, meaning the last
merge-back has landed, so the release PR doesn't start out of date. It refuses
a release that already shipped, too.

## Review on staging

Review on staging, not on the PR's diff. The release PR's Commits tab names
every PR in the release; work through each one's "What the specs can't show"
steps. A fix for
something found in review goes into the release branch by PR, and staging
redeploys. A fix that `next` also needs reaches it through the merge-back.

When review approves, record the commit staging is running in the PR's
"Commit reviewed on staging" field. The repository's Environments page shows
it on the latest staging deployment. With staging switched off
(`DEPLOY_STAGING` unset, common for a solo project), review the release
branch however you test, and record its head commit (`git rev-parse
origin/release/<name>`).

A fix made on the release branch puts its changelog line under that release's
`## v<name>` section, not under `[Unreleased]`. A line under `[Unreleased]`
would reach `next` with the merge-back and be listed again in the next
release.

On a repository whose rules require an approval, someone other than the
author approves the release PR on GitHub before `ship`. That's separate from
the stakeholders' sign-off on staging.

### Partial approval

When some of the changes aren't ready, revert them on the release branch, by
PR, and ship the rest:

```bash
git switch -c hold-back-search origin/release/2026.10.27
git revert -m 1 <the feature's merge commit>
# also delete its line from the release's CHANGELOG.md section
git push -u origin hold-back-search
gh pr create --base release/2026.10.27 --title "Hold back search for this release"
```

List each held-back PR and its revert commit under "Held back".

**The revert reaches `next` too.** After the release merges back, the held-back
feature is gone from `next` as well. To bring it back, revert the revert on
`next` by PR (`git revert <the revert commit>`), and put its changelog line
back under `[Unreleased]`. Don't re-merge the feature branch: git sees its
commits as already merged, so nothing comes back.

## Ship it

```bash
bin/release ship <release PR> <commit reviewed on staging>
```

It does three things:

1. Merges with `--match-head-commit <commit>`, so only the reviewed commit
   ships. If the branch moved after review, GitHub refuses ("Head branch was
   modified"), and the new commit gets reviewed on staging first. The merge
   deploys production, and the release branch is deleted.
2. Publishes a GitHub Release, `v<name>`, at the merge commit, with that
   release's changelog section as its notes. Publishing creates the tag.
3. Merges `main` back into `next`, as below.

If any step stops partway, run the same command again. It skips the merge
when the PR is already merged, skips publishing when `v<name>` exists, and
reuses a merge-back branch and PR that are already open.

## Merge main back into next

`ship` does this itself. After a hotfix, run:

```bash
bin/release merge-back
```

It pushes a branch cut from `main` (`merge-back/<name>`, or
`merge-back/main-<commit>` after a hotfix), opens its PR into `next`, brings
it up to date, and turns on auto-merge with a merge commit. If GitHub can't
bring it up to date, it says so. A PR whose
head is `main` itself can't be brought up to date, since that would push to
`main`, which is why a separate branch is needed. If `next` moves again before
the PR merges, press Update branch. Keep it **a merge commit**: a squash or
rebase leaves `main` out of `next`'s history, so every later release PR shows
changes `main` already has, and can conflict on them.

## Hotfix

A fix production can't wait a release for goes straight to `main`:

```bash
git switch -c hotfix/sign-in-loop origin/main
# fix, commit, push
gh pr create --base main --title "Sign-in no longer loops after a password reset"
```

Merging it deploys production. Then run `bin/release merge-back`. If a release
branch is open, bring the fix into it through a branch cut from `main` with a
PR into `release/<name>`.

## In case of emergency

The rulesets give no one a bypass, admins included. When production is down
and the PR path can't carry the fix (CI itself is broken, say), an admin
switches the blocking ruleset off, pushes, and switches it back on:

```bash
gh api repos/OWNER/REPO/rulesets --jq '.[] | "\(.id) \(.name)"'
gh api -X PUT repos/OWNER/REPO/rulesets/<id> -f enforcement=disabled
git push origin hotfix/sign-in-loop:main
bin/branch-rules   # add --solo if the repo runs solo; turns every ruleset back on
```

Rerunning `bin/branch-rules` puts back every ruleset exactly as
`config/github/rulesets/` describes it. Then merge `main` back into `next` as
after any hotfix. A ruleset left disabled is the risk here, so rerun the
script in the same sitting as the push.

## Where this is heading

The release round spends reviewers' time, so the aim is to need it less. A
problem a reviewer finds by hand that a spec could have caught becomes a spec,
and the "What the specs can't show" lists get shorter. Once most releases pass
staging untouched, a fork can loosen the flow a step at a time:

1. Ask for an approval only on PRs that touch risky paths, such as sign-in,
   authorization, tenancy and migrations. List them in a `CODEOWNERS` file,
   set `require_code_owner_review` to `true` in `config/github/rulesets/`,
   and drop `required_approving_review_count` to `0`.
2. Skip staging for releases that touch none of those paths.
3. Run `cut` and `ship` from CI after every green merge into `next`.

The last step is where [Impatient
Programming](https://impatientprogramming.org/rules/#rule-27) points: green
merges itself. The tags, the changelog and rollback by commit stay the same at
every step.

## Changing the flow

The flow is a default, not a requirement. The branch rules live in
`config/github/rulesets/`, the deploys in `.github/workflows/deploy.yml`, the
steps in `bin/release`, and this page, the release template in
`.github/PULL_REQUEST_TEMPLATE/release.md` and the PR template in
`.github/PULL_REQUEST_TEMPLATE.md` describe them. Change all of them
together.

The changelog and release-name convention is separate from the flow. It lives
in `lib/release_changelog.rb`, and `bin/release` reads it only through that
module's public methods. A fork that keeps its changelog another way replaces
that file, keeps the method signatures, and leaves the rest alone.
