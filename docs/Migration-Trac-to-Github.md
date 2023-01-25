See also: https://trac.sagemath.org/ticket/30363


# Proposed workflow on GitHub (with transition guide from Trac)

- One time action: **Instead of depositing an SSH public key on Trac**:
  - No action needed if you have already contributed to any other project on GitHub and set up Git credentials or SSH keys for this.
  - For new users of GitHub:
    - Either https://docs.github.com/en/get-started/getting-started-with-git/caching-your-github-credentials-in-git
    - Or [generate ssh keypair, or use an already existing one, and upload the public key to your GitHub account settings](https://docs.github.com/en/authentication/connecting-to-github-with-ssh)
 
- One time action: **Instead of adding a git remote named `trac`**:
  
  - [Create your personal GitHub fork](https://docs.github.com/en/get-started/quickstart/fork-a-repo#forking-a-repository) of the main repository https://github.com/sagemath/sage - this will become a repository in https://github.com/USERNAME
  - **If you already have a clone of a Sage repository on your computer:**
    - Check your current git remote repositories:
      ```
      git remote -v
      ```
    - If you already have the main Sage repository (https://github.com/sagemath/sage) as a remote, and its name is not `upstream`, rename it to `upstream` using `git remote rename OLD-NAME upstream`
    - Otherwise, add a new remote:
      ```
      git remote add upstream https://github.com/sagemath/sage.git
      ```
      Alternatively, use ssh access with your ssh keypair - see (Optional) above:
      ```
      git remote add upstream git@github.com:sagemath/sage.git
      ```
    - If you already have a remote named `origin` and it is not your personal fork, rename this remote to something else using `git remote rename origin MY-OLD-ORIGIN`
    - Finally, add your fork as a remote via (the URL can be copied from there)
      ```
      git remote add origin https://github.com/USERNAME/sage.git
      ```
      Alternatively, with ssh access (see above):
      ```
      git remote add origin git@github.com:USERNAME/sage.git
      ``` 
  - **Otherwise (fresh start):**
    - [Clone the forked repository](https://docs.github.com/en/get-started/quickstart/fork-a-repo#cloning-your-forked-repository),
      and do one of the following, depending on the access type (https vs ssh)
      ```
      git clone https://github.com/USERNAME/sage.git   # https
      git clone git@github.com:USERNAME/sage.git       # ssh
      ```
      This will link your fork as the `origin` remote in the local git.
    - [Configure git to sync your fork with the main Sage repository](https://docs.github.com/en/get-started/quickstart/fork-a-repo#configuring-git-to-sync-your-fork-with-the-original-repository), and do one of the following, depending on the access type (https vs ssh):
      ```
      git remote add upstream https://github.com/sagemath/sage.git   # https
      git remote add upstream git@github.com:sagemath/sage.git       # ssh
      ```
   - In order to be able to fetch branches from existing Trac tickets, also set up the following (read-only) remote:
     ```
     git remote add trac https://github.com/sagemath/sagetrac-mirror.git
     ```
  - (Of course, you can give arbitrary names to your git remotes, but `origin` and `upstream` are the established defaults, which will make it easier to use tools such as the GitHub command-line tools.)

- For reporting a bug, planning an enhancement, describing a project, **instead of opening a Trac ticket**:

  - [Open an Issue on GitHub](https://docs.github.com/en/issues). Preview of Issues (converted from Trac): https://github.com/sagemath/trac_to_gh/issues
  - **Trac ticket box attributes** are mapped as follows (see https://github.com/sagemath/trac-to-github/issues/8):
    - **Type** ("defect", "enhancement", "task") are mapped to "Labels" "bug", "enhancement".
    - **Component** ("basic arithmetic", "linear algebra", "geometry", ...) are mapped to "Labels" 
      with prefix `c: `
    - **Priority** ("trivial"/"minor"/"major"/"critical"/"blocker") are mapped to "Labels" with prefix `p: `
    - **Keywords** just add them in free form to the issue description if there's no suitable "Label"
    - **Cc**: use `@USERNAME` either in the Issue description or in any comment. 
      - Optionally, regular developers who would like to get notified automatically when a PR touches a particular part of the sage code can add themselves as a [Code Owner](https://docs.github.com/en/repositories/managing-your-repositorys-settings-and-features/customizing-your-repository/about-code-owners).
    - **Description** becomes just the first comment on the Issue
    - **Branch**/**Commit**/**Authors**/**Reviewers**/**Work Issues**: via Pull Requests (PR), see below
    - **Report Upstream** is replaced by [automatic cross references between Issues/PRs in different repos](https://docs.github.com/en/get-started/writing-on-github/working-with-advanced-formatting/autolinked-references-and-urls#issues-and-pull-requests)
    - **Milestone = duplicate/invalid/wontfix** and **Resolution** ("duplicate", "invalid", "wontfix")
      are replaced by
      - [marking as duplicate](https://docs.github.com/en/issues/tracking-your-work-with-issues/marking-issues-or-pull-requests-as-a-duplicate), 
      - "Labels" "duplicate", "invalid", "wontfix", or
      - closing with a comment; use "Close as not wanted"
    - **Dependencies**: Use the phrase "Depends on ", followed by the Issue or PR reference.
      Repeat this in separate lines if there is more than one dependency.
      This format is understood by various dependency managers: See https://www.dpulls.com/,
      https://github.com/z0al/dependent-issues, https://github.com/gregsdennis/dependencies-action/pull/5

- For contributing a change that does not address an existing open Issue, **instead of opening a Trac ticket and pushing a git branch to it**:
  - Create a new local branch based on `upstream/develop`
  - Push the branch to the remote named `origin`, i.e., to your fork
  - A git message will provide a URL for opening a Pull Request (PR)
  - [Create the PR](https://docs.github.com/en/pull-requests/collaborating-with-pull-requests/proposing-changes-to-your-work-with-pull-requests/creating-a-pull-request)
  - If it is not ready for review, [mark the PR as a "Draft"](https://docs.github.com/en/pull-requests/collaborating-with-pull-requests/proposing-changes-to-your-work-with-pull-requests/changing-the-stage-of-a-pull-request)

- For contributing a change that addresses an existing open Issue that has been created on GitHub, **instead of pushing a git branch to a Trac ticket**:
  - same as above
  - [use `Fixes #ISSUENUMBER` to link to an existing issue](https://docs.github.com/en/issues/tracking-your-work-with-issues/linking-a-pull-request-to-an-issue); this will auto-close the linked Issue when the PR is merged.

- For contributing a change that addresses an existing open Issue that has been migrated from Trac, **instead of pushing a git branch to a Trac ticket**:
  - Pull the branch from your read-only `trac` remote (see section *One time action: Instead of adding a git remote named trac*) as you use to do before.
  - Edit and commit your changes
  - Push the branch to the remote named `origin`, i.e., to your fork
  - Follow the instructions above from there

- For finding PRs that are waiting for review, **instead of using Trac ticket reports**:
  - [filter PRs by review status](https://docs.github.com/en/issues/tracking-your-work-with-issues/filtering-and-searching-issues-and-pull-requests#filtering-pull-requests-by-review-status)

- **Instead of adding a comment to a ticket**:
  - Add a comment to the Issue
  - If a PR is linked to the Issue, you can alternatively comment on the PR. 
  - Where should a comment go?
    - To say that the reported issue is not a bug but a feature, the comment should go on the Issue
    - To point out typos in the changes, the comment should go on the PR
    - ... (add your examples)
  - Generally everyone has a large enough screen to view both the Issue and the PR on their screen simultaneously

- For reviewing a change:
  - **instead of looking at the patchbot**, use the [Checks on GitHub Actions](https://trac.sagemath.org/wiki/ReleaseTours/sage-9.6#BuildsandchecksofticketbranchesonGitHubActions), which are already available on Trac since the Sage 9.6 series; the [status of the check runs](https://docs.github.com/en/pull-requests/collaborating-with-pull-requests/collaborating-on-repositories-with-code-quality-features/about-status-checks) will be clearer on GitHub [than on Trac](https://trac.sagemath.org/ticket/33818) 
  - **instead of copy-pasting parts of the diff of a branch to a comment**, use [pull request reviews](https://docs.github.com/en/pull-requests/collaborating-with-pull-requests/reviewing-changes-in-pull-requests/about-pull-request-reviews): You can add comments directly to changed lines
  - **instead of making reviewer edits**, smaller suggestions can be made [through the github web interface](https://egghead.io/lessons/github-add-suggestions-in-a-github-pr-review) as part of the [pull request review](https://docs.github.com/en/pull-requests/collaborating-with-pull-requests/reviewing-changes-in-pull-requests/incorporating-feedback-in-your-pull-request)
  - **if you want to be able to make changes directly to others' PRs** (when the author elects to allow edits from maintainers), please contact one of the [Sagemath Github admins](https://github.com/orgs/sagemath/people?query=role%3Aowner), who can give you the relevant permissions.
  - **instead of changing the status of the ticket** (i.e. "positive review" or "needs work"), choose the [correct type of your pull request review](https://docs.github.com/en/pull-requests/collaborating-with-pull-requests/reviewing-changes-in-pull-requests/reviewing-proposed-changes-in-a-pull-request#submitting-your-review) (i.e. "approve" vs "request changes")
  - for trying the branch of a PR locally, **instead of using `git trac checkout TICKETNUMBER` or `git trac try TICKETNUMBER`**, use [`git fetch upstream pull/PULL_REQUEST_ID/head:LOCAL_BRANCH_NAME`](https://docs.github.com/en/pull-requests/collaborating-with-pull-requests/reviewing-changes-in-pull-requests/checking-out-pull-requests-locally)
    - alternatively, with the [GitHub command-line interface](https://trac.sagemath.org/ticket/34523), use [`gh pr checkout PULL_REQUEST_ID`](https://cli.github.com/manual/gh_pr_checkout)
    
- For organizing, **instead of using meta-tickets**:
  - either open an Issue
    - it can include a checklist of things to do which can be checked off as they are dealt with by various PRs.
  - or [create a new Project](https://github.com/features/issues)

# Release Manager's workflow

- Unchanged: Release Manager @vbraun merges positively reviewed tickets into his branch https://github.com/vbraun/sage
  - The release manager uses [a filter to identify the pull requests that a reviewer has approved](https://docs.github.com/en/issues/tracking-your-work-with-issues/filtering-and-searching-issues-and-pull-requests#filtering-pull-requests-by-review-status)
  - Once released (currently targeted for Q4 2022), we instead use [Merge Queues](https://docs.github.com/en/repositories/configuring-branches-and-merges-in-your-repository/configuring-pull-request-merges/managing-a-merge-queue).
- Unchanged: To make a beta or stable release, Release Manager merges (fast-forward) his branch into the `develop` branch and creates a tag
- Unchanged: To make a stable release, Release Manager merges (fast-forward) the `develop` branch into the `main` branch.
  - Only change is the rename of `master` to `main` due to cultural sensitivity - as proposed in https://trac.sagemath.org/ticket/31287
  - In the future, we might migrate from this [Gitflow workflow](https://www.atlassian.com/git/tutorials/comparing-workflows/gitflow-workflow) to the [Trunk-based workflow](https://www.atlassian.com/continuous-delivery/continuous-integration/trunk-based-development) where the `develop` branch is no longer needed and changes are directly merged into `main`.

# Proposed permissions and protections

Main repository https://github.com/sagemath/sage:
- Only 2 named [branches](https://github.com/sagemath/sage/branches), `develop` and `master`
- everything else goes through PRs
- Create a new team: https://github.com/orgs/sagemath/teams "Release Manager"
- Set up [branch protection rule](https://docs.github.com/en/repositories/configuring-branches-and-merges-in-your-repository/defining-the-mergeability-of-pull-requests/about-protected-branches): Only "Release Manager" team can push; no override for users in Admin role; no deletions; no force pushes
- Review/update https://github.com/orgs/sagemath/teams/core/members
- Create a new team for other developers, [give Write access to team in repo](https://docs.github.com/en/repositories/managing-your-repositorys-settings-and-features/managing-repository-settings/managing-teams-and-people-with-access-to-your-repository#inviting-a-team-or-person), add people to team
  - the Write access does not allow pushing to `develop` or `master`
  - the Write access allows members of the team to push commits to branches of PRs ([unless the PR owner has disabled this for this PR](https://docs.github.com/en/pull-requests/collaborating-with-pull-requests/working-with-forks/allowing-changes-to-a-pull-request-branch-created-from-a-fork))
  

# Conversion of Trac tickets and the Trac wiki to GitHub

Conversion script: https://github.com/sagemath/trac-to-github
-  [issues there](https://github.com/sagemath/trac-to-github/issues) are various technical discussions on the topic 

Preview of the converted issues:
- Iteration 0 (2022-09): A few issues converted from Trac tickets at https://github.com/sagemath/trac_to_gh/issues?q=is%3Aissue
- Iterations 1–50 (2022-12): Migration archive (all 35000 issues) formatted as Markdown at https://github.com/sagemath/trac_to_gh/tree/main/Issues-11xxx etc.
- Iterations 51- (2023-01): Migration archive imported into a GitHub Enterprise Server instance https://34.105.185.241/sagemath

Preview of the converted wiki: https://github.com/sagemath/trac_to_gh/wiki

Switchover day (confirmed: Feb 1, 2023):
- Steps see https://github.com/sagemath/trac-to-github/issues/73

# Retrieving data from GitHub

[GitHub REST API](https://docs.github.com/en/rest)

Particularly, anything extracting/archiving discussions should probably look at [Issues API](https://docs.github.com/en/rest/issues/issues), because "Pull requests are just issues with code", although there is a separate [Pull request review comments API](https://docs.github.com/en/rest/pulls/comments). Special care may need to be taken to preserve cross-references when archiving.

3 minute video demoing importing github repos to gitlab, which emphasizes answers to a lot of natural frequent questions (involving users, issue comments, labels, etc.): https://www.youtube.com/watch?v=VYOXuOg9tQI

[Trac #34624: Backup Issues/PRs for projects hosted in https://github.com/sagemath/](https://trac.sagemath.org/ticket/34624)
